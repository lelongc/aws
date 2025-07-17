Ý chính của tùy chọn **Enable DNS name** cho Interface Endpoint là:

Nó làm cho **tên miền công khai** mặc định của dịch vụ AWS (như `sqs.REGION.amazonaws.com`) khi được bạn hoặc ứng dụng của bạn tra cứu (phân giải DNS) từ bên trong VPC, sẽ trả về **địa chỉ IP riêng tư** của cái Endpoint đó (chính xác là IP của ENI thuộc Endpoint) nằm ngay trong VPC của bạn.

Và sau đó, khi ứng dụng của bạn gửi lưu lượng đến địa chỉ IP riêng tư đó, lưu lượng sẽ được đưa vào cái "lối đi tắt riêng tư" (Endpoint) này để kết nối đến dịch vụ AWS, thay vì đi ra Internet.

Tóm lại: **Dùng dns công khai -> phân giải ra IP riêng tư trong VPC -> gửi lưu lượng đến IP riêng tư đó (chính là Endpoint) -> đi vào mạng nội bộ của AWS.**

- Với **Gateway Endpoint** (chỉ dùng cho S3/DynamoDB): **Không có tùy chọn "Enable DNS name"** theo cách tương tự. Gateway Endpoint không tạo ra ENI hay IP riêng trong subnet của bạn để tên miền dịch vụ phân giải tới. Thay vào đó, bạn cấu hình trong **Bảng Định tuyến (Route Table)** của subnet một quy tắc: Lưu lượng đi đến **dải địa chỉ IP công khai (public IP ranges)** của dịch vụ (ví dụ: S3, được cung cấp dưới dạng Prefix List) sẽ được gửi đến đích là **Gateway Endpoint ID** đó.

Tên miền công khai của S3/DynamoDB vẫn phân giải ra dải IP công khai của chúng, nhưng cơ chế định tuyến ở cấp độ subnet sẽ "chụp lấy" lưu lượng đi đến các dải IP đó và chuyển hướng nó vào Gateway Endpoint thay vì ra Internet Gateway.

Tóm lại, "Enable DNS name" là tính năng đặc trưng của Interface Endpoint để hỗ trợ việc sử dụng tên miền công khai cho kết nối riêng tư thông qua phân giải DNS đến IP riêng. Gateway Endpoint dựa vào việc định tuyến dựa trên dải IP công khai của dịch vụ trong Bảng Định tuyến.
