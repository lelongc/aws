![alt text](../image/policy-latency.png)
### Chi tiết kiến thức về Latency-Based Routing Policy trong Amazon Route 53

#### 1. **Khái niệm cơ bản**
- **Latency-Based Routing Policy** trong Route 53 giúp định tuyến lưu lượng đến tài nguyên có độ trễ thấp nhất từ vị trí người dùng.
- Độ trễ được đo dựa trên tốc độ kết nối giữa người dùng và vùng AWS gần nhất của tài nguyên.

#### 2. **Ứng dụng**
- Thích hợp cho các trang web và ứng dụng yêu cầu tốc độ phản hồi nhanh, nơi độ trễ mạng là yếu tố quan trọng.
- Tự động chuyển hướng người dùng đến khu vực địa lý gần nhất với họ để giảm thời gian phản hồi.

#### 3. **Hoạt động**
- Ví dụ:
  - Một ứng dụng được triển khai tại hai khu vực:
    - **us-east-1** (miền Đông Hoa Kỳ).
    - **ap-southeast-1** (Singapore).
  - Người dùng:
    - Tại Mỹ sẽ được chuyển hướng đến **us-east-1**.
    - Tại châu Á sẽ được chuyển hướng đến **ap-southeast-1**.

#### 4. **Cách thiết lập**
1. **Tạo bản ghi Latency:**
   - Vào Route 53, tạo bản ghi mới với chính sách Latency.
   - Đặt tên bản ghi (ví dụ: `latency.yourdomain.com`).
   - Chỉ định giá trị IP hoặc Alias tương ứng với các vùng AWS.

2. **Liên kết vùng với IP:**
   - Xác định vùng AWS tương ứng với mỗi IP.
   - Ví dụ:
     - IP của máy chủ tại Singapore sẽ được gắn với **ap-southeast-1**.
     - IP của máy chủ tại Mỹ sẽ được gắn với **us-east-1**.

3. **Kiểm tra bằng Health Check (nếu cần):**
   - Kết hợp với kiểm tra sức khỏe (Health Check) để đảm bảo chỉ chuyển hướng đến các tài nguyên đang hoạt động.

#### 5. **Kiểm tra và xác minh**
- Sử dụng VPN để kiểm tra từ các vị trí khác nhau:
  - **Từ châu Âu:** Người dùng được chuyển hướng đến tài nguyên tại **eu-central-1**.
  - **Từ Canada:** Người dùng được chuyển hướng đến **us-east-1**.
  - **Từ Hồng Kông:** Người dùng được chuyển hướng đến **ap-southeast-1**.

- **Công cụ kiểm tra:**
  - Sử dụng lệnh `dig` trong terminal để kiểm tra bản ghi DNS và xác minh IP được trả về.
  - Lưu ý rằng DNS Cache có thể ảnh hưởng đến kết quả, cần làm mới DNS Cache nếu thay đổi vị trí.

#### 6. **Lợi ích**
- Tăng tốc độ phản hồi cho người dùng toàn cầu.
- Cải thiện trải nghiệm người dùng nhờ giảm độ trễ mạng.
- Dễ dàng cấu hình và kết hợp với các tính năng khác của Route 53.

