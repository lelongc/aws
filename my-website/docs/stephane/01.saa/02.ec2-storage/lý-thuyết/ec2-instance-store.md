

### 1. **EC2 Instance Store là gì?**
- **EC2 Instance Store** là một loại lưu trữ đính kèm trực tiếp vào phần cứng của server vật lý (hard drive còn ebs là network drive )mà EC2 instance đang chạy trên đó. Đặc biệt, EC2 Instance Store có thể cung cấp hiệu suất I/O (Input/Output) rất cao vì dữ liệu được lưu trữ trực tiếp trên ổ cứng của máy chủ vật lý, không phải qua mạng.
- Tuy nhiên, lưu trữ này có tính **ephemeral** (tạm thời), tức là khi EC2 instance bị dừng hoặc bị xóa, dữ liệu lưu trữ trong EC2 Instance Store sẽ bị mất.

### 2. **Ưu điểm và Nhược điểm**
- **Ưu điểm**:
  - **Hiệu suất cao**: EC2 Instance Store có thể cung cấp hiệu suất rất tốt về IOPS (Operations Per Second - Số thao tác vào ra mỗi giây) và băng thông, rất thích hợp cho các ứng dụng cần hiệu suất I/O cao, như cơ sở dữ liệu tạm thời, bộ đệm (buffer), hoặc các tác vụ tính toán yêu cầu đọc/ghi nhanh.
  - **Thích hợp cho lưu trữ tạm thời**: EC2 Instance Store lý tưởng cho các dữ liệu tạm thời, chẳng hạn như cache hoặc dữ liệu tính toán trung gian.
- **Nhược điểm**:
  - **Mất dữ liệu khi dừng hoặc xóa EC2 instance**: Nếu EC2 instance bị dừng hoặc xóa, dữ liệu trên EC2 Instance Store sẽ bị mất vĩnh viễn. Vì vậy, nó không phải là lựa chọn tốt cho việc lưu trữ dài hạn.
  - **Không phù hợp cho lưu trữ lâu dài**: EC2 Instance Store không được thiết kế để lưu trữ dữ liệu lâu dài. Nếu bạn cần lưu trữ bền vững và an toàn, **EBS** (Elastic Block Store) sẽ là lựa chọn tốt hơn.

### 3. **Khi nào nên sử dụng EC2 Instance Store?**
- **Lưu trữ tạm thời**: Ví dụ như cache hoặc dữ liệu tạm thời trong các ứng dụng tính toán hoặc phân tích dữ liệu.
- **Hiệu suất I/O cao**: Khi bạn cần tốc độ đọc/ghi nhanh cho các ứng dụng yêu cầu hiệu suất cực cao, chẳng hạn như cơ sở dữ liệu NoSQL hoặc các hệ thống lưu trữ tạm thời.

### 4. **Các tính năng của EC2 Instance Store**
- **Thông lượng và IOPS cao**: EC2 Instance Store có thể cung cấp hàng triệu thao tác đọc/ghi mỗi giây (ví dụ: 3.3 triệu IOPS cho một số loại instance store nhất định), cao hơn nhiều so với các volume EBS thông thường, như EBS io2.
- **Tính chất tạm thời (ephemeral)**: Khi EC2 instance bị dừng hoặc xóa, dữ liệu trên EC2 Instance Store sẽ mất hoàn toàn.

### 5. **Sự khác biệt với EBS**
- **EBS** là dịch vụ lưu trữ bền vững của AWS, nơi dữ liệu được duy trì ngay cả khi EC2 instance bị dừng hoặc xóa. Tuy nhiên, hiệu suất của EBS (IOPS, throughput) thấp hơn nhiều so với EC2 Instance Store.
- **EBS** thích hợp cho các ứng dụng yêu cầu lưu trữ lâu dài và dữ liệu quan trọng, trong khi **EC2 Instance Store** chủ yếu phục vụ cho các ứng dụng cần hiệu suất I/O cực nhanh và dữ liệu tạm thời.

### 6. **Lưu ý khi sử dụng EC2 Instance Store**
- Nếu bạn quyết định sử dụng EC2 Instance Store, bạn cần phải **sao lưu dữ liệu** của mình một cách định kỳ để tránh mất dữ liệu, đặc biệt khi EC2 instance bị dừng hoặc xóa.
- EC2 Instance Store không phải là lựa chọn phù hợp cho việc lưu trữ dữ liệu quan trọng mà cần tính bền vững.

### Tóm lại:
EC2 Instance Store là lựa chọn tuyệt vời nếu bạn cần hiệu suất I/O cực cao và lưu trữ tạm thời (như bộ đệm hoặc dữ liệu trung gian), nhưng không nên sử dụng nó cho lưu trữ lâu dài vì dữ liệu sẽ bị mất khi EC2 instance bị dừng hoặc xóa. Còn đối với lưu trữ lâu dài và an toàn, EBS sẽ là lựa chọn phù hợp hơn.