## Các Dịch vụ AWS Hỗ trợ Tích hợp và Di chuyển từ On-Premise

Khi bạn muốn "bắt tay" giữa hệ thống đang chạy ở nhà (on-premise) với "người bạn khổng lồ" AWS, hoặc thậm chí là "chuyển nhà" lên AWS, thì đây là những trợ thủ đắc lực:

### 1. Amazon Linux 2 AMI dưới dạng Máy ảo (VM) 🐧

- **Ý tưởng là gì?** AWS cho phép bạn tải **Amazon Linux 2 AMI** (Amazon Machine Image - cái khuôn để tạo máy chủ ảo) về dưới dạng file **ISO**.
- **Làm sao dùng?** Bạn có thể nạp file ISO này vào các phần mềm tạo máy ảo phổ biến như:
  - VMWare
  - KVM
  - VirtualBox (Oracle VM)
  - Microsoft Hyper-V
- **Lợi ích:** Điều này cho phép bạn chạy Amazon Linux 2 **ngay trên hạ tầng on-premise** của mình. Bạn có thể làm quen, phát triển, thử nghiệm ứng dụng trong một môi trường gần giống với khi chạy trên EC2 của AWS. Khá là hay ho để vọc vạch đó!

---

### 2. VM Import/Export ➡️⬅️

- **Làm được gì?** Dịch vụ này cho phép bạn:
  - **Import (Nhập):** Di chuyển các máy ảo (VM) và ứng dụng hiện có của bạn từ on-premise vào **EC2** một cách trực tiếp.
  - **Export (Xuất):** Ngược lại, bạn cũng có thể xuất các máy ảo từ EC2 trở lại môi trường on-premise nếu cần.
- **Ứng dụng thực tế:**
  - Di chuyển hệ thống lên cloud.
  - Xây dựng chiến lược **Disaster Recovery** (Phục hồi sau thảm họa) bằng cách sao lưu các VM on-premise lên cloud.

---

### 3. AWS Application Discovery Service 🔍

- **Nhiệm vụ:** Dịch vụ này giúp bạn **thu thập thông tin** về các máy chủ đang chạy on-premise để lên kế hoạch di chuyển.
- **Thông tin gì?** Nó cung cấp:
  - Thông tin về mức độ sử dụng tài nguyên của server (server utilization).
  - Sơ đồ phụ thuộc giữa các server (dependency mappings).
- **Lợi ích:** Rất hữu ích khi bạn muốn thực hiện một cuộc di chuyển quy mô lớn từ on-premise lên cloud, giúp bạn hiểu rõ hơn về hệ thống hiện tại.

---

### 4. AWS Migration Hub 📍

- **Đơn giản là:** Một nơi trung tâm để bạn **theo dõi tiến độ** của tất cả các dự án di chuyển (migration) của mình.

---

### 5. AWS Database Migration Service (DMS) 🗄️➡️☁️

- **Khả năng siêu phàm:** Cho phép bạn **sao chép (replicate)** cơ sở dữ liệu:
  - Từ on-premise lên AWS.
  - Giữa các dịch vụ AWS với nhau.
  - Từ AWS về lại on-premise.
- **Tuyệt vời ở chỗ:**
  - Hỗ trợ nhiều công nghệ CSDL khác nhau: Oracle, MySQL, PostgreSQL, SQL Server, MariaDB, và cả NoSQL như **DynamoDB**, MongoDB, DocumentDB.
  - Thực hiện được các kịch bản "fancy" như di chuyển dữ liệu từ MySQL (quan hệ) sang DynamoDB (NoSQL).
- **Ví dụ:** Bạn có database MySQL chạy on-premise. Khi muốn dần chuyển việc lên AWS, bạn có thể dùng DMS để replicate database đó lên AWS. Khi nào sẵn sàng, bạn chuyển hẳn sang dùng database trên AWS.

---

### 6. AWS Server Migration Service (SMS) 🖥️➡️☁️

- **Chuyên môn:** Dành cho việc **sao chép tăng trưởng (incremental replication)** các máy chủ đang hoạt động (live servers) từ on-premise lên AWS.
- **Cách thức:** Nó sao chép trực tiếp các ổ đĩa (volumes) của server.
- **Khi nào dùng?** Phù hợp cho việc sao chép liên tục, đang diễn ra, đặc biệt là khi bạn muốn di chuyển server mà ít gây gián đoạn nhất.

---

## Chốt hạ cho kỳ thi 📝

Nghe qua một lượt có vẻ nhiều dịch vụ đúng không? Đừng lo! Điều quan trọng nhất bạn cần nhớ là **tên của các dịch vụ này ở mức độ tổng quan** và biết rằng chúng **liên quan đến việc tích hợp hoặc di chuyển từ on-premise lên AWS**.

Khi thấy những cái tên như:

- **Amazon Linux 2 AMI as VM**
- **VM Import/Export**
- **AWS Application Discovery Service**
- **AWS Migration Hub**
- **AWS Database Migration Service (DMS)**
- **AWS Server Migration Service (SMS)**

...trong câu hỏi thi, bạn sẽ không bị bất ngờ và biết ngay là chúng phục vụ cho kịch bản on-premise.
