### **Throughput là gì?**

**Throughput** (tạm dịch: thông lượng) là khái niệm dùng để đo lường lượng dữ liệu có thể được truyền hoặc xử lý trong một khoảng thời gian nhất định, thường được đo bằng đơn vị **MB/s** (megabytes per second) hoặc **Gbps** (gigabits per second). 

#### **Trong lĩnh vực lưu trữ (storage):**
Throughput biểu thị **tốc độ truyền tải dữ liệu** từ ổ đĩa hoặc hệ thống lưu trữ đến máy chủ hoặc ứng dụng. Nó thường được dùng để đánh giá hiệu suất của các ứng dụng xử lý lượng lớn dữ liệu, chẳng hạn:

- Truyền tệp video lớn.
- Phân tích dữ liệu trong các hệ thống Big Data.
- Đọc và ghi log trên máy chủ.

Ví dụ:
- Một ổ EBS (Elastic Block Store) có throughput là **250 MB/s** nghĩa là nó có thể xử lý dữ liệu đầu vào hoặc đầu ra tối đa 250 megabytes mỗi giây.

---

### **Khác biệt giữa throughput và IOPS**
- **Throughput**:
  - Tập trung vào **tốc độ truyền tải tổng thể**.
  - Phù hợp với khối lượng công việc lớn, các yêu cầu xử lý file size lớn.
  - Được đo bằng **MB/s**.

- **IOPS (Input/Output Operations Per Second)**:
  - Đo số lượng **tác vụ đọc/ghi dữ liệu** được thực hiện mỗi giây.
  - Phù hợp với các công việc yêu cầu truy cập dữ liệu nhỏ lẻ và liên tục.
  - Được đo bằng **số lần thao tác/giây**.

#### **Ví dụ minh họa:**
- **Ứng dụng yêu cầu throughput cao:** 
  - Chạy video 4K từ ổ đĩa.
  - Phân tích log server với file log kích thước lớn.
- **Ứng dụng yêu cầu IOPS cao:**
  - Cơ sở dữ liệu giao dịch (transactional databases) với hàng triệu truy vấn đọc/ghi nhỏ.
  - Hệ thống lưu trữ email.

---

### **Throughput trong AWS EBS**
AWS EBS cung cấp các loại volume với mức throughput tối đa khác nhau:

1. **gp3 (General Purpose SSD):**
   - Throughput tối đa: **1,000 MB/s**.
   - Phù hợp với hầu hết ứng dụng thông thường.

2. **io2 Block Express (Provisioned IOPS SSD):**
   - Throughput tối đa: **4,000 MB/s**.
   - Lý tưởng cho cơ sở dữ liệu lớn như Oracle, SQL Server.

3. **st1 (Throughput-Optimized HDD):**
   - Throughput tối đa: **500 MB/s**.
   - Tối ưu cho big data và xử lý log.

4. **sc1 (Cold HDD):**
   - Throughput tối đa: **250 MB/s**.
   - Dành cho lưu trữ lâu dài, ít truy cập.

---

### **Tóm lại**
- **Throughput** là tốc độ truyền tải dữ liệu, phù hợp với các ứng dụng xử lý dữ liệu lớn hoặc truy cập tuần tự (sequential access).
- **IOPS** phù hợp với các ứng dụng yêu cầu xử lý dữ liệu nhanh và liên tục với các khối dữ liệu nhỏ (random access).