### Chi tiết kiến thức về **Sticky Sessions** (Session Affinity) cho Elastic Load Balancer

---

#### **1. Khái niệm Sticky Sessions:**
Sticky Sessions (hay Session Affinity) là một tính năng trong Elastic Load Balancer (ELB) cho phép các yêu cầu từ cùng một client được gửi đến cùng một instance backend.

- **Mặc định:** ELB phân phối yêu cầu một cách đồng đều (round-robin hoặc theo trọng số) tới các EC2 instances.
- **Khi bật Sticky Sessions:** Yêu cầu từ một client sẽ luôn được xử lý bởi một EC2 instance cụ thể.

---

#### **2. Hoạt động của Sticky Sessions:**
- **Cookie:** ELB sử dụng cookie để duy trì stickiness.
  - Khi client gửi yêu cầu, load balancer trả về một cookie trong response.
  - Cookie này chứa thông tin xác định backend instance mà client nên kết nối.
  - Khi cookie hết hạn, client có thể được chuyển tới một instance khác.

---

#### **3. Các loại Cookie trong Sticky Sessions:**
Có 2 loại cookie chính:
1. **Application-based Cookie:**
   - Được tạo bởi ứng dụng backend (EC2 instance).
   - Có thể tùy chỉnh các thuộc tính cookie theo yêu cầu ứng dụng.
   - Cookie name phải được chỉ định cho từng target group.
   - Lưu ý không được sử dụng các tên cookie như: `AWSALB`, `AWSALBAPP`, `AWSALBTG` vì chúng đã được ELB sử dụng.

2. **Duration-based Cookie:**
   - Được tạo bởi load balancer.
   - Tên cookie:
     - `AWSALB` cho Application Load Balancer (ALB).
     - `AWSELB` cho Classic Load Balancer (CLB).
   - Cookie này có thời hạn cụ thể (thời gian tồn tại được cấu hình tại ELB).

---

#### **4. Bật và Cấu hình Sticky Sessions:**
- Sticky Sessions được kích hoạt ở **mức target group**.
- Hai tùy chọn stickiness:
  1. **Load Balancer Generated Cookie (Duration-based Cookie):**
     - Thời hạn từ 1 giây đến 7 ngày.
  2. **Application-based Cookie:**
     - Cần chỉ định tên cookie được ứng dụng tạo ra.

**Hướng dẫn cấu hình:**
1. Truy cập vào **Target Group** trong AWS Console.
2. Chọn **Edit Attributes**.
3. Bật stickiness và chọn loại cookie.
4. Lưu các thay đổi.

---

#### **5. Use Case của Sticky Sessions:**
- Duy trì kết nối tới cùng backend instance để không mất dữ liệu phiên người dùng, ví dụ:
  - **Dữ liệu đăng nhập**.
  - **Giỏ hàng** trong ứng dụng e-commerce.
- **Lưu ý:** Bật sticky sessions có thể dẫn đến mất cân bằng tải nếu một instance phải xử lý quá nhiều yêu cầu từ các "sticky" clients.

---

#### **6. Cách kiểm tra Sticky Sessions:**
1. Sử dụng Developer Tools (trình duyệt Chrome hoặc Firefox).
2. Truy cập tab **Network** để kiểm tra cookie.
3. Khi sticky sessions được bật, client sẽ kết nối với cùng một instance dựa trên cookie.

---

#### **7. Tắt Sticky Sessions:**
- Truy cập lại **Target Group**, chọn **Edit Attributes** và tắt stickiness để load balancer quay về phân phối yêu cầu bình thường.

---

### **Lưu ý:**
- Sticky Sessions thích hợp cho các ứng dụng cần duy trì dữ liệu session trên cùng backend instance.
- Tuy nhiên, trong các hệ thống phân tán lớn, nên cân nhắc sử dụng **[Distributed Cache](../lý-thuyết-bên-lề/Distributed-Cache.md)** (Redis, Memcached) thay vì dựa hoàn toàn vào sticky sessions để quản lý session data.