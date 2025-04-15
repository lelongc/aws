### Chi tiết kiến thức về SQS, SNS và Kinesis

---

#### **1. Amazon SQS (Simple Queue Service)**
Amazon SQS là một dịch vụ hàng đợi thông điệp được quản lý hoàn toàn. Dưới đây là các đặc điểm chính:

- **Mô hình hoạt động**: 
  - Người tiêu thụ (consumer) **kéo dữ liệu** từ hàng đợi (queue).
  - Sau khi xử lý thông điệp, consumer phải xóa thông điệp khỏi hàng đợi để đảm bảo không thông điệp nào được xử lý lại.

- **Đặc điểm nổi bật**:
  - **Đồng thời**: Hỗ trợ nhiều consumer làm việc cùng lúc trên cùng một hàng đợi.
  - **Không cần cấu hình trước throughput**: Dịch vụ tự động mở rộng quy mô (scaling) để xử lý hàng trăm ngàn thông điệp.
  - **Thứ tự thông điệp**:
    - Thứ tự không được đảm bảo mặc định.
    - Nếu yêu cầu **FIFO** (First-In-First-Out), bạn cần bật FIFO queues.
  - **Delay messages**: Cho phép trì hoãn thông điệp, ví dụ, thông điệp chỉ xuất hiện sau 30 giây kể từ khi được gửi.

---

#### **2. Amazon SNS (Simple Notification Service)**
Amazon SNS là dịch vụ thông báo sử dụng mô hình pub-sub (publish-subscribe). Dưới đây là các điểm nổi bật:

- **Mô hình hoạt động**:
  - Publisher (nhà xuất bản) gửi thông điệp đến một **chủ đề (topic)**.
  - Các subscriber (người đăng ký) nhận bản sao của thông điệp.
  
- **Đặc điểm nổi bật**:
  - **Số lượng lớn subscriber**: Hỗ trợ lên tới 12.5 triệu subscriber cho mỗi chủ đề.
  - **Không lưu trữ thông điệp**: 
    - Thông điệp không được lưu trữ lâu dài, do đó, nếu không được giao, có khả năng mất mát.
  - **Kết hợp với SQS**: 
    - Có thể kết hợp SNS với SQS để tạo kiến trúc fan-out.
    - Hỗ trợ cả SNS FIFO topic kết hợp với SQS FIFO queue.
  - **Khả năng mở rộng**: Hỗ trợ hàng trăm ngàn topic mà không cần cấu hình trước.

---

#### **3. Amazon Kinesis**
Amazon Kinesis là một dịch vụ xử lý dữ liệu lớn theo thời gian thực. Nó phù hợp cho các ứng dụng phân tích big data và ETL.

- **Mô hình hoạt động**:
  - **Standard mode**:
    - Consumer **kéo dữ liệu** từ Kinesis với tốc độ **2 MB/giây mỗi shard**.
  - **Enhanced fan-out mode**:
    - Kinesis **đẩy dữ liệu** đến consumer.
    - Mỗi consumer có thể nhận **2 MB/giây mỗi shard** độc lập.
  
- **Đặc điểm nổi bật**:
  - **Lưu trữ dữ liệu (data persistence)**:
    - Dữ liệu được lưu trữ từ 1 đến 365 ngày (tùy cấu hình).
    - Cho phép replay (phát lại) dữ liệu trong khoảng thời gian lưu trữ.
  - **Thứ tự thông điệp**: Đảm bảo thứ tự ở cấp độ shard.
  - **Quản lý throughput**:
    - **Provisioned mode**: Người dùng tự cấu hình số lượng shard.
    - **On-demand mode**: Kinesis tự động điều chỉnh số lượng shard dựa trên lưu lượng.
  - **Dữ liệu hết hạn (data expiry)**: Dữ liệu sẽ bị xóa sau khoảng thời gian lưu trữ được định cấu hình.

---

### **Tóm tắt so sánh SQS, SNS và Kinesis**

| **Đặc điểm**          | **SQS**                                   | **SNS**                                | **Kinesis**                               |
|-----------------------|-------------------------------------------|----------------------------------------|------------------------------------------|
| **Mô hình hoạt động** | Consumer kéo thông điệp từ hàng đợi       | Pub-Sub (Push tới subscriber)         | Consumer kéo dữ liệu hoặc nhận push      |
| **Thứ tự thông điệp** | FIFO (nếu bật) hoặc không đảm bảo         | Không đảm bảo                          | Đảm bảo thứ tự ở cấp shard               |
| **Lưu trữ dữ liệu**   | Lưu tạm thời (consumer phải xóa)          | Không lưu trữ                          | Lưu từ 1-365 ngày                        |
| **Mở rộng quy mô**    | Tự động mở rộng                          | Tự động mở rộng                        | Người dùng phải cấu hình shard hoặc dùng on-demand |
| **Ứng dụng chính**    | Hàng đợi tin nhắn                        | Thông báo và phân phối tin nhắn        | Xử lý dữ liệu lớn theo thời gian thực    |

Hy vọng kiến thức chi tiết trên hữu ích cho bạn!