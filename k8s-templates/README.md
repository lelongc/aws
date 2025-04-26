# Kubernetes Templates Collection

Bộ sưu tập các template Kubernetes (K8s) cho nhiều loại ứng dụng và services khác nhau, phù hợp cho các doanh nghiệp từ nhỏ đến lớn.

## Cấu trúc thư mục

```
k8s-templates/
│
├── basic/                   # Template K8s cơ bản
│   ├── deployment.yaml      # Deployment đơn giản
│   ├── service.yaml         # ClusterIP và NodePort services
│   ├── ingress.yaml         # Ingress cơ bản
│   └── configmap-secret.yaml # ConfigMap và Secret
│
├── applications/            # Template cho các ứng dụng phổ biến
│   ├── web/                 # Web applications
│   │   ├── nodejs/          # Node.js apps (Express, Next.js)
│   │   ├── python/          # Python apps (Django, Flask)
│   │   └── java/            # Java apps (Spring Boot)
│   │
│   ├── databases/           # Database deployments
│   │   ├── mysql/           # MySQL với persistent storage
│   │   ├── postgresql/      # PostgreSQL với persistent storage
│   │   ├── mongodb/         # MongoDB với replication
│   │   └── redis/           # Redis với clustering
│   │
│   └── messaging/           # Messaging systems
│       ├── kafka/           # Kafka cluster
│       ├── rabbitmq/        # RabbitMQ
│       └── nats/            # NATS
│
├── advanced/                # Cấu hình K8s nâng cao
│   ├── hpa/                 # Horizontal Pod Autoscaling
│   ├── pdb/                 # Pod Disruption Budget
│   ├── network-policies/    # Network Policies
│   ├── resource-quotas/     # Resource Quotas và Limits
│   └── affinity/            # Node/Pod Affinity rules
│
├── monitoring/              # Monitoring và logging
│   ├── prometheus/          # Prometheus stack
│   ├── grafana/             # Grafana dashboards
│   ├── loki/                # Loki for logs
│   └── jaeger/              # Jaeger for tracing
│
├── security/                # Security configurations
│   ├── rbac/                # Role-Based Access Control
│   ├── network-policies/    # Security-focused policies
│   ├── pod-security/        # Pod Security Policies/Standards
│   └── cert-manager/        # Cert-manager for TLS
│
└── gitops/                  # GitOps templates
    ├── argocd/              # ArgoCD configurations
    └── flux/                # Flux CD configurations
```

## Cách sử dụng

### Triển khai ứng dụng cơ bản

```bash
# Áp dụng deployment và service
kubectl apply -f k8s-templates/basic/deployment.yaml
kubectl apply -f k8s-templates/basic/service.yaml

# Tùy chỉnh trước khi apply
cat k8s-templates/basic/deployment.yaml | sed 's/app-name/my-application/g' | kubectl apply -f -
```

### Sử dụng Kustomize

Nhiều template được thiết kế để sử dụng với Kustomize:

```bash
# Tạo overlay cho môi trường production
mkdir -p my-app/overlays/production
cp k8s-templates/applications/web/nodejs/kustomization.yaml my-app/overlays/production/

# Tùy chỉnh và áp dụng
cd my-app
kubectl apply -k overlays/production/
```

## Best Practices

### Resource Management

- Luôn thiết lập resource requests và limits cho mỗi container
- Sử dụng HorizontalPodAutoscaler để tự động scale theo tải
- Cấu hình PodDisruptionBudget để đảm bảo tính khả dụng cao

### Configuration

- Sử dụng ConfigMaps cho cấu hình không nhạy cảm
- Sử dụng Secrets cho thông tin nhạy cảm (mật khẩu, tokens, certificates)
- Tận dụng các environment variables và volume mounts

### Networking

- Giới hạn network traffic với NetworkPolicies
- Sử dụng Services cho service discovery
- Cấu hình Ingress với TLS cho các endpoint public

### Security

- Áp dụng RBAC (Role-Based Access Control) cho tất cả users và serviceaccounts
- Chạy containers với non-root user
- Thiết lập SecurityContext và PodSecurityStandards

### High Availability

- Sử dụng multiple replicas cho stateless apps
- Cấu hình pod anti-affinity để phân tán trên nhiều nodes
- Thiết lập liveness và readiness probes

## Templates cho từng quy mô doanh nghiệp

### Doanh nghiệp nhỏ

- Basic deployment, service, và ingress
- Single-instance databases với persistent storage
- Simple monitoring với Prometheus và Grafana

### Doanh nghiệp vừa

- Multi-replica deployments với HPA
- Database replication (master-slave)
- CI/CD integration với ArgoCD
- Monitoring stack đầy đủ

### Doanh nghiệp lớn

- Multi-cluster deployments
- Advanced service mesh (Istio)
- Geo-distributed databases
- Comprehensive security policies
- Custom resource definitions (CRDs)

## Tài liệu tham khảo

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Kubernetes Best Practices](https://kubernetes.io/docs/concepts/configuration/overview/)
- [Cloud Native Trail Map](https://github.com/cncf/landscape/blob/master/README.md#trail-map)
- [Kubernetes Patterns](https://www.oreilly.com/library/view/kubernetes-patterns/9781492050278/)
