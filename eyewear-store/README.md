# Eyewear Store - Web Bán Kính Mắt Full Stack

Dự án web bán kính mắt sử dụng công nghệ hiện đại: Next.js, NestJS và TypeScript với cấu trúc monorepo.

## Tổng quan dự án

Eyewear Store là website thương mại điện tử chuyên bán kính mắt với đầy đủ tính năng:
- Hiển thị danh sách sản phẩm, lọc, tìm kiếm
- Giỏ hàng và thanh toán trực tuyến
- Đăng ký/đăng nhập tài khoản
- Quản lý đơn hàng, yêu thích sản phẩm
- So sánh sản phẩm, đánh giá
- Blog với nội dung hữu ích
- Trang quản trị dành cho admin

## Công nghệ sử dụng

- **Frontend**: Next.js, React, TypeScript, Tailwind CSS, React Query, Zustand
- **Backend**: NestJS, TypeORM, PostgreSQL, JWT Authentication
- **Tools & Deployment**: Docker, Docker Compose, PNPM

## Cài đặt và chạy dự án

### Phương pháp 1: Sử dụng Docker Compose (Đơn giản nhất)

#### Yêu cầu
- Docker và Docker Compose
- Git

#### Các bước thực hiện

1. **Clone repository**
```bash
git clone https://github.com/your-username/eyewear-store.git
cd eyewear-store
```

2. **Chuẩn bị môi trường**
```bash
# Tạo thư mục hình ảnh cần thiết
mkdir -p frontend/public/images/{blog,products,brands,about}
mkdir -p frontend/public/images/{hero,logo,seo}

# Tải một số hình ảnh mẫu (không bắt buộc)
curl -o frontend/public/images/hero/hero-bg.jpg https://images.unsplash.com/photo-1511499767150-a48a237f0083
curl -o frontend/public/images/logo/logo.png https://via.placeholder.com/200x80?text=Eyewear+Store
```

3. **Khởi chạy với Docker Compose**
```bash
docker-compose up --build
```

4. **Truy cập ứng dụng**
- Frontend: http://localhost:3000
- Backend API: http://localhost:4000
- API Documentation: http://localhost:4000/api

### Phương pháp 2: Cài đặt thủ công

#### Yêu cầu
- Node.js (v18.x trở lên)
- PNPM (v8.x trở lên)
- PostgreSQL

#### Các bước thực hiện

1. **Clone repository**
```bash
git clone https://github.com/your-username/eyewear-store.git
cd eyewear-store
```

2. **Cài đặt dependencies**
```bash
pnpm install
```

3. **Thiết lập PostgreSQL**
- Cài đặt PostgreSQL từ [trang chính thức](https://www.postgresql.org/download/)
- Tạo database "eyewear"

4. **Cấu hình môi trường Backend**
```bash
# Copy file .env mẫu
cp backend/.env.example backend/.env

# Chỉnh sửa thông tin kết nối database trong backend/.env
```

5. **Cấu hình môi trường Frontend**
```bash
# Copy file .env mẫu
cp frontend/.env.local.example frontend/.env.local
```

6. **Chạy migration và seed dữ liệu**
```bash
cd backend
pnpm run migration:run
pnpm run seed
```

7. **Khởi động ứng dụng**
```bash
# Terminal 1 - Backend
cd backend
pnpm run start:dev

# Terminal 2 - Frontend
cd frontend
pnpm run dev
```

8. **Truy cập ứng dụng**
- Frontend: http://localhost:3000
- Backend API: http://localhost:4000
- API Documentation: http://localhost:4000/api

## Tài khoản demo

- **Admin**: admin@eyewear-store.vn / password123
- **User**: user@eyewear-store.vn / password123

## Tính năng chính

### Người dùng
- **Catalog sản phẩm**: Xem, lọc, tìm kiếm sản phẩm
- **Chi tiết sản phẩm**: Xem thông tin chi tiết, thêm vào giỏ hàng
- **Giỏ hàng**: Thêm, xóa sản phẩm, cập nhật số lượng
- **Thanh toán**: Thanh toán online với Stripe hoặc COD
- **Tài khoản**: Đăng nhập, đăng ký, quản lý thông tin
- **Đơn hàng**: Xem lịch sử, chi tiết đơn hàng
- **Danh sách yêu thích**: Lưu sản phẩm yêu thích
- **So sánh sản phẩm**: So sánh các sản phẩm khác nhau
- **Đánh giá**: Viết và xem đánh giá sản phẩm
- **Blog**: Đọc bài viết về kính mắt và chăm sóc mắt

### Admin
- **Dashboard**: Thống kê tổng quan
- **Quản lý sản phẩm**: Thêm, sửa, xóa sản phẩm
- **Quản lý đơn hàng**: Cập nhật trạng thái, xem chi tiết
- **Quản lý người dùng**: Xem và quản lý tài khoản
- **Quản lý blog**: Thêm, sửa, xóa bài viết

Tôi sẽ cập nhật file README với hướng dẫn đầy đủ để giúp người dùng hiểu và chạy dự án:

```markdown
# Eyewear Store - Web Bán Kính Mắt Full Stack

Dự án web bán kính mắt sử dụng công nghệ hiện đại: Next.js, NestJS và TypeScript với cấu trúc monorepo.

## Tổng quan dự án

Eyewear Store là website thương mại điện tử chuyên bán kính mắt với đầy đủ tính năng:
- Hiển thị danh sách sản phẩm, lọc, tìm kiếm
- Giỏ hàng và thanh toán trực tuyến
- Đăng ký/đăng nhập tài khoản
- Quản lý đơn hàng, yêu thích sản phẩm
- So sánh sản phẩm, đánh giá
- Blog với nội dung hữu ích
- Trang quản trị dành cho admin

## Công nghệ sử dụng

- **Frontend**: Next.js, React, TypeScript, Tailwind CSS, React Query, Zustand
- **Backend**: NestJS, TypeORM, PostgreSQL, JWT Authentication
- **Tools & Deployment**: Docker, Docker Compose, PNPM

## Cài đặt và chạy dự án

### Phương pháp 1: Sử dụng Docker Compose (Đơn giản nhất)

#### Yêu cầu
- Docker và Docker Compose
- Git

#### Các bước thực hiện

1. **Clone repository**
```bash
git clone https://github.com/your-username/eyewear-store.git
cd eyewear-store
```

2. **Chuẩn bị môi trường**
```bash
# Tạo thư mục hình ảnh cần thiết
mkdir -p frontend/public/images/{blog,products,brands,about}
mkdir -p frontend/public/images/{hero,logo,seo}

# Tải một số hình ảnh mẫu (không bắt buộc)
curl -o frontend/public/images/hero/hero-bg.jpg https://images.unsplash.com/photo-1511499767150-a48a237f0083
curl -o frontend/public/images/logo/logo.png https://via.placeholder.com/200x80?text=Eyewear+Store
```

3. **Khởi chạy với Docker Compose**
```bash
docker-compose up --build
```

4. **Truy cập ứng dụng**
- Frontend: http://localhost:3000
- Backend API: http://localhost:4000
- API Documentation: http://localhost:4000/api

### Phương pháp 2: Cài đặt thủ công

#### Yêu cầu
- Node.js (v18.x trở lên)
- PNPM (v8.x trở lên)
- PostgreSQL

#### Các bước thực hiện

1. **Clone repository**
```bash
git clone https://github.com/your-username/eyewear-store.git
cd eyewear-store
```

2. **Cài đặt dependencies**
```bash
pnpm install
```

3. **Thiết lập PostgreSQL**
- Cài đặt PostgreSQL từ [trang chính thức](https://www.postgresql.org/download/)
- Tạo database "eyewear"

4. **Cấu hình môi trường Backend**
```bash
# Copy file .env mẫu
cp backend/.env.example backend/.env

# Chỉnh sửa thông tin kết nối database trong backend/.env
```

5. **Cấu hình môi trường Frontend**
```bash
# Copy file .env mẫu
cp frontend/.env.local.example frontend/.env.local
```

6. **Chạy migration và seed dữ liệu**
```bash
cd backend
pnpm run migration:run
pnpm run seed
```

7. **Khởi động ứng dụng**
```bash
# Terminal 1 - Backend
cd backend
pnpm run start:dev

# Terminal 2 - Frontend
cd frontend
pnpm run dev
```

8. **Truy cập ứng dụng**
- Frontend: http://localhost:3000
- Backend API: http://localhost:4000
- API Documentation: http://localhost:4000/api

## Tài khoản demo

- **Admin**: admin@eyewear-store.vn / password123
- **User**: user@eyewear-store.vn / password123

## Tính năng chính

### Người dùng
- **Catalog sản phẩm**: Xem, lọc, tìm kiếm sản phẩm
- **Chi tiết sản phẩm**: Xem thông tin chi tiết, thêm vào giỏ hàng
- **Giỏ hàng**: Thêm, xóa sản phẩm, cập nhật số lượng
- **Thanh toán**: Thanh toán online với Stripe hoặc COD
- **Tài khoản**: Đăng nhập, đăng ký, quản lý thông tin
- **Đơn hàng**: Xem lịch sử, chi tiết đơn hàng
- **Danh sách yêu thích**: Lưu sản phẩm yêu thích
- **So sánh sản phẩm**: So sánh các sản phẩm khác nhau
- **Đánh giá**: Viết và xem đánh giá sản phẩm
- **Blog**: Đọc bài viết về kính mắt và chăm sóc mắt

### Admin
- **Dashboard**: Thống kê tổng quan
- **Quản lý sản phẩm**: Thêm, sửa, xóa sản phẩm
- **Quản lý đơn hàng**: Cập nhật trạng thái, xem chi tiết
- **Quản lý người dùng**: Xem và quản lý tài khoản
- **Quản lý blog**: Thêm, sửa, xóa bài viết

## Cấu trúc dự án

```
eyewear-store/
├── backend/                 # NestJS backend API
│   ├── src/                 # Source code
│   │   ├── main.ts          # Entry point
│   │   ├── app.module.ts    # Main module
│   │   ├── modules/         # Feature modules
│   │   ├── migrations/      # Database migrations
│   │   └── config/          # Configuration
│   └── ...
├── frontend/                # Next.js frontend
│   ├── public/              # Static assets
│   │   └── images/          # Images
│   ├── src/
│   │   ├── components/      # React components
│   │   ├── pages/           # Next.js pages
│   │   ├── services/        # API services
│   │   ├── store/           # State management
│   │   └── styles/          # Global styles
│   └── ...
├── shared/                  # Shared code between frontend and backend
│   └── types/               # TypeScript types/interfaces
├── docker-compose.yml       # Docker configuration
└── ...
```

## Khắc phục sự cố

### Lỗi kết nối database
```
ERROR [TypeOrmModule] Unable to connect to the database...
```
- Kiểm tra PostgreSQL đã chạy chưa
- Kiểm tra thông tin kết nối trong file `.env`
- Đảm bảo database "eyewear" đã được tạo

### Lỗi hình ảnh không hiển thị
- Kiểm tra đã tạo đủ các thư mục hình ảnh trong `frontend/public/images/`
- Đảm bảo đường dẫn hình ảnh trong code khớp với tên file đã tạo

### Lỗi CORS
```
Access to fetch at 'http://localhost:4000/api/...' from origin 'http://localhost:3000' has been blocked by CORS policy
```
- Kiểm tra `FRONTEND_URL` trong file `.env` của backend

### Lỗi khi chạy Docker
- Kiểm tra Docker và Docker Compose đã cài đặt đúng
- Đảm bảo cổng 3000 và 4000 không bị chiếm bởi ứng dụng khác

## Phát triển dự án

### Thêm tính năng mới
1. Tạo branch mới: `git checkout -b feature/ten-tinh-nang`
2. Phát triển tính năng
3. Tạo Pull Request để merge vào main

### Thêm migration mới
```bash
cd backend
pnpm run migration:create src/migrations/TenMigration
```

## Tài liệu tham khảo

- [NestJS Documentation](https://docs.nestjs.com/)
- [Next.js Documentation](https://nextjs.org/docs)
- [TypeORM Documentation](https://typeorm.io/)
- [React Query Documentation](https://tanstack.com/query/latest)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)

## Đóng góp

Nếu bạn muốn đóng góp cho dự án, vui lòng:
1. Fork repository
2. Tạo branch mới: `git checkout -b feature/your-feature-name`
3. Commit changes: `git commit -am 'Add some feature'`
4. Push to branch: `git push origin feature/your-feature-name`
5. Submit Pull Request

## Giấy phép

[Drash](LICENSE)
```

Made changes.