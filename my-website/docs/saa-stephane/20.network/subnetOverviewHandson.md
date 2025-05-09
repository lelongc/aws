**Subnet (Mạng con) là gì?**

- Subnet là một **phân dải (sub-range)** của các địa chỉ IPv4 (và tùy chọn IPv6) nằm trong khối CIDR lớn hơn của VPC của bạn.
- Mỗi Subnet phải nằm trọn vẹn trong **một Availability Zone (AZ)** duy nhất và không thể trải rộng qua nhiều AZ.

**Các địa chỉ IP được AWS dành riêng trong mỗi Subnet:**

- Trong mỗi khối CIDR của Subnet, AWS tự động dành riêng **5 địa chỉ IP đầu tiên và địa chỉ IP cuối cùng**. Các địa chỉ này không khả dụng để bạn gán cho các tài nguyên của mình (ví dụ: phiên bản EC2).
- Lý do các địa chỉ này được dành riêng (ví dụ với subnet `10.0.0.0/24`):
  - **Địa chỉ IP đầu tiên (.0):** Địa chỉ mạng (Network address) - đại diện cho toàn bộ mạng con.
  - **Địa chỉ IP thứ hai (.1):** Được AWS dành riêng cho **VPC Router** - cổng mặc định (default gateway) cho subnet.
  - **Địa chỉ IP thứ ba (.2):** Được AWS dành riêng cho việc ánh xạ đến **Amazon provided DNS** - máy chủ DNS của AWS.
  - **Địa chỉ IP thứ tư (.3):** Được AWS dành riêng cho mục đích sử dụng trong tương lai.
  - **Địa chỉ IP cuối cùng (.255):** Địa chỉ broadcast mạng (Network broadcast address). AWS không hỗ trợ broadcast trong VPC, vì vậy địa chỉ này được dành riêng.

**Gợi ý quan trọng cho bài thi (Tính toán kích thước Subnet):**

- Khi tính toán số lượng địa chỉ IP thực tế cần thiết cho các phiên bản EC2 hoặc tài nguyên khác trong một subnet, bạn phải luôn **trừ đi 5 địa chỉ IP dành riêng này**.
- **Ví dụ:**
  - Nếu bạn cần 29 địa chỉ IP khả dụng cho các phiên bản EC2 trong một subnet.
  - Một subnet có kích thước `/27` có tổng cộng $2^{(32-27)} = 32$ địa chỉ IP. Nếu trừ đi 5 địa chỉ dành riêng, bạn chỉ còn $32 - 5 = 27$ địa chỉ khả dụng. $27 < 29$, không đủ.
  - Bạn cần chọn kích thước subnet lớn hơn, ví dụ `/26`. Subnet `/26` có tổng cộng $2^{(32-26)} = 64$ địa chỉ IP. Trừ đi 5 địa chỉ dành riêng, bạn còn $64 - 5 = 59$ địa chỉ khả dụng. $59 > 29$, đủ.
- **Quy tắc:** Số IP khả dụng = (Tổng số IP trong CIDR của Subnet) - 5.

**Các bước tạo Subnet (Ví dụ tạo 4 Subnet trong một Custom VPC):**

1.  **Truy cập AWS Console:** Đến dịch vụ VPC.
2.  **Chọn VPC:** Lọc danh sách Subnet theo VPC tùy chỉnh bạn muốn thêm Subnet vào (ví dụ: "DemoVPC") để giao diện dễ nhìn hơn.
3.  **Nhấp "Create Subnet"** (Tạo Subnet).
4.  **Thiết lập Subnet:**
    - **Chọn VPC:** Chọn VPC bạn muốn tạo Subnet trong đó.
    - **Đặt tên Subnet:** Đặt tên có ý nghĩa (ví dụ: `PublicSubnetA`, `PrivateSubnetB`).
    - **Chọn Availability Zone (AZ):** Chọn một AZ cụ thể cho Subnet này. Việc tạo nhiều Subnet ở các AZ khác nhau là cần thiết cho **tính sẵn sàng cao (High Availability)**.
    - **Chọn Khối CIDR IPv4:** Chỉ định một dải địa chỉ IP cho Subnet này. Khối CIDR này phải nằm trong dải CIDR của VPC và **không được trùng lặp** với bất kỳ Subnet nào khác trong VPC đó.
      - **Đối với Public Subnet (ví dụ):** Có thể chọn kích thước nhỏ hơn như `/24` (256 địa chỉ). Thường dùng cho các tài nguyên hướng ra ngoài Internet như Load Balancer, máy chủ web công cộng.
      - **Đối với Private Subnet (ví dụ):** Có thể chọn kích thước lớn hơn như `/20` (4096 địa chỉ) nếu bạn dự kiến có nhiều tài nguyên nội bộ (như máy chủ ứng dụng, cơ sở dữ liệu) trong Subnet này.
    - **Ví dụ các khối CIDR được chọn (trong VPC có CIDR `10.0.0.0/16`):**
      - `PublicSubnetA`: `10.0.0.0/24` (trong AZ eu-central-1a) -> 256 IP
      - `PublicSubnetB`: `10.0.1.0/24` (trong AZ eu-central-1b) -> 256 IP (dải tiếp theo)
      - `PrivateSubnetA`: `10.0.16.0/20` (trong AZ eu-central-1a) -> 4096 IP (dải lớn hơn, bắt đầu ở octet thứ 3 khác biệt để tránh trùng lặp)
      - `PrivateSubnetB`: `10.0.32.0/20` (trong AZ eu-central-1b) -> 4096 IP (dải tiếp theo)
5.  **Tạo nhiều Subnet:** Nhấp vào tùy chọn để thêm Subnet khác và lặp lại bước 4 cho đến khi tạo đủ số lượng và loại Subnet mong muốn (ví dụ: 2 Public, 2 Private ở 2 AZ khác nhau).
6.  **Hoàn tất:** Nhấp "Create Subnets" để tạo các Subnet.

**Lưu ý sau khi tạo:**

- Sau khi tạo, bạn sẽ thấy số lượng địa chỉ IP khả dụng trong mỗi Subnet là **tổng số IP trong CIDR trừ đi 5** (ví dụ: `/24` còn 251, `/20` còn 4091).
- **Việc tạo Subnet không tự động biến nó thành "Public" hay "Private"**: Ở bước này, tất cả các Subnet trông giống nhau về mặt cấu hình (ngoại trừ tùy chọn Auto-assign public IPv4, nhưng đó không phải yếu tố quyết định). Điều làm cho một Subnet trở thành Public hay Private phụ thuộc vào **Bảng Định tuyến (Route Table)** mà nó liên kết đến và việc Bảng định tuyến đó có đường dẫn (route) ra Internet Gateway hay không.

- **Việc tạo Subnet không tự động biến nó thành "Public" hay "Private"**: Ở bước này, tất cả các Subnet trông giống nhau về mặt cấu hình (ngoại trừ tùy chọn Auto-assign public IPv4, nhưng đó không phải yếu tố quyết định). Điều làm cho một Subnet trở thành Public hay Private phụ thuộc vào **Bảng Định tuyến (Route Table)** mà nó liên kết đến và việc Bảng định tuyến đó có đường dẫn (route) ra Internet Gateway hay không.
  Tóm lại, việc tạo Subnet là phân chia không gian địa chỉ IP của VPC thành các mạng nhỏ hơn trong từng AZ, đồng thời phải lưu ý đến 5 địa chỉ IP dành riêng và tính toán kích thước subnet phù hợp với nhu cầu tài nguyên của bạn. Việc phân loại Public/Private sẽ được cấu hình ở bước cấu hình route table
