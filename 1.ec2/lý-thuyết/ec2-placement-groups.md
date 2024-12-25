**Placement Groups** trong AWS, một tính năng nâng cao được sử dụng để kiểm soát cách các EC2 instances được đặt trong cơ sở hạ tầng AWS.

---

### **1. Tổng quan về Placement Groups**

Placement Groups cung cấp chiến lược để tổ chức các EC2 instances nhằm tối ưu hóa hiệu suất và độ sẵn sàng. AWS không cho phép bạn tương tác trực tiếp với phần cứng, nhưng thông qua Placement Groups, bạn có thể chỉ định cách sắp xếp các instances với nhau.

**Ba chiến lược Placement Groups chính:**

1. **Cluster Placement Group**.
2. **Spread Placement Group**.
3. **Partition Placement Group**.

---

### **2. Cluster Placement Group**

- **Mô tả**:
  - Tập trung các EC2 instances vào cùng một **Availability Zone (AZ)**, với mục tiêu đạt được kết nối mạng **low latency** (độ trễ thấp) và **high throughput** (băng thông cao).
  - Các instances trong nhóm sẽ được đặt gần nhau trên phần cứng.
- **Ưu điểm**:

  - Hiệu suất cao cho các ứng dụng yêu cầu tốc độ xử lý và kết nối mạng nhanh.
  - Hỗ trợ băng thông mạng lên đến **10 Gbps** giữa các instances (với Enhanced Networking).

- **Nhược điểm**:
  - Nếu AZ gặp sự cố, tất cả các instances trong Cluster Placement Group đều sẽ ngừng hoạt động.
- **Ứng dụng**:
  - Big Data, Machine Learning, hoặc các ứng dụng yêu cầu **tốc độ xử lý dữ liệu cao**.
  - Ví dụ: Các hệ thống cần xử lý khối lượng dữ liệu lớn trong thời gian ngắn.

---

### **3. Spread Placement Group**

- **Mô tả**:

  - Phân tán các EC2 instances ra trên các **phần cứng khác nhau** để giảm rủi ro thất bại đồng thời.
  - Mỗi EC2 instance được đặt trên một phần cứng vật lý khác nhau (hardware rack khác nhau).
  - Hỗ trợ tối đa **7 instances trên mỗi AZ**.

    Host trong Spread Placement Group liên quan đến Dedicated Hosts (máy chủ vật lý chuyên dụng) mà bạn có thể sử dụng trong các trường hợp cần kiểm soát phần cứng hoặc khi triển khai AWS Outposts (cơ sở hạ tầng AWS tại chỗ, trên premises của bạn).

    Trong một Spread Placement Group, AWS sẽ cố gắng đặt từng instance (EC2 instance) vào một rack khác nhau để đảm bảo rằng lỗi ở một rack sẽ không ảnh hưởng đến các instance khác trong nhóm.
    Mỗi rack thường có nguồn điện, mạng, và phần cứng riêng biệt, giúp tăng khả năng chịu lỗi.

- **Ưu điểm**:

  - Giảm thiểu nguy cơ **thất bại đồng thời** giữa các instances, đảm bảo tính sẵn sàng cao.
  - Có thể trải rộng qua nhiều AZ, giúp tăng khả năng chịu lỗi.

- **Nhược điểm**:
  - Bị giới hạn chỉ 7 instances trên mỗi AZ.
- **Ứng dụng**:
  - Các ứng dụng quan trọng (critical applications) cần đảm bảo tính **sẵn sàng cao** và **không bị gián đoạn**, như hệ thống thanh toán, cơ sở dữ liệu.

---

### **4. Partition Placement Group**

- **Mô tả**:

  - Phân chia các EC2 instances vào nhiều **partitions** (mỗi partition là một tập hợp phần cứng riêng biệt).
  - Một Partition Placement Group có thể được cấu hình để trải rộng qua nhiều AZ
    Mỗi partition trong nhóm được trải đều trên nhiều phần cứng vật lý khác nhau trong cùng một AZ.
    Các instance trong cùng một partition có thể chia sẻ phần cứng. Nhưng các partition khác nhau sẽ nằm trên phần cứng khác nhau để tăng tính sẵn sàng và giảm rủi ro đồng thời.
  - Tối đa **7 partitions trên mỗi AZ**.
  - Mỗi partition hoạt động độc lập, giảm rủi ro lỗi lan truyền giữa các partitions.
    Partition(1 nhóm phần cứng ) có thể sử dụng nhiều phần cứng trong cùng một AZ, nhưng không thể chia sẻ hoặc liên kết với phần cứng ở partition khác trong cùng az và ngoài AZ khác

    - Bạn không chọn các AZ khi sử dụng Partition Placement Group.
    AWS sẽ tự động phân phối các instances của bạn vào các AZ khác nhau trong khu vực của bạn, sao cho mỗi instance nằm trong một partition khác nhau.

- **Ưu điểm**:

  - Hỗ trợ hàng trăm instances trong một nhóm.
  - An toàn hơn so với Spread Placement Group khi số lượng lớn instances cần được tổ chức.
  - Tương thích tốt với các ứng dụng **phân vùng dữ liệu (partition-aware)**.

- **Nhược điểm**:

  - Chỉ phù hợp với các ứng dụng được thiết kế để tận dụng **partitioning**.
    [Link đến file khái niệm  ứng dụng được thiết kế để tận dụng partitioning.](../lý-thuyết-bên-lề/app-partitioning.md)

        
- **Ứng dụng**:
  - Các hệ thống Big Data như Hadoop, Cassandra, Kafka, HDFS.
  - Phân phối dữ liệu qua nhiều partition để đảm bảo tính ổn định và khả năng chịu lỗi.
    vd
    Giả sử bạn có 3 partitions (P1, P2, P3) trong một Partition Placement Group tại AZ us-east-1a.
    P1: Các instance của P1 sẽ nằm trên một nhóm phần cứng A.
    P2: Các instance của P2 sẽ nằm trên nhóm phần cứng B.
    P3: Các instance của P3 sẽ nằm trên nhóm phần cứng C.
    Nhưng tất cả P1, P2, P3 đều phải nằm trong AZ us-east-1a.
    Nếu bạn cần tăng độ sẵn sàng qua nhiều AZ (ví dụ us-east-1a, us-east-1b), bạn phải tạo thêm Partition Placement Group riêng biệt cho mỗi AZ.

---

### **So sánh nhanh giữa ba loại Placement Groups**

| Tính năng              | Cluster Placement Group        | Spread Placement Group  | Partition Placement Group             |
| ---------------------- | ------------------------------ | ----------------------- | ------------------------------------- |
| **Hiệu suất mạng**     | Cao, độ trễ thấp               | Không ưu tiên           | Tùy thuộc vào partition setup         |
| **Khả năng chịu lỗi**  | Thấp (1 AZ fail = tất cả fail) | Cao (phân tán hardware) | Cao (cách ly failure giữa partitions) |
| **Số lượng instances** | Không giới hạn                 | Tối đa 7 mỗi AZ         | Hàng trăm instances trên nhiều AZ     |
| **Ứng dụng chính**     | Big Data, HPC, ML              | Hệ thống quan trọng     | Big Data phân vùng (Kafka, Hadoop)    |

---

### **Kết luận**

Placement Groups là một công cụ mạnh mẽ để tối ưu hóa hiệu suất và độ sẵn sàng của hệ thống EC2 trên AWS. Lựa chọn loại Placement Group phụ thuộc vào yêu cầu ứng dụng:

- **Cluster**: Nếu cần hiệu suất mạng cao.
- **Spread**: Nếu cần tối ưu hóa sẵn sàng và giảm thiểu rủi ro.
- **Partition**: Nếu cần quản lý khối lượng lớn dữ liệu với độ an toàn cao.
