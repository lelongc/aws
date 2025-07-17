
1. **Giới thiệu về các tùy chọn lưu trữ EC2**:
   - EBS (Elastic Block Store) là một ổ đĩa mạng có thể gắn vào các EC2 instances và giữ lại dữ liệu ngay cả khi instance bị xóa.

2. **Tính năng của EBS**:
   - EBS cho phép khôi phục dữ liệu khi tạo lại instance và gắn ổ đĩa EBS trước đó vào.
   - Mỗi EBS volume chỉ có thể gắn vào một instance tại một thời điểm. ccp 

3. **Các loại EBS Volume**:
   - EBS có thể là SSD hoặc Magnetic, với dung lượng 30GB miễn phí mỗi tháng cho loại General Purpose.
   -  GP2 hoặc GP3.

4. **Cách hoạt động của EBS**:
   - EBS sử dụng mạng để kết nối giữa instance và ổ đĩa, vì vậy có thể gặp độ trễ.
   - EBS có thể được gỡ ra và gắn lại vào một instance khác nhanh chóng, giúp hữu ích trong các tình huống failover.

5. **Khu vực Availability Zone (AZ)**:
   - EBS chỉ có thể gắn vào các instance trong cùng một AZ.
   - Nếu muốn di chuyển EBS giữa các AZ, bạn phải tạo snapshot và phục hồi lại từ snapshot.

6. **Tạo và quản lý EBS Volumes**: 
   - Khi tạo EBS Volume, bạn cần xác định dung lượng và IOPS (operations per second) trước. 
         [IOPS là ](../lý-thuyết-bên-lề/IOPS.md)

   - EBS có thể được tạo ra mà không cần gắn vào instance và có thể gắn lại khi cần.

7. **Tính năng "Delete on Termination"**:
   - Khi EC2 instance bị xóa, EBS gắn vào có thể bị xóa tùy theo thiết lập "Delete on Termination".
   - Mặc định, root volume sẽ bị xóa khi instance bị xóa, nhưng các EBS volumes khác cùng gắn vô thì không bị xóa trừ khi có cấu hình khác.

