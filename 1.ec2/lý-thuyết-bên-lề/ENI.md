Đúng vậy! Một **Elastic Network Interface (ENI)** có thể có **nhiều địa chỉ Private IPv4**, cụ thể như sau:

### **Mỗi ENI có thể chứa:**

1. **Primary Private IPv4**:

   - Đây là địa chỉ **Private IPv4 chính** được gắn với ENI khi nó được tạo. Primary Private IPv4 là bắt buộc.

2. **Secondary Private IPv4**:
   - Ngoài địa chỉ chính, ENI có thể được gắn thêm **một hoặc nhiều Secondary Private IPv4**.
   - Các địa chỉ này rất hữu ích trong một số trường hợp, ví dụ:
     - Một instance phục vụ nhiều ứng dụng, mỗi ứng dụng có một Private IP riêng.
     - Bạn cần di chuyển một Secondary Private IP sang một ENI khác khi failover.

---

### **Ví dụ:**

- Một ENI có:
  - **Primary Private IPv4**: `10.0.1.10`.
  - **Secondary Private IPv4**: `10.0.1.11`, `10.0.1.12`.

Trên instance:

- Địa chỉ `10.0.1.10` sẽ xuất hiện trên interface `eth0` (mặc định).
- Địa chỉ `10.0.1.11` và `10.0.1.12` sẽ được cấu hình thêm.

---

### **Câu hỏi thường gặp:**

1. **Tại sao cần nhiều Private IPv4 trên ENI?**

   - Giúp hỗ trợ nhiều ứng dụng hoặc dịch vụ trên một instance (mỗi ứng dụng dùng một IP riêng).
   - Cho phép failover dễ dàng: bạn có thể chuyển một Secondary Private IP sang một ENI hoặc EC2 khác.

2. **Giới hạn số lượng Private IPv4 trên ENI?**

   - Số lượng địa chỉ Private IPv4 tối đa trên ENI phụ thuộc vào loại instance EC2 mà ENI gắn vào. Ví dụ:
     - Loại instance nhỏ (e.g., `t2.micro`) có thể chỉ hỗ trợ 2–3 địa chỉ Private IPv4.
     - Loại lớn hơn (e.g., `m5.large`) hỗ trợ nhiều hơn.

3. **Các địa chỉ Private IPv4 này được quản lý thế nào?**
   - Bạn có thể thêm hoặc xóa Secondary Private IPv4 bất cứ lúc nào thông qua AWS Management Console, CLI, hoặc API.
   - **Primary Private IPv4** thì không thể xóa hoặc thay đổi.

---

### **Tóm lại**:

- **Một ENI** có thể có nhiều địa chỉ **Private IPv4** (1 Primary + nhiều Secondary).
- Sử dụng nhiều Private IPv4 giúp tối ưu hóa tài nguyên và hỗ trợ failover trong nhiều tình huống.

### **Chi tiết về Failover với 2 ENI và IP không đổi**

Failover với **Elastic Network Interface (ENI)** hoạt động theo cách giữ nguyên địa chỉ IP, giúp các ứng dụng và dịch vụ không nhận thấy thay đổi, kể cả khi có sự cố. Để hiểu rõ hơn, hãy xem chi tiết dưới đây:

---

### **Tại sao IP không đổi khi failover?**

1. **ENI giữ địa chỉ IP:**

   - Một ENI luôn gắn liền với **Private IPv4** và (nếu có) **Elastic/Public IPv4**.
   - Khi bạn chuyển ENI từ một EC2 Instance sang một EC2 Instance khác:
     - **Private IP** và **Elastic IP** (nếu có) của ENI được giữ nguyên.
     - Ứng dụng vẫn kết nối đến IP này mà không nhận ra rằng ENI đã được di chuyển.

2. **Public IP động không di chuyển:**
   - Nếu EC2 chỉ dùng Public IP động (gán tự động bởi AWS), địa chỉ này **không di chuyển** khi failover.
   - Nhưng nếu bạn sử dụng **Elastic IP** (IP Public tĩnh do bạn quản lý), Elastic IP sẽ được di chuyển theo ENI và không thay đổi.

---

### **Quy trình Failover với ENI**

Giả sử bạn có 2 ENI trong cùng một AZ:

#### **Trạng thái ban đầu**

- **ENI chính (Primary ENI)** gắn với Instance A:
  - Địa chỉ Private IP: `10.0.1.100`.
  - Elastic IP: `54.210.120.5` (nếu cần public).
- **ENI phụ (Secondary ENI)** chưa hoạt động hoặc gắn với Instance B (dự phòng).

#### **Khi xảy ra sự cố**

1. Instance A gặp lỗi, không thể truy cập.
2. ENI chính được tách ra khỏi Instance A.
3. ENI chính được gắn vào Instance B trong cùng AZ.

#### **Sau khi Failover**

- Instance B giờ có **Private IP** `10.0.1.100` và Elastic IP `54.210.120.5`.
- Các ứng dụng, client, hoặc dịch vụ bên ngoài vẫn kết nối qua các IP này mà không nhận ra thay đổi.

---

**Hệ thống cơ sở dữ liệu Private**

- **Kiến trúc:**

  - Một cơ sở dữ liệu MySQL dùng Private IP `10.0.1.50`.
  - ENI chính gắn với Instance A, các ứng dụng truy cập qua Private IP này.

- **Khi xảy ra sự cố:**
  - Instance A bị lỗi, ENI chính được chuyển sang Instance B.
  - Private IP `10.0.1.50` vẫn hoạt động, các ứng dụng không cần thay đổi cấu hình.

---

### **So sánh IP trong Failover**

| **Loại IP**          | **Di chuyển với ENI** | **Lưu ý**                                                         |
| -------------------- | --------------------- | ----------------------------------------------------------------- |
| **Private IPv4**     | Có                    | Địa chỉ Private IP gắn với ENI sẽ di chuyển cùng ENI.             |
| **Public IP (động)** | Không                 | Nếu EC2 dùng Public IP động, địa chỉ này không di chuyển.         |
| **Elastic IP**       | Có                    | Elastic IP di chuyển cùng ENI, thích hợp cho các ứng dụng public. |

---

### **Ứng dụng của Failover với ENI**

1. **Tính sẵn sàng cao:**  
   Duy trì kết nối mạng ổn định, ngay cả khi EC2 Instance gặp sự cố.
2. **Cấu trúc mạng linh hoạt:**  
   ENI có thể di chuyển giữa các instance trong cùng AZ, cho phép thay thế instance dễ dàng.
3. **Quản lý IP hiệu quả:**  
   Elastic IP hoặc Private IP cố định giúp ứng dụng không cần cập nhật cấu hình.
