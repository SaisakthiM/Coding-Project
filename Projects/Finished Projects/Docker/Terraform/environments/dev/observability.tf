# ═══════════════════════════════════════════════════════════════
# observability.tf — Full observability stack
#
# Collector topology
# ──────────────────────────────────────────────────────────────
#
#  Docker services (gateway-net)
#       │  push OTLP to otel-gateway:4317/4318
#       │  scraped by otel-gateway prometheus receiver
#       ▼
#  otel-gateway  (docker_container — docker.tf)
#       │  forwards all signals via OTLP to kind NodePort 30317
#       ▼
#  otel-collector  (helm_release — monitoring ns, kind)
#       │  also receives OTLP from in-cluster k8s services
#       │  enriches with k8sattributes
#       ├──► Tempo        (traces)
#       ├──► Prometheus   (metrics via remote-write)
#       └──► Loki         (logs)
#
# NodePort mapping
#   30317 — OTLP gRPC  (gateway → kind collector)
#   30318 — OTLP HTTP  (browser SDKs → kind collector)
#   30080 — ingress-nginx (grafana, jaeger, otel HTTP UI)
#
# Depends on: kubernetes.tf (null_resource.kind_cluster,
#             helm_release.ingress_nginx, kubectl_manifest.minio_service)
# ═══════════════════════════════════════════════════════════════

# ─── REDIS (Bitnami — used by observability stack) ────────────
resource "helm_release" "redis" {
  depends_on = [
    null_resource.kind_cluster,
    kubectl_manifest.cassandra_service,
    kubectl_manifest.cassandra_statefulset,
  ]
  name       = "redis"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "redis"
  namespace  = "default"
  wait       = true
  timeout    = 120

  set {
    name  = "auth.password"
    value = "redis-password"
  }
  set {
    name  = "architecture"
    value = "standalone"
  }
  set_sensitive {
    name  = "values_sha"
    value = filebase64sha256("${local.obs_path}/redis-values.yml")
  }
}

# ─── KUBE-PROMETHEUS-STACK ────────────────────────────────────
resource "helm_release" "kube_prometheus_stack" {
  depends_on       = [null_resource.kind_cluster, helm_release.redis]
  name             = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  create_namespace = true
  wait             = true
  timeout          = 600

  values = [
    file("${local.obs_path}/prometheus.yml"),
    file("${local.obs_path}/grafana-values.yml"),
    yamlencode({
      prometheus = {
        prometheusSpec = {
          enableRemoteWriteReceiver = true
          resources = {
            requests = { cpu = "200m", memory = "512Mi" }
            limits   = { cpu = "1000m", memory = "2Gi" }
          }
        }
      }
    }),
  ]

  lifecycle {
    ignore_changes = [
      values, # prevents re-upgrade on every apply
    ]
  }
}

# ─── LOKI ─────────────────────────────────────────────────────
resource "helm_release" "loki" {
  depends_on       = [helm_release.kube_prometheus_stack]
  name             = "loki"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "loki"
  namespace        = "monitoring"
  create_namespace = true
  wait             = true
  timeout          = 300

  values = [file("${local.obs_path}/loki-config.yml")]

  set_sensitive {
    name  = "values_sha"
    value = filebase64sha256("${local.obs_path}/loki-config.yml")
  }
}

# ─── TEMPO ────────────────────────────────────────────────────
resource "helm_release" "tempo" {
  depends_on       = [helm_release.loki, kubectl_manifest.minio_service]
  name             = "tempo"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "tempo"
  namespace        = "monitoring"
  create_namespace = true
  wait             = true
  timeout          = 300

  values = [file("${local.obs_path}/tempo-config.yml")]

  set_sensitive {
    name  = "values_sha"
    value = filebase64sha256("${local.obs_path}/tempo-config.yml")
  }
}

# ─── PROMTAIL ─────────────────────────────────────────────────
resource "helm_release" "promtail" {
  depends_on       = [helm_release.loki]
  name             = "promtail"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "promtail"
  namespace        = "monitoring"
  create_namespace = true
  wait             = true
  timeout          = 180

  values = [file("${local.obs_path}/promtail-config.yml")]

  set_sensitive {
    name  = "values_sha"
    value = filebase64sha256("${local.obs_path}/promtail-config.yml")
  }
}

# ─── OTEL COLLECTOR (in-cluster) ──────────────────────────────
resource "helm_release" "otel_collector" {
  depends_on = [
    helm_release.tempo,
    helm_release.loki,
    helm_release.kube_prometheus_stack,
  ]
  name             = "otel-collector"
  repository       = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart            = "opentelemetry-collector"
  namespace        = "monitoring"
  create_namespace = true
  wait             = true
  timeout          = 300

  values = [file("${local.obs_path}/otel-collector-config.yml")]
}

# ─── OTEL NODEPORT SERVICE ────────────────────────────────────
# Stable NodePorts so the Docker-side otel-gateway can always
# reach the in-cluster collector at 30317 (gRPC) / 30318 (HTTP).
resource "kubectl_manifest" "otel_nodeport" {
  depends_on = [helm_release.otel_collector]
  yaml_body  = <<-YAML
    apiVersion: v1
    kind: Service
    metadata:
      name: otel-collector-nodeport
      namespace: monitoring
      labels:
        app: otel-collector-nodeport
    spec:
      type: NodePort
      selector:
        app.kubernetes.io/name: opentelemetry-collector
      ports:
        - name: otlp-grpc
          protocol: TCP
          port: 4317
          targetPort: 4317
          nodePort: 30317
        - name: otlp-http
          protocol: TCP
          port: 4318
          targetPort: 4318
          nodePort: 30318
  YAML
}

# ─── JAEGER ───────────────────────────────────────────────────
resource "helm_release" "jaeger" {
  depends_on       = [helm_release.ingress_nginx, helm_release.otel_collector]
  name             = "jaeger"
  repository       = "https://jaegertracing.github.io/helm-charts"
  chart            = "jaeger"
  namespace        = "monitoring"
  create_namespace = true
  wait             = true
  timeout          = 180

  values = [file("${local.obs_path}/jaeger-config.yml")]
}

resource "kubectl_manifest" "jaeger_v2_config" {
  depends_on = [null_resource.kind_cluster]
  yaml_body  = <<-YAML
    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: jaeger-v2-config
      namespace: monitoring
    data:
      config.yaml: |
        service:
          extensions: [jaeger_storage, jaeger_query, healthcheckv2]
          pipelines:
            traces:
              receivers: [otlp, jaeger]
              exporters: [jaeger_storage]

        extensions:
          healthcheckv2:
            use_v2: true
            http:
              endpoint: 0.0.0.0:13133

          jaeger_storage:
            backends:
              some_storage:
                memory:
                  max_traces: 50000

          jaeger_query:
            storage:
              traces: some_storage
            base_path: /jaeger

        receivers:
          otlp:
            protocols:
              grpc:
                endpoint: 0.0.0.0:4317
              http:
                endpoint: 0.0.0.0:4318
          jaeger:
            protocols:
              grpc:
                endpoint: 0.0.0.0:14250
              thrift_http:
                endpoint: 0.0.0.0:14268

        exporters:
          jaeger_storage:
            trace_storage: some_storage
  YAML
}

# ─── OTEL INGRESS ─────────────────────────────────────────────
# Exposes OTLP/HTTP at /otel/ so browser-instrumented frontends
# can send spans without needing a direct NodePort.
resource "kubectl_manifest" "otel_ingress" {
  depends_on = [helm_release.ingress_nginx, helm_release.otel_collector]
  yaml_body  = <<-YAML
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: otel-collector-ingress
      namespace: monitoring
      annotations:
        nginx.ingress.kubernetes.io/rewrite-target: /$2
        nginx.ingress.kubernetes.io/use-regex: "true"
        nginx.ingress.kubernetes.io/ssl-redirect: "false"
        nginx.ingress.kubernetes.io/enable-cors: "true"
        nginx.ingress.kubernetes.io/cors-allow-origin: "*"
        nginx.ingress.kubernetes.io/cors-allow-methods: "POST, OPTIONS"
        nginx.ingress.kubernetes.io/cors-allow-headers: "Content-Type, traceparent, tracestate"
    spec:
      ingressClassName: nginx
      rules:
        - http:
            paths:
              - path: /otel(/|$)(.*)
                pathType: ImplementationSpecific
                backend:
                  service:
                    name: otel-collector
                    port:
                      number: 4318
  YAML
}

# ─── GRAFANA INGRESS ──────────────────────────────────────────
resource "kubectl_manifest" "ingress_grafana" {
  depends_on = [helm_release.ingress_nginx, helm_release.kube_prometheus_stack]
  yaml_body  = <<-YAML
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: observability-grafana-ingress
      namespace: monitoring
      annotations:
        nginx.ingress.kubernetes.io/use-regex: "true"
        nginx.ingress.kubernetes.io/proxy-read-timeout: "300"
        nginx.ingress.kubernetes.io/proxy-send-timeout: "300"
        nginx.ingress.kubernetes.io/proxy-http-version: "1.1"
        nginx.ingress.kubernetes.io/websocket-services: "kube-prometheus-stack-grafana"
    spec:
      ingressClassName: nginx
      rules:
        - http:
            paths:
              - path: /grafana
                pathType: Prefix
                backend:
                  service:
                    name: kube-prometheus-stack-grafana
                    port:
                      number: 80
  YAML
}

# ─── JAEGER INGRESS ───────────────────────────────────────────
resource "kubectl_manifest" "ingress_jaeger" {
  depends_on = [helm_release.ingress_nginx, helm_release.otel_collector, kubectl_manifest.jaeger_v2_config]
  yaml_body  = <<-YAML
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: observability-jaeger-ingress
      namespace: monitoring
      annotations:
        nginx.ingress.kubernetes.io/use-regex: "true"
    spec:
      ingressClassName: nginx
      rules:
        - http:
            paths:
              - path: /jaeger
                pathType: Prefix
                backend:
                  service:
                    name: jaeger
                    port:
                      number: 16686
  YAML
}
