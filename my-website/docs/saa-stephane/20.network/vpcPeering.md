![1746950742697](image/vpcPeering/1746950742697.png)

**VPC Peering là gì?**

- VPC Peering là một **kết nối mạng** giữa **hai VPC (Virtual Private Cloud)**, cho phép chúng giao tiếp với nhau bằng cách sử dụng mạng riêng của AWS.
- Mục đích của việc thiết lập peering là để các VPC có thể **hoạt động như thể chúng nằm trong cùng một mạng**, mặc dù thực tế chúng có thể ở các Vùng (Region) khác nhau, thuộc các Tài khoản AWS khác nhau, hoặc thậm chí là hai VPC riêng biệt trong cùng một Tài khoản.

**Tại sao sử dụng VPC Peering?**

- Để kết nối các ứng dụng hoặc dịch vụ chạy trong các VPC khác nhau cần giao tiếp nội bộ (ví dụ: ứng dụng web trong VPC A cần truy cập cơ sở dữ liệu trong VPC B).
- Cho phép truy cập tài nguyên trên các Vùng hoặc Tài khoản khác một cách riêng tư và hiệu quả hơn so với việc đi qua Internet công cộng.

**Yêu cầu Bắt buộc:**

- Để thiết lập VPC Peering giữa hai VPC, khối **CIDR IPv4 (và cả IPv6 nếu có sử dụng)** của hai VPC đó **KHÔNG ĐƯỢC TRÙNG LẶP (must be distant from each other)**.
- Nếu CIDR trùng lặp, các VPC sẽ không thể giao tiếp qua kết nối peering đó. Đây là một ràng buộc quan trọng cần kiểm tra trước khi thiết lập.

**Đặc điểm của VPC Peering:**

1.  **Kết nối điểm-điểm (Point-to-point):** VPC Peering là kết nối trực tiếp giữa **DUY NHẤT hai VPC**.
2.  **KHÔNG có tính bắc cầu (NOT Transitive):** Đây là đặc điểm RẤT RẤT QUAN TRỌNG và là điểm thường gây nhầm lẫn.
    - Nếu bạn có 3 VPC là A, B và C.
    - Bạn tạo kết nối peering giữa A và B (A <-> B). A và B có thể giao tiếp.
    - Bạn tạo kết nối peering giữa B và C (B <-> C). B và C có thể giao tiếp.
    - **Tuy nhiên, A và C sẽ KHÔNG THỂ giao tiếp trực tiếp với nhau thông qua B.** Kết nối peering không có tính bắc cầu.
    - Để A và C có thể giao tiếp, bạn **bắt buộc phải tạo thêm một kết nối peering trực tiếp giữa A và C** (A <-> C). Mỗi cặp VPC cần giao tiếp phải có một kết nối peering riêng.

**Cấu hình Bổ sung Bắt buộc (sau khi tạo kết nối Peering):**

- Việc tạo kết nối VPC Peering chỉ mới là bước "thiết lập đường hầm". Để lưu lượng mạng thực sự đi qua đường hầm đó, bạn **bắt buộc phải cập nhật Bảng Định tuyến (Route Table)** trong các Subnet của **cả hai VPC** tham gia peering.
- Trong Bảng định tuyến của Subnet thuộc VPC A, bạn cần thêm một quy tắc định tuyến:
  - **Đích (Destination):** Khối CIDR của VPC B.
  - **Đích đến (Target):** Chọn **Peering Connection** và chỉ định ID kết nối peering giữa A và B.
- Tương tự, trong Bảng định tuyến của Subnet thuộc VPC B, bạn cần thêm quy tắc:
  - **Đích (Destination):** Khối CIDR của VPC A.
  - **Đích đến (Target):** Chọn Peering Connection và chỉ định ID kết nối peering giữa A và B.
- Bước cập nhật Bảng định tuyến này là **thiết yếu** để cho phép các phiên bản EC2 trong các Subnet khác nhau thuộc hai VPC đã peering có thể "biết đường" để gửi lưu lượng cho nhau.

**Khả năng kết nối của VPC Peering:**

VPC Peering rất linh hoạt và có thể kết nối các VPC:

- **Trong cùng một Tài khoản AWS:** Kết nối hai VPC khác nhau trong cùng một tài khoản.
- **Giữa các Tài khoản AWS khác nhau:** Kết nối VPC thuộc Tài khoản A với VPC thuộc Tài khoản B.
- **Giữa các Vùng AWS khác nhau:** Kết nối VPC ở Vùng này với VPC ở Vùng khác.

**Tính năng Nâng cao ([Security Groups qua Peering](./ly-thuyet-khac/sg-peering.md) ):**

- Khi kết nối peering được thiết lập giữa các VPC **trong CÙNG một Vùng** (có thể trong cùng tài khoản hoặc khác tài khoản), bạn có thể **tham chiếu (reference)** một **Security Group ID** từ VPC được peering trong luật của Security Group trong VPC của bạn.
- Điều này rất mạnh mẽ vì bạn có thể cho phép lưu lượng dựa trên "phiên bản này là thành viên của Security Group X" thay vì phải dựa trên dải địa chỉ IP (CIDR) của toàn bộ Subnet hoặc VPC.

**Tóm lại:**

VPC Peering là cách kết nối trực tiếp hai VPC qua mạng AWS. Yêu cầu CIDR không trùng lặp. Quan trọng nhất là nó **không có tính bắc cầu** (mỗi cặp cần peering riêng) và bạn **phải cập nhật Bảng định tuyến** ở cả hai phía để lưu lượng đi qua. Nó hỗ trợ kết nối trong/khác tài khoản và trong/khác vùng, với tính năng tham chiếu Security Group cho các kết nối cùng vùng.

---

**Mục tiêu của Lab:**

Thiết lập kết nối VPC Peering giữa VPC tùy chỉnh bạn đã tạo (`DemoVPC`) và VPC mặc định (Default VPC) được tạo sẵn trong tài khoản của bạn, sau đó cho phép các phiên bản EC2 trong hai VPC này giao tiếp với nhau bằng địa chỉ IP riêng tư (Private IP).

**Bước 1: Chứng minh hai VPC ban đầu không kết nối được**

1.  **Khởi chạy phiên bản EC2:**
    - Khởi chạy một phiên bản EC2 mới (ví dụ: Amazon Linux 2, t2.micro, không cần Key Pair cho mục đích này) vào **Default VPC** của bạn.
    - Đảm bảo phiên bản này nằm trong Subnet mặc định của Default VPC (thường tự động gán IP công khai và có Internet access).
    - Tạo một Security Group mới (hoặc sử dụng Default SG của Default VPC) cho phép SSH (Port 22) từ địa chỉ IP công cộng của bạn hoặc từ bất kỳ đâu (`0.0.0.0/0` cho demo).
2.  **Xác định IP riêng tư:** Ghi lại địa chỉ IP riêng tư (Private IP) của phiên bản mới trong Default VPC và phiên bản Bastion Host (hoặc bất kỳ phiên bản nào trong `DemoVPC`) mà bạn sẽ sử dụng để kiểm tra kết nối. Lưu ý dải IP riêng tư của chúng (ví dụ: `DemoVPC` có thể dùng `10.0.0.0/16`, Default VPC thường dùng `172.31.0.0/16`). Sự khác biệt rõ rệt về dải IP riêng tư xác nhận chúng nằm ở các mạng (VPC) khác nhau.
3.  **Kiểm tra kết nối ban đầu:**
    - SSH vào phiên bản EC2 nằm trong `DemoVPC` của bạn (ví dụ: Bastion Host).
    - Từ phiên bản đó, sử dụng lệnh `curl` hoặc `ping` để cố gắng kết nối đến địa chỉ IP riêng tư của phiên bản EC2 nằm trong **Default VPC** (ví dụ: `curl <Private-IP-cua-instance-o-DefaultVPC>:80` nếu bạn có web server ở đó, hoặc `ping <Private-IP-cua-instance-o-DefaultVPC>`).
    - **Kết quả:** Kết nối sẽ **THẤT BẠI** (ví dụ: timeout). Điều này chứng minh rằng theo mặc định, các VPC hoàn toàn cô lập với nhau về mặt mạng.

**Bước 2: Tạo kết nối VPC Peering**

1.  Truy cập **AWS VPC console** -> **Peering Connections**.
2.  Nhấp vào **Create peering connection**.
3.  **Cấu hình kết nối:**
    - **Peering connection name:** Đặt tên cho dễ nhớ (ví dụ: `demo-peering-connection`).
    - **Select a local VPC to peer with (Requester):** Chọn **VPC yêu cầu** kết nối. Chọn `DemoVPC` của bạn.
    - **Select a VPC to peer with (Accepter):** Chọn **VPC chấp nhận** kết nối.
      - **Account:** Chọn "My account" (vì cả hai VPC đều trong cùng tài khoản).
      - **Region:** Chọn "This Region" (vì cả hai VPC đều trong cùng Vùng).
      - **VPC ID:** Chọn Default VPC từ danh sách thả xuống.
    - AWS sẽ hiển thị CIDR của cả hai VPC. Hệ thống sẽ **tự động kiểm tra xem có trùng lặp CIDR không**. Nếu không trùng lặp, kết nối peering có thể được tạo.
    - Nhấp vào **Create peering connection**.

**Bước 3: Chấp nhận kết nối Peering**

1.  Trạng thái của kết nối Peering mới tạo sẽ là `Pending Acceptance` (đang chờ chấp nhận).
2.  Trong cùng màn hình Peering Connections, chọn kết nối `demo-peering-connection`.
3.  Nhấp vào **Actions** -> **Accept Request**.
4.  Nhấp **Accept**. Trạng thái sẽ chuyển sang `Active`.
5.  **Lưu ý:** Nếu peering giữa các tài khoản khác nhau, chủ sở hữu của VPC chấp nhận ở tài khoản kia mới có thể thực hiện bước chấp nhận này.

**Bước 4: Cập nhật Bảng Định tuyến (Route Table) ở CẢ HAI VPC**

- **Quan trọng:** Dù kết nối Peering đang ở trạng thái `Active`, lưu lượng mạng vẫn **chưa thể đi qua** cho đến khi bạn cập nhật Bảng định tuyến.
- **Cập nhật Bảng Định tuyến của VPC Yêu cầu (`DemoVPC`):**
  - Truy cập **VPC console** -> **Route Tables**.
  - Chọn Bảng định tuyến mà bạn sử dụng cho các Subnet nơi các phiên bản cần giao tiếp với VPC bên kia đang chạy (ví dụ: `PublicRouteTable` nếu bạn kiểm tra từ Bastion Host ở Public Subnet).
  - Chuyển đến tab **Routes** -> **Edit routes**.
  - **Thêm một quy tắc định tuyến mới:**
    - **Destination (Đích):** Nhập **khối CIDR của VPC chấp nhận** (Default VPC). Bạn cần tìm CIDR của Default VPC trong phần "Your VPCs". Ví dụ: `172.31.0.0/16`.
    - **Target (Đích đến):** Chọn **Peering Connection** và chọn `demo-peering-connection` từ danh sách.
  - Nhấp **Save changes**.
- **Cập nhật Bảng Định tuyến của VPC Chấp nhận (Default VPC):**
  - Tìm Bảng định tuyến của Default VPC. Thường là "main" route table hoặc bảng được gán rõ ràng cho Subnet của phiên bản bạn dùng để kiểm tra.
  - Chuyển đến tab **Routes** -> **Edit routes**.
  - **Thêm một quy tắc định tuyến mới:**
    - **Destination (Đích):** Nhập **khối CIDR của VPC yêu cầu** (`DemoVPC`). Ví dụ: `10.0.0.0/16`.
    - **Target (Đích đến):** Chọn **Peering Connection** và chọn `demo-peering-connection` (cùng ID peering).
  - Nhấp **Save changes**.

**Bước 5: Xác minh kết nối lại**

- Quay lại phiên bản EC2 trong `DemoVPC` (Bastion Host).
- Lặp lại lệnh kiểm tra kết nối đến địa chỉ IP riêng tư của phiên bản trong Default VPC (ví dụ: `curl <Private-IP-cua-instance-o-DefaultVPC>:80` hoặc `ping <Private-IP-cua-instance-o-DefaultVPC>`).
- **Kết quả:** Kết nối sẽ **THÀNH CÔNG**. Điều này chứng tỏ VPC Peering đã hoạt động và các phiên bản ở hai VPC khác nhau giờ đây có thể giao tiếp với nhau bằng địa chỉ IP riêng tư thông qua kết nối peering an toàn của AWS.

**Tóm lại các điểm chính của Lab:**

- VPC mặc định cô lập về mạng.
- Tạo peering connection yêu cầu CIDR không trùng lặp.
- Kết nối peering phải được chấp nhận.
- **BẮT BUỘC phải cập nhật Bảng định tuyến ở CẢ HAI VPC** để lưu lượng đi qua kết nối peering.
- Sau khi cấu hình đúng, các phiên bản có thể giao tiếp bằng Private IP qua peering.
