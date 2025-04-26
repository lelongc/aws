# Jenkins CI/CD cho Doanh nghiệp Vừa

## Tổng quan

Đây là giải pháp CI/CD toàn diện sử dụng Jenkins cho doanh nghiệp vừa, bao gồm Jenkins master, agents và các pipelines tự động hóa phức tạp. Hệ thống được thiết kế để hỗ trợ nhiều nhóm phát triển và môi trường triển khai.

## Kiến trúc hệ thống

```
jenkins-medium/
├── master/                      # Cấu hình Jenkins master
│   ├── docker-compose.yml       # Docker compose cho master
│   ├── plugins.txt              # Plugins cho master
│   └── init.groovy.d/           # Automation scripts
│       ├── basic-security.groovy
│       └── configure-credentials.groovy
├── agents/                      # Cấu hình Jenkins agents
│   ├── linux/
│   │   └── Dockerfile           # Agent Linux
│   └── windows/
│       └── Dockerfile           # Agent Windows
├── pipelines/                   # Các Jenkinsfile cho từng dự án
│   ├── web-app/
│   │   └── Jenkinsfile
│   └── api-service/
│       └── Jenkinsfile
├── shared-libraries/            # Shared Libraries
│   ├── vars/                    # Global variables/functions
│   │   ├── buildJava.groovy
│   │   └── deployToK8s.groovy
│   ├── src/                     # Source code
│   │   └── org/example/
│   │       └── Utils.groovy
│   └── resources/               # Non-source files
│       └── templates/
│           └── deployment.yaml
├── jobs/                        # Job DSL scripts
│   ├── seed-jobs.groovy
│   └── project-jobs.groovy
├── casc/                        # Configuration as Code
│   └── jenkins.yaml             # Jenkins configuration
└── README.md                    # Tài liệu này
```

## Hướng dẫn triển khai

### 1. Thiết lập Jenkins Master

```bash
cd master
docker-compose up -d
```

### 2. Cấu hình Jenkins Configuration as Code (JCasC)

1. Đảm bảo plugin `configuration-as-code` được cài đặt
2. Sao chép file `casc/jenkins.yaml` vào thư mục `/var/jenkins_home/casc_configs/`
3. Cài đặt biến môi trường `CASC_JENKINS_CONFIG=/var/jenkins_home/casc_configs/`
4. Khởi động lại Jenkins

### 3. Cài đặt Shared Libraries

1. Tạo và cấu hình Shared Libraries trong Jenkins
2. Sử dụng Git repositories cho mỗi shared library
3. Cấu hình các dự án để sử dụng shared libraries

### 4. Thiết lập Kubernetes agents

1. Triển khai Kubernetes cluster
2. Cấu hình Jenkins Kubernetes plugin
3. Sử dụng các pod templates đã định nghĩa

## Shared Libraries

Thư viện chứa các hàm tái sử dụng cho pipelines:

- `buildJava.groovy`: Hàm xây dựng và kiểm thử ứng dụng Java
- `deployToK8s.groovy`: Hàm triển khai ứng dụng lên Kubernetes

## Pipeline-as-Code

Mỗi dự án có một Jenkinsfile riêng định nghĩa quy trình CI/CD:

- Build & test
- Static code analysis
- Container build
- Triển khai đến các môi trường khác nhau
- Thông báo kết quả

## Bảo mật

- LDAP authentication (tùy chọn)
- Role-based Access Control
- Credentials management
- Audit logging

## Monitoring và Logging

- Prometheus integration
- Grafana dashboards
- Log forwarding đến ELK stack

## Khắc phục sự cố

Các vấn đề thường gặp và cách giải quyết:

1. **Pipeline lỗi**: Kiểm tra logs và console output
2. **Agent không kết nối**: Kiểm tra mạng và cấu hình
3. **Jenkins quá tải**: Tăng tài nguyên và tối ưu cấu hình

## Liên hệ

Nếu cần hỗ trợ, vui lòng liên hệ: jenkins-admin@example.com
