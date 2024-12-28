### Chi tiết kiến thức:

#### **1. Giới thiệu về tối ưu hoá việc triển khai ứng dụng**
- Việc triển khai ứng dụng trên các máy ảo **EC2** (Elastic Compute Cloud) thường mất thời gian:
  - Cài đặt ứng dụng.
  - Phục hồi dữ liệu.
  - Cấu hình hệ điều hành (OS) và ứng dụng.
  - Khởi chạy dịch vụ.

#### **2. Giải pháp: Tăng tốc triển khai với Cloud**
- Sử dụng các công cụ và phương pháp như:
  - **Golden AMI (Amazon Machine Image)**.
  - **User Data** cho khởi tạo.
  - **Snapshots** cho cơ sở dữ liệu và đĩa.

---

#### **3. Golden AMI**
- **Khái niệm**: AMI là một bản sao chứa toàn bộ cài đặt, ứng dụng và cấu hình cần thiết.
  - Với **Golden AMI**, tất cả ứng dụng, OS, và dependencies đã được cài đặt trước.
  - Khi cần, EC2 instances được khởi chạy trực tiếp từ AMI này.
- **Ưu điểm**:
  - Không cần cài lại các ứng dụng.
  - Tốc độ khởi động nhanh hơn đáng kể.
  - Dễ dàng tái sử dụng trên nhiều EC2 instances.

---

#### **4. EC2 User Data**
- **Khái niệm**:
  - **Bootstrapping**: Cấu hình máy ảo ngay khi khởi động, ví dụ:
    - Cài đặt ứng dụng hoặc dependencies.
    - Lấy thông tin động như URL cơ sở dữ liệu hoặc mật khẩu.
  - Sử dụng User Data để thực hiện các cấu hình này tự động.
- **Hạn chế**:
  - **Chậm** nếu phải lặp lại các cài đặt trên nhiều EC2 instances.
- **Giải pháp**: Kết hợp:
  - **Golden AMI** cho phần cố định.
  - **User Data** cho cấu hình động.

---

#### **5. Elastic Beanstalk**
- **Tích hợp Golden AMI và User Data**:
  - Elastic Beanstalk sử dụng nguyên lý tương tự để tự động quản lý và triển khai ứng dụng.

---

#### **6. Snapshots (RDS & EBS)**
- **RDS Databases (Relational Database Service)**:
  - **Snapshot** giúp phục hồi cơ sở dữ liệu với:
    - Dữ liệu sẵn sàng (schema + data).
    - Tốc độ khởi tạo nhanh hơn so với chạy các lệnh `INSERT` thủ công.
- **EBS Volumes (Elastic Block Store)**:
  - Phục hồi từ snapshot giúp:
    - Đĩa đã được format và chứa sẵn dữ liệu.
    - Tránh tạo đĩa trống và phải định dạng thủ công.

---

#### **7. Ứng dụng trong kỳ thi Solutions Architect**
- Bạn cần biết cách:
  - Tăng tốc khởi động **EC2 instances**.
  - Tối ưu hoá **RDS databases** và **EBS volumes**.
  - Sử dụng các công cụ như **Golden AMI**, **User Data**, và **Snapshots**.

---

### **Tóm tắt ý chính**
- **Golden AMI**: Lưu sẵn cấu hình và cài đặt, giúp khởi động nhanh.
- **User Data**: Cấu hình linh hoạt, kết hợp với Golden AMI.
- **Snapshots**: Phục hồi nhanh cho cơ sở dữ liệu (RDS) và đĩa lưu trữ (EBS).

