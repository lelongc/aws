# Jenkins CI/CD Templates for Enterprises of Different Sizes

Bộ template này cung cấp các mẫu Jenkins pipeline cho doanh nghiệp nhỏ, vừa và lớn, mỗi mẫu được thiết kế để phù hợp với quy mô và nhu cầu khác nhau.

## Nội dung

- [Tổng quan về Jenkins CI/CD](#tổng-quan-về-jenkins-cicd)
- [Pipeline cho doanh nghiệp nhỏ](#pipeline-cho-doanh-nghiệp-nhỏ)
- [Pipeline cho doanh nghiệp vừa](#pipeline-cho-doanh-nghiệp-vừa)
- [Pipeline cho doanh nghiệp lớn](#pipeline-cho-doanh-nghiệp-lớn)
- [Hướng dẫn triển khai](#hướng-dẫn-triển-khai)
- [Các khái niệm cần nắm](#các-khái-niệm-cần-nắm)

## Tổng quan về Jenkins CI/CD

Jenkins là một nền tảng tự động hóa mã nguồn mở giúp đơn giản hóa quá trình phát triển phần mềm thông qua tích hợp liên tục (CI) và triển khai liên tục (CD).

### Các thành phần chính của Jenkins:

- **Jenkins Server**: Máy chủ trung tâm điều phối các công việc
- **Agents/Nodes**: Các máy thực thi các tác vụ trong pipeline
- **Plugins**: Mở rộng chức năng của Jenkins (Git, Docker, Kubernetes...)
- **Jenkinsfile**: File định nghĩa pipeline theo cú pháp Declarative hoặc Scripted
- **Pipeline**: Quy trình CI/CD được định nghĩa bằng mã

## Pipeline cho doanh nghiệp nhỏ

### Đặc điểm:

- Pipeline đơn giản, chạy trên một agent
- Sử dụng Maven để build và test
- Triển khai thủ công lên staging và production
- Gửi email thông báo kết quả

### Các giai đoạn:

1. **Checkout**: Lấy mã nguồn từ Git
2. **Build**: Biên dịch mã nguồn
3. **Test**: Chạy unit tests
4. **Deploy to Staging**: Triển khai lên môi trường staging
5. **Manual Approval**: Phê duyệt thủ công trước khi lên production
6. **Deploy to Production**: Triển khai lên môi trường production

### Cách chạy:

```bash
# Thiết lập Jenkins server với Java và Maven
# Tạo pipeline job mới và cấu hình để sử dụng Jenkinsfile
cd /path/to/project
curl -O https://raw.githubusercontent.com/your-repo/small-business-pipeline.jenkinsfile
mv small-business-pipeline.jenkinsfile Jenkinsfile
git add Jenkinsfile
git commit -m "Add Jenkins pipeline"
git push
```

## Pipeline cho doanh nghiệp vừa

### Đặc điểm:

- Chạy trên nền tảng Kubernetes
- Sử dụng containers cho các giai đoạn khác nhau
- Tích hợp với SonarQube để phân tích chất lượng mã nguồn
- Triển khai tự động lên nhiều môi trường
- Thông báo qua Slack

### Các giai đoạn:

1. **Checkout**: Lấy mã nguồn
2. **Build**: Biên dịch mã nguồn
3. **Unit Tests**: Chạy unit tests
4. **Code Quality Analysis**: Phân tích chất lượng mã nguồn với SonarQube
5. **Build Docker Image**: Tạo Docker image
6. **Push Docker Image**: Đẩy Docker image lên registry
7. **Deploy to Dev**: Triển khai lên môi trường phát triển
8. **Integration Tests**: Chạy integration tests
9. **Deploy to Staging**: Triển khai lên môi trường staging (nếu nhánh là develop)
10. **Manual Approval**: Phê duyệt thủ công (nếu nhánh là master)
11. **Deploy to Production**: Triển khai lên môi trường production (nếu nhánh là master)

### Yêu cầu cài đặt:

- Jenkins với Kubernetes plugin
- Kubernetes cluster
- SonarQube server
- Docker registry
- Slack webhook

### Cách chạy:

```bash
# Cài đặt plugins cần thiết: Kubernetes, Docker, SonarQube Scanner, Slack Notification
# Cấu hình credentials cho Docker registry và Kubernetes
# Cấu hình kết nối tới SonarQube
cd /path/to/project
curl -O https://raw.githubusercontent.com/your-repo/medium-business-pipeline.jenkinsfile
mv medium-business-pipeline.jenkinsfile Jenkinsfile
git add Jenkinsfile
git commit -m "Add Jenkins pipeline for medium business"
git push
```

## Pipeline cho doanh nghiệp lớn

### Đặc điểm:

- CI/CD phức tạp với nhiều bước kiểm tra và bảo mật
- Sử dụng multiple agents và parallel stages
- Blue/Green deployment
- Kiểm tra bảo mật và performance
- Tích hợp với nhiều hệ thống (JIRA, PagerDuty, Datadog...)

### Các giai đoạn chính:

1. **Parallel Checkout**: Lấy mã nguồn ứng dụng và infrastructure
2. **Static Analysis & Build**: Phân tích mã nguồn và build song song
3. **Unit Tests**: Chạy unit tests
4. **Build & Scan Container**: Build Docker và quét lỗ hổng bảo mật
5. **Integration Tests**: Chạy integration tests
6. **Performance Tests**: Kiểm tra hiệu năng
7. **Approval Gates**: Các bước phê duyệt từ team Security và Product Owner
8. **Blue/Green Deployment**: Triển khai sử dụng chiến lược Blue/Green
9. **Post Deployment**: Các hoạt động sau triển khai

### Yêu cầu cài đặt:

- Jenkins phân tán với nhiều agents
- Kubernetes cluster
- Các công cụ bảo mật (OWASP Dependency Check, Trivy)
- Công cụ kiểm tra hiệu năng (JMeter, K6)
- AWS/Cloud credentials
- Terraform
- Tích hợp với hệ thống thông báo và giám sát

### Cách chạy:

```bash
# Cài đặt Jenkins Distributed Architecture
# Cài đặt và cấu hình tất cả các plugin cần thiết
# Cấu hình credentials cho tất cả các hệ thống
cd /path/to/project
curl -O https://raw.githubusercontent.com/your-repo/large-enterprise-pipeline.jenkinsfile
mv large-enterprise-pipeline.jenkinsfile Jenkinsfile
git add Jenkinsfile
git commit -m "Add enterprise-grade Jenkins pipeline"
git push
```

## Hướng dẫn triển khai

### 1. Cài đặt Jenkins

```bash
# Cài đặt Jenkins trên Ubuntu
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install jenkins
```

### 2. Cài đặt các plugin cần thiết

- Pipeline
- Git
- Docker
- Kubernetes
- Email Extension
- Slack Notification
- SonarQube Scanner
- OWASP Dependency-Check
- Performance Plugin

### 3. Cấu hình Jenkins

1. Tạo credentials cho các dịch vụ (Git, Docker, Cloud providers)
2. Cấu hình email và Slack notifications
3. Thêm agents/nodes nếu cần
4. Cấu hình kết nối Kubernetes nếu sử dụng

### 4. Tạo và chạy pipeline

1. Tạo Jenkins job kiểu "Pipeline"
2. Cấu hình để sử dụng "Pipeline script from SCM"
3. Chỉ định repository và đường dẫn tới Jenkinsfile
4. Run pipeline

## Các khái niệm cần nắm

### Pipeline

Pipeline là một tập hợp các plugins và công cụ giúp triển khai CI/CD pipeline trong Jenkins.

- **Declarative Pipeline**: Cấu trúc đơn giản, có định nghĩa rõ ràng
- **Scripted Pipeline**: Linh hoạt hơn, sử dụng Groovy script

### Stages và Steps

- **Stage**: Một phần của pipeline (build, test, deploy...), hiển thị trên giao diện Jenkins
- **Step**: Một tác vụ đơn lẻ nằm trong stage

### Agents

Agents là các máy chạy các jobs. Có thể là:

- `agent any`: Chạy trên bất kỳ agent nào có sẵn
- `agent { label 'my-label' }`: Chạy trên agent có label cụ thể
- `agent { docker 'maven:3.8.1-openjdk-11' }`: Chạy trong Docker container
- `agent { kubernetes { ... } }`: Chạy trong Kubernetes pod

### Parallel Execution

Chạy nhiều stages song song để giảm thời gian pipeline:

```groovy
stage('Parallel Stage') {
    parallel {
        stage('Branch A') {
            steps {
                echo "Branch A"
            }
        }
        stage('Branch B') {
            steps {
                echo "Branch B"
            }
        }
    }
}
```

### Shared Libraries

Cho phép tái sử dụng code giữa các pipeline:

```groovy
@Library('my-shared-library') _

pipeline {
    agent any
    stages {
        stage('Example') {
            steps {
                mySharedFunction()
            }
        }
    }
}
```

### Blue Ocean

Giao diện người dùng hiện đại cho Jenkins, giúp trực quan hóa pipeline.

### Best Practices

1. **Fail fast**: Đưa các kiểm tra nhanh lên đầu pipeline
2. **Cache dependencies**: Sử dụng caching để tăng tốc build
3. **Idempotent deployments**: Đảm bảo deployments có thể chạy nhiều lần mà không gây lỗi
4. **Tách biệt environments**: Dev, Staging, Production nên tách biệt hoàn toàn
5. **Monitoring**: Theo dõi hiệu suất của pipeline và deployments

## Tài liệu tham khảo

- [Jenkins User Documentation](https://www.jenkins.io/doc/)
- [Jenkins Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)
- [Jenkins Shared Libraries](https://www.jenkins.io/doc/book/pipeline/shared-libraries/)
- [Kubernetes Jenkins Plugin](https://plugins.jenkins.io/kubernetes/)

---

## Ví dụ Jenkins URL

- Small Business: http://jenkins.smallbusiness.com:8080
- Medium Business: http://jenkins.medium-enterprise.com
- Large Enterprise: https://jenkins.large-enterprise.com
