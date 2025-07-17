# Tấn Công DDoS và Các Khái Niệm Liên Quan

## Tấn Công DDoS Là Gì?

DDoS (Distributed Denial of Service) là loại tấn công mạng trong đó kẻ tấn công sử dụng nhiều hệ thống bị xâm nhập (botnet) để làm quá tải hệ thống, dịch vụ hoặc mạng của mục tiêu bằng lưu lượng truy cập lớn, khiến dịch vụ không thể phục vụ người dùng hợp pháp.

## Các Loại Tấn Công DDoS Phổ Biến

### 1. Tấn Công Tầng Mạng/Vận Chuyển (Layer 3/4)

#### SYN Flood

- Khai thác quy trình bắt tay TCP ba bước (three-way handshake)
- Kẻ tấn công gửi nhiều gói SYN với địa chỉ nguồn giả mạo
- Máy chủ phản hồi với SYN-ACK và chờ ACK cuối cùng
- Máy chủ tiêu tốn tài nguyên chờ các kết nối không hoàn thành

#### UDP Flood

- Gửi một lượng lớn gói UDP đến các cổng ngẫu nhiên
- Máy chủ kiểm tra ứng dụng đang lắng nghe tại cổng
- Khi không tìm thấy ứng dụng, máy chủ phản hồi với gói "Destination Unreachable"
- Tiêu tốn tài nguyên hệ thống khi xử lý số lượng lớn gói tin

#### ICMP Flood (Ping Flood)

- Gửi một lượng lớn gói ICMP Echo Request (ping)
- Buộc máy chủ phải phản hồi với gói ICMP Echo Reply
- Làm cạn kiệt băng thông

### 2. Tấn Công Phản Xạ/Khuếch Đại (Reflection/Amplification Attacks)

#### DNS Amplification

- Kẻ tấn công gửi yêu cầu DNS với địa chỉ nguồn giả (spoofed) là địa chỉ nạn nhân
- Máy chủ DNS phản hồi với gói dữ liệu lớn hơn nhiều lần
- Hệ số khuếch đại có thể đạt 50-100 lần

#### NTP Amplification

- Sử dụng máy chủ Network Time Protocol (NTP)
- Khai thác lệnh "monlist" trả về danh sách các kết nối gần đây
- Phản hồi có thể lớn hơn yêu cầu tới 500 lần

### 3. Tấn Công Tầng Ứng Dụng (Layer 7)

#### HTTP Flood

- Tạo ra nhiều yêu cầu HTTP hợp lệ hoặc gần như hợp lệ
- Khó phân biệt với lưu lượng thông thường
- Tập trung vào các trang cần xử lý nhiều tài nguyên

#### Slowloris

- Mở nhiều kết nối với máy chủ web và giữ chúng mở càng lâu càng tốt
- Gửi các HTTP header một cách chậm rãi, từng phần một
- Cuối cùng chiếm hết slots kết nối của máy chủ

## Dấu Hiệu Nhận Biết Tấn Công DDoS

- Hiệu suất mạng chậm bất thường
- Không thể truy cập trang web cụ thể
- Tăng đột biến về lưu lượng mạng
- Mất kết nối Internet không rõ nguyên nhân
- Tài nguyên máy chủ (CPU, RAM, băng thông) bị sử dụng quá mức

## Cách Thức Phòng Chống DDoS

### Chiến Lược Giảm Thiểu

1. **Tăng Dung Lượng Mạng**

   - Mở rộng băng thông để xử lý lưu lượng cao
   - Sử dụng các dịch vụ cloud để có khả năng mở rộng linh hoạt

2. **Phân Tán Tài Nguyên**

   - Phân phối nội dung qua nhiều máy chủ và vị trí địa lý
   - Sử dụng CDN (Content Delivery Network)

3. **Lọc Lưu Lượng**
   - Cấu hình tường lửa để lọc gói tin
   - Sử dụng các dịch vụ bảo vệ DDoS chuyên dụng

### Các Công Nghệ Phòng Chống

1. **Scrubbing Centers**

   - Chuyển hướng lưu lượng đến trung tâm lọc
   - Lọc ra lưu lượng độc hại trước khi chuyển tiếp lưu lượng hợp pháp

2. **Anycast Network Diffusion**

   - Phân tán tấn công qua nhiều điểm cuối mạng

3. **Web Application Firewalls (WAF)**

   - Lọc lưu lượng HTTP/HTTPS độc hại

4. **BGP Flowspec**
   - Lọc, giới hạn tốc độ hoặc chuyển hướng lưu lượng trên mạng lớn

## Dịch Vụ Bảo Vệ DDoS Trên AWS

AWS cung cấp các dịch vụ bảo vệ DDoS thông qua AWS Shield, với hai cấp độ bảo vệ:

1. **AWS Shield Standard**

   - Bảo vệ miễn phí cho tất cả khách hàng AWS
   - Bảo vệ chống lại các tấn công phổ biến tầng 3 và tầng 4

2. **AWS Shield Advanced**
   - Dịch vụ bảo vệ DDoS cao cấp
   - Bảo vệ chống lại các tấn công phức tạp hơn
   - Tích hợp với AWS WAF để bảo vệ tầng ứng dụng
   - Hỗ trợ từ đội ngũ phản ứng DDoS
   - Bảo vệ chi phí mở rộng khi bị tấn công

AWS Shield kết hợp với các dịch vụ khác như AWS WAF và Amazon CloudFront cung cấp giải pháp bảo vệ DDoS toàn diện cho các ứng dụng cloud.
