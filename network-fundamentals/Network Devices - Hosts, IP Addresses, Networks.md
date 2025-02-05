---

#### **2. Host (Thiết bị gửi/nhận dữ liệu)**
- **Định nghĩa**: 
  - Host là bất kỳ thiết bị nào gửi hoặc nhận dữ liệu qua mạng.
  - Ví dụ: máy tính, laptop, điện thoại, máy in, máy chủ, tài nguyên đám mây (cloud servers), thiết bị IoT (Internet of Things) như TV thông minh, loa đồng bộ, đồng hồ thông minh, tủ lạnh thông minh, v.v.
  
- **Phân loại Host**:
  - **Clients**: Thiết bị khởi tạo yêu cầu (ví dụ: yêu cầu trang web từ server).
  - **Servers**: Thiết bị phản hồi yêu cầu (ví dụ: gửi trang web đến client).

- **Lưu ý**:
  - Thuật ngữ "client" và "server" mang tính tương đối, phụ thuộc vào bối cảnh giao tiếp. Một thiết bị có thể vừa là client, vừa là server trong các trường hợp khác nhau.

- **Server**:
  - Bản chất chỉ là một máy tính có phần mềm được cài đặt để xử lý các yêu cầu cụ thể (ví dụ: server web, server file).
  - Mọi thiết bị có thể trở thành server nếu được cài phần mềm phù hợp.

---

#### **3. Địa chỉ IP (IP Address)**

- **Định nghĩa**:

  - Địa chỉ IP là danh tính của mỗi host trên mạng.
  - Mỗi host phải có địa chỉ IP để giao tiếp trên Internet, giống như số điện thoại để gọi điện hoặc địa chỉ nhà để gửi thư.

- **Cấu trúc địa chỉ IP**:

  - Địa chỉ IP gồm 32 bit, chia thành 4 octet, mỗi octet là một số từ 0 đến 255.
  - Các bit nhị phân được chuyển đổi thành số thập phân để dễ đọc hơn.
  - Ví dụ: 192.168.1.1

- **Gán địa chỉ IP theo thứ bậc**:

  - Địa chỉ IP thường được tổ chức theo phân cấp:
    - **Công ty**: Sở hữu một phạm vi địa chỉ IP cụ thể (ví dụ: 10.x.x.x thuộc về công ty Acme).
    - **Văn phòng**: Mỗi văn phòng của công ty có một dải địa chỉ riêng (ví dụ: New York: 10.20.x.x, London: 10.30.x.x).
    - **Nhóm trong văn phòng**: Chia nhỏ địa chỉ IP cho các đội nhóm (ví dụ: đội Sales ở New York: 10.20.55.x).

- **Ý nghĩa**:
  - Địa chỉ IP giúp xác định chính xác vị trí của một thiết bị trên mạng, từ công ty, văn phòng đến đội nhóm cụ thể.

---

#### **4. Cách giao tiếp sử dụng địa chỉ IP**

- **Gửi yêu cầu**:
  - Host gửi gói tin (packet) đi kèm với địa chỉ IP nguồn và đích.
  - Ví dụ:
    - IP nguồn: Địa chỉ của client.
    - IP đích: Địa chỉ của server.
- **Phản hồi yêu cầu**:
  - Server gửi gói tin phản hồi kèm địa chỉ IP nguồn (server) và địa chỉ IP đích (client).



#### **1. Phân cấp địa chỉ IP và Subnetting**
- **Phân cấp địa chỉ IP**:
  - Địa chỉ IP được phân chia thành các cấp bậc nhằm tổ chức và quản lý hiệu quả.
  - Ví dụ:
    - Công ty Acme sở hữu không gian địa chỉ IP bắt đầu với `10.x.x.x`.
    - Các văn phòng (New York, London, Tokyo) được gán các dải con từ không gian này (ví dụ: `10.20.x.x` cho New York).
    - Các đội trong mỗi văn phòng được gán các phân đoạn nhỏ hơn (ví dụ: `10.20.55.x` cho đội Sales).

- **Subnetting**:
  - Quá trình chia nhỏ không gian địa chỉ IP thành các mạng con (subnet).
  - Giúp tổ chức hợp lý hơn, phù hợp với các yêu cầu kết nối khác nhau.

---

#### **2. Network (Mạng máy tính)**
- **Định nghĩa**:
  - Một Network là sự kết nối giữa hai hoặc nhiều host để chia sẻ dữ liệu.
  - Khi hai host được kết nối trực tiếp với nhau, một Network đã được tạo thành.
  
- **Ý nghĩa lịch sử**:
  - Trước khi có mạng, việc chia sẻ dữ liệu giữa hai thiết bị đòi hỏi phải sử dụng thiết bị lưu trữ vật lý (ví dụ: đĩa mềm, USB).
  - Mạng tự động hóa quá trình này, giúp các thiết bị giao tiếp và chia sẻ dữ liệu một cách nhanh chóng.

- **Nhóm mạng theo mục đích sử dụng**:
  - Các host có kết nối tương tự nhau được nhóm thành một mạng.
  - Ví dụ:
    - Mạng gia đình: Máy tính, laptop, điện thoại, máy in dùng để kết nối Internet.
    - Mạng tại quán cà phê: Các thiết bị khách hàng kết nối để truy cập Internet.
    - Mạng trường học: Tổ chức thành các mạng nhỏ hơn theo từng lớp học hoặc khu vực.

- **Subnets (Mạng con)**:
  - Mạng con là các mạng nhỏ nằm trong một mạng lớn hơn.
  - Ví dụ: 
    - Các phòng ban trong một văn phòng thuộc về mạng con của văn phòng đó.
    - Văn phòng thuộc về mạng con của toàn bộ công ty.

---

#### **3. Internet: Một tập hợp các mạng**
- **Định nghĩa**:
  - Internet là tập hợp của các mạng kết nối với nhau.
  - Ví dụ: Mạng của công ty kết nối với mạng trường học, mạng khách hàng cá nhân thông qua các nhà cung cấp dịch vụ Internet (ISP).

- **Kết nối giữa các mạng**:
  - Các mạng không kết nối trực tiếp với nhau trong mọi trường hợp.
  - Thay vào đó, chúng kết nối thông qua một nguồn trung tâm là **Internet**.

- **Vai trò của ISP**:
  - ISP (Internet Service Provider) chịu trách nhiệm duy trì và kết nối các mạng với nhau, giúp giao tiếp và truyền tải dữ liệu giữa chúng.

---

#### **4. Tóm tắt kiến thức**
- **Host**:
  - Là bất kỳ thiết bị nào gửi/nhận dữ liệu.
  - Được phân thành **clients** (khởi tạo yêu cầu) và **servers** (đáp ứng yêu cầu).

- **Địa chỉ IP**:
  - Danh tính của mỗi host trên mạng.
  - Có cấu trúc phân cấp để tổ chức hiệu quả, cho phép định vị thiết bị chính xác.

- **Mạng**:
  - Nhóm logic của các host có nhu cầu kết nối tương tự.
  - Các mạng có thể chứa các mạng con (subnet) và kết nối với nhau qua Internet.

---
]