# Docker - Hướng dẫn toàn diện

## Mục lục

- [Giới thiệu về Docker](#giới-thiệu-về-docker)
- [Kiến trúc Docker](#kiến-trúc-docker)
- [Cài đặt Docker](#cài-đặt-docker)
- [Các khái niệm cơ bản](#các-khái-niệm-cơ-bản)
- [Lệnh Docker cơ bản](#lệnh-docker-cơ-bản)
- [Dockerfile](#dockerfile)
- [Docker Compose](#docker-compose)
- [Docker Volumes](#docker-volumes)
- [Docker Network](#docker-network)
- [Docker Registry](#docker-registry)
- [Best Practices](#best-practices)
- [Docker Security](#docker-security)
- [Docker trong CI/CD](#docker-trong-cicd)
- [Các công cụ liên quan](#các-công-cụ-liên-quan)
- [Khắc phục sự cố](#khắc-phục-sự-cố)
- [Tài liệu tham khảo](#tài-liệu-tham-khảo)

## Giới thiệu về Docker

Docker là một nền tảng mã nguồn mở cho phép tự động triển khai ứng dụng bên trong các container. Docker đảm bảo ứng dụng luôn chạy giống nhau trong mọi môi trường thông qua việc đóng gói ứng dụng và tất cả dependencies của nó vào một container nhẹ, di động.

### Lợi ích chính của Docker:

- **Tính nhất quán**: Đảm bảo ứng dụng chạy giống nhau trong development, staging và production
- **Nhẹ và hiệu quả**: Container sử dụng ít tài nguyên hơn so với máy ảo truyền thống
- **Tốc độ triển khai**: Docker container khởi động và dừng nhanh chóng
- **Cô lập**: Các container hoạt động độc lập, không ảnh hưởng đến nhau
- **Khả năng mở rộng**: Dễ dàng thêm/xóa container tùy theo nhu cầu

## Kiến trúc Docker

![Docker Architecture](https://docs.docker.com/engine/images/architecture.svg)

Docker sử dụng kiến trúc client-server:

- **Docker Client**: Giao diện người dùng chính để tương tác với Docker
- **Docker Host**: Chạy Docker daemon (dockerd)
- **Docker Daemon**: Quản lý các Docker object như images, containers, networks và volumes
- **Docker Registry**: Lưu trữ Docker images

## Cài đặt Docker

### Windows

```bash
# Tải Docker Desktop cho Windows từ trang chủ
https://www.docker.com/products/docker-desktop

# Hoặc sử dụng Windows Package Manager (winget)
winget install Docker.DockerDesktop
```

### macOS

```bash
# Tải Docker Desktop cho Mac từ trang chủ
https://www.docker.com/products/docker-desktop

# Hoặc sử dụng Homebrew
brew install --cask docker
```

### Linux (Ubuntu)

```bash
# Cập nhật package index
sudo apt-get update

# Cài đặt các packages cần thiết
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common

# Thêm Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Thêm Docker repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Cài đặt Docker Engine
sudo apt-get update
sudo apt-get install docker-ce

# Cài đặt Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.18.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

## Các khái niệm cơ bản

### Container

Container là một instance đang chạy của một Docker image. Container là một đơn vị phần mềm tiêu chuẩn đóng gói mã và tất cả các dependencies của nó.

### Image

Image là một template chỉ đọc chứa các hướng dẫn để tạo container Docker. Image chứa hệ điều hành, ứng dụng, thư viện và các file cấu hình.

### Dockerfile

File văn bản chứa tất cả các lệnh để tạo Docker image.

### Docker Hub

Registry công cộng để lưu trữ và chia sẻ Docker images.

### Docker Compose

Công cụ để định nghĩa và chạy multi-container Docker applications.

### Volume

Cơ chế lưu trữ dữ liệu được tạo và sử dụng bởi Docker containers.

## Lệnh Docker cơ bản

### Quản lý Images

```bash
# Tải image từ Docker Hub
docker pull [image_name]:[tag]

# Liệt kê tất cả images trên máy host
docker images

# Xóa image
docker rmi [image_id/image_name]

# Tạo image từ Dockerfile
docker build -t [image_name]:[tag] [path_to_dockerfile_directory]

# Đẩy image lên registry
docker push [image_name]:[tag]
```

### Quản lý Containers

```bash
# Tạo và khởi động container
docker run [options] [image_name]:[tag]

# Các options phổ biến
# -d: Chạy container ở background
# -p host_port:container_port: Map port của host với container
# -v host_path:container_path: Mount volume
# --name: Đặt tên cho container
# --rm: Tự động xóa container khi stop

# Liệt kê container đang chạy
docker ps

# Liệt kê tất cả container (kể cả đã dừng)
docker ps -a

# Dừng container
docker stop [container_id/container_name]

# Khởi động container đã dừng
docker start [container_id/container_name]

# Khởi động lại container
docker restart [container_id/container_name]

# Xóa container
docker rm [container_id/container_name]

# Xem logs của container
docker logs [container_id/container_name]

# Thực thi lệnh trong container đang chạy
docker exec -it [container_id/container_name] [command]

# Tạo một bash shell trong container đang chạy
docker exec -it [container_id/container_name] bash
```

### Quản lý Docker system

```bash
# Hiển thị thông tin hệ thống Docker
docker info

# Hiển thị thống kê disk usage
docker system df

# Xóa tất cả container, network, image và build cache không sử dụng
docker system prune -a
```

## Dockerfile

Dockerfile là file text chứa các lệnh để xây dựng Docker image. Dưới đây là cấu trúc và các lệnh phổ biến trong Dockerfile:

```dockerfile
# Base image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Metadata
LABEL maintainer="example@example.com"
LABEL version="1.0"

# Environment variables
ENV NODE_ENV=production
ENV PORT=3000

# Copy package.json first (for better caching)
COPY package.json package-lock.json* ./

# Install dependencies
RUN npm ci --only=production

# Copy application code
COPY . .

# Build application (if needed)
RUN npm run build

# Expose port
EXPOSE 3000

# Set non-root user
USER node

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1

# Command to run when container starts
CMD ["node", "dist/main.js"]
```

### Các lệnh Dockerfile chính:

- **FROM**: Chỉ định image cơ sở
- **WORKDIR**: Thiết lập thư mục làm việc trong container
- **COPY/ADD**: Sao chép files từ host vào container
- **RUN**: Thực thi lệnh shell và tạo layer mới
- **ENV**: Thiết lập biến môi trường
- **EXPOSE**: Khai báo port mạng container lắng nghe
- **USER**: Thiết lập user để chạy image
- **VOLUME**: Tạo mount point cho external volumes
- **CMD**: Lệnh mặc định khi container khởi chạy
- **ENTRYPOINT**: Configures container to run as an executable
- **HEALTHCHECK**: Kiểm tra container còn hoạt động không

### Best Practices cho Dockerfile:

1. **Sử dụng .dockerignore** để loại bỏ các file không cần thiết
2. **Multi-stage builds** để giảm kích thước image
3. **Layer caching**: Sắp xếp các lệnh để tận dụng tối đa cache
4. **Combine RUN commands** để giảm số lượng layers
5. **Sử dụng image cơ sở nhẹ** như Alpine Linux
6. **Chỉ định tag cụ thể** cho image cơ sở
7. **Non-root user** để tăng tính bảo mật
8. **Minimizing installed packages** để giảm attack surface

## Docker Compose

Docker Compose là công cụ để định nghĩa và quản lý multi-container Docker applications. File `docker-compose.yml` mô tả các services, networks và volumes.

### Ví dụ docker-compose.yml:

```yaml
version: "3.8"

services:
  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile.prod
    ports:
      - "80:80"
    depends_on:
      - backend
    environment:
      - API_URL=http://backend:3000/api
    networks:
      - app-network
    restart: unless-stopped

  backend:
    build: ./backend
    ports:
      - "3000:3000"
    depends_on:
      - database
    environment:
      - DATABASE_URL=postgres://user:password@database:5432/db
      - NODE_ENV=production
    volumes:
      - ./uploads:/app/uploads
    networks:
      - app-network
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  database:
    image: postgres:14-alpine
    volumes:
      - db-data:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=password
      - POSTGRES_DB=db
    ports:
      - "5432:5432"
    networks:
      - app-network

networks:
  app-network:
    driver: bridge

volumes:
  db-data:
    driver: local
```

### Các lệnh Docker Compose:

```bash
# Tạo và khởi động tất cả services
docker-compose up

# Tạo và khởi động ở background
docker-compose up -d

# Tạo và khởi động service cụ thể
docker-compose up -d [service_name]

# Build lại images
docker-compose build

# Dừng services
docker-compose stop

# Dừng và xóa tất cả containers, networks
docker-compose down

# Dừng và xóa tất cả, bao gồm cả volumes
docker-compose down -v

# Xem logs của tất cả services
docker-compose logs

# Xem logs của một service cụ thể
docker-compose logs [service_name]

# Xem status của services
docker-compose ps

# Chạy command trong service
docker-compose exec [service_name] [command]

# Scale service
docker-compose up -d --scale [service_name]=3
```

## Docker Volumes

Volumes là cơ chế lưu trữ dữ liệu liên tục cho các Docker containers.

### Types of volumes:

1. **Named volumes**: Quản lý bởi Docker

   ```bash
   docker volume create my-volume
   docker run -v my-volume:/app/data [image_name]
   ```

2. **Bind mounts**: Mount thư mục từ host vào container

   ```bash
   docker run -v /host/path:/container/path [image_name]
   ```

3. **tmpfs mounts**: Lưu trữ tạm thời trong memory
   ```bash
   docker run --tmpfs /app/tmp [image_name]
   ```

### Volume commands:

```bash
# Tạo volume
docker volume create [volume_name]

# Liệt kê volumes
docker volume ls

# Kiểm tra thông tin chi tiết volume
docker volume inspect [volume_name]

# Xóa volume
docker volume rm [volume_name]

# Xóa tất cả volumes không sử dụng
docker volume prune
```

## Docker Network

Docker networks cho phép các containers giao tiếp với nhau và với thế giới bên ngoài.

### Network drivers:

1. **bridge**: Default network driver, containers trên cùng network có thể giao tiếp với nhau
2. **host**: Container dùng trực tiếp networking của host
3. **none**: Tắt networking
4. **overlay**: Kết nối nhiều Docker daemons
5. **macvlan**: Container có MAC address riêng biệt

### Network commands:

```bash
# Tạo network
docker network create [options] [network_name]

# Liệt kê networks
docker network ls

# Kiểm tra thông tin chi tiết network
docker network inspect [network_name]

# Kết nối container vào network
docker network connect [network_name] [container_name]

# Ngắt kết nối container khỏi network
docker network disconnect [network_name] [container_name]

# Xóa network
docker network rm [network_name]

# Xóa tất cả networks không sử dụng
docker network prune
```

## Docker Registry

Registry là dịch vụ lưu trữ và phân phối Docker images.

### Public Registry:

- **Docker Hub**: Registry công cộng mặc định
- **GitHub Container Registry**: GitHub's container registry
- **Amazon ECR Public Gallery**: AWS's public container registry

### Private Registry:

- **Docker Registry**: Self-hosted registry
- **Amazon ECR**: AWS's private container registry
- **Google Container Registry (GCR)**: Google Cloud's container registry
- **Azure Container Registry (ACR)**: Microsoft Azure's container registry

### Registry commands:

```bash
# Đăng nhập vào registry
docker login [registry_url]

# Đẩy image lên registry
docker push [registry_url]/[username]/[image_name]:[tag]

# Kéo image từ registry
docker pull [registry_url]/[username]/[image_name]:[tag]

# Đăng xuất khỏi registry
docker logout [registry_url]
```

## Best Practices

### Security:

1. **Keep images minimal**: Chỉ bao gồm những gì cần thiết
2. **Use official base images**: Ưu tiên dùng images chính thức
3. **Scan images for vulnerabilities**: Sử dụng công cụ như Trivy, Snyk
4. **Use non-root users**: Tránh chạy container với quyền root
5. **Use read-only filesystems** khi có thể
6. **Limit capabilities and resources**
7. **Update images regularly** để sửa lỗi bảo mật

### Performance:

1. **Multi-stage builds**: Giảm kích thước image
2. **Layer caching**: Tối ưu hóa build process
3. **Don't install unnecessary packages**
4. **Use .dockerignore** để loại bỏ các file không cần thiết
5. **Combine RUN commands** để giảm layers
6. **Set resource limits** cho container

### Deployment:

1. **Use container orchestration** như Kubernetes, Docker Swarm
2. **Implement health checks** để kiểm tra trạng thái container
3. **Use rolling updates** để triển khai không downtime
4. **Implement proper logging** để dễ debug
5. **Monitor containers** sử dụng công cụ như Prometheus, cAdvisor

## Docker Security

### Security Concerns:

1. **Container isolation**: Containers chia sẻ kernel với host
2. **Image security**: Images có thể chứa vulnerabilities
3. **Container privileges**: Containers chạy với quyền quá cao
4. **Data security**: Bảo vệ dữ liệu nhạy cảm

### Security Best Practices:

1. **Scan images** để tìm vulnerabilities
2. **Use trusted images** từ nguồn đáng tin cậy
3. **Limit container resources** để ngăn DoS attack
4. **Use secrets management** cho thông tin nhạy cảm
5. **Enable content trust** để verify image integrity
6. **Use read-only filesystems** khi có thể
7. **Apply security updates** thường xuyên

### Securing Docker daemon:

```bash
# Sử dụng TLS cho Docker daemon
dockerd --tlsverify \
  --tlscacert=ca.pem \
  --tlscert=server-cert.pem \
  --tlskey=server-key.pem \
  -H=0.0.0.0:2376
```

## Docker trong CI/CD

Docker là công cụ quan trọng trong CI/CD pipelines, cho phép xây dựng, test và triển khai ứng dụng một cách nhất quán.

### CI/CD với Docker:

1. **Build stage**: Tạo Docker image từ source code
2. **Test stage**: Chạy tests trong Docker container
3. **Security scan**: Quét image tìm vulnerabilities
4. **Push stage**: Đẩy image lên registry
5. **Deploy stage**: Triển khai containers lên production

### Ví dụ GitHub Actions với Docker:

```yaml
name: Docker CI/CD

on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2

      - name: Login to DockerHub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      - name: Build and push
        uses: docker/build-push-action@v4
        with:
          context: .
          push: true
          tags: myorg/myapp:latest

      - name: Scan image for vulnerabilities
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: myorg/myapp:latest
          format: "table"
          exit-code: "1"
          ignore-unfixed: true
          severity: "CRITICAL,HIGH"
```

## Các công cụ liên quan

### Container Orchestration:

- **Kubernetes**: Hệ thống mạnh mẽ để tự động triển khai, mở rộng và quản lý ứng dụng container
- **Docker Swarm**: Giải pháp orchestration tích hợp sẵn của Docker
- **Amazon ECS/EKS**: Dịch vụ quản lý container của AWS
- **Google GKE**: Managed Kubernetes service của Google Cloud

### Monitoring:

- **Prometheus**: Hệ thống monitoring và alerting
- **Grafana**: Visualization platform
- **cAdvisor**: Phân tích hiệu suất container
- **Datadog**: Monitoring service cho cloud applications

### Logging:

- **ELK Stack (Elasticsearch, Logstash, Kibana)**: Phân tích và visualization logs
- **Fluentd**: Unified logging layer
- **Loki**: Logging system từ Grafana

### Development:

- **Docker Extension for VS Code**: Tích hợp Docker vào VS Code
- **Portainer**: Web UI để quản lý Docker
- **Dive**: Tool để phân tích Docker image layers
- **hadolint**: Dockerfile linter

## Khắc phục sự cố

### 1. Container không khởi động

```bash
# Kiểm tra logs
docker logs [container_id]

# Kiểm tra container status
docker inspect [container_id]

# Chạy container với interactive mode
docker run -it [image_name] [command]
```

### 2. Không thể truy cập service trong container

```bash
# Kiểm tra port mapping
docker port [container_id]

# Kiểm tra container network
docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' [container_id]

# Kiểm tra service đang chạy trong container
docker exec -it [container_id] ps aux
```

### 3. Docker chiếm nhiều disk space

```bash
# Kiểm tra disk usage
docker system df

# Xóa unused resources
docker system prune -a

# Xóa dangling images
docker image prune

# Xóa unused volumes
docker volume prune
```

### 4. Container bị crash hoặc restart liên tục

```bash
# Kiểm tra container status và exit code
docker inspect [container_id] | grep -i status

# Kiểm tra memory usage
docker stats [container_id]

# Tăng memory limit
docker run --memory=2g [image_name]
```

### 5. Quá chậm khi build image

```bash
# Sử dụng .dockerignore để loại bỏ files không cần thiết
# Tối ưu Dockerfile để tận dụng cache
# Sử dụng multi-stage builds
# Xem quá trình build chi tiết
docker build --progress=plain -t [image_name] .
```

## Tài liệu tham khảo

- [Docker Official Documentation](https://docs.docker.com/)
- [Docker Hub](https://hub.docker.com/)
- [Docker Curriculum](https://docker-curriculum.com/)
- [Kubernetes Documentation](https://kubernetes.io/docs/home/)
- [Docker Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Docker Security Best Practices](https://docs.docker.com/engine/security/)
- [The Docker Book by James Turnbull](https://www.dockerbook.com/)
- [Docker Deep Dive by Nigel Poulton](https://nigelpoulton.com/books/)
