# Node.js Backend Dockerfile Templates

Bộ sưu tập các Dockerfile mẫu cho các ứng dụng backend Node.js, bao gồm các framework phổ biến như NestJS, Express, Fastify, và Koa.

## Các template có sẵn

1. **nestjs-prod.Dockerfile**

   - Dockerfile cho ứng dụng NestJS (production)
   - Multi-stage build: giai đoạn build và runtime
   - Non-root user cho bảo mật
   - Healthcheck tích hợp

2. **nodejs-express-prod.Dockerfile** (xem tại thư mục web/node)
3. **nodejs-fastify-prod.Dockerfile** (xem thêm tại thư mục)
4. **nodejs-koa-prod.Dockerfile** (xem thêm tại thư mục)

## Cách sử dụng

### NestJS Application

```bash
# Build image
docker build -t myorg/nestjs-app:1.0.0 -f nestjs-prod.Dockerfile .

# Chạy container
docker run -p 3000:3000 myorg/nestjs-app:1.0.0
```

## Cấu trúc thư mục đề xuất cho ứng dụng NestJS

```
nestjs-app/
├── src/              # Mã nguồn của ứng dụng
├── test/             # Unit và e2e tests
├── config/           # Cấu hình ứng dụng theo môi trường
├── dist/             # Thư mục build (sẽ được tạo khi build)
├── package.json      # Dependency definitions
├── package-lock.json # Lock file
├── tsconfig.json     # TypeScript config
├── nest-cli.json     # NestJS CLI config
├── .dockerignore     # Files/folders to ignore in Docker build
└── Dockerfile        # Dockerfile chính
```

## Best Practices

1. **Sử dụng Node.js LTS** - Luôn sử dụng phiên bản Node.js LTS cho môi trường production
2. **Non-root user** - Chạy ứng dụng với user không phải root trong container
3. **Multi-stage builds** - Giảm kích thước image và không đưa development dependencies vào production image
4. **Environment variables** - Cấu hình ứng dụng thông qua biến môi trường
5. **Healthchecks** - Thêm endpoint kiểm tra sức khỏe để container orchestrator (như Kubernetes) có thể giám sát
6. **Logging** - Ghi log ra stdout/stderr để container orchestrator có thể thu thập

## Tùy chỉnh

Dockerfile mẫu này có thể được tùy chỉnh theo nhu cầu cụ thể:

- Thay đổi port mặc định
- Thêm ENVIRONMENT variables
- Điều chỉnh healthcheck parameters
- Thêm các dependencies hệ thống nếu cần thiết

## Khắc phục sự cố

### Lỗi "node_modules not found"

Đảm bảo bạn đã chạy `npm install` hoặc đã khai báo đúng trong Dockerfile:

```dockerfile
COPY package.json yarn.lock* ./
RUN npm ci
```

### Application không start được

Kiểm tra lại entry point trong package.json và CMD trong Dockerfile:

```json
"scripts": {
  "start:prod": "node dist/main"
}
```

## Tài liệu tham khảo

- [NestJS Documentation](https://docs.nestjs.com/)
- [Docker Multi-Stage Builds](https://docs.docker.com/build/building/multi-stage/)
- [Node.js Docker Best Practices](https://github.com/nodejs/docker-node/blob/main/docs/BestPractices.md)
