**Vấn đề ban đầu:**

- Khi bạn mới tạo các Subnet trong VPC tùy chỉnh của mình, theo mặc định, chúng **chưa có kết nối Internet**.
- Sự khác biệt giữa một "Public Subnet" (Subnet công khai) và một "Private Subnet" (Subnet riêng tư) chính là ở việc Subnet đó có được cấu hình để có lối ra Internet trực tiếp hay không. Hiện tại, các Subnet mới tạo đều chưa có kết nối này.

**Internet Gateway (IGW) là gì?**

- Internet Gateway là một **thành phần mạng** của VPC.
- Chức năng của nó là cho phép các tài nguyên bên trong VPC (như phiên bản EC2, hàm Lambda trong VPC, v.v.) có thể **kết nối với Internet**.

**Đặc điểm của Internet Gateway:**

- **Có khả năng mở rộng theo chiều ngang (Scales horizontally):** Tự động mở rộng để xử lý lượng truy cập Internet lớn.
- **Tính sẵn sàng cao và dư thừa(chịu lỗi cao) (Highly available and redundant):** Được AWS quản lý để luôn sẵn sàng và chống lỗi.
- Là một tài nguyên được AWS **quản lý hoàn toàn** (managed resource).
- Phải được **tạo ra riêng biệt** (separately) và sau đó được **đính kèm (attach)** vào một VPC.

**Quan hệ giữa Internet Gateway và VPC:**

- **Một VPC chỉ có thể đính kèm với DUY NHẤT một Internet Gateway** và ngược lại (một Internet Gateway chỉ có thể đính kèm với DUY NHẤT một VPC tại một thời điểm).

**Điểm Quan trọng Cốt lõi:**

- Việc **chỉ tạo và đính kèm** một Internet Gateway vào VPC **KHÔNG ĐỦ** để cung cấp kết nối Internet cho các Subnet.
- Internet Gateway chỉ là **cửa ngõ tiềm năng**. Để lưu lượng mạng thực sự đi qua cánh cửa này ra Internet, bạn **bắt buộc phải chỉnh sửa Bảng Định tuyến (Route Table)** của Subnet để chỉ định đường đi đó.

**Làm thế nào để có Internet Access (Sơ đồ luồng logic):**

Để một phiên bản EC2 trong Subnet có thể kết nối ra Internet, cần có các thành phần và cấu hình sau:

![1746807630211](image/IGW-routeTable/1746807630211.png)

1.  **Tạo và đính kèm Internet Gateway** vào VPC.
2.  **Chỉnh sửa Bảng Định tuyến (Route Table)** được liên kết với Subnet đó.
    - Thêm một quy tắc định tuyến mới (a new route) trong Bảng định tuyến.
    - Quy tắc này sẽ chỉ định rằng **tất cả lưu lượng mạng muốn đi ra Internet** (thường được biểu diễn bằng khối CIDR `0.0.0.0/0`) sẽ được gửi đến **Internet Gateway** đã đính kèm vào VPC.
3.  **Lưu lượng từ phiên bản EC2 sẽ đi theo luồng logic sau:**
    - Yêu cầu từ Phiên bản EC2 -> được xử lý bởi **VPC Router** (nằm trong Subnet).
    - Router kiểm tra Bảng Định tuyến của Subnet.
    - Nếu đích đến là Internet, Router sẽ đẩy lưu lượng theo quy tắc `0.0.0.0/0` -> đến **Internet Gateway**.
    - Internet Gateway chuyển lưu lượng ra **Internet**.

**Tóm lại:**

Internet Gateway là cánh cổng ra Internet cho VPC. Tuy nhiên, để cánh cổng này hoạt động cho một Subnet cụ thể, bạn phải cấu hình Bảng định tuyến của Subnet đó để chỉ dẫn lưu lượng mạng đi ra Internet thông qua Internet Gateway. Bước tiếp theo sẽ là thực hành tạo IGW và chỉnh sửa Bảng định tuyến để biến một Subnet thành "Public Subnet".
