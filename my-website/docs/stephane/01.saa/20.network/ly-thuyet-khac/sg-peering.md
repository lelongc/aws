1.  **Nhắc lại:** Tính năng này chỉ hoạt động khi hai VPC được peering **trong CÙNG một Vùng (Region)** AWS.

2.  **Cách thông thường (khi không dùng tính năng này):**

    - Giả sử bạn có VPC A và VPC B được peering.
    - Trong VPC A, bạn có một máy chủ web (Web Server).
    - Trong VPC B, bạn có máy chủ ứng dụng (App Server).
    - Bạn muốn Web Server (trong VPC A) chỉ cho phép **App Server** (trong VPC B) kết nối đến nó qua cổng 80.
    - Theo cách thông thường, trong Security Group của **Web Server** (ở VPC A), bạn sẽ thêm một luật **cho phép (Allow)** lưu lượng vào (inbound) trên cổng 80, và đặt **Nguồn (Source)** là **dải địa chỉ IP (CIDR Block)** của subnet chứa App Server trong VPC B (ví dụ: `10.1.0.0/24`).

3.  **Cách dùng tính năng Nâng cao (Tham chiếu Security Group qua Peering):**

    - Thay vì đặt Nguồn là dải IP (`10.1.0.0/24`), trong Security Group của **Web Server** (ở VPC A), bạn thêm luật **cho phép (Allow)** lưu lượng vào (inbound) trên cổng 80, và đặt **Nguồn (Source)** là **ID của Security Group** mà **App Server** đang là thành viên trong VPC B (ví dụ: `sg-0123456789abcdef0`).
    - Security Group này (`sg-0123456789abcdef0`) này tồn tại ở VPC B.

4.  **"Điều này rất mạnh mẽ" nghĩa là gì? (Lợi ích):**
    - **Kiểm soát chi tiết hơn (Granularity):** Bạn không chỉ cho phép **bất kỳ máy chủ nào** có IP trong dải `10.1.0.0/24` kết nối. Bạn chỉ cho phép kết nối từ **NHỮNG MÁY CHỦ CỤ THỂ** mà bạn đã gán vào cái Security Group có ID là `sg-0123456789abcdef0` ở VPC B. Nó giống như bạn cho phép "chỉ những người có thẻ ra vào đặc biệt này" chứ không phải "tất cả mọi người trong khu nhà đó".
    - **Linh hoạt hơn:** Nếu sau này bạn di chuyển App Server sang một subnet khác trong VPC B (có dải IP khác), bạn **không cần phải quay lại sửa luật Security Group** của Web Server ở VPC A nữa. Luật tham chiếu Security Group vẫn hoạt động đúng vì App Server vẫn thuộc Security Group đó. Nếu dùng cách truyền thống (dựa trên CIDR), bạn sẽ phải cập nhật dải IP nguồn trong luật.
    - **Dễ quản lý và hiểu:** Bạn cấp quyền dựa trên "vai trò" của máy chủ (được biểu diễn bởi Security Group của nó) thay vì vị trí IP mạng cụ thể. Luật "Cho phép kết nối từ SG AppServer" dễ hiểu hơn là "Cho phép kết nối từ 10.1.0.0/24".

**Tóm lại một cách đơn giản:**

Thay vì nói "Tôi cho phép **cả dãy nhà có địa chỉ từ X đến Y** vào đây", bạn nói "Tôi chỉ cho phép **những người mang thẻ ID này** vào đây (và cái thẻ ID này được cấp cho các máy chủ App Server ở VPC bên kia)".
