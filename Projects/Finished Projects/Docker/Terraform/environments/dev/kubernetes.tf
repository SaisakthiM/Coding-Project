# ═══════════════════════════════════════════════════════════════
# kubernetes.tf — Social Media App on kind
#
# Depends on: docker.tf  (docker_network.gateway_net, module.gateway)
# ═══════════════════════════════════════════════════════════════

locals {
  social_base = abspath("${path.module}/../../projects/Social Media App")
}

# ─── SOCIAL MEDIA DOCKER IMAGES ───────────────────────────────
resource "docker_image" "social_django" {
  name         = "socialmediaapp-django:latest"
  keep_locally = true
  build {
    context    = abspath("${path.module}/../../projects/Social Media App/apps/backend")
    dockerfile = "Dockerfile"
  }
  triggers = {
    dir_sha = sha256(join("", [
      for f in fileset("${path.module}/../../projects/Social Media App/apps/backend", "**") :
      filesha256("${path.module}/../../projects/Social Media App/apps/backend/${f}")
      if !can(regex("(__pycache__|.pyc|.git)", f))
    ]))
  }
}

resource "docker_image" "social_frontend" {
  name         = "socialmediaapp-frontend-prod:latest"
  keep_locally = true
  build {
    context    = abspath("${path.module}/../../projects/Social Media App/apps/frontend")
    dockerfile = "Dockerfile"
  }
  triggers = {
    dir_sha = sha256(join("", [
      for f in fileset("${path.module}/../../projects/Social Media App/apps/frontend", "**") :
      filesha256("${path.module}/../../projects/Social Media App/apps/frontend/${f}")
      if !can(regex("(node_modules|dist|.git)", f))
    ]))
  }
}

resource "docker_image" "social_go" {
  name         = "socialmediaapp-microservice-go:latest"
  keep_locally = true
  build {
    context    = abspath("${path.module}/../../projects/Social Media App/apps/microservice-go")
    dockerfile = "Dockerfile"
  }
  triggers = {
    dir_sha = sha256(join("", [
      for f in fileset("${path.module}/../../projects/Social Media App/apps/microservice-go", "**") :
      filesha256("${path.module}/../../projects/Social Media App/apps/microservice-go/${f}")
      if !can(regex(".git", f))
    ]))
  }
}

resource "docker_image" "social_java" {
  name         = "socialmediaapp-microservice-java:latest"
  keep_locally = true
  build {
    context    = abspath("${path.module}/../../projects/Social Media App/apps/microservice-java")
    dockerfile = "Dockerfile"
  }
  triggers = {
    dir_sha = sha256(join("", [
      for f in fileset("${path.module}/../../projects/Social Media App/apps/microservice-java", "**") :
      filesha256("${path.module}/../../projects/Social Media App/apps/microservice-java/${f}")
      if !can(regex("(target|.git)", f))
    ]))
  }
}

resource "docker_image" "social_minio" {
  name         = "socialmediaapp-minio:latest"
  keep_locally = true
  build {
    context    = abspath("${path.module}/../../projects/Social Media App/storage/minio")
    dockerfile = "Dockerfile"
  }
  triggers = {
    dir_sha = sha256(join("", [
      for f in fileset("${path.module}/../../projects/Social Media App/storage/minio", "**") :
      filesha256("${path.module}/../../projects/Social Media App/storage/minio/${f}")
      if !can(regex(".git", f))
    ]))
  }
}

# ─── KIND CLUSTER ─────────────────────────────────────────────
resource "null_resource" "kind_cluster" {
  triggers = {
    kind_config = filesha256("${path.module}/../../projects/Social Media App/infrastructure/kind/kind-config.yaml")
  }
  provisioner "local-exec" {
    command = <<-EOT
      if ! kind get clusters | grep -q "social-media"; then
        kind create cluster --config "${abspath("${path.module}/../../projects/Social Media App/infrastructure/kind/kind-config.yaml")}"
      fi
    EOT
  }
  provisioner "local-exec" {
    when    = destroy
    command = "kind delete cluster --name social-media"
  }
}

# ─── IMAGE LOADING ────────────────────────────────────────────

# Manual trigger — only runs when you set load_images = true
resource "null_resource" "kind_images" {
  triggers = {
    manual = var.load_images
  }
  provisioner "local-exec" {
    command = <<EOT
      cd ~/.cache/
      # Cassandra
      docker pull --platform=linux/amd64 cassandra:5.0
      docker save cassandra:5.0-amd64 -o cassandra.tar
      docker cp cassandra.tar social-media-control-plane:/cassandra.tar
      docker cp cassandra.tar social-media-worker:/cassandra.tar
      docker cp cassandra.tar social-media-worker2:/cassandra.tar
      docker exec -i social-media-control-plane ctr -n k8s.io images import /cassandra.tar
      docker exec -i social-media-worker ctr -n k8s.io images import /cassandra.tar
      docker exec -i social-media-worker2 ctr -n k8s.io images import /cassandra.tar

      # Kafka
      docker pull --platform=linux/amd64 confluentinc/cp-kafka:7.6.0  
      docker save confluentinc/cp-kafka:7.6.0 -o kafka.tar
      docker cp kafka.tar social-media-control-plane:/kafka.tar
      docker cp kafka.tar social-media-worker:/kafka.tar
      docker cp kafka.tar social-media-worker2:/kafka.tar
      docker exec -i social-media-control-plane ctr -n k8s.io images import /kafka.tar
      docker exec -i social-media-worker ctr -n k8s.io images import /kafka.tar
      docker exec -i social-media-worker2 ctr -n k8s.io images import /kafka.tar
    EOT
  }
}

resource "null_resource" "kind_load_images" {
  depends_on = [
    null_resource.kind_cluster,
    docker_image.social_django,
    docker_image.social_frontend,
    docker_image.social_go,
    docker_image.social_java,
    docker_image.social_minio,
  ]
  triggers = {
    django_id   = docker_image.social_django.image_id
    frontend_id = docker_image.social_frontend.image_id
    go_id       = docker_image.social_go.image_id
    java_id     = docker_image.social_java.image_id
    minio_id    = docker_image.social_minio.image_id
  }
  provisioner "local-exec" {
    command = <<-EOT
      kind load docker-image socialmediaapp-django:latest --name social-media
      kind load docker-image socialmediaapp-frontend-prod:latest --name social-media
      kind load docker-image socialmediaapp-microservice-go:latest --name social-media
      kind load docker-image socialmediaapp-microservice-java:latest --name social-media
      kind load docker-image socialmediaapp-minio:latest --name social-media
    EOT
  }
}

# Connect gateway Docker container to kind's Docker network so it can
# reach kind NodePorts (e.g. 30317 for OTEL) from gateway-net.
resource "null_resource" "gateway_kind_network" {
  depends_on = [null_resource.kind_cluster, module.gateway]
  triggers = {
    cluster_id = null_resource.kind_cluster.id
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = "docker network connect kind gateway || true"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "docker network disconnect kind gateway || true"
  }
}

# ─── INGRESS-NGINX ────────────────────────────────────────────
resource "helm_release" "ingress_nginx" {
  depends_on       = [null_resource.kind_cluster]
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true
  wait             = true
  timeout          = 120

  values = [<<-EOT
    controller:
      service:
        type: NodePort
        nodePorts:
          http: "30080"
      hostPort:
        enabled: true
        ports:
          http: 80
      metrics:
        enabled: true
        port: 10254
        service:
          annotations:
            prometheus.io/scrape: "true"
            prometheus.io/port: "10254"
        serviceMonitor:
          enabled: true
          namespace: monitoring
          interval: 30s
          additionalLabels:
            release: kube-prometheus-stack
        prometheusRule:
          enabled: false
  EOT
  ]
}

# ─── POSTGRES ─────────────────────────────────────────────────
resource "kubectl_manifest" "postgres_secret" {
  depends_on = [null_resource.kind_cluster]
  yaml_body  = <<-YAML
    apiVersion: v1
    kind: Secret
    metadata:
      name: postgres-secret
    type: Opaque
    data:
      POSTGRES_PASSWORD: ${base64encode(var.social_db_password)}
  YAML
}

resource "kubectl_manifest" "postgres_service" {
  depends_on = [null_resource.kind_cluster]
  yaml_body  = <<-YAML
    apiVersion: v1
    kind: Service
    metadata:
      name: postgres
    spec:
      ports:
        - port: 5432
          targetPort: 5432
      selector:
        app: postgres
  YAML
}

resource "kubectl_manifest" "postgres_statefulset" {
  depends_on = [kubectl_manifest.postgres_secret, kubectl_manifest.postgres_service]
  yaml_body  = <<-YAML
    apiVersion: apps/v1
    kind: StatefulSet
    metadata:
      name: postgres
    spec:
      serviceName: postgres
      replicas: 1
      selector:
        matchLabels:
          app: postgres
      template:
        metadata:
          labels:
            app: postgres
        spec:
          containers:
            - name: postgres
              image: postgres:15
              ports:
                - containerPort: 5432
              env:
                - name: POSTGRES_DB
                  value: ${var.social_db_name}
                - name: POSTGRES_USER
                  value: ${var.social_db_user}
                - name: POSTGRES_PASSWORD
                  valueFrom:
                    secretKeyRef:
                      name: postgres-secret
                      key: POSTGRES_PASSWORD
              volumeMounts:
                - name: postgres-storage
                  mountPath: /var/lib/postgresql/data
      volumeClaimTemplates:
        - metadata:
            name: postgres-storage
          spec:
            accessModes:
              - ReadWriteOnce
            resources:
              requests:
                storage: 1Gi
  YAML
}

# ─── BACKEND ──────────────────────────────────────────────────
resource "kubectl_manifest" "backend_service" {
  depends_on = [null_resource.kind_cluster]
  yaml_body  = <<-YAML
    apiVersion: v1
    kind: Service
    metadata:
      name: backend
    spec:
      selector:
        app: backend
      ports:
        - port: 8000
          targetPort: 8000
      type: ClusterIP
  YAML
}

resource "kubectl_manifest" "backend_deployment" {
  depends_on = [null_resource.kind_load_images, kubectl_manifest.postgres_statefulset]
  yaml_body  = <<-YAML
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: backend
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: backend
      template:
        metadata:
          labels:
            app: backend
        spec:
          containers:
            - name: backend
              image: socialmediaapp-django:latest
              imagePullPolicy: Never
              ports:
                - containerPort: 8000
              env:
                - name: DB_NAME
                  value: ${var.social_db_name}
                - name: DB_USER
                  value: ${var.social_db_user}
                - name: DB_PASSWORD
                  valueFrom:
                    secretKeyRef:
                      name: postgres-secret
                      key: POSTGRES_PASSWORD
                - name: DB_HOST
                  value: postgres
                - name: DB_PORT
                  value: "5432"
                - name: DEBUG
                  value: "True"
                - name: RUNNING_IN_DOCKER
                  value: "True"
                - name: REDIS_PORT
                  value: "6379"
  YAML
}

# ─── FRONTEND ─────────────────────────────────────────────────
resource "kubectl_manifest" "frontend_service" {
  depends_on = [null_resource.kind_cluster]
  yaml_body  = <<-YAML
    apiVersion: v1
    kind: Service
    metadata:
      name: frontend-prod
    spec:
      selector:
        app: frontend
      ports:
        - protocol: TCP
          port: 80
          targetPort: 80
      type: ClusterIP
  YAML
}

resource "kubectl_manifest" "frontend_deployment" {
  depends_on = [null_resource.kind_load_images]
  yaml_body  = <<-YAML
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: frontend-prod
      labels:
        app: frontend
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: frontend
      template:
        metadata:
          labels:
            app: frontend
        spec:
          containers:
            - name: frontend
              image: socialmediaapp-frontend-prod:latest
              imagePullPolicy: Never
              ports:
                - containerPort: 80
  YAML
}

# ─── MICROSERVICE GO ──────────────────────────────────────────
resource "kubectl_manifest" "microservice_go_service" {
  depends_on = [null_resource.kind_cluster]
  yaml_body  = <<-YAML
    apiVersion: v1
    kind: Service
    metadata:
      name: microservice-go
    spec:
      selector:
        app: microservice-go
      ports:
        - protocol: TCP
          port: 8080
          targetPort: 8080
      type: ClusterIP
  YAML
}

resource "kubectl_manifest" "microservice_go_deployment" {
  depends_on = [null_resource.kind_load_images]
  yaml_body  = <<-YAML
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: microservice-go
      labels:
        app: microservice-go
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: microservice-go
      template:
        metadata:
          labels:
            app: microservice-go
        spec:
          containers:
            - name: microservice-go
              image: socialmediaapp-microservice-go:latest
              imagePullPolicy: Never
              ports:
                - containerPort: 8080
              env:
                - name: REDIS_HOST
                  value: redis
                - name: REDIS_PORT
                  value: "6379"
  YAML
}

# ─── MICROSERVICE JAVA ────────────────────────────────────────
resource "kubectl_manifest" "microservice_java_service" {
  depends_on = [null_resource.kind_cluster, kubectl_manifest.kafka_service]
  yaml_body  = <<-YAML
    apiVersion: v1
    kind: Service
    metadata:
      name: microservice-java
    spec:
      selector:
        app: microservice-java
      ports:
        - protocol: TCP
          port: 8080
          targetPort: 8080
      type: ClusterIP
  YAML
}

resource "kubectl_manifest" "microservice_java_deployment" {
  depends_on = [null_resource.kind_load_images, kubectl_manifest.kafka_service]
  yaml_body  = <<-YAML
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: microservice-java
      labels:
        app: microservice-java
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: microservice-java
      template:
        metadata:
          labels:
            app: microservice-java
        spec:
          containers:
            - name: microservice-java
              image: socialmediaapp-microservice-java:latest
              imagePullPolicy: Never
              ports:
                - containerPort: 8080
              env:
                - name: SPRING_CASSANDRA_CONTACT-POINTS
                  value: cassandra
                - name: SPRING_CASSANDRA_PORT
                  value: "9042"
                - name: SPRING_CASSANDRA_LOCAL-DATACENTER
                  value: datacenter1
  YAML
}

# ─── KAFKA ────────────────────────────────────────────────────
resource "kubectl_manifest" "kafka_statefulset" {
  depends_on = [null_resource.kind_cluster]
  yaml_body  = <<-YAML
    apiVersion: apps/v1
    kind: StatefulSet
    metadata:
      name: kafka
      namespace: default
    spec:
      serviceName: kafka
      replicas: 1
      selector:
        matchLabels:
          app: kafka
      template:
        metadata:
          labels:
            app: kafka
        spec:
          containers:
            - name: kafka
              image: confluentinc/cp-kafka:7.6.0
              imagePullPolicy: IfNotPresent
              env:
                # 1. Enable KRaft and define combined roles
                - name: KAFKA_NODE_ID
                  value: "1"
                - name: KAFKA_PROCESS_ROLES
                  value: "broker,controller"
                
                # 2. Configure Listeners for internal cluster and outside traffic
                - name: KAFKA_LISTENERS
                  value: "PLAINTEXT://0.0.0.0:9092,CONTROLLER://0.0.0.0:9093"
                - name: KAFKA_ADVERTISED_LISTENERS
                  value: "PLAINTEXT://kafka:9092"
                - name: KAFKA_CONTROLLER_LISTENER_NAMES
                  value: "CONTROLLER"
                - name: KAFKA_LISTENER_SECURITY_PROTOCOL_MAP
                  value: "CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT"
                - name: KAFKA_INTER_BROKER_LISTENER_NAME
                  value: "PLAINTEXT"
                
                # 3. Establish Controller Quorum Voters
                - name: KAFKA_CONTROLLER_QUORUM_VOTERS
                  value: "1@kafka:9093"
                
                # 4. Generate a unique Cluster ID for KRaft storage formatting
                - name: CLUSTER_ID
                  value: "MkU3OEVBNTcwNTJENDM2Qk"

                # 5. Handle Logging Configurations natively
                - name: KAFKA_LOG_DIRS
                  value: "/var/lib/kafka/data"
                - name: KAFKA_GC_LOG_OPTS
                  value: "-Xlog:gc*:file=/var/lib/kafka/data/kafkaServer-gc.log:time,tags:filecount=10,filesize=100M"
                
                # 6. Minimum parameters for a stable 1-node cluster
                - name: KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR
                  value: "1"
                - name: KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS
                  value: "0"
                - name: KAFKA_TRANSACTION_STATE_LOG_MIN_ISR
                  value: "1"
                - name: KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR
                  value: "1"
              ports:
                - containerPort: 9092
                  name: broker
                - containerPort: 9093
                  name: controller
              resources:
                requests:
                  memory: "512Mi"
                  cpu: "250m"
                limits:
                  memory: "1Gi"
                  cpu: "1000m"
  YAML
}


resource "kubectl_manifest" "kafka_service" {
  depends_on = [kubectl_manifest.kafka_statefulset]
  yaml_body  = <<-YAML
    apiVersion: v1
    kind: Service
    metadata:
      name: kafka
      namespace: default
    spec:
      clusterIP: None
      selector:
        app: kafka
      ports:
        - name: plaintext
          port: 9092
          targetPort: 9092
        - name: controller
          port: 9093
          targetPort: 9093
  YAML
}

# ─── CASSANDRA ────────────────────────────────────────────────
resource "kubectl_manifest" "cassandra_statefulset" {
  depends_on = [null_resource.kind_cluster]
  yaml_body  = <<-YAML
    apiVersion: apps/v1
    kind: StatefulSet
    metadata:
      name: cassandra
      namespace: default
    spec:
      serviceName: cassandra
      replicas: 1
      selector:
        matchLabels:
          app: cassandra
      template:
        metadata:
          labels:
            app: cassandra
        spec:
          initContainers:
            - name: increase-vm-max-map-count
              image: busybox
              imagePullPolicy: IfNotPresent
              command: ["sysctl", "-w", "vm.max_map_count=1048575"]
              securityContext:
                privileged: true
          containers:
            - name: cassandra
              image: cassandra:5.0
              imagePullPolicy: IfNotPresent
              ports:
                - containerPort: 9042
                  name: cql
              env:
                # 1. Increased heap size to match allocated memory limits cleanly
                - name: MAX_HEAP_SIZE
                  value: "1024M"
                - name: HEAP_NEWSIZE
                  value: "256M"
                - name: CASSANDRA_CLUSTER_NAME
                  value: "cassandra-cluster"
              resources:
                requests:
                  memory: "1536Mi"
                  cpu: "250m"
                limits:
                  memory: "2Gi"
                  cpu: "1000m"
              # 2. Replaced heavy CLI execution probes with lightweight TCP port checks
              readinessProbe:
                tcpSocket:
                  port: 9042
                initialDelaySeconds: 45
                periodSeconds: 10
                failureThreshold: 3
              livenessProbe:
                tcpSocket:
                  port: 9042
                initialDelaySeconds: 60
                periodSeconds: 20
                failureThreshold: 5
  YAML
}

resource "kubectl_manifest" "cassandra_service" {
  depends_on = [kubectl_manifest.cassandra_statefulset]
  yaml_body  = <<-YAML
    apiVersion: v1
    kind: Service
    metadata:
      name: cassandra
      namespace: default
    spec:
      clusterIP: None
      selector:
        app: cassandra
      ports:
        - port: 9042
          targetPort: 9042
          name: cql
  YAML
}

# ─── REDIS ────────────────────────────────────────────────────
resource "kubectl_manifest" "redis_deployment" {
  yaml_body = <<-YAML
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: redis
      namespace: default
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: redis
      template:
        metadata:
          labels:
            app: redis
        spec:
          containers:
          - name: redis
            image: redis:7-alpine
            ports:
            - containerPort: 6379
            resources:
              requests:
                memory: "64Mi"
                cpu: "50m"
  YAML
}

resource "kubectl_manifest" "redis_service" {
  depends_on = [kubectl_manifest.redis_deployment]
  yaml_body  = <<-YAML
    apiVersion: v1
    kind: Service
    metadata:
      name: redis
      namespace: default
    spec:
      selector:
        app: redis
      ports:
      - port: 6379
        targetPort: 6379
  YAML
}

# ─── MINIO ────────────────────────────────────────────────────
resource "kubectl_manifest" "minio_service" {
  depends_on = [null_resource.kind_cluster]
  yaml_body  = <<-YAML
    apiVersion: v1
    kind: Service
    metadata:
      name: minio
    spec:
      selector:
        app: minio
      ports:
        - name: api
          protocol: TCP
          port: 9000
          targetPort: 9000
        - name: console
          protocol: TCP
          port: 9004
          targetPort: 9004
      type: ClusterIP
  YAML
}

resource "kubectl_manifest" "minio_deployment" {
  depends_on = [null_resource.kind_load_images]
  yaml_body  = <<-YAML
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: minio
      labels:
        app: minio
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: minio
      template:
        metadata:
          labels:
            app: minio
        spec:
          containers:
            - name: minio
              image: socialmediaapp-minio:latest
              imagePullPolicy: Never
              args:
                - server
                - /data
                - --console-address
                - ":9004"
              ports:
                - containerPort: 9000
                - containerPort: 9004
              env:
                - name: MINIO_ROOT_USER
                  value: ${var.social_minio_user}
                - name: MINIO_ROOT_PASSWORD
                  value: ${var.social_minio_password}
              volumeMounts:
                - name: minio-data
                  mountPath: /data
          volumes:
            - name: minio-data
              emptyDir:
                sizeLimit: 2Gi
  YAML
}

# ─── INGRESSES ────────────────────────────────────────────────
resource "kubectl_manifest" "ingress_api" {
  depends_on = [helm_release.ingress_nginx]
  yaml_body  = <<-YAML
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: social-media-api-ingress
      namespace: default
      annotations:
        nginx.ingress.kubernetes.io/rewrite-target: /api/$2
        nginx.ingress.kubernetes.io/use-regex: "true"
        nginx.ingress.kubernetes.io/proxy-body-size: "100m"
    spec:
      ingressClassName: nginx
      rules:
        - http:
            paths:
              - path: /social/api(/|$)(.*)
                pathType: ImplementationSpecific
                backend:
                  service:
                    name: backend
                    port:
                      number: 8000
  YAML
}

resource "kubectl_manifest" "ingress_minio" {
  depends_on = [helm_release.ingress_nginx]
  yaml_body  = <<-YAML
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: social-media-minio-ingress
      namespace: default
      annotations:
        nginx.ingress.kubernetes.io/rewrite-target: /$2
        nginx.ingress.kubernetes.io/use-regex: "true"
        nginx.ingress.kubernetes.io/proxy-body-size: "100m"
    spec:
      ingressClassName: nginx
      rules:
        - http:
            paths:
              - path: /social/minio(/|$)(.*)
                pathType: ImplementationSpecific
                backend:
                  service:
                    name: minio
                    port:
                      number: 9000
  YAML
}

resource "kubectl_manifest" "ingress_frontend" {
  depends_on = [helm_release.ingress_nginx]
  yaml_body  = <<-YAML
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: social-media-frontend-ingress
      annotations:
        nginx.ingress.kubernetes.io/use-regex: "true"
    spec:
      ingressClassName: nginx
      rules:
      - http:
          paths:
          - path: /social(/|$)(.*)
            pathType: ImplementationSpecific
            backend:
              service:
                name: frontend-prod
                port:
                  number: 80
  YAML
}
