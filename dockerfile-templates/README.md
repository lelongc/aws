# Dockerfile Templates Collection

Bộ sưu tập các Dockerfile mẫu cho nhiều ngôn ngữ lập trình và nền tảng khác nhau. Các mẫu này được thiết kế cho các doanh nghiệp từ nhỏ đến lớn, và tuân thủ các best practice trong việc xây dựng container.

## Cấu trúc thư mục

```
dockerfile-templates/
│
├── web/                      # Dockerfile cho các ứng dụng web
│   ├── node/                 # Node.js (React, Vue, Angular, Express)
│   ├── php/                  # PHP (Laravel, Symfony, WordPress)
│   ├── python/               # Python (Django, Flask)
│   ├── ruby/                 # Ruby (Rails, Sinatra)
│   ├── java/                 # Java (Spring Boot)
│   └── dotnet/               # .NET Core
│
├── mobile/                   # Dockerfile cho phát triển ứng dụng di động
│   ├── react-native/         # React Native
│   ├── flutter/              # Flutter
│   ├── android/              # Android Native
│   └── ios/                  # iOS build environments
│
├── backend/                  # Dockerfile cho backend services
│   ├── golang/               # Go
│   ├── rust/                 # Rust
│   ├── java/                 # Java (Microservices)
│   ├── python/               # Python (FastAPI, gRPC)
│   ├── nodejs/               # Node.js (NestJS, Express)
│   └── dotnet/               # .NET Core
│
├── data/                     # Dockerfile cho data processing & analytics
│   ├── python-data/          # Python (Pandas, NumPy, Jupyter)
│   ├── r/                    # R
│   ├── spark/                # Apache Spark
│   └── ml/                   # Machine Learning environments
│
├── devops/                   # Dockerfile cho CI/CD và DevOps
│   ├── jenkins/              # Jenkins agents
│   ├── ansible/              # Ansible
│   ├── terraform/            # Terraform
│   └── monitoring/           # Prometheus, Grafana, etc.
│
└── multi-stage/              # Multi-stage Dockerfile examples
    ├── production/           # Production-optimized examples
    └── development/          # Development environment examples
```

## Cách sử dụng

Mỗi Dockerfile template đi kèm với một file README.md giải thích chi tiết cấu trúc và cách sử dụng. Các template được thiết kế để dễ dàng tùy chỉnh theo nhu cầu cụ thể của dự án.

Ví dụ để sử dụng Dockerfile cho ứng dụng Node.js:

```bash
# Sao chép Dockerfile mẫu vào dự án của bạn
cp dockerfile-templates/web/node/node-react-prod.Dockerfile ./Dockerfile

# Tùy chỉnh Dockerfile nếu cần

# Build Docker image
docker build -t my-nodejs-app .

# Chạy container
docker run -p 3000:3000 my-nodejs-app
```

## Best Practices

Các Dockerfile trong bộ sưu tập này tuân thủ các best practices sau:

1. **Sử dụng image cơ sở cụ thể** - Luôn chỉ định phiên bản cụ thể của image cơ sở
2. **Multi-stage builds** - Giảm kích thước image cuối cùng
3. **Layer caching** - Sắp xếp các lệnh để tận dụng tối đa cache
4. **Tối thiểu hóa số lượng layers** - Kết hợp các lệnh RUN khi có thể
5. **Non-root user** - Chạy container với quyền không phải root
6. **Security scanning** - Hướng dẫn scan image với trivy hoặc công cụ tương tự
7. **Environment variables** - Sử dụng biến môi trường cho cấu hình
8. **Healthchecks** - Thêm HEALTHCHECK khi có thể
9. **Proper cleanup** - Xóa cache và files tạm thời không cần thiết

## Phiên Bản

v1.0.0 - Bản release đầu tiên

## Đóng góp

Nếu bạn muốn đóng góp hoặc báo lỗi cho bộ sưu tập Dockerfile này, vui lòng mở issue hoặc pull request tại repository gốc.

## License

MIT
