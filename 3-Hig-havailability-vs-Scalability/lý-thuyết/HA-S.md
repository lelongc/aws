
## **1. Scalability (Khả năng mở rộng)**
Scalability là khả năng của một hệ thống hoặc ứng dụng xử lý tải lớn hơn bằng cách thích ứng hoặc mở rộng.

Có **hai loại khả năng mở rộng chính**:
### **a. Vertical Scalability (Mở rộng theo chiều dọc)**
- Tăng kích thước của một máy hoặc một instance.
- Ví dụ:
  - Một hệ thống chạy trên **t2.micro** (nhỏ) nâng cấp lên **t2.large** (lớn hơn).
  - **Call center**: Nâng cấp một nhân viên từ **junior** (5 cuộc gọi/phút) lên **senior** (10 cuộc gọi/phút).
- **Ứng dụng**:
  - Thường sử dụng cho các **hệ thống không phân tán** như **cơ sở dữ liệu** (RDS, ElastiCache).
- **Hạn chế**:
  - Có giới hạn về phần cứng (hardware limit).
  
### **b. Horizontal Scalability (Mở rộng theo chiều ngang)**
- Tăng số lượng máy hoặc instance trong hệ thống.
- Ví dụ:
  - Thêm nhiều nhân viên vào call center: từ 1, rồi 2, rồi 6 nhân viên.
  - Trong AWS, tăng số lượng EC2 instance (scale out).
- **Ứng dụng**:
  - Dùng cho **hệ thống phân tán** như **web applications** hoặc **modern applications**.
- AWS hỗ trợ dễ dàng: Chỉ cần thêm EC2 instance.

---

## **2. High Availability (Khả dụng cao)**
High Availability đảm bảo hệ thống vẫn hoạt động ngay cả khi một phần của hệ thống gặp sự cố.

### **a. Mục tiêu chính**:
- **Khả năng chịu lỗi** (fault tolerance): Sống sót sau sự cố ở một trung tâm dữ liệu (data center).
- Trong AWS: Triển khai ứng dụng trên **nhiều Availability Zones (AZ)**.

### **b. Ví dụ thực tế**:
- Call center:
  - 3 nhân viên ở tòa nhà New York.
  - 3 nhân viên ở tòa nhà San Francisco.
  - Nếu New York gặp sự cố, San Francisco vẫn hoạt động.
- Trong AWS:
  - RDS **Multi-AZ**: Passive high availability.
  - EC2 với **Auto Scaling Group** và **Load Balancer**: Active high availability.

---

## **3. Tổng kết về EC2**:
### **a. Vertical Scaling**:
- **Tăng kích thước** của instance (scale up/down).
- Từ **t2.nano** (0.5 GB RAM, 1 vCPU) lên **u-12tb1.metal** (12.3 TB RAM, 450 vCPUs).

### **b. Horizontal Scaling**:
- **Tăng số lượng** instance (scale out/in).

### **c. High Availability**:
- Chạy hệ thống trên **nhiều AZ** bằng cách sử dụng:
  - Auto Scaling Group với Multi-AZ.
  - Load Balancer với Multi-AZ.

---

## **4. Ý tưởng chính cần nhớ**:
- **Scalability**:
  - **Vertical**: Nâng cấp phần cứng của instance.
  - **Horizontal**: Tăng số lượng instance.
- **High Availability**:
  - Chạy ứng dụng trên nhiều AZ để đảm bảo không bị gián đoạn khi xảy ra sự cố.

- **Ghi nhớ "Call Center"**:
  - Vertical: Nâng cấp nhân viên từ junior lên senior.
  - Horizontal: Thêm nhiều nhân viên.
  - High Availability: Phân chia nhân viên ở các tòa nhà khác nhau.

---
