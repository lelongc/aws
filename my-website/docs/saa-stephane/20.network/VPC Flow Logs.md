### Tổng quan về VPC Flow Logs

**VPC Flow Logs** là một tính năng của AWS cho phép bạn ghi lại (capture) thông tin về **luồng traffic IP** đi vào và đi ra khỏi các network interface (giao diện mạng) trong VPC của bạn. Đây là công cụ không thể thiếu để **giám sát và gỡ lỗi các vấn đề kết nối mạng**.

Bạn có thể bật Flow Logs ở 3 cấp độ:

1. **VPC level:** Ghi lại log cho tất cả các network interface trong toàn bộ VPC.
2. **Subnet level:** Ghi lại log cho tất cả các network interface trong một subnet cụ thể.
3. **Elastic Network Interface (ENI) level:** Ghi lại log cho một network interface duy nhất.

VPC Flow Logs có thể ghi lại thông tin từ cả các interface do AWS quản lý, ví dụ như:

- Elastic Load Balancers (ELB)
- Amazon RDS
- Amazon ElastiCache
- Amazon Redshift
- Amazon WorkSpaces
- NAT Gateway
- Transit Gateway

---

### Đích đến và Cấu trúc của Flow Logs

#### 1. Đích đến (Destination)

Log sau khi được thu thập có thể được đẩy đến 3 dịch vụ chính:

- **Amazon S3:** Lưu trữ lâu dài, phù hợp cho việc phân tích dữ liệu lớn (big data analytics) và tuân thủ (compliance).
- **Amazon CloudWatch Logs:** Phân tích và giám sát gần thời gian thực (near real-time), thiết lập cảnh báo (alarms).
- **Amazon Kinesis Data Firehose:** Dành cho việc streaming dữ liệu log đến các đích khác như Amazon S3, Redshift, hoặc các công cụ của bên thứ ba để phân tích chuyên sâu.

#### 2. Cấu trúc một bản ghi Log (Log Record Format)

Mỗi bản ghi trong Flow Log chứa các metadata về một gói tin mạng. Mặc dù bạn không cần nhớ chính xác từng trường, nhưng việc hiểu các trường quan trọng là **cực kỳ cần thiết** khi đi phỏng vấn và làm việc thực tế.

`version | account-id | interface-id | srcaddr | dstaddr | srcport | dstport | protocol | packets | bytes | start | end | action | log-status`

![1748437579816](image/VPCFlowLogs/1748437579816.png)

Các trường **quan trọng nhất** cần nắm:

- `srcaddr` & `dstaddr`: Địa chỉ IP nguồn và đích. Giúp xác định các IP có vấn đề (ví dụ: IP đang cố gắng tấn công hoặc bị từ chối liên tục).
- `srcport` & `dstport`: Cổng nguồn và đích. Giúp xác định các port đang gặp sự cố.
- `protocol`: Giao thức mạng (ví dụ: `6` cho TCP, `17` cho UDP).
- `action`: **ACCEPT** (Chấp nhận) hoặc **REJECT** (Từ chối). Đây là trường **then chốt** để gỡ lỗi. Nó cho biết liệu traffic có được Security Group hoặc Network ACL cho phép hay không.
- `log-status`: Trạng thái của việc ghi log (OK, NODATA, SKIPDATA).

---

### Ứng dụng thực tế: Gỡ lỗi Security Group (SG) và Network ACL (NACL) 🕵️‍♂️

Đây là một kịch bản kinh điển trong các cuộc phỏng vấn DevOps. Flow Logs là công cụ chính để phân biệt vấn đề nằm ở SG hay NACL. Nguyên tắc cốt lõi cần nhớ:

- **Security Groups (SG) là stateful:** Nếu traffic đi vào (inbound) được cho phép, traffic trả về (outbound) tương ứng sẽ tự động được cho phép, và ngược lại.
- **Network ACLs (NACL) là stateless:** Bạn phải định nghĩa luật cho cả chiều đi vào (inbound) và chiều đi ra (outbound) một cách riêng biệt.

Dựa vào trường `action` trong Flow Logs, ta có thể suy luận:

![1748437859665](image/VPCFlowLogs/1748437859665.png)

#### Kịch bản 1: Traffic đi vào (Inbound Traffic)

- **`action` = REJECT:** Vấn đề có thể do **NACL hoặc SG**. Cả hai đều có thể chặn traffic đi vào.
- **`action` = ACCEPT `(cho chiều vào) nhưng lại có`REJECT` cho chiều trả về (outbound):** Vấn đề **chắc chắn là do NACL**.
  - **Giải thích:** Vì SG là stateful, nếu nó đã `ACCEPT` chiều vào thì nó sẽ tự động cho phép chiều trả về. Việc chiều trả về bị `REJECT` chỉ có thể xảy ra khi luật outbound của NACL (là stateless) đã chặn nó.

#### Kịch bản 2: Traffic đi ra (Outbound Traffic)

- **`action` = REJECT:** Vấn đề có thể do **NACL hoặc SG**. Cả hai đều có thể chặn traffic đi ra.
- **`action` = ACCEPT `(cho chiều ra) nhưng lại có`REJECT` cho chiều trả về (inbound):** Vấn đề **chắc chắn là do NACL**.
  - **Giải thích:** Tương tự, SG là stateful nên nếu nó đã `ACCEPT` chiều ra thì sẽ cho phép chiều trả về. Việc chiều trả về bị `REJECT` chỉ có thể do luật inbound của NACL chặn.

> **Mẹo phỏng vấn:** Khi được hỏi cách debug một EC2 instance không thể kết nối ra ngoài hoặc không thể truy cập từ bên ngoài, hãy trả lời rằng bạn sẽ bắt đầu bằng việc kiểm tra VPC Flow Logs, tập trung vào trường `action` để xác định traffic bị `REJECT` ở đâu, sau đó áp dụng logic stateful/stateless để khoanh vùng vấn đề là SG hay NACL.

---

### Các Kiến Trúc Phân Tích Flow Logs 🚀

Việc chỉ thu thập log là chưa đủ. Là một DevOps Engineer, bạn cần biết cách phân tích chúng để rút ra thông tin hữu ích.

![1748438875717](image/VPCFlowLogs/1748438875717.png)

#### 1. Kiến trúc CloudWatch: Giám sát & Cảnh báo thời gian thực

- **Luồng:** VPC Flow Logs → CloudWatch Logs.
- **Phân tích:**
  - **CloudWatch Logs Insights:** Sử dụng ngôn ngữ truy vấn giống SQL để tìm kiếm và phân tích log một cách nhanh chóng. Ví dụ: tìm các IP bị từ chối nhiều nhất.
  - **CloudWatch Contributor Insights:** Tự động tìm ra các "tác nhân" đóng góp nhiều nhất vào traffic mạng (ví dụ: top 10 IP gửi nhiều dữ liệu nhất).
  - **Metric Filters & Alarms:** Tạo bộ lọc để đếm số lần xuất hiện của một mẫu cụ thể (ví dụ: traffic SSH/RDP bất thường) và chuyển nó thành một CloudWatch Metric. Sau đó, đặt CloudWatch Alarm trên metric này để gửi thông báo qua **SNS** (email, SMS, aLambda,...) khi có dấu hiệu đáng ngờ.

#### 2. Kiến trúc S3 + Athena: Phân tích SQL & Trực quan hóa

- **Luồng:** VPC Flow Logs → S3 Bucket → Amazon Athena → Amazon QuickSight.
- **Phân tích:**
  - **S3:** Lưu trữ log gốc một cách bền vững và chi phí thấp.
  - **Amazon Athena:** Dịch vụ truy vấn không server (serverless), cho phép bạn chạy các câu lệnh **SQL** tiêu chuẩn trực tiếp trên các file log lưu trong S3. Rất mạnh mẽ cho việc phân tích ad-hoc, điều tra các sự cố bảo mật trong quá khứ.
  - **Amazon QuickSight:** Dịch vụ BI (Business Intelligence) giúp trực quan hóa dữ liệu từ Athena thành các biểu đồ, dashboard đẹp mắt, dễ hiểu. Ví dụ: vẽ bản đồ các IP tấn công, biểu đồ traffic theo thời gian.

---

### Mục tiêu của bài thực hành

Bài thực hành này hướng dẫn bạn cách thiết lập và sử dụng VPC Flow Logs một cách toàn diện, bao gồm:

1.  **Tạo Flow Log** để gửi dữ liệu đến **Amazon S3**.
2.  **Tạo Flow Log** để gửi dữ liệu đến **Amazon CloudWatch Logs**.
3.  **Phân tích log** trong CloudWatch để giám sát gần thời gian thực.
4.  **Sử dụng Amazon Athena** để thực hiện các truy vấn SQL phức tạp trên dữ liệu log lưu trữ tại S3.

---

### Phần 1: Cấu hình Flow Log đẩy dữ liệu vào Amazon S3

Đây là kịch bản phổ biến để lưu trữ log lâu dài và phân tích dữ liệu lớn.

#### Các bước thực hiện:

1.  **Điều hướng:** Đi đến `VPC Dashboard` > `Your VPCs` > chọn VPC của bạn > tab `Flow Logs` > `Create flow log`.
2.  **Điền thông tin cấu hình:**
    - **Name:** Đặt một tên dễ nhận biết (ví dụ: `DemoS3FlowLog`).
    - **Filter (Bộ lọc):**
      - `Accept`: Chỉ ghi log traffic được phép.
      - `Reject`: Chỉ ghi log traffic bị từ chối. **Rất hữu ích khi bạn đang debug tại sao một kết nối bị lỗi.**
      - `All`: Ghi lại tất cả.
    - **Maximum aggregation interval (Khoảng thời gian tổng hợp tối đa):**
      - `10 minutes` (Mặc định & Khuyến nghị): Log được tổng hợp và ghi vào file mỗi 10 phút. Giúp giảm số lượng file và chi phí.
      - `1 minute`: Log được ghi mỗi phút. Giúp dữ liệu có nhanh hơn nhưng sẽ tạo ra **nhiều file hơn và chi phí cao hơn**. Trong demo, chọn 1 phút để thấy kết quả ngay lập tức.
    - **Destination (Đích đến):** Chọn `Send to an Amazon S3 bucket`.
3.  **Cung cấp S3 Bucket ARN:**
    - Bạn cần tạo một S3 bucket trước để làm nơi chứa log.
    - Vào S3, tạo bucket (ví dụ: `demo-stephane-vpc-flow-logs-v2`).
    - Trong bucket vừa tạo, vào tab `Properties` và sao chép giá trị **Bucket ARN**.
    - Dán ARN này vào ô cấu hình Flow Log.
4.  **Quan trọng: Bucket Policy tự động**
    - Khi bạn hoàn tất, AWS sẽ hiển thị một thông báo rằng một **resource-based policy** (chính là Bucket Policy) sẽ được tự động tạo và gắn vào S3 bucket của bạn.
    - **Kiến thức cần nhớ:** Policy này cấp quyền cho dịch vụ `vpc-flow-logs.amazonaws.com` thực hiện hành động `PutObject` vào bucket của bạn. Bạn không cần phải tự tay cấu hình, nhưng phải hiểu cơ chế này.
5.  **Log record format:** Để định dạng mặc định của AWS.
6.  **Hoàn tất:** Nhấn `Create flow log`.

Sau vài phút, bạn có thể vào S3 Bucket và sẽ thấy một cấu trúc thư mục được tạo ra: `AWSLogs/[Account-ID]/vpcflowlogs/[Region]/[Năm]/[Tháng]/[Ngày]/...`

---

### Phần 2: Cấu hình Flow Log đẩy dữ liệu vào CloudWatch Logs

Kịch bản này dùng để giám sát gần thời gian thực (near real-time) và thiết lập cảnh báo.

#### Các bước thực hiện:

1.  Tạo một Flow Log mới như trên.
2.  **Điền thông tin cấu hình:**
    - **Name:** `DemoFlowLog-CloudWatchLogs`.
    - **Filter:** `All`.
    - **Interval:** `1 minute`.
    - **Destination:** Chọn `Send to CloudWatch Logs`.
3.  **Thiết lập Permissions (Quyền hạn) - Bước quan trọng nhất:**
    - Để dịch vụ VPC Flow Logs có thể ghi dữ liệu vào CloudWatch, bạn cần cung cấp 2 thứ: **IAM Role** và **Log Group**.
    - **a. Tạo Log Group:**
      - Mở CloudWatch > `Logs` > `Log groups` > `Create log group`.
      - Đặt tên (ví dụ: `VPCFlowLogs`).
      - **Best Practice:** Đặt `Retention setting` (Thời gian lưu trữ), ví dụ `1 day`, để tự động xóa log cũ và tiết kiệm chi phí.
    - **b. Tạo IAM Role:**
      - Mở IAM > `Roles` > `Create role`.
      - **Trust policy (Chính sách tin cậy):** Chọn `Custom trust policy`. Đây là bước để định nghĩa **ai (Principal)** có thể "mượn" (assume) role này.
      - Dán đoạn JSON sau:
        ```json
        {
          "Version": "2012-10-17",
          "Statement": [
            {
              "Effect": "Allow",
              "Principal": {
                "Service": "vpc-flow-logs.amazonaws.com"
              },
              "Action": "sts:AssumeRole"
            }
          ]
        }
        ```
        Điều này có nghĩa là bạn cho phép dịch vụ VPC Flow Logs đảm nhận role này.
      - **Permissions policy (Chính sách quyền hạn):** Gắn policy `CloudWatchLogsFullAccess` (hoặc một policy tùy chỉnh chặt chẽ hơn). Policy này định nghĩa **hành động gì** mà role được phép làm sau khi đã được "mượn".
      - Đặt tên cho Role (ví dụ: `flowlogsrole`) và tạo.
4.  **Hoàn tất cấu hình:** Quay lại trang tạo Flow Log, chọn **Log group** và **IAM role** bạn vừa tạo. Nhấn `Create flow log`.

#### Phân tích log trong CloudWatch:

- Trong CloudWatch Log Group bạn đã tạo, bạn sẽ thấy các **Log Streams** xuất hiện. Mỗi stream thường tương ứng với một **Network Interface (ENI)**.
- Trong demo, khi xem log stream của ENI thuộc Bastion Host, người hướng dẫn thấy rất nhiều dòng `REJECT`.
- **Phân tích thực tế:** Các dòng log này cho thấy nhiều địa chỉ IP lạ từ Internet đang cố gắng truy cập vào EC2 instance nhưng bị từ chối. Đây là hành vi quét lỗ hổng (scanning) rất phổ biến.
- **Hành động:** Nếu một IP nào đó tấn công quá nhiều, bạn có thể dùng địa chỉ IP đó để tạo một luật `DENY` trong **Network ACL (NACL)** để chặn nó ngay từ lớp ngoài cùng.

---

### Phần 3: Phân Tích Chuyên Sâu với Amazon Athena

Đây là kỹ năng nâng cao cho thấy bạn có thể xử lý và khai thác dữ liệu từ log.

#### Mục đích:

Sử dụng cú pháp SQL quen thuộc để truy vấn các file log `.gz` được lưu trữ trên S3 mà không cần server hay ETL.

#### Các bước thực hiện:

1.  **Thiết lập Athena:**
    - Lần đầu sử dụng Athena, bạn cần chỉ định một "Query result location". Đây là một S3 bucket (hoặc một folder trong bucket) để Athena lưu kết quả của các câu truy vấn. Hãy tạo một bucket mới cho mục đích này.
2.  **Tạo Bảng (Table) trong Athena:**
    - Athena cần một "schema" (lược đồ) để hiểu cấu trúc của file log. Bạn sẽ định nghĩa schema này bằng một câu lệnh `CREATE EXTERNAL TABLE`.
    - **Mẹo:** AWS đã cung cấp sẵn câu lệnh mẫu trong tài liệu. Bạn chỉ cần tìm "AWS VPC flow logs Athena" là sẽ thấy.
    - **Phần quan trọng nhất:** Trong câu lệnh `CREATE TABLE`, bạn phải cập nhật `LOCATION` trỏ đúng đến folder chứa log của bạn trong S3.
      - Ví dụ: `s3://demo-stephane-vpc-flow-logs-v2/AWSLogs/[Account-ID]/vpcflowlogs/[Region]/`
    - Chạy câu lệnh này trong Query Editor của Athena.
3.  **Tạo Partitions (Phân vùng) - Tối ưu hiệu năng và chi phí:**
    - **Partitions là gì?** Nó giống như việc bạn tạo chỉ mục (index) cho dữ liệu dựa trên cấu trúc thư mục (`year`, `month`, `day`). Khi truy vấn, Athena sẽ chỉ quét các thư mục (partitions) liên quan thay vì quét toàn bộ bucket. Điều này giúp **tăng tốc độ truy vấn và giảm đáng kể chi phí**.
    - Bạn cần chạy lệnh `ALTER TABLE ADD PARTITION` để "đăng ký" các partition mới với Athena.
      - `ALTER TABLE vpc_flow_logs ADD PARTITION (year='2021', month='10', day='06') LOCATION 's3://.../2021/10/06/'`
    - **Kiến thức nâng cao:** Trong thực tế, việc thêm partition thủ công này sẽ được tự động hóa bằng **AWS Glue Crawler**. Crawler sẽ tự động quét S3, phát hiện schema và các partition mới để cập nhật vào Athena Data Catalog. Nhắc đến Glue Crawler trong phỏng vấn sẽ cho thấy bạn có kinh nghiệm vận hành chuyên nghiệp.
4.  **Truy vấn dữ liệu:**
    - Giờ đây, bạn có thể chạy các câu lệnh SQL tiêu chuẩn.
    - Ví dụ: Tìm 10 traffic bị từ chối: `SELECT * FROM vpc_flow_logs WHERE action = 'REJECT' LIMIT 10;`
    - Ví dụ nâng cao: Tìm 10 IP tấn công nhiều nhất:
      ```sql
      SELECT srcaddr, COUNT(*) as attack_count
      FROM vpc_flow_logs
      WHERE action = 'REJECT'
      GROUP BY srcaddr
      ORDER BY attack_count DESC
      LIMIT 10;
      ```

### Kết luận và Dọn dẹp

- Bài thực hành đã cho thấy cách gửi log đến hai đích phổ biến (S3, CloudWatch), cách kiểm tra log và cách phân tích chuyên sâu bằng Athena.
- **Hành động cuối cùng:** Luôn nhớ xóa các Flow Logs đã tạo để tránh phát sinh chi phí không cần thiết. Đây là một thói quen vận hành tốt.
