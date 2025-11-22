# 1️⃣ Make Kubernetes use local Docker images (Minikube)
# Only if using Minikube; uncomment if needed
# & minikube docker-env | Invoke-Expression

# 2️⃣ Create k8s folder
$k8sPath = "C:\Coding Project\Projects\Social Media App\k8s"
if (!(Test-Path $k8sPath)) { New-Item -ItemType Directory -Path $k8sPath }

# 3️⃣ Define manifest contents using your actual container names
$manifests = @{

"postgres-deployment.yaml" = @"
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres
spec:
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
        env:
          - name: POSTGRES_DB
            value: 'socialmediaapp'
          - name: POSTGRES_USER
            value: 'postgres'
          - name: POSTGRES_PASSWORD
            value: 'saisakthi2008'
        ports:
          - containerPort: 5432
"@

"postgres-service.yaml" = @"
apiVersion: v1
kind: Service
metadata:
  name: postgres
spec:
  selector:
    app: postgres
  ports:
    - port: 5432
      targetPort: 5432
      name: postgres
  type: ClusterIP
"@

"backend-deployment.yaml" = @"
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
        image: socialmediaapp-django
        env:
          - name: DB_NAME
            value: 'socialmediaapp'
          - name: DB_USER
            value: 'postgres'
          - name: DB_PASSWORD
            value: 'saisakthi2008'
          - name: DB_HOST
            value: 'postgres'
          - name: DB_PORT
            value: '5432'
        ports:
          - containerPort: 8000
"@

"backend-service.yaml" = @"
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
      name: backend
  type: ClusterIP
"@

"frontend-deployment.yaml" = @"
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
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
        image: socialmediaapp-frontend-dev
        ports:
          - containerPort: 5173
"@

"frontend-service.yaml" = @"
apiVersion: v1
kind: Service
metadata:
  name: frontend
spec:
  selector:
    app: frontend
  ports:
    - port: 5173
      targetPort: 5173
      name: frontend
  type: NodePort
"@

"minio-deployment.yaml" = @"
apiVersion: apps/v1
kind: Deployment
metadata:
  name: minio
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
        image: socialmediaapp-minio
        args: ["server", "/data", "--console-address", ":9004"]
        env:
          - name: MINIO_ROOT_USER
            value: "minio"
          - name: MINIO_ROOT_PASSWORD
            value: "minio123"
        ports:
          - containerPort: 9000
          - containerPort: 9004
        volumeMounts:
          - name: minio-storage
            mountPath: /data
      volumes:
        - name: minio-storage
          emptyDir: {}
"@

"minio-service.yaml" = @"
apiVersion: v1
kind: Service
metadata:
  name: minio
spec:
  selector:
    app: minio
  ports:
    - name: api
      port: 9000
      targetPort: 9000
    - name: console
      port: 9004
      targetPort: 9004
  type: ClusterIP
"@

"tempo-deployment.yaml" = @"
apiVersion: apps/v1
kind: Deployment
metadata:
  name: tempo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: tempo
  template:
    metadata:
      labels:
        app: tempo
    spec:
      containers:
      - name: tempo
        image: grafana/tempo:2.4.1
        args: ["-config.file=/etc/tempo/config.yml"]
        ports:
          - containerPort: 3200
"@

"tempo-service.yaml" = @"
apiVersion: v1
kind: Service
metadata:
  name: tempo
spec:
  selector:
    app: tempo
  ports:
    - port: 3200
      targetPort: 3200
      name: tempo
  type: ClusterIP
"@
}

# 4️⃣ Write manifests
foreach ($file in $manifests.Keys) {
    $content = $manifests[$file]
    $filePath = Join-Path $k8sPath $file
    Set-Content -Path $filePath -Value $content
}

Write-Host "All Kubernetes manifests created in $k8sPath"

# 5️⃣ Apply manifests
kubectl apply -f $k8sPath

# 6️⃣ Show pod status
kubectl get pods -w
