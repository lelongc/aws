
## AWS Batch là gì?

**AWS Batch** là một dịch vụ **xử lý theo lô (batch processing) được quản lý hoàn toàn**, cho phép bạn chạy hàng trăm nghìn công việc tính toán (batch jobs) trên AWS một cách hiệu quả và ở mọi quy mô.

Vậy, một **"batch job"** là gì?

-   Đơn giản, đó là một công việc có **điểm bắt đầu** và **điểm kết thúc** rõ ràng (ví dụ: một tác vụ bắt đầu lúc 1 giờ sáng và kết thúc lúc 3 giờ sáng).
-   Nó khác với các công việc liên tục (continuous) hay streaming luôn chạy không có điểm dừng.

---
## AWS Batch hoạt động như thế nào? ⚙️

Cơ chế của AWS Batch rất thông minh và giúp bạn "nhàn" hơn rất nhiều:

1.  **Bạn định nghĩa công việc:** Một batch job được định nghĩa dưới dạng một **Docker image** và một **task definition** (tương tự như khi bạn dùng Amazon ECS). Về cơ bản, bất cứ thứ gì có thể chạy trên ECS đều có thể chạy trên AWS Batch.
2.  **Bạn gửi công việc vào hàng đợi (Queue):** Bạn chỉ cần gửi hoặc lên lịch cho các batch job của mình vào một hàng đợi.
3.  **Batch lo phần còn lại:**
    -   AWS Batch sẽ **tự động và linh hoạt khởi chạy** các **EC2 instance** hoặc **Spot Instances**.
    -   Nó sẽ **cung cấp đúng lượng tài nguyên tính toán (compute) và bộ nhớ (memory)** cần thiết để xử lý các công việc trong hàng đợi của bạn.
    -   Khi công việc hoàn tất, Batch cũng sẽ tự động thu hồi các tài nguyên đó.

**Lợi ích chính** là bạn không cần phải quản lý hạ tầng bên dưới. Bạn chỉ cần tập trung vào công việc của mình, còn việc tối ưu chi phí và mở rộng quy mô đã có Batch lo!

---
## So sánh "Kinh điển": AWS Batch vs. AWS Lambda 🆚

Đây là phần rất quan trọng cho kỳ thi, vì hai dịch vụ này có vẻ tương tự nhưng lại phục vụ các mục đích khác nhau.

| Tiêu chí | AWS Batch | AWS Lambda |
| :--- | :--- | :--- |
| ⏰ **Thời gian chạy** | **Không giới hạn**. Công việc có thể chạy trong nhiều giờ hoặc nhiều ngày vì nó chạy trên EC2. | **Bị giới hạn** (hiện tại là 15 phút). |
| 📦 **Runtime** | **Bất kỳ runtime nào** bạn muốn, miễn là bạn đóng gói nó dưới dạng một **Docker image**. | Chỉ hỗ trợ các **ngôn ngữ lập trình được định sẵn**. |
| 💾 **Lưu trữ (Disk Space)** | **Dung lượng lớn**, vì bạn có thể sử dụng lưu trữ của EC2 như **EBS volume** hoặc **Instance Store**. | **Dung lượng tạm thời có giới hạn** ( `/tmp` ). |
| 🏗️ **Mô hình** | Là một **dịch vụ được quản lý (managed service)**, nhưng **không phải serverless**. Nó vẫn dựa trên các EC2 instance được tạo ra (dù bạn không trực tiếp quản lý chúng). | Là dịch vụ **Serverless** đúng nghĩa. |

---
## "Chốt hạ" cho Kỳ thi 📝

-   Hãy nghĩ đến **AWS Batch** khi bạn cần thực hiện các công việc **xử lý theo lô, chạy trong thời gian dài, và đòi hỏi nhiều tài nguyên**.
-   Batch dựa trên **Docker** và **ECS**, cho phép linh hoạt tối đa về môi trường chạy.
-   Nắm vững sự khác biệt cốt lõi giữa **Batch** và **Lambda** về **thời gian chạy, runtime, dung lượng lưu trữ, và mô hình serverless**.

