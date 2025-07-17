**AWS Database Migration Service (DMS)** cung cấp nhiều tùy chọn để bạn di chuyển cơ sở dữ liệu. Dưới đây là tổng quan các bước và lựa chọn chính khi sử dụng DMS, rất hữu ích cho việc hiểu rõ dịch vụ này.

---

## Các bước và Tùy chọn chính trong AWS DMS

Giao diện DMS được thiết kế để hướng dẫn bạn qua quy trình di chuyển, bao gồm các giai đoạn chính:

### 1. Khám phá và Đánh giá (Discover and Assess) 🧐

- **Công cụ:** Sử dụng **AWS DMS Fleet Advisor**.
- **Mục đích:**
  - Tự động quét và kiểm kê (inventory) tất cả các cơ sở dữ liệu on-premises của bạn.
  - Xác định các lộ trình di chuyển tiềm năng và phù hợp nhất.
- **Lợi ích:** Cung cấp kết quả trong vài giờ, giúp tiết kiệm đáng kể thời gian lập kế hoạch mà không cần dùng công cụ của bên thứ ba hay thuê chuyên gia di chuyển.

### 2. Chuyển đổi (Convert) 🔄

- **Công cụ:** Sử dụng **DMS Schema Conversion Tool (SCT)**.
- **Mục đích:** Chuyển đổi schema (cấu trúc) của cơ sở dữ liệu từ một công nghệ CSDL này sang một công nghệ CSDL khác (ví dụ: từ Oracle sang PostgreSQL).
- **Lợi ích:** Giúp bạn hình dung được các loại chuyển đổi cần thiết và mức độ phức tạp trước khi thực hiện di chuyển dữ liệu.

### 3. Các Tùy chọn Di chuyển Dữ liệu (Migration Options) 🚚

Đây là giai đoạn thực sự di chuyển dữ liệu của bạn. DMS cung cấp các loại hình di chuyển sau:

- **Homogenous Data Migration (Di chuyển CSDL Đồng nhất):**
  - **Khi nào:** Di chuyển giữa các CSDL có cùng công nghệ (ví dụ: Oracle sang Oracle, MySQL sang MySQL).
  - **Ưu điểm:** Thường nhanh hơn vì có thể tận dụng các công cụ gốc (native database tools) của CSDL đó.
- **Heterogeneous Migrations (Di chuyển CSDL Không Đồng nhất):**
  - **Khi nào:** Di chuyển giữa các CSDL có công nghệ khác nhau (ví dụ: Oracle sang Aurora, SQL Server sang PostgreSQL).
  - **Các lựa chọn thực thi:**
    - **Serverless Replication (Sao chép Không Máy chủ):**
      - Bạn không cần quản lý bất kỳ tài nguyên hạ tầng nào (như EC2 instance) cho việc sao chép.
      - **Ưu điểm:** Dễ dàng hơn, ít quản lý hơn.
      - **Nhược điểm:** Không hỗ trợ tất cả các loại CSDL. Nên thử lựa chọn này trước, nếu không được hỗ trợ thì chuyển sang Instance-based.
    - **Instance-based Migration (Di chuyển Dựa trên Instance):**
      - DMS sẽ sử dụng một EC2 instance (gọi là **Replication Instance**) để thực hiện tác vụ di chuyển. Bạn không trực tiếp quản lý OS của instance này, nhưng bạn cần cấu hình kích thước và các thiết lập cho nó.

---

## Cấu hình Replication Instance (Cho Instance-based Migration)

Khi chọn di chuyển dựa trên instance, bạn cần tạo và cấu hình một **Replication Instance**:

- **Name & Description:** Đặt tên và mô tả cho instance.
- **Instance Configuration:**
  - **Instance class:** Chọn kích thước instance (ví dụ: `t3.micro` đến các instance rất lớn) dựa trên lượng dữ liệu cần di chuyển và tải công việc.
  - **Engine version:** Chọn phiên bản DMS. Tham khảo release notes để biết các cập nhật mới nhất.
  - **High Availability (Tính sẵn sàng cao):**
    - **Multi-AZ:** Nên chọn cho các tác vụ di chuyển production để đảm bảo khả năng phục hồi nếu một AZ gặp sự cố.
    - **Single-AZ:** Có thể đủ cho môi trường dev/test. (Lưu ý: Một số instance class lớn có thể yêu cầu Multi-AZ).
  - **Allocated storage:** Dung lượng lưu trữ cho instance.
- **Connectivity and Security:**
  - **VPC, Subnet group:** Chọn mạng và subnet cho instance.
  - **Publicly accessible:** Xác định instance có thể truy cập công khai hay không.
- **Advanced settings & Maintenance:** Cấu hình nâng cao và cài đặt bảo trì cho OS của instance.

Sau khi cấu hình xong, bạn sẽ tạo Replication Instance.

---

## Tạo Endpoints 📍

**Endpoints** định nghĩa nơi CSDL nguồn và đích của bạn được đặt.

- **Loại Endpoint:**
  - **Source endpoint (Điểm cuối nguồn):** Nơi DMS sẽ đọc dữ liệu.
  - **Target endpoint (Điểm cuối đích):** Nơi DMS sẽ ghi dữ liệu.
- **Cấu hình:**
  - **RDS database:** Nếu CSDL là một RDS instance, có tùy chọn chọn trực tiếp dễ dàng.
  - **Endpoint identifier:** Tên định danh cho endpoint.
  - **Source/Target engine type:** Chọn loại CSDL (Oracle, MySQL, PostgreSQL, S3, Kafka, v.v.).
  - **Endpoint settings:** Cung cấp thông tin kết nối (server name, port, username, password, database name). Có thể dùng wizard hướng dẫn hoặc cung cấp dưới dạng JSON.
- **Test connection:** DMS cho phép bạn kiểm tra kết nối từ Replication Instance đến CSDL nguồn/đích.

---

## Tạo Database Migration Tasks (Tác vụ Di chuyển CSDL) 📝

Sau khi có Replication Instance và các Endpoints, bạn sẽ tạo một **Database Migration Task**:

- **Cấu hình Task:**
  - **Replication instance:** Chọn Replication Instance bạn đã tạo.
  - **Source database endpoint:** Chọn điểm cuối nguồn.
  - **Target database endpoint:** Chọn điểm cuối đích.
  - **Migration type (Loại di chuyển):**
    - **Migrate existing data (Di chuyển dữ liệu hiện có):** Chỉ tải dữ liệu hiện tại một lần (full load).
    - **Migrate existing data and replicate ongoing changes (Di chuyển dữ liệu hiện có và sao chép các thay đổi đang diễn ra):** Thực hiện full load, sau đó tiếp tục sao chép các thay đổi (Change Data Capture - CDC) để duy trì đồng bộ. Đây là lựa chọn phổ biến cho di chuyển với thời gian ngừng hoạt động tối thiểu.
    - **Replicate data changes only (Chỉ sao chép các thay đổi dữ liệu):** Chỉ thực hiện CDC (giả sử dữ liệu ban đầu đã được tải bằng cách khác).
  - **Task settings:** Nhiều tùy chọn cấu hình chi tiết, có thể dùng wizard hoặc JSON editor.
  - **Table mappings:** Cho phép bạn chọn bảng nào cần di chuyển, đổi tên bảng, thêm các cột chuyển đổi, v.v.
- **Assessment & Configuration:** DMS có thể thực hiện đánh giá trước khi chạy task.

Sau khi tạo, task sẽ thực hiện việc di chuyển dữ liệu theo cấu hình của bạn.

---

## Xu hướng và Các Tính năng Khác

- **Serverless Replication:** DMS đang phát triển theo hướng này, cho phép di chuyển trực tiếp từ CSDL này sang CSDL khác mà không cần quản lý Replication Instance.
- **Schema Conversion & Fleet Advisor:** Tích hợp sâu hơn để hỗ trợ chuyển đổi schema và đưa ra các khuyến nghị từ Fleet Advisor.
- **Homogenous Data Migrations:** Tận dụng các công cụ CSDL gốc để tăng tốc độ di chuyển đồng nhất.

**Tóm lại:** Quy trình cơ bản khi dùng DMS (đặc biệt là instance-based) là:

1. **(Tùy chọn)** Sử dụng **Fleet Advisor** để đánh giá.
2. **(Tùy chọn, nếu cần)** Sử dụng **SCT** để chuyển đổi schema.
3. Tạo **Replication Instance**.
4. Tạo **Source và Target Endpoints**.
5. Tạo và chạy **Database Migration Task**.
