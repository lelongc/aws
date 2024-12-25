# Hướng Dẫn Khắc Phục Sự Cố SSH

Khi sử dụng SSH để kết nối đến các instance EC2, bạn có thể gặp phải một số lỗi phổ biến. Dưới đây là các bước hướng dẫn giúp bạn khắc phục các sự cố này:

### 1) Lỗi **Connection Timeout**
**Nguyên nhân:** Đây là vấn đề liên quan đến Security Group hoặc tường lửa.

- Kiểm tra và đảm bảo rằng Security Group đã được cấu hình đúng, cho phép kết nối qua cổng 22 (SSH).
- Đảm bảo rằng Security Group này đã được gán chính xác cho instance EC2 của bạn.

### 2) Vẫn gặp lỗi **Connection Timeout** sau khi kiểm tra Security Group
**Nguyên nhân:** Có thể tường lửa của công ty hoặc tường lửa cá nhân đang chặn kết nối.

- Trong trường hợp này, hãy thử sử dụng **EC2 Instance Connect** như được mô tả trong bài học tiếp theo.

### 3) SSH không hoạt động trên Windows
**Nguyên nhân:** Nếu nhận được thông báo "ssh command not found," điều này có nghĩa là SSH chưa được cài đặt hoặc cấu hình.

- Hãy sử dụng công cụ **Putty** để kết nối.
- Nếu vẫn gặp vấn đề, hãy sử dụng **EC2 Instance Connect**.

### 4) Lỗi **Connection Refused**
**Nguyên nhân:** Instance EC2 của bạn có thể đang hoạt động nhưng không chạy dịch vụ SSH.

- Thử khởi động lại instance.
- Nếu không được, hãy xoá instance hiện tại và tạo một instance mới, đảm bảo sử dụng Amazon Linux 2.

### 5) Lỗi **Permission denied (publickey, gssapi-keyex, gssapi-with-mic)**
**Nguyên nhân:** Có thể bạn đang sử dụng sai key bảo mật hoặc sai user.

- Kiểm tra xem bạn có sử dụng đúng key bảo mật đã gán cho instance không.
- Đảm bảo bạn sử dụng đúng user khi kết nối. Với Amazon Linux 2, user mặc định là `ec2-user`. Lệnh SSH mẫu:
  ```
  ssh -i <key.pem> ec2-user@<public-ip>
  ```

### 6) Không gì hoạt động - "aaaahhhhhh"
**Giải pháp:**

- Đừng hoảng loạn. Sử dụng **EC2 Instance Connect** để truy cập instance.
- Đảm bảo bạn đã khởi tạo instance với Amazon Linux 2.

### 7) Hôm qua kết nối được, hôm nay không được
**Nguyên nhân:** Khi bạn stop và start lại instance, địa chỉ IP công cộng (Public IP) của instance sẽ thay đổi.

- Cập nhật IP mới trong lệnh SSH hoặc cấu hình Putty.
- Đảm bảo bạn đã lưu đúng địa chỉ Public IP mới.

