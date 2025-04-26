# Next.js Dockerfile Templates

Hướng dẫn sử dụng và tùy chỉnh Dockerfile cho ứng dụng Next.js cho các môi trường production và development.

## Các template có sẵn

1. **nextjs-prod.Dockerfile**
   - Dockerfile cho ứng dụng Next.js (production)
   - Multi-stage build tối ưu hóa kích thước image
   - Sử dụng standalone output từ Next.js
   - Non-root user cho bảo mật

## Tính năng chính

- **Tối ưu hóa kích thước image** sử dụng multi-stage builds
- **Standalone mode** của Next.js để có hiệu suất tốt nhất
- **Bảo mật cao** với non-root user
- **Docker layer caching** để build nhanh hơn
- **Healthchecks** để giám sát container
- **Hỗ trợ đa package managers** (npm, yarn, pnpm)

## Cách sử dụng

### Chuẩn bị Next.js project

Để sử dụng chế độ standalone, thêm cấu hình sau vào `next.config.js`:

```javascript
module.exports = {
  output: "standalone",
};
```

### Build và chạy Docker image

```bash
# Build image
docker build -t myorg/nextjs-app:1.0.0 -f nextjs-prod.Dockerfile .

# Chạy container
docker run -p 3000:3000 myorg/nextjs-app:1.0.0
```

## Cấu trúc thư mục đề xuất cho ứng dụng Next.js

```
nextjs-app/
├── app/              # App Router (Next.js 13+)
├── pages/            # Pages Router
├── public/           # Static assets
├── components/       # React components
├── styles/           # CSS styles
├── lib/              # Utility functions
├── next.config.js    # Next.js configuration
├── package.json      # Dependencies and scripts
├── .dockerignore     # Files to ignore in Docker build
└── Dockerfile        # Dockerfile for production
```

## Tùy chỉnh

### Môi trường development

Để sử dụng trong môi trường development với hot-reloading:

```dockerfile
FROM node:18-alpine

WORKDIR /app

COPY package.json yarn.lock* package-lock.json* ./
RUN npm ci

COPY . .

EXPOSE 3000

CMD ["npm", "run", "dev"]
```

### Với runtime environment variables

Next.js phân biệt giữa build-time và runtime environment variables. Để sử dụng runtime variables:

```dockerfile
# Trong Dockerfile:
ENV PORT=3000

# Khi chạy container:
docker run -e NEXT_PUBLIC_API_URL=https://api.example.com -p 3000:3000 myorg/nextjs-app
```

## Best Practices

1. **Sử dụng Next.js output: 'standalone'** - Giảm kích thước image và cải thiện hiệu suất khởi động
2. **Caching dependencies** - Sao chép package.json trước, rồi mới sao chép source code
3. **Environment variables** - Sử dụng NEXT*PUBLIC* prefix cho client-side variables
4. **Telemetry** - Tắt telemetry trong production với ENV NEXT_TELEMETRY_DISABLED=1
5. **Healthchecks** - Tạo API route /api/health để sử dụng với Docker healthcheck

## Khắc phục sự cố

### Lỗi "Error: ENOENT: no such file or directory, open '/app/.next/BUILD_ID'"

Đảm bảo bạn đã thêm `output: 'standalone'` trong next.config.js và build thành công trước khi tạo container.

### Không thể truy cập API routes

Kiểm tra xem server.js có được tạo đúng cách và port mapping có chính xác không:

```bash
docker run -p 3000:3000 myorg/nextjs-app
```

## Tài liệu tham khảo

- [Next.js Deployment Documentation](https://nextjs.org/docs/deployment)
- [Next.js with Docker](https://nextjs.org/docs/deployment#docker-image)
- [Next.js Output Standalone](https://nextjs.org/docs/advanced-features/output-file-tracing)
