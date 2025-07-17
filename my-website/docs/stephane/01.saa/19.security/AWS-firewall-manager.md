# AWS Firewall Manager - Quản Lý Tập Trung Các Quy Tắc Bảo Mật

## Giới Thiệu

AWS Firewall Manager là dịch vụ giúp quản lý tất cả các quy tắc tường lửa trong tất cả các tài khoản của một tổ chức AWS. Mục đích chính là cho phép quản lý đồng thời các quy tắc trên nhiều tài khoản khác nhau.

## Chính Sách Bảo Mật (Security Policy)

Firewall Manager cho phép bạn thiết lập các chính sách bảo mật - một tập hợp chung các quy tắc bảo mật. Một chính sách bảo mật có thể bao gồm:

1. **Quy tắc Web Application Firewall (WAF)**:

   - Áp dụng cho ALB, API Gateway, CloudFront và các dịch vụ khác
   - Bảo vệ các ứng dụng web khỏi các [tấn công tầng 7](./security-concepts/web-attacks.md)

2. **Quy tắc Shield Advanced**:

   - Áp dụng cho ALB, CLB, NLB, Elastic IP, CloudFront
   - Bảo vệ tài nguyên khỏi các [tấn công DDoS](./security-concepts/ddos-attacks.md)

3. **Tiêu chuẩn hóa Security Groups**:

   - Áp dụng cho EC2, Application Load Balancer, và các ENI (Elastic Network Interface) trong VPC
   - Đảm bảo tính nhất quán trong cấu hình bảo mật mạng

4. **Quy tắc AWS Network Firewall**:

   - Hoạt động ở cấp VPC
   - Kiểm soát luồng lưu lượng mạng vào/ra VPC

5. **Quy tắc Amazon Route 53 Resolver DNS Firewall**:
   - Bảo vệ DNS queries
   - Ngăn chặn truy cập đến các tên miền độc hại

## Đặc Điểm Chính của Firewall Manager

- Các chính sách được tạo ở cấp độ region
- Chính sách được áp dụng cho tất cả các tài khoản trong tổ chức AWS
- **Tự động áp dụng**: Nếu có tài nguyên mới được tạo (ví dụ: ALB mới), Firewall Manager sẽ tự động áp dụng các quy tắc đã định nghĩa cho tài nguyên đó
- **Quản lý tập trung**: Giám sát việc tuân thủ từ một giao diện duy nhất
- **Áp dụng đồng bộ**: Đảm bảo các tài nguyên mới luôn tuân thủ các chính sách bảo mật

## So Sánh Giữa WAF, Shield và Firewall Manager

Các dịch vụ WAF, Shield, và Firewall Manager thường được sử dụng kết hợp để bảo vệ toàn diện:

### AWS WAF

- **Mục đích chính**: Xác định và cấu hình các quy tắc Web ACL
- **Khi nào sử dụng**: Phù hợp khi cần bảo vệ một lần cho các tài nguyên cụ thể
- **Khả năng**: Lọc lưu lượng web dựa trên các điều kiện như IP, HTTP headers, body, URI, v.v.

### AWS Shield Advanced

- **Mục đích chính**: Bảo vệ nâng cao chống lại tấn công DDoS
- **Tính năng bổ sung**:
  - Hỗ trợ từ Đội Ứng Phó Shield (Shield Response Team - SRT)
  - Báo cáo nâng cao
  - Tự động tạo quy tắc WAF
- **Khi nào sử dụng**: Nếu bạn thường xuyên bị tấn công DDoS, nên cân nhắc mua Shield Advanced

### AWS Firewall Manager

- **Mục đích chính**: Quản lý tập trung các quy tắc bảo mật trên nhiều tài khoản
- **Khi nào sử dụng**:
  - Khi cần triển khai WAF trên nhiều tài khoản
  - Muốn tự động hóa việc bảo vệ tài nguyên mới
  - Cần đảm bảo tính nhất quán trong chính sách bảo mật
- **Khả năng**: Quản lý các quy tắc WAF, Shield Advanced, Security Groups, Network Firewall, và DNS Firewall từ một nơi duy nhất

## Quy Trình Làm Việc Với Firewall Manager

1. **Thiết lập tiên quyết**:

   - Có tổ chức AWS với AWS Organizations
   - Chỉ định tài khoản quản trị Firewall Manager
   - Kích hoạt AWS Config

2. **Tạo chính sách bảo mật**:

   - Chọn loại chính sách (WAF, Shield, Security Groups, v.v.)
   - Xác định phạm vi áp dụng (toàn tổ chức, tài khoản cụ thể, tags)
   - Xác định các quy tắc và hành động

3. **Triển khai và giám sát**:
   - Firewall Manager tự động áp dụng chính sách cho các tài nguyên hiện có và mới
   - Theo dõi tình trạng tuân thủ từ bảng điều khiển

## Các Trường Hợp Sử Dụng Phổ Biến

1. **Tổ chức đa tài khoản**:

   - Áp dụng các quy tắc bảo mật nhất quán trên tất cả các tài khoản trong tổ chức

2. **Tuân thủ quy định**:

   - Đảm bảo tất cả tài nguyên đều tuân thủ các tiêu chuẩn bảo mật tổ chức

3. **Tự động hóa bảo mật**:

   - Tự động áp dụng chính sách bảo mật cho các tài nguyên mới được tạo

4. **Quản lý tập trung**:
   - Giảm gánh nặng quản lý khi có nhiều tài khoản và nhiều region

## Lợi Ích Của Firewall Manager

- **Tiết kiệm thời gian**: Không cần cấu hình riêng biệt cho từng tài khoản
- **Nhất quán**: Đảm bảo tất cả tài nguyên đều được bảo vệ theo cùng một tiêu chuẩn
- **Tự động hóa**: Tự động áp dụng cho tài nguyên mới
- **Tuân thủ**: Dễ dàng thực thi các chính sách bảo mật trong toàn tổ chức
- **Giám sát tập trung**: Xem tổng quan về tình trạng bảo mật từ một nơi duy nhất

## Tóm Tắt

AWS Firewall Manager là công cụ quản lý tập trung các quy tắc bảo mật trên nhiều tài khoản AWS. Dịch vụ này hoạt động cùng với WAF và Shield để cung cấp giải pháp bảo vệ toàn diện cho các tài nguyên cloud của bạn. Firewall Manager đặc biệt hữu ích cho các tổ chức lớn với nhiều tài khoản AWS, giúp đảm bảo áp dụng nhất quán các chính sách bảo mật và tự động bảo vệ các tài nguyên mới được tạo.
