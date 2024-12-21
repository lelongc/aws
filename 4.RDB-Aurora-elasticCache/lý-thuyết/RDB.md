
---

### **1. RDS là gì?**
- **AWS RDS** là một dịch vụ cơ sở dữ liệu được **quản lý hoàn toàn** bởi Amazon Web Services.
- **Mục tiêu chính**: Cung cấp một cách dễ dàng để triển khai, quản lý, và mở rộng các cơ sở dữ liệu quan hệ (Relational Databases) mà không cần phải quản lý thủ công các chi tiết như cài đặt phần mềm, bảo trì, hoặc điều chỉnh hiệu suất.
  
#### **SQL là gì?**
- **SQL (Structured Query Language)** là ngôn ngữ truy vấn phổ biến dùng để giao tiếp với cơ sở dữ liệu.
- RDS hỗ trợ các cơ sở dữ liệu sử dụng SQL, bao gồm:
  - PostgreSQL
  - MySQL
  - MariaDB
  - Oracle
  - Microsoft SQL Server
  - IBM DB2
  - Aurora (cơ sở dữ liệu được AWS phát triển).

---

### **2. Tại sao chọn RDS thay vì tự triển khai trên EC2?**
**So sánh giữa RDS và tự triển khai cơ sở dữ liệu trên EC2:**

| Tiêu chí            | RDS (Dịch vụ quản lý)                         | Triển khai trên EC2                          |
|---------------------|-----------------------------------------------|---------------------------------------------|
| **Cài đặt & Cấu hình** | Tự động (AWS đảm nhiệm).                     | Bạn phải cài đặt và cấu hình thủ công.       |
| **Sao lưu dữ liệu**   | Tự động sao lưu liên tục.                    | Phải tự thiết lập và quản lý sao lưu.        |
| **Khôi phục dữ liệu** | Hỗ trợ khôi phục theo thời điểm (Point-in-Time Restore). | Phải viết quy trình khôi phục riêng.        |
| **Quản lý bảo trì**   | AWS tự động cập nhật phần mềm/hệ điều hành.  | Phải tự quản lý cập nhật.                    |
| **Mở rộng (Scaling)**| - **Dọc**: Tăng cấu hình máy chủ.<br>- **Ngang**: Thêm Read Replica. | Phải dừng hệ thống hoặc sử dụng thủ công.   |
| **Hiệu suất**        | Tối ưu hóa với các tính năng sẵn có.          | Phụ thuộc vào kỹ năng quản trị.              |
| **Khả năng tiếp cận**| Không cần truy cập SSH vào máy chủ.           | Có thể truy cập máy chủ qua SSH.             |

---

### **3. Các lợi ích chi tiết của RDS**
#### a) **Tự động hóa quản lý cơ sở dữ liệu**
- **Cài đặt tự động**: AWS xử lý việc thiết lập cơ sở dữ liệu.
- **Cập nhật phần mềm tự động**: Hệ điều hành và phần mềm cơ sở dữ liệu được cập nhật mà bạn không cần can thiệp.
  
#### b) **Sao lưu và khôi phục**
- **Sao lưu liên tục**:
  - AWS tự động sao lưu cơ sở dữ liệu của bạn.
  - Bạn có thể khôi phục dữ liệu về bất kỳ thời điểm nào (Point-in-Time Restore).
- **Lợi ích**: Tránh mất dữ liệu do lỗi hệ thống hoặc thao tác sai.

#### c) **Hiệu suất và tính sẵn sàng cao**
- **Read Replicas**: 
  - Bản sao đọc của cơ sở dữ liệu giúp cải thiện tốc độ đọc.
  - Hữu ích khi có nhiều yêu cầu truy vấn đọc đồng thời.
- **Multi-AZ Deployment**:
  - Cơ sở dữ liệu được nhân bản ở nhiều vùng sẵn sàng (Availability Zones) khác nhau.
  - Tăng khả năng chịu lỗi (Disaster Recovery).

#### d) **Mở rộng dễ dàng**
- **Mở rộng dọc (Vertical Scaling)**:
  - Thay đổi loại máy chủ để tăng hiệu năng (VD: từ t2.micro lên m5.large).
- **Mở rộng ngang (Horizontal Scaling)**:
  - Thêm các Read Replicas để xử lý nhiều truy vấn đọc hơn.
- **Tự động mở rộng lưu trữ (Storage Auto Scaling)**:
  - Dễ dàng tăng dung lượng lưu trữ khi cơ sở dữ liệu gần đầy, mà không cần dừng hệ thống.

#### e) **Giám sát và bảo trì**
- **Dashboards**:
  - AWS cung cấp bảng điều khiển để theo dõi hiệu suất cơ sở dữ liệu.
- **Lịch bảo trì**:
  - Bạn có thể đặt lịch thời gian bảo trì để giảm thiểu ảnh hưởng đến hoạt động.

---

### **4. Tính năng đặc biệt: RDS Storage Auto Scaling**
#### a) **Tính năng này hoạt động như thế nào?**
1. Khi tạo cơ sở dữ liệu, bạn sẽ định cấu hình dung lượng lưu trữ (ví dụ: 20GB).
2. Nếu cơ sở dữ liệu gần hết dung lượng:
   - Tự động mở rộng mà không cần dừng hệ thống.
   - Không cần thao tác thủ công.
3. Điều kiện kích hoạt mở rộng:
   - Dung lượng trống < **10%**.
   - Kéo dài trong **5 phút** liên tục.
    AWS không mở rộng dung lượng ngay lập tức khi dung lượng trống < 10%.
    Hệ thống sẽ đợi 5 phút để chắc chắn rằng tình trạng này không phải chỉ là tạm thời (do đột biến ngắn hạn trong công việc).
   Ví dụ :
    Nếu cơ sở dữ liệu chỉ bị thiếu dung lượng trong 2 phút rồi phục hồi, tính năng mở rộng sẽ không kích hoạt.
    Nhưng nếu thiếu dung lượng kéo dài liên tục trong 5 phút, hệ thống bắt đầu chuẩn bị mở rộng.
   - Đã qua **6 giờ** từ lần mở rộng gần nhất.
   Ví dụ:
    Lần mở rộng gần nhất là lúc 8:00 sáng.
    Nếu dung lượng trống < 10% lúc 11:00 sáng, hệ thống sẽ không mở rộng ngay, vì chưa qua đủ 6 giờ từ lần mở rộng trước.

#### b) **Cấu hình giới hạn**
- Bạn có thể đặt **ngưỡng tối đa** để lưu trữ không tăng vượt quá mức mong muốn.

#### c) **Ứng dụng**
- Phù hợp cho các ứng dụng có khối lượng công việc **không ổn định** hoặc **khó dự đoán**.

---

### **5. Hạn chế của RDS**
- **Không có quyền SSH**:
  - Bạn không thể truy cập vào máy chủ vật lý hoặc hệ điều hành.
  - AWS chịu trách nhiệm quản lý hạ tầng.

#### **Lợi ích của việc không có SSH:**
- Giảm nguy cơ cấu hình sai hoặc bảo mật thấp.
- Đơn giản hóa quản trị.

---

### **6. Khi nào nên dùng RDS?**
- Khi bạn cần một **giải pháp cơ sở dữ liệu được quản lý hoàn toàn**.
- Khi muốn tập trung vào ứng dụng thay vì quản lý hạ tầng.
- Khi cần khả năng **mở rộng nhanh chóng** và **đảm bảo tính sẵn sàng cao**.

---

