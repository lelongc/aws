**High Performance Computing (HPC)**, hay còn gọi là **Tính toán hiệu năng cao**

## HPC là gì và Tại sao Cloud lại là "Sân chơi" lý tưởng?

**High Performance Computing (HPC)** là việc sử dụng sức mạnh tính toán cực lớn để giải quyết các bài toán phức tạp, đòi hỏi xử lý một lượng khổng lồ dữ liệu và tính toán.

**Tại sao AWS lại tuyệt vời cho HPC?**

- **Khả năng mở rộng siêu tốc:** Bạn có thể tạo ra một số lượng rất lớn tài nguyên (máy chủ, lưu trữ) trong nháy mắt.
- **Tăng tốc độ ra kết quả:** Càng nhiều tài nguyên, bài toán càng được giải quyết nhanh hơn.
- **Chi trả theo những gì bạn dùng (Pay-as-you-go):** Tính toán xong, bạn có thể xóa toàn bộ hạ tầng và không phải trả thêm một xu nào. Quá tiện lợi đúng không?

**Ứng dụng của HPC ở đâu?** Rất nhiều lĩnh vực: phân tích gen (genomics), hóa học tính toán, mô hình hóa rủi ro tài chính, dự báo thời tiết, Machine Learning, Deep Learning, xe tự hành, v.v.

---

## "Bộ đồ nghề" AWS cho HPC 🛠️

Để xây dựng một hệ thống HPC trên AWS, chúng ta cần kết hợp nhiều dịch vụ và tính năng khác nhau. Hãy xem xét từng khía cạnh nhé:

### 1. Quản lý và Truyền tải Dữ liệu 🗄️➡️☁️

Lượng dữ liệu cho HPC thường rất lớn, nên việc đưa dữ liệu lên AWS hiệu quả là rất quan trọng.

- **AWS Direct Connect:**
  - Kết nối mạng riêng, an toàn, tốc độ cao (Gbps) giữa trung tâm dữ liệu của bạn và AWS.
- **AWS Snowball / Snowmobile:**
  - Khi bạn cần chuyển hàng Petabytes dữ liệu. Đây là giải pháp vật lý (gửi thiết bị đến chép dữ liệu rồi gửi lại AWS). Thường dùng cho các lần chuyển lớn, một lần.
- **AWS DataSync:**
  - Cài đặt agent để di chuyển lượng lớn dữ liệu giữa hệ thống on-premise (NAS, SMB) và các dịch vụ lưu trữ AWS như S3, EFS, FSx for Windows.

---

### 2. Sức mạnh Tính toán và Mạng lưới (Compute & Networking) 💻🔗

Đây là trái tim của HPC!

- **EC2 Instances:**

  - Chọn các loại instance tối ưu cho CPU (CPU optimized) hoặc GPU (GPU optimized) tùy thuộc vào loại tính toán.
  - Sử dụng **Spot Instances** hoặc **Spot Fleets** để tiết kiệm chi phí đáng kể.
  - **Auto Scaling** để tự động điều chỉnh số lượng instance theo nhu cầu tính toán.
  - **EC2 Placement Group (loại "Cluster"):** Đặt các instance trong cùng một "cluster" để có hiệu năng mạng tốt nhất (độ trễ thấp, băng thông cao, ví dụ 10 Gbps). Tất cả instance trong cluster placement group sẽ nằm trên cùng một rack, trong cùng một Availability Zone (AZ).

- **EC2 Enhanced Networking (SR-IOV) - Mạng Nâng cao:**

  - Cung cấp băng thông cao hơn, số gói tin mỗi giây (PPS - Packet Per Second) cao hơn, và độ trễ thấp hơn.
  - **Cách để có Enhanced Networking:**
    1. **ENA (Elastic Network Adapter):** Phổ biến và mới hơn. Hỗ trợ tốc độ mạng lên đến **100 Gbps**. Đây là cái bạn cần nhớ kỹ!
    2. **Intel 82599VF:** Công nghệ cũ hơn, hỗ trợ đến 10 Gbps. Ghi nhớ phòng khi gặp trong đề thi.

- **EFA (Elastic Fabric Adapter) - "Vũ khí tối thượng" cho Mạng HPC:**

  - Đây là một phiên bản **cải tiến của ENA, được thiết kế ĐẶC BIỆT cho HPC**.
  - **Chỉ hoạt động trên Linux.**
  - Tuyệt vời cho các tác vụ đòi hỏi **giao tiếp giữa các node (inter-node communication)** rất mạnh mẽ hoặc các **workload liên kết chặt chẽ (tightly coupled workload)** – nghĩ đến các bài toán tính toán phân tán.
  - **Tại sao nó "xịn"?** EFA sử dụng tiêu chuẩn **MPI (Message Passing Interface)**. Quan trọng hơn, nó **bỏ qua (bypass) nhân (kernel) của hệ điều hành Linux** để cung cấp độ trễ THẤP HƠN NỮA và truyền tải đáng tin cậy hơn.
  - **Thi cử:** Rất hay có câu hỏi phân biệt giữa ENA và EFA. Hãy đảm bảo bạn hiểu rõ sự khác biệt và khi nào dùng cái nào! EFA là cho HPC hiệu năng cao nhất, cần giao tiếp liên node mạnh.

---

### 3. Lưu trữ Dữ liệu (Storage) 💾

Dữ liệu HPC cần được truy cập nhanh và hiệu quả.

- **Lưu trữ gắn liền với Instance (Instance-Attached Storage):**

  - **EBS (Elastic Block Store):** Có thể đạt tới 256,000 IOPS với `io2 Block Express`.
  - **Instance Store:** Hiệu năng cực cao (hàng triệu IOPS), độ trễ rất thấp vì nằm trên phần cứng của EC2 instance. Tuy nhiên, dữ liệu sẽ mất nếu instance bị dừng hoặc chấm dứt (ephemeral).

- **Lưu trữ Mạng (Network Storage):**

  - **Amazon S3:** Lưu trữ các đối tượng lớn (large objects). Đây không phải là file system truyền thống.
  - **EFS (Elastic File System):** IOPS có thể tự động mở rộng theo kích thước tổng của file system, hoặc bạn có thể dùng chế độ Provisioned IOPS để có IOPS cao hơn.
  - **FSx for Lustre - "Ngôi sao" Lưu trữ cho HPC:** 🌟
    - Đây là một hệ thống tệp được **tối ưu hóa đặc biệt cho HPC**. (Lustre = Linux + Cluster).
    - Cung cấp hàng triệu IOPS.
    - Dữ liệu ở backend được lưu trữ trên S3. Rất quan trọng phải nhớ dịch vụ này cho HPC!

---

### 4. Tự động hóa và Điều phối (Automation & Orchestration) 🤖⚙️

Quản lý một cụm HPC lớn cần công cụ hỗ trợ.

- **AWS Batch:**

  - Dịch vụ hỗ trợ chạy các **job song song trên nhiều node (multi-node parallel jobs)**.
  - Giúp bạn lên lịch và khởi chạy các EC2 instance cho các batch job một cách dễ dàng. AWS Batch sẽ quản lý các instance này. Rất phổ biến cho HPC.

- **AWS ParallelCluster:**

  - Một công cụ quản lý cụm (cluster) mã nguồn mở, giúp bạn **triển khai các cụm HPC trên AWS một cách dễ dàng**.
  - Bạn cấu hình cụm thông qua các tệp văn bản (text files).
  - Nó tự động hóa việc tạo VPC, Subnet, các loại cluster và instance.
  - **Lưu ý cho kỳ thi:** Thường được đề cập là sử dụng **ParallelCluster cùng với EFA**. Trong file cấu hình của ParallelCluster có tham số để bật EFA, giúp cải thiện hiệu năng mạng và do đó, tăng hiệu năng của cụm HPC.

---

## Chốt lại "Bí kíp" HPC cho Kỳ thi 🎯

- HPC trên AWS **không phải là một dịch vụ đơn lẻ**, mà là sự **kết hợp của nhiều dịch vụ và tùy chọn khác nhau**.
- Hãy nắm vững các thành phần chính trong mỗi "trụ cột":
  - **Truyền tải dữ liệu:** Direct Connect, Snowball, DataSync.
  - **Tính toán & Mạng:** EC2 (optimized, Spot), Placement Group (Cluster), **ENA** (chung chung, tốc độ cao), **EFA** (chuyên cho HPC, MPI, OS bypass, Linux).
  - **Lưu trữ:** EBS, Instance Store, S3, EFS, và đặc biệt là **FSx for Lustre** (HPC optimized).
  - **Tự động hóa & Điều phối:** **AWS Batch**, **AWS ParallelCluster** (thường đi với EFA).
- Hiểu _tại sao_ một dịch vụ/tính năng lại phù hợp với HPC (ví dụ: EFA cho mạng độ trễ cực thấp, FSx for Lustre cho lưu trữ chia sẻ hiệu năng cao).
