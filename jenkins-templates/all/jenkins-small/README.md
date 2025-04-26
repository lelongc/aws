# Jenkins CI/CD cho Doanh nghiệp nhỏ

## Giới thiệu

Đây là cấu trúc Jenkins CI/CD cơ bản dành cho doanh nghiệp nhỏ, bao gồm các tập tin cấu hình cần thiết để triển khai một hệ thống CI/CD đơn giản nhưng hiệu quả.

## Cấu trúc thư mục

```
jenkins-small/
├── Jenkinsfile                  # Pipeline cơ bản
├── docker-compose.yml           # Cài đặt Jenkins bằng Docker
├── jobs/                        # Các job cấu hình mẫu
│   ├── build-job.xml
│   └── deploy-job.xml
├── plugins.txt                  # Danh sách plugins cần thiết
├── init.groovy.d/               # Scripts thiết lập Jenkins
│   └── basic-security.groovy    # Cấu hình bảo mật cơ bản
└── README.md                    # Tài liệu này
```

## Hướng dẫn cài đặt

1. Đảm bảo Docker và Docker Compose đã được cài đặt
2. Clone repository này về máy local
3. Chạy lệnh sau để khởi động Jenkins:

```bash
docker-compose up -d
```

4. Truy cập Jenkins theo địa chỉ: http://localhost:8080
5. Đăng nhập với tài khoản mặc định:
   - Username: admin
   - Password: admin123

## Cấu hình hệ thống

- Jenkins được cấu hình để sử dụng các plugin cơ bản cho CI/CD
- Pipeline mẫu cung cấp các giai đoạn: Build, Test và Deploy
- Các job mẫu trong thư mục `jobs/` có thể được nhập vào Jenkins

## Danh sách plugins

- Git integration
- Pipeline plugins
- Docker integration
- Credentials management
- Email notification

## Bảo trì

- Sao lưu thư mục `jenkins_home` định kỳ để đảm bảo không mất dữ liệu
- Cập nhật plugins và Jenkins khi có phiên bản mới
- Kiểm tra logs định kỳ để phát hiện vấn đề

## Liên hệ

Nếu có vấn đề hoặc câu hỏi, vui lòng liên hệ với đội phát triển tại: dev-team@example.com
