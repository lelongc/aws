# Eyewear Store - Hướng dẫn chạy nhanh với Docker Compose

## Yêu cầu tối thiểu

- Docker và Docker Compose
- Git

## Cài đặt siêu nhanh (3 bước)

### 1. Clone repository

```bash
git clone https://github.com/your-username/eyewear-store.git
cd eyewear-store
```

### 2. Chuẩn bị môi trường và hình ảnh

```bash
# Tạo file .env từ mẫu
cp backend/.env.example backend/.env
cp frontend/.env.local.example frontend/.env.local

# Tạo thư mục hình ảnh cần thiết
mkdir -p frontend/public/images/{blog,products,brands}

# Tải một số hình ảnh mẫu (không bắt buộc)
# Bạn có thể bỏ qua bước này và hệ thống sẽ dùng placeholder
curl -o frontend/public/images/hero-bg.jpg https://images.unsplash.com/photo-1511499767150-a48a237f0083
curl -o frontend/public/images/logo.png https://via.placeholder.com/200x80?text=Eyewear+Store
```

### 3. Khởi chạy tất cả bằng Docker Compose

```bash
docker-compose up --build
```

**Vậy là xong!** Không cần cài đặt Node.js, PNPM hay database. Docker sẽ tự động thiết lập và chạy mọi thứ.

## Truy cập ứng dụng

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:4000
- **API Documentation**: http://localhost:4000/api
- **Database**: PostgreSQL (port 5432)

## Tài khoản demo

- **Admin:** admin@eyewear-store.vn / password123
- **User:** user@eyewear-store.vn / password123

## Lệnh Docker Compose hữu ích

```bash
# Khởi động toàn bộ hệ thống
docker-compose up

# Khởi động ở chế độ nền
docker-compose up -d

# Dừng các container
docker-compose down

# Xem logs
docker-compose logs -f

# Xem logs của một service cụ thể
docker-compose logs -f frontend
docker-compose logs -f backend

# Khởi động lại một service
docker-compose restart frontend

# Xóa tất cả dữ liệu và build lại
docker-compose down -v
docker-compose up --build
```

## Thông tin về Docker Compose

Docker Compose thiết lập 3 container:

1. **postgres**: PostgreSQL database
2. **backend**: NestJS API backend 
3. **frontend**: Next.js frontend

Các container được cấu hình để giao tiếp với nhau và tự động khởi động theo thứ tự phù hợp.

### Chi tiết cấu hình

- PostgreSQL sẽ lưu dữ liệu vào volume `postgres_data` để dữ liệu được giữ lại giữa các lần khởi động
- Backend sẽ tự động chạy migration và seed data khi khởi động
- Các container được kết nối qua mạng `eyewear-network`
- Hot-reload được kích hoạt cho cả backend và frontend

## Troubleshooting

### Nếu web không hiển thị

- Kiểm tra logs: `docker-compose logs -f frontend`
- Đảm bảo đã chạy với `--build` ở lần đầu: `docker-compose up --build`
- Kiểm tra cổng có bị chiếm không: `netstat -ano | findstr 3000`

### Nếu API không hoạt động

- Kiểm tra logs: `docker-compose logs -f backend`
- Kiểm tra database đã chạy chưa: `docker-compose logs -f postgres`
- Thử khởi động lại backend: `docker-compose restart backend`

### Nếu các thay đổi code không được cập nhật

- Khởi động lại với flag build: `docker-compose up --build`
- Hoặc build lại một service cụ thể: `docker-compose build frontend`

### Nếu chưa có data mẫu

- Đảm bảo migration và seed đã chạy: `docker-compose exec backend pnpm run seed`
- Kiểm tra logs để xem lỗi: `docker-compose logs -f backend`
