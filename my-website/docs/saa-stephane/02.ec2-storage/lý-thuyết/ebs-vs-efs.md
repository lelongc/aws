

### Sự khác biệt chính:
1. **EBS (Elastic Block Store)**:
   - Được thiết kế để gắn với **một EC2 instance duy nhất** tại một thời điểm (trừ trường hợp đặc biệt với các loại `io1` và `io2` cho phép multi-attach).
   - **Giới hạn trong Availability Zone (AZ)**: Một EBS volume bị ràng buộc với một AZ cụ thể.
   - **Hiệu suất theo dung lượng**:
     - Đối với `gp2`: IOPS tăng khi dung lượng ổ đĩa tăng.
     - Đối với `gp3` và `io1/io2`: Có thể tăng IOPS độc lập với dung lượng ổ đĩa.
   - **Di chuyển giữa các AZ**: Cần tạo snapshot, sau đó khôi phục snapshot trong AZ khác.
   - **Sao lưu ảnh hưởng hiệu suất**: Quá trình sao lưu sử dụng I/O, do đó không nên sao lưu  khi ứng dụng đang xử lý lưu lượng cao .
   - **Root volume** mặc định sẽ bị xóa khi EC2 instance bị xóa, nhưng có thể cấu hình để giữ lại.

2. **EFS (Elastic File System)**:
   - Là hệ thống file qua mạng (network file system), được thiết kế để gắn với **hàng trăm EC2 instance trên nhiều AZ**.
   - Hỗ trợ **POSIX**, chỉ dành cho **Linux instance**.
   - **Chia sẻ tệp**: Nhiều instance có thể chia sẻ cùng một file system thông qua các mount target ở các AZ khác nhau.
   - **Chi phí cao hơn EBS**, nhưng có thể tiết kiệm thông qua việc sử dụng các tier lưu trữ.

3. **Instance Store**:
   - Là bộ nhớ vật lý gắn trực tiếp với EC2 instance.
   - **Không bền vững**: Nếu EC2 instance bị mất, dữ liệu trên instance store cũng mất theo.

---

