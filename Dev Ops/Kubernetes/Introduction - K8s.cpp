/* Kubernetes Notes - Complete Overview

Definition:
- Kubernetes is an open-source container orchestration tool developed by Google.
- Container orchestration = managing many containers (like musicians in an orchestra) at scale.

Advantages:
1) High availability
2) Scalability and high performance
3) Disaster recovery (backup and restore)

Core Concepts:

1) Pod:
- Smallest running unit in Kubernetes; abstracts one or more containers.
- Each pod has a private IP for internal communication.
- If a pod crashes, Kubernetes can create a new pod with a new IP.

2) Node:
- A machine (physical or virtual) that runs one or more pods.

3) Cluster:
- Collection of nodes.
- Example structure:
Cluster
 ├─ ConfigMap (centralized configuration for services, environment variables)
 ├─ Secret (sensitive info, like .env variables for pods)
 ├─ Node 1
 │   ├─ Pod A (microservice: user-service)
 │   │   ├─ Accesses ConfigMap & Secret
 │   │   └─ Communicates internally with other pods
 │   └─ Pod B (microservice: notes-service)
 │       ├─ Accesses ConfigMap & Secret
 │       └─ Calls Pod A for user info
 ├─ Node 2
 │   ├─ Pod C (microservice: payments-proxy)
 │   │   └─ Calls external APIs (Stripe, OAuth)
 │   └─ Pod D (microservice: notifications)
 │       └─ Sends emails/push notifications via external APIs
 ├─ Ingress Controller (e.g., NGINX)
 │   ├─ Receives external requests
 │   └─ Routes them to correct pods/services (like a reverse proxy)
 └─ Egress (optional, via NAT/proxy)
     └─ Handles outbound traffic to external APIs securely (like a forward proxy)

4) ConfigMap:
- Centralized service configuration accessible by pods.
- If a service URL or config changes, update ConfigMap instead of each pod individually.

5) Secret:
- Stores sensitive information (passwords, API keys).
- Like .env files in backend projects, but managed in Kubernetes.

6) Deployment:
- Abstraction on top of pods.
- Manages ReplicaSets and rolling updates.
- Ensures desired number of pod replicas are running.
- Handles updates without downtime by creating new pods and removing old ones gradually.

7) Volumes:
- Provides persistent storage for pods, since pods are ephemeral.
- Types:
  1) Inside cluster (local storage, e.g., hostPath)
  2) Outside cluster (remote storage, e.g., NFS, cloud volumes like AWS EBS)

8) Replication / CI-CD:
- Replication = multiple copies of a pod for high availability.
- During code updates, Kubernetes can do a rolling update:
  - New pods deployed first while old pods still serve traffic.
  - Traffic switched to new pods after they are ready.
  - Old pods terminated.
- This prevents downtime in production.

Summary:
- Ingress = external reverse proxy (public request → internal pods)
- Egress = outgoing traffic management (internal → external APIs)
- Deployment = ensures pod replicas, handles updates automatically
- ConfigMap / Secret = centralized config and secure info
- Volumes = persistent storage
- Replication = high availability & zero downtime

Kubernetes & Container Abstraction Ladder:

Assembly
  -> C
    -> C++ (OOP, classes)
      -> Browser engines (JS runtime environment)
        -> JavaScript / Node.js
          -> Express.js (framework abstraction)
            -> Next.js (framework abstraction on Express)
              -> Docker container (packaged app)
                -> Kubernetes Pod (abstracted container)
                  -> Replica managed by Deployment (scalable, fault-tolerant)

Observation on abstraction and resource usage:

- Every layer of abstraction simplifies development and adds features but increases complexity and size.
- Example chain: 
  assembly -> C -> C++ -> JS/Node -> Express -> Next.js -> Docker container -> Kubernetes Pod -> Deployment/Replica
- Each layer brings:
  * Runtime requirements
  * Libraries/packages
  * Container image sizes
- Result: even a small service can balloon to hundreds of MBs or GBs in a Kubernetes cluster when fully containerized with dependencies and replicas.
- Trade-off: abstraction and scalability vs performance, resource usage, and debugging difficulty
Deployments vs StatefulSets:

- Deployment:
  * Used for **stateless pods**
  * Pods are interchangeable; can be scaled up/down easily
  * IPs and storage are ephemeral (they can be recreated anywhere)
  * Example: frontend, API services

- StatefulSet:
  * Used for **stateful pods**
  * Maintains **stable identities, stable network IDs, and stable storage**
  * Each pod gets a persistent volume (via PersistentVolumeClaim)
  * Scaling preserves the ordering and uniqueness of pods
  * Example: Databases (PostgreSQL, MongoDB), Kafka

Why StatefulSets matter:
- Avoids inconsistencies in databases and other stateful apps
- Guarantees pods can reconnect to the same storage
- Allows safe upgrades and replicas without data loss

Architecture of a simple node:

A simple node contains the following things 

                    ┌─────────────────────────────────────────────────────┐
                    │          Kubernetes Cluster                         │
                    │                                                     │
                    │  ┌──────────────────┐   ┌──────────────────┐        │
                    │  │     Node 1       │   │     Node 2       │        │
                    │  │                  │   │                  │        │
                    │  │  ┌───────────┐   │   │  ┌───────────┐   │        │
                    │  │  │  my-app   │   │   │  │  my-app   │   │        │
                    │  │  │  (Docker) │   │   │  │  (Docker) │   │        │
                    │  │  └─────┬─────┘   │   │  └─────┬─────┘   │        │
                    │  │        │         │   │        │         │        │
                    │  │        └─────────┼───┼────────┘         │        │
                    │  │                  │   │                  │        │
                    │  │    ┌─────────────┴───┴─────────────┐    │        │
                    │  │    │      DB Service               │    │        │
                    │  │    └─────────────┬───┬─────────────┘    │        │
                    │  │                  │   │                  │        │
                    │  │        ┌─────────┘   └────────┐         │        │
                    │  │        │                      │         │        │
                    │  │  ┌─────┴─────┐         ┌─────┴─────┐    │        │
                    │  │  │    DB     │         │    DB     │    │        │ 
                    │  │  │  (Docker) │         │  (Docker) │    │        │
                    │  │  └───────────┘         └───────────┘    │        │
                    │  │                                         │        │
                    │  │  ┌───────────┐         ┌───────────┐    │        │
                    │  │  │  Kubelet  │         │  Kubelet  │    │        │
                    │  │  └───────────┘         └───────────┘    │        │
                    │  └──────────────────┘   └──────────────────┘        │
                    └─────────────────────────────────────────────────────┘

this is the diagram 
it contains the runtime of the docker (we call it pod),
and data base service to connect two instances of the node data base and communicate with each other
kubelet is the process of kubernetes which does what the kubernetes master node want to do

here is a master node structure

 ┌──────────────────────────────────────────────┐
 │                    Client                    │
 │   • Sends Update & Query requests            │
 └──────────────────────────────────────────────┘
                    │
                    ▼
 ┌──────────────────────────────────────────────┐
 │                  MASTER 1                    │
 │                                              │
 │   ┌────────────────────────────────────────┐ │
 │   │              API Server                │ │
 │   │  • Entry point of cluster              │ │
 │   │  • Validates requests & talks to etcd  │ │
 │   └────────────────────────────────────────┘ │
 │                                              │
 │   ┌────────────────────────────────────────┐ │
 │   │                Scheduler               │ │
 │   │  • Assigns pods to worker nodes        │ │
 │   │  • Chooses best node based on usage    │ │
 │   └────────────────────────────────────────┘ │
 │                                              │
 │   ┌────────────────────────────────────────┐ │
 │   │           Controller Manager           │ │
 │   │  • Runs control loops                  │ │
 │   │  • Maintains desired cluster state     │ │
 │   └────────────────────────────────────────┘ │
 │                                              │
 │   ┌────────────────────────────────────────┐ │
 │   │                   etcd                 │ │
 │   │  • Key–value store for all cluster     │ │
 │   │    data                                │ │
 │   │  • Source of truth for cluster state   │ │
 │   └────────────────────────────────────────┘ │
 │                                              │
 └──────────────────────────────────────────────┘

these control the worker nodes and consumes less resources

Minikube and kubectl:
ok it is easy to do in speaking but we have to use it in production 
how can we do that
there comes the minikube 
here both the master and worker node runs on the same machine removing the 
requirements for high resource needs like servers

then what is kubectl 
it is a kube controller 
how will you create services, locks, configmaps
there comes kubernetes API 
how will you communicate with it
there are 3 ways
1) UI 2) API directly 
and the most powerful one 3) CLI which is kubectl



















*/
