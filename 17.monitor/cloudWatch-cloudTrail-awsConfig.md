**AWS CloudWatch, CloudTrail và Config: So sánh chi tiết**

### 1. **Amazon CloudWatch**

- **Mục đích**: Giám sát hiệu suất và quan sát hệ thống.
- **Tính năng chính**:
  - **Metrics (Chỉ số)**: Theo dõi các chỉ số hiệu suất thời gian thực như CPU, lưu lượng mạng, số request trên ELB, tỷ lệ lỗi...
  - **Dashboards (Bảng điều khiển)**: Hiển thị trực quan hóa dữ liệu từ các dịch vụ như EC2, RDS, ELB...
  - **Alarms (Cảnh báo)**: Kích hoạt thông báo hoặc hành động tự động khi vượt ngưỡng (ví dụ: độ trễ cao trên ELB).
  - **Logs (Nhật ký)**: Tập hợp và phân tích log từ ứng dụng hoặc dịch vụ AWS (ví dụ: log truy cập ELB).
- **Ví dụ với ELB**: Giám sát độ trễ request, tỷ lệ lỗi 4xx/5xx, số lượng máy chủ "khỏe mạnh".

---

### 2. **AWS CloudTrail**

- **Mục đích**: Ghi lại hoạt động API để kiểm tra (audit) bảo mật.
- **Tính năng chính**:
  - **API Logging**: Ghi lại mọi lệnh API trong tài khoản AWS (ví dụ: thay đổi security group của ELB, cập nhật SSL certificate).
  - **Trách nhiệm rõ ràng**: Xác định ai đã thực hiện thay đổi (IAM user/role), thời gian và địa chỉ IP nguồn.
  - **Dịch vụ toàn cầu**: Hoạt động trên mọi region (nếu được kích hoạt).
- **Ví dụ với ELB**: Xác định user nào đã xóa listener của ELB thông qua lệnh API.

---

### 3. **AWS Config**

- **Mục đích**: Theo dõi thay đổi cấu hình và đảm bảo tuân thủ (compliance).
- **Tính năng chính**:
  - **Lịch sử cấu hình**: Ghi lại trạng thái tài nguyên theo thời gian (ví dụ: security group rules của ELB, SSL certificate).
  - **Kiểm tra tuân thủ**: Đánh giá cấu hình dựa trên quy tắc định sẵn (ví dụ: "ELB phải dùng HTTPS", "S3 bucket không public").
  - **Timeline (Dòng thời gian)**: Hiển thị trực quan các thay đổi và trạng thái tuân thủ.
- **Ví dụ với ELB**: Đảm bảo ELB luôn gắn SSL certificate và chặn traffic HTTP.

---

### **Tổng hợp qua ví dụ Elastic Load Balancer (ELB)**:

- **CloudWatch** phát hiện ELB có tỷ lệ lỗi 5xx tăng đột biến → Kích hoạt alarm.
- **Config** phát hiện security group của ELB bị sửa đổi, cho phép traffic HTTP → Vi phạm compliance.
- **CloudTrail** chỉ ra lệnh API sửa security group được thực hiện bởi user X → Xác định nguyên nhân.

---

### **Bảng so sánh nhanh**:

| Dịch vụ            | Câu hỏi trả lời                                      | Ví dụ ứng dụng                 |
| -------------------- | -------------------------------------------------------- | ---------------------------------- |
| **CloudWatch** | "Tài nguyên hoạt động thế nào?"                   | Giám sát CPU, log, cảnh báo    |
| **CloudTrail** | "Ai đã thay đổi cấu hình qua API?"                 | Audit hành động user/quản trị |
| **Config**     | "Cấu hình có tuân thủ không? Đã thay đổi gì?" | Kiểm tra security group, SSL      |

**Lưu ý**: Cả 3 dịch vụ bổ trợ cho nhau, giúp quản lý tài nguyên AWS toàn diện từ hiệu suất, bảo mật đến tuân thủ.
