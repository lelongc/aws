

#### 1. **Mã hóa dữ liệu at-rest**
- **At-rest encryption** đảm bảo dữ liệu được mã hóa trên các volume lưu trữ.
- Cơ chế mã hóa sử dụng **AWS KMS (Key Management Service)**.
- Áp dụng mã hóa:
  - Master database và mọi replica đều được mã hóa.
  - Cấu hình mã hóa phải được thiết lập **ngay tại thời điểm khởi tạo database**.
- **Lưu ý**:
  - Nếu master database không được mã hóa, các read replicas cũng không thể mã hóa.
  - Để mã hóa một database không được mã hóa trước đó, cần thực hiện các bước:
    1. Tạo **database snapshot** từ database gốc.
    2. Khôi phục snapshot đó thành một database đã được mã hóa.

#### 2. **Mã hóa dữ liệu in-flight**
- **In-flight encryption** bảo vệ dữ liệu khi truyền từ client đến database.
- RDS và Aurora hỗ trợ in-flight encryption mặc định.
- Client cần sử dụng **TLS root certificates** của AWS (cung cấp trên trang web của AWS).

#### 3. **Xác thực database**
- **Cách xác thực truyền thống**: Sử dụng **username** và **password**.
- **Xác thực bằng IAM**:
  - AWS cho phép sử dụng **IAM roles** để kết nối database.
  - Ví dụ: EC2 instance có gán IAM role có thể xác thực trực tiếp đến database mà không cần thông tin username và password.
  - Điều này giúp quản lý bảo mật tập trung trong **AWS IAM**.

#### 4. **Kiểm soát truy cập mạng**
- Sử dụng **security groups** để kiểm soát truy cập vào database.
- Có thể cấu hình:
  - Mở hoặc chặn **cổng cụ thể**.
  - Cho phép hoặc từ chối **IP cụ thể**.
  - Cấu hình theo **security groups khác**.

#### 5. **SSH Access**
- RDS và Aurora là các dịch vụ **managed services**:
  - Không hỗ trợ truy cập trực tiếp qua SSH.
  - Ngoại lệ: Nếu sử dụng **RDS Custom**, AWS cho phép SSH access.

#### 6. **Audit Logs (Nhật ký kiểm tra)**
- Cho phép theo dõi:
  - Các truy vấn thực hiện trên database.
  - Các hoạt động khác trong database.
- Audit logs sẽ tự động mất sau một thời gian.
- Để lưu trữ logs lâu dài:
  - Gửi logs đến **CloudWatch Logs**, dịch vụ lưu trữ và phân tích logs của AWS.

### Tổng kết
RDS và Aurora cung cấp các tính năng bảo mật toàn diện bao gồm mã hóa dữ liệu, kiểm soát truy cập, xác thực linh hoạt, và công cụ giám sát qua Audit Logs. Những tính năng này đảm bảo dữ liệu của bạn được bảo vệ trong cả trạng thái lưu trữ và truyền tải.