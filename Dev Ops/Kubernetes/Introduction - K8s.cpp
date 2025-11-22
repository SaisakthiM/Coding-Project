/* Kubernetes Notes

This is a Kubernetes course

Introduction:
- Kubernetes is an open-source container orchestration tool developed by Google.
- Container orchestration manages multiple containers (like managing an orchestra of musicians).
- Advantages:
  1) High availability
  2) Scalability and high performance
  3) Disaster recovery (backup and restore)

- What is a container orchestration tool?
  - Think of a container running in Docker as a musician.
  - If you have 100-200 musicians playing simultaneously, how do you manage them?
  - Orchestration is like managing a musical orchestra; Kubernetes manages all containers.


Pods:
- Smallest running unit in Kubernetes.
- Abstracts a container (blueprint of what to do, not how to do it).
- Each pod gets a private IP for internal communication.
- If a pod crashes, the node recreates it and assigns a new IP.
- Abstraction:
  - Blueprint abstraction: Pods abstract container details.
  - Layered abstraction: e.g., JS → Node → Express → Next.js (adds convenience, may reduce performance).

Cluster Hierarchy:
Cluster
 ├─ ConfigMap
 │   - Centralized configuration for services, environment variables.
 │   - All pods can access it; change config in one place, all pods use updated values.
 ├─ Secret
 │   - Stores sensitive data (.env, API keys, passwords) securely.
 │   - Pods access it like environment variables without exposing secrets.
 ├─ Node 1
 │   ├─ Pod A (microservice: user-service)
 │   │   ├─ Accesses ConfigMap and Secret for API URLs and credentials
 │   │   └─ Communicates internally with other pods
 │   └─ Pod B (microservice: notes-service)
 │       ├─ Accesses ConfigMap for database URL and auth secrets
 │       └─ Calls Pod A for user info
 ├─ Node 2
 │   ├─ Pod C (microservice: payments-proxy)
 │   │   └─ Calls external APIs (Stripe, OAuth)
 │   └─ Pod D (microservice: notifications)
 │       └─ Sends emails or push notifications using external APIs
 ├─ Ingress Controller (e.g., NGINX)
 │   ├─ Works like a reverse proxy
 │   ├─ Converts internal pod addresses to secure public URLs
 │   └─ Routes requests to correct pods/services
└─ Egress (optional, via NAT/proxy)
     - Handles outbound traffic from cluster to external APIs securely
     - Definition: Egress manages traffic leaving the Kubernetes cluster.
       It ensures external requests from pods are routed properly, optionally filtered,
       or proxied through a secure gateway.
Ingress:
- Converts internal addresses (e.g., http://192.168.9.2:port) to secure, public-facing URLs.
- Ensures HTTPS and better domain names.

Summary:
- Pods abstract containers and are basic Kubernetes units.
- Nodes are collections of pods.
- Clusters are collections of nodes.
- ConfigMaps centralize configuration; Secrets store sensitive data.
- Ingress manages incoming traffic; Egress manages outbound traffic.
- Microservices communicate internally or externally through cluster infrastructure.
*/
