
---

## 🛠️ **Tóm tắt thông tin về Amazon EFS**

### 1. **Giới thiệu về EFS**  
- **EFS (Elastic File System)** là một hệ thống lưu trữ tệp được quản lý, hoạt động như **[NFS](../lý-thuyết-bên-lề/NFS.md)** (Network File System).  
- **Khả năng kết nối**: Có thể được gắn với nhiều EC2 instances nằm ở các **Availability Zone** khác nhau.  
- **Ưu điểm**: **Highly available**, **scalable**, và **pay-per-use** (trả tiền theo dung lượng sử dụng).  
- **Giá thành**: Khoảng 3 lần giá của GP2 EBS volume.  

---

### 2. **Mục đích sử dụng của EFS**  
- Content Management  
- Web Serving  
- Data Sharing  
- WordPress Hosting  

---

### 3. **Tính bảo mật với KMS và Linux compatibility**  
- EFS sử dụng tiêu chuẩn mã hóa **KMS với AES-256**.  
- Chỉ **hỗ trợ Linux-based AMI** (không hỗ trợ Windows).  

---

### 4. **Tính năng và hiệu suất**  
#### 📊 **Tính năng mở rộng**  
- Tự động mở rộng, không cần dự báo dung lượng lưu trữ trước.  
- Có thể hỗ trợ hàng nghìn NFS clients và quy mô dữ liệu lên tới **petabyte**.  
Để hiểu rõ hơn về các khái niệm và chế độ hiệu suất của **Amazon EFS (Elastic File System)** trong AWS, hãy đi sâu vào từng khái niệm bạn đã đề cập:

---

### **Amazon EFS là gì?**
Amazon Elastic File System (EFS) là dịch vụ lưu trữ tệp được thiết kế để cung cấp lưu trữ có khả năng mở rộng, linh hoạt, và chia sẻ cho các ứng dụng trong AWS. Nó hỗ trợ các giao thức như **NFSv4** để các máy chủ EC2 hoặc ứng dụng khác có thể truy cập tệp giống như lưu trữ cục bộ.

EFS có nhiều chế độ hiệu suất khác nhau để phù hợp với các loại ứng dụng và khối lượng công việc.

---

### **1. Chế độ hiệu suất (Performance Mode)**

#### **General Purpose (Mục đích chung):**
- **Mục đích**: Dành cho các ứng dụng nhạy cảm về **độ trễ (latency)**.
- **Sử dụng trong**:
  - **CMS (Content Management Systems)**: Các hệ thống quản lý nội dung như WordPress.
  - **Web Servers**: Các máy chủ web phục vụ nội dung trực tiếp.
  - **Ứng dụng phát triển và thử nghiệm**: Những tác vụ yêu cầu tốc độ truy cập nhanh.
- **Đặc điểm**:
  - Cân bằng giữa độ trễ thấp và thông lượng tốt.
  - Giới hạn về khả năng mở rộng IOPS (input/output operations per second).

#### **Max I/O (Hiệu suất tối đa):**
- **Mục đích**: Tối ưu hóa **throughput** (thông lượng) với độ trễ cao hơn.
- **Sử dụng trong**:
  - Xử lý dữ liệu lớn (**Big Data**).
  - Ứng dụng yêu cầu luồng dữ liệu lớn, như **media processing** hoặc **phân tích dữ liệu**.
    [ví dụ](../lý-thuyết-bên-lề/bigdata-mediaprocessing.md)
- **Đặc điểm**:
  - Có khả năng mở rộng IOPS cao hơn, nhưng đánh đổi bằng độ trễ cao hơn.
  - Thích hợp với hệ thống có nhiều máy chủ thực hiện truy cập đồng thời.

---

### **2. Chế độ thông lượng (Throughput Mode)**

#### **Bursting Throughput (Hiệu suất tăng tự động):**
- **Mục đích**: Cung cấp khả năng tăng hiệu suất tự động (burst) khi cần thiết.
- **Cách hoạt động**:
  - EFS cung cấp thông lượng cơ bản phụ thuộc vào kích thước hệ thống tệp của bạn.
  - Khi nhu cầu đột ngột tăng lên, EFS tự động "burst" để đáp ứng khối lượng công việc tăng đột biến.
  - Ví dụ: Nếu bạn có 1TB dung lượng lưu trữ, bạn sẽ được cung cấp 50MB/s thông lượng cơ bản, và hệ thống có thể tăng lên tối đa 100MB/s trong thời gian ngắn.
- **Sử dụng trong**: Ứng dụng không thường xuyên có yêu cầu throughput cao, nhưng vẫn cần khả năng tăng hiệu suất trong thời gian ngắn.


---

### **3. Enhanced/Elastic (Chế độ thông lượng linh hoạt)**

#### **Elastic (Thông lượng đàn hồi):**
- **Mục đích**: Thông lượng tự động điều chỉnh dựa trên tải công việc hiện tại.
- **Cách hoạt động**:
  - EFS tự động điều chỉnh throughput theo nhu cầu của bạn, không cần cấu hình thủ công.
  - Khi tải công việc tăng, hệ thống sẽ tăng throughput; khi tải giảm, throughput giảm.
- **Sử dụng trong**: Các ứng dụng có tính chất biến động cao, như xử lý dữ liệu thời gian thực hoặc streaming.
#### **Provisioned Throughput (Thông lượng cố định):**
- **Mục đích**: Đặt mức thông lượng cố định theo yêu cầu, không phụ thuộc vào dung lượng lưu trữ.
- **Cách hoạt động**:
  - Người dùng định cấu hình trước một mức **throughput** cụ thể, ví dụ: 200MB/s.
  - Hữu ích cho các ứng dụng cần throughput cao nhưng không lưu trữ quá nhiều dữ liệu.
- **Sử dụng trong**: Big Data, Machine Learning, hoặc các ứng dụng luôn cần throughput ổn định.


---

### 5. **Storage Classes**  

| **Tier**           | **Mô tả**                                                                                 |
|--------------------|------------------------------------------------------------------------------------------|
| **Standard Tier**  | Dùng cho dữ liệu thường xuyên được truy cập.                                            |
| **EFS-IA Tier**    | Dùng cho dữ liệu ít được truy cập; chi phí lưu trữ thấp nhưng có phí khi truy cập lại. |
| **Archive Storage** | Lưu trữ dữ liệu rất ít khi được truy cập với chi phí lưu trữ rẻ nhất.                     |

---

### 6. **Tính năng Lifecycle Policies**  
- Di chuyển dữ liệu tự động giữa các tầng lưu trữ dựa theo thời gian không được sử dụng.  
- Ví dụ: Dữ liệu không được truy cập sau 60 ngày sẽ được chuyển sang **EFS-IA**.

---

### 7. **Availability & Durability**  

#### ✅ **Multi-AZ Availability**  
- Tạo độ bền dữ liệu và khả năng chống thảm họa.  

#### 🏠 **Single Availability Zone (One Zone-IA)**  
- Rẻ hơn và tiết kiệm chi phí, phù hợp cho các nhu cầu phát triển và lưu trữ thông tin ít quan trọng.

---

### 8. 💰 **Tiết kiệm chi phí**  
- Tùy chọn các storage classes và lifecycle policies có thể tiết kiệm **lên tới 90% chi phí**.

### 9. Lab
-  chọn subnet mới chọn efs cho ec2, tạo sg demo gắn vô ec2 , khi tạo ec2 có chỗ chỉnh để tự tạo sg , sg tự tạo đó sẽ có rule để sg demo trỏ đến efs qua giao thức nnfs port 2049 , tất cả các sg ở trên tự gắn vô efs  
---

Amazon EFS là giải pháp linh hoạt, dễ mở rộng và tiết kiệm chi phí, tối ưu cho các tác vụ yêu cầu lưu trữ phân tán với khả năng mở rộng linh hoạt.