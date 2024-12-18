

---

## 🚀 **Tóm tắt nội dung: Mã hóa EBS Volume**

### 📌 **1. Lợi ích của việc mã hóa EBS Volume**
Khi mã hóa EBS, bạn đảm bảo:
- **Dữ liệu tại trạng thái nghỉ (data at rest)** được mã hóa trong volume.
- **Dữ liệu đang truyền tải (in-flight)** giữa instance và volume được mã hóa.
- Tất cả **snapshot** và các volume được tạo từ snapshot đều được mã hóa.
- **Quản lý mã hóa và giải mã được thực hiện tự động** thông qua EC2 và EBS, bạn không cần can thiệp.

---

### 🔑 **2. Cách AWS mã hóa dữ liệu**
- AWS sử dụng **KMS** (Key Management Service).
- **Mã hóa tiêu chuẩn:** AES-256.

---

### 🛠️ **3. Cách mã hóa EBS volume**
#### a. **Khi tạo một EBS volume mới**
- Nếu chọn mã hóa ngay từ đầu, dữ liệu sẽ được mã hóa tự động.
- Nếu không mã hóa ngay, bạn có thể mã hóa sau thông qua **snapshot**.

#### b. **Mã hóa dữ liệu từ volume không mã hóa (unencrypted)**
1. **Tạo một snapshot không mã hóa** từ volume hiện tại.
2. Dùng **copy snapshot** và trong quá trình sao chép, chọn "Enable encryption".
3. Dùng snapshot đã mã hóa đó để tạo một **mới EBS volume** được mã hóa.

#### c. **Tạo Volume trực tiếp mã hóa  từ snapshot mã hóa hoặc không mã hóa **
- Dễ dàng và nhanh chóng bằng cách chọn tùy chọn **"Create volumes from snapshot"** và kích hoạt mã hóa trực tiếp.

---

### ⚠️ **4. Giới hạn và lưu ý**
1. **Giao diện mã hóa không làm tăng đáng kể độ trễ (latency).**  
2. Nếu sao chép snapshot không mã hóa từ các instance hiện tại, cần bật mã hóa trong quá trình sao chép.
3. **Xóa snapshot không cần thiết** sau khi mã hóa và hoàn thành việc chuyển dữ liệu.

---

## 🏆 **Tóm lược - Điều cần nhớ**


| **Phương pháp**                                           | **Mô tả**                                                                                                     |
|------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------|
| **a. Khi tạo một EBS volume mới**                          | Nếu chọn mã hóa ngay từ đầu, dữ liệu sẽ được mã hóa tự động. Nếu không mã hóa ngay, bạn có thể mã hóa sau thông qua **snapshot**. |
| **b. Mã hóa dữ liệu từ volume không mã hóa (unencrypted)**   | 1. **Tạo một snapshot không mã hóa** từ volume hiện tại.                                                    |
|                                                            | 2. Dùng **copy snapshot** và trong quá trình sao chép, chọn "Enable encryption".                              |
|                                                            | 3. Dùng snapshot đã mã hóa đó để tạo một **mới EBS volume** được mã hóa.                                     |
| **c. Tạo Volume mã hóa trực tiếp từ snapshot  ( mã hóa hoặc không mã hóa )** | Dễ dàng và nhanh chóng bằng cách chọn tùy chọn **"Create volumes from snapshot"** và kích hoạt mã hóa trực tiếp. |
|d. KMS sử dụng tiêu chuẩn mã hóa AES-256        | AWS sử dụng KMS với tiêu chuẩn mã hóa mạnh mẽ và an toàn **AES-256** để bảo mật dữ liệu.                  |




---

