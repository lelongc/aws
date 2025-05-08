Đích (Destination): Khối CIDR của chính VPC đó (ví dụ: 172.31.0.0/16).
Đích đến (Target): local
Ý nghĩa: Quy tắc này nói rằng "bất kỳ lưu lượng mạng nào có địa chỉ đích nằm trong dải IP của VPC này thì hãy giữ nó ở nội bộ (local) VPC".Đích (Destination): Khối CIDR của chính VPC đó (ví dụ: 172.31.0.0/16).
Đích đến (Target): local
Ý nghĩa: Quy tắc này nói rằng "bất kỳ lưu lượng mạng nào có địa chỉ đích nằm trong dải IP của VPC này thì hãy giữ nó ở nội bộ (local) VPC".

Okay, đây là giải thích chi tiết về VPC mặc định (Default VPC) được tạo cùng tài khoản AWS của bạn, dựa trên nội dung bạn cung cấp:

**Default VPC là gì?**

- Default VPC là một mạng riêng ảo (Virtual Private Cloud) mà AWS tự động tạo ra cho tài khoản AWS mới của bạn ở **mỗi Vùng (Region)**.
- Mục đích của việc này là giúp những người mới bắt đầu có thể **sử dụng AWS ngay lập tức** mà không cần phải cấu hình mạng phức tạp ban đầu.

**Hành vi mặc định khi sử dụng Default VPC:**

- Khi bạn khởi chạy các phiên bản Amazon EC2 mà **không chỉ định cụ thể subnet nào**, chúng sẽ được tự động khởi chạy vào **Default VPC** và một trong các subnet mặc định của nó.
- Theo mặc định, Default VPC đã được cấu hình sẵn để có **kết nối Internet**.
- Mỗi phiên bản EC2 được khởi chạy trong các subnet mặc định sẽ tự động nhận được một **địa chỉ IPv4 công khai (Public IPv4 address)**. Đây là lý do bạn có thể kết nối trực tiếp (ví dụ: dùng SSH) đến các phiên bản EC2 ngay sau khi tạo mà không cần cấu hình thêm.
- Các phiên bản EC2 cũng sẽ nhận được tên **DNS công khai và riêng tư (Public and Private IPv4 DNS name)**.

**Thực hành tốt nhất (Best Practice):**

- Mặc dù Default VPC tiện lợi cho việc bắt đầu nhanh hoặc thử nghiệm, nhưng **thực hành tốt nhất** là bạn nên **tạo VPC tùy chỉnh của riêng mình** (Custom VPCs) cho môi trường sản phẩm (production accounts).
- Việc tạo VPC tùy chỉnh giúp bạn kiểm soát hoàn toàn dải địa chỉ IP, cấu trúc mạng con, định tuyến và các thiết lập bảo mật, phù hợp hơn với yêu cầu cụ thể của ứng dụng và tuân thủ các tiêu chuẩn bảo mật của doanh nghiệp.

**Các Thành phần và Cấu hình của Default VPC:**

Khi khám phá Default VPC trong AWS Console, bạn sẽ thấy các thành phần sau được tạo sẵn:

1. **VPC:**

   - Có một **khối CIDR IPv4 (IPv4 CIDR block)** được định nghĩa sẵn (ví dụ phổ biến là `172.31.0.0/16`).
   - Với CIDR `/16`, dải địa chỉ này chứa tổng cộng $2^{16} = 65.536$ địa chỉ IP khả dụng.
   - Theo mặc định, không có khối CIDR IPv6 nào được liên kết.
   - Flow Logs (Nhật ký luồng) thường không được bật mặc định cho VPC.
   - Không có thẻ (tags) được gán mặc định.

2. **Subnets (Mạng con):**

   - Ba (hoặc nhiều hơn tùy Vùng) subnet được tạo sẵn, mỗi subnet nằm trong một **Availability Zone (AZ) khác nhau** trong Vùng đó. Điều này nhằm cung cấp sẵn một cấu trúc mạng cơ bản cho kiến trúc có tính sẵn sàng cao (highly available).
   - Mỗi subnet có khối CIDR IPv4 riêng của nó (ví dụ: `/20`), là một phần của khối CIDR lớn hơn của VPC.
   - Với CIDR `/20`, mỗi subnet chứa $2^{12} = 4096$ địa chỉ IP. Tuy nhiên, số lượng địa chỉ IP thực tế khả dụng thường ít hơn (ví dụ: 4091) vì AWS **dành riêng 5 địa chỉ IP đầu tiên** trong mỗi subnet cho các mục đích mạng nội bộ của AWS (địa chỉ mạng, địa chỉ Broadcast, gateway, và 2 địa chỉ DNS).
   - Các subnet mặc định có thiết lập **"Auto-assign public IPv4" được BẬT (enabled)**. Điều này giải thích tại sao các phiên bản EC2 khởi chạy vào đây tự động nhận được địa chỉ IP công khai.
   - Không có Flow Logs được bật mặc định cho subnet.
   - Không có CIDR Reservations hoặc chia sẻ subnet mặc định.

3. **Route Table (Bảng định tuyến):**

   - Một bảng định tuyến mặc định (default route table), còn gọi là bảng định tuyến chính (main route table), được tạo.
   - Bảng định tuyến này chứa các **quy tắc (routes)** để xác định lưu lượng mạng từ VPC đi đâu.
   - Một quy tắc quan trọng là quy tắc định tuyến cho toàn bộ lưu lượng **bên ngoài** khối CIDR của VPC (đường dẫn `0.0.0.0/0` cho IPv4) sẽ được gửi đến **Internet Gateway**.
     còn có một quy tắc mặc định luôn tồn tại được gọi là quy tắc định tuyến cục bộ (local route).Đích (Destination): Khối CIDR của chính VPC đó (ví dụ: 172.31.0.0/16).
     Đích đến (Target): local
     Ý nghĩa: Quy tắc này nói rằng "bất kỳ lưu lượng mạng nào có địa chỉ đích nằm trong dải IP của VPC này thì hãy giữ nó ở nội bộ (local) VPC".

- Bảng định tuyến mặc định này được **liên kết ngầm (implicitly associated)** với tất cả các subnet trong VPC mà không được liên kết rõ ràng (explicitly associated) với một bảng định tuyến cụ thể nào khác.

4. **Internet Gateway (IGW):**

   - Một Internet Gateway được tạo và **đính kèm vào Default VPC**.
   - Chức năng của IGW là cho phép các phiên bản trong VPC có thể **truy cập Internet** và cho phép lưu lượng từ Internet truy cập vào các phiên bản có địa chỉ IP công khai trong VPC (nếu các cấu hình bảo mật như Security Groups và Network ACL cho phép).

5. **Network ACLs (NACLs - Danh sách kiểm soát truy cập mạng):**

   - Mỗi subnet được liên kết với một Network ACL.
   - Network ACL mặc định có cấu hình **rất thoáng**: cho phép **TẤT CẢ** lưu lượng truy cập (trên TẤT CẢ các giao thức, từ BẤT KỲ nguồn nào) cho cả **chiều vào (inbound)** và **chiều ra (outbound)**. Điều này đảm bảo kết nối mạng cơ bản hoạt động ngay lập tức, nhưng thường cần được tùy chỉnh cho môi trường production để tăng cường bảo mật.

**Tổng kết:**

Default VPC được thiết lập sẵn với các thành phần mạng cơ bản (VPC, subnets, route table, Internet Gateway, NACL) và cấu hình mặc định cho phép kết nối Internet và tự động gán IP công khai cho các phiên bản EC2, giúp bạn nhanh chóng bắt đầu sử dụng AWS. Việc hiểu các thành phần này là bước đầu tiên quan trọng trước khi tự xây dựng VPC tùy chỉnh theo nhu cầu cụ thể của ứng dụng.
