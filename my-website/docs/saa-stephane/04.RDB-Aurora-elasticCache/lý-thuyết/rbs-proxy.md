
Amazon RDS Proxy là một dịch vụ proxy được quản lý hoàn toàn, không cần máy chủ, giúp cải thiện hiệu suất, khả năng sẵn sàng và bảo mật cho cơ sở dữ liệu RDS. Dưới đây là giải thích chi tiết về các tính năng và lợi ích của nó:

---

### **1. RDS Proxy là gì?**
- RDS Proxy là một dịch vụ đóng vai trò trung gian giữa ứng dụng của bạn và cơ sở dữ liệu RDS.
- Nó thực hiện **gộp kết nối (connection pooling)**, giảm số lượng kết nối trực tiếp đến instance RDS.

---

### **2. Tại sao nên sử dụng RDS Proxy?**
- **Gộp kết nối**: Ứng dụng kết nối đến proxy thay vì kết nối trực tiếp đến instance RDS. Proxy sẽ gộp các kết nối này và giảm tổng số kết nối đến cơ sở dữ liệu.
- **Cải thiện hiệu suất cơ sở dữ liệu**:
  - Giảm áp lực lên **CPU** và **RAM**.
  - Hạn chế số lượng kết nối mở và giảm khả năng gặp lỗi **timeout**.
- **Tối ưu hóa thời gian chuyển đổi dự phòng (Failover)**:
  - Trong trường hợp chuyển đổi dự phòng (ví dụ: từ instance chính sang instance dự phòng), RDS Proxy giúp giảm thời gian chuyển đổi lên đến **66%**.
  - Ứng dụng chỉ cần kết nối với proxy, và proxy sẽ xử lý việc chuyển đổi mà không cần thay đổi ở mức ứng dụng.

---

### **3. Các tính năng chính**
- **Không cần máy chủ (Serverless)**:
  - RDS Proxy được quản lý hoàn toàn và tự động mở rộng quy mô khi cần.
  - Không cần quản lý dung lượng.
- **Khả dụng cao (High Availability)**:
  - Hoạt động trên nhiều **Vùng sẵn sàng (AZs)**.
  - Đảm bảo truy cập cơ sở dữ liệu liên tục khi xảy ra sự cố chuyển đổi dự phòng.
- **Tương thích cao**:
  - Hỗ trợ các cơ sở dữ liệu: **MySQL**, **PostgreSQL**, **MariaDB**, **Microsoft SQL Server**, và **Aurora (MySQL và PostgreSQL)**.
- **Không cần thay đổi mã nguồn**:
  - Không cần thay đổi mã ứng dụng, chỉ cần kết nối đến proxy thay vì instance RDS.
- **Xác thực IAM**:
  - Cưỡng chế xác thực bằng **AWS IAM** khi truy cập cơ sở dữ liệu.
  - Thông tin xác thực được lưu trữ an toàn bằng **AWS Secrets Manager**.
- **Bảo mật cao**:
  - RDS Proxy chỉ truy cập được từ trong **VPC** của bạn, không công khai trên internet.

---

### **4. Ứng dụng: Lambda Functions**
- Lambda functions thực thi mã ngắn gọn, không trạng thái, và thường mở rộng hoặc thu hẹp quy mô rất nhanh, gây ra:
  - **Kết nối tăng vọt**: Hàng trăm hoặc hàng nghìn kết nối được mở và đóng trong thời gian ngắn.
  - **Áp lực tài nguyên**: Cơ sở dữ liệu RDS bị quá tải do số lượng kết nối ngắn hạn này.
- **Giải pháp từ RDS Proxy**:
  - Gộp các kết nối từ Lambda functions để giảm tải cho cơ sở dữ liệu.
  - Quản lý kết nối hiệu quả, ngăn chặn các vấn đề như lỗi **timeout** hoặc kết nối không được đóng.

---

### **5. Điểm cần nhớ khi thi**
- RDS Proxy hỗ trợ:
  - Giảm thời gian chuyển đổi dự phòng lên đến **66%**.
  - Cưỡng chế xác thực bằng **IAM**.
  - Lưu trữ thông tin xác thực an toàn trong **Secrets Manager**.
- Hỗ trợ tất cả các engine chính của RDS và đặc biệt hữu ích trong các môi trường có: 
  - **Số lượng kết nối lớn**.
  - **Lambda functions hoạt động mạnh**.

--- 

RDS Proxy là một giải pháp hiệu quả để quản lý kết nối cơ sở dữ liệu trong các hệ thống yêu cầu khả năng mở rộng cao và thời gian phản hồi nhanh.