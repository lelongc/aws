# Node.js Dockerfile Templates

Bộ sưu tập các Dockerfile mẫu cho các ứng dụng Node.js, bao gồm các framework phổ biến như React, Angular, Vue.js, Express và NestJS.

## Các template có sẵn

1. **node-react-prod.Dockerfile**

   - Dockerfile cho ứng dụng React (production)
   - Multi-stage build: giai đoạn build và giai đoạn serve với Nginx
   - Tối ưu cho môi trường production

2. **node-express-prod.Dockerfile**

   - Dockerfile cho ứng dụng Express.js (production)
   - Sử dụng PM2 để quản lý process
   - Non-root user cho bảo mật
   - Healthcheck tích hợp

3. **node-angular-prod.Dockerfile** (xem thêm tại thư mục)
4. **node-vue-prod.Dockerfile** (xem thêm tại thư mục)
5. **node-nest-prod.Dockerfile** (xem thêm tại thư mục)
6. **node-development.Dockerfile** (xem thêm tại thư mục)

## Cách sử dụng

### React Application

```bash
# Build image
docker build -t myorg/react-app:1.0.0 -f node-react-prod.Dockerfile .

# Chạy container
docker run -p 80:80 myorg/react-app:1.0.0
```

### Express Application

```bash
# Build image
docker build -t myorg/express-app:1.0.0 -f node-express-prod.Dockerfile .

# Chạy container
docker run -p 3000:3000 myorg/express-app:1.0.0
```

## Cấu trúc thư mục đề xuất cho ứng dụng Node.js

```
my-app/
├── src/              # Mã nguồn ứng dụng
├── public/           # Static assets (cho React/Angular/Vue)
├── package.json      # Dependency definitions
├── package-lock.json # Lock file
├── tsconfig.json     # TypeScript config (nếu dùng TypeScript)
├── .dockerignore     # Files/folders to ignore in Docker build
├── Dockerfile        # Dockerfile chính
└── docker-compose.yml # Cấu hình Docker Compose (nếu cần)
```

## Best Practices

1. **Sử dụng Node.js LTS** - Luôn sử dụng phiên bản Node.js LTS cho môi trường production
2. **Non-root user** - Chạy ứng dụng với user không phải root trong container
3. **Multi-stage builds** - Giảm kích thước image và không đưa development dependencies vào production image
4. **Dependency management** - Sử dụng package-lock.json hoặc yarn.lock để đảm bảo cài đặt dependencies chính xác
5. **Proper process management** - Sử dụng PM2 hoặc tương tự để quản lý process Node.js
6. **Environment variables** - Cấu hình ứng dụng thông qua biến môi trường
7. **Security scanning** - Scan image với trivy, Clair hoặc Docker Scout

## Tùy chỉnh

Các Dockerfile mẫu này có thể được tùy chỉnh theo nhu cầu cụ thể:

- Thay đổi base image (alpine vs slim vs buster)
- Thêm các dependency hệ thống nếu cần
- Điều chỉnh cấu hình Nginx cho ứng dụng React/Angular/Vue
- Thay đổi port và healthcheck path

## Khắc phục sự cố

### Lỗi "node_modules not found"

Đảm bảo bạn đã chạy `npm install` hoặc đã khai báo đúng trong Dockerfile:

```dockerfile
COPY package.json package-lock.json* ./
RUN npm ci
```

### Lỗi "Permission denied"

Kiểm tra quyền hạn và ownership trong container:

```dockerfile
RUN chown -R appuser:appgroup /app
```

## Tài liệu tham khảo

- [Node.js Docker Best Practices](https://github.com/nodejs/docker-node/blob/main/docs/BestPractices.md)
- [Docker Multi-Stage Builds](https://docs.docker.com/build/building/multi-stage/)
