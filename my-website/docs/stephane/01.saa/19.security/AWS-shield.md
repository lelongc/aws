# AWS Shield - Dịch Vụ Bảo Vệ DDoS

## Giới Thiệu

AWS Shield là một dịch vụ được thiết kế để bảo vệ cơ sở hạ tầng của bạn khỏi các cuộc tấn công [DDoS (Distributed Denial of Service)](./security-concepts/ddos-attacks.md).

Tấn công DDoS là gì? Đó là khi cơ sở hạ tầng của bạn đột ngột nhận được rất nhiều yêu cầu cùng một lúc từ nhiều máy tính trên toàn thế giới. Mục tiêu của các cuộc tấn công này là làm quá tải và gây sập hệ thống của bạn, khiến người dùng thực sự không thể sử dụng dịch vụ. Đây chính là lý do tại sao nó được gọi là "từ chối dịch vụ phân tán".

## Các Loại Dịch Vụ AWS Shield

AWS cung cấp hai cấp độ bảo vệ với Shield:

### 1. AWS Shield Standard

- Dịch vụ miễn phí và tự động kích hoạt cho tất cả khách hàng AWS
- Bảo vệ chống lại các cuộc tấn công phổ biến như:
  - SYN flood
  - UDP flood
  - Các cuộc tấn công phản xạ (reflection attacks)
  - Các cuộc tấn công tầng 3 và tầng 4 khác

### 2. AWS Shield Advanced

- Dịch vụ giảm thiểu DDoS tùy chọn cao cấp
- Chi phí khoảng 3.000 USD mỗi tháng cho mỗi tổ chức
- Bảo vệ chống lại các cuộc tấn công DDoS phức tạp hơn cho:
  - Amazon EC2
  - Elastic Load Balancing
  - Amazon CloudFront
  - AWS Global Accelerator
  - Route 53

## Tính Năng Của AWS Shield Advanced

AWS Shield Advanced cung cấp nhiều tính năng bổ sung:

1. **Hỗ trợ 24/7 từ đội ngũ phản ứng DDoS của AWS**

   - Khi bị tấn công, bạn sẽ có chuyên gia hỗ trợ

2. **Bảo vệ chi phí**

   - Nếu chi phí của bạn tăng do bị tấn công DDoS, Shield Advanced sẽ bảo vệ bạn khỏi những chi phí phát sinh này

3. **Giảm thiểu tự động cho tầng ứng dụng**
   - Tự động tạo, đánh giá và triển khai các quy tắc WAF để giảm thiểu các cuộc tấn công tầng 7
   - Tường lửa ứng dụng web (WAF) của bạn sẽ tự động có các quy tắc để giúp giảm thiểu các cuộc tấn công DDoS nếu chúng xảy ra ở tầng 7

## Khi Nào Nên Sử Dụng AWS Shield Advanced?

AWS Shield Advanced được khuyến nghị cho các trường hợp:

1. **Ứng dụng có tính khả dụng cao**

   - Các ứng dụng yêu cầu thời gian hoạt động liên tục

2. **Ứng dụng nhạy cảm với chi phí**

   - Khi bạn muốn bảo vệ khỏi chi phí phát sinh do các cuộc tấn công

3. **Hệ thống quan trọng**

   - Các hệ thống không thể chấp nhận thời gian ngừng hoạt động

4. **Có nguy cơ cao bị tấn công**
   - Các tổ chức có khả năng trở thành mục tiêu của các cuộc tấn công DDoS

## Tích Hợp Với Các Dịch Vụ AWS Khác

Shield Advanced hoạt động hiệu quả khi kết hợp với:

- **AWS WAF**: Để bảo vệ tầng ứng dụng (tầng 7)
- **Amazon CloudFront và Route 53**: Để tạo kiến trúc có khả năng phục hồi cao
- **AWS Global Accelerator**: Để bảo vệ các ứng dụng với IP tĩnh

## Tóm Tắt

- AWS Shield là dịch vụ bảo vệ DDoS của AWS
- Shield Standard miễn phí và bảo vệ chống tấn công tầng 3/4 cơ bản
- Shield Advanced cung cấp bảo vệ nâng cao với chi phí bổ sung
- Shield Advanced tích hợp với WAF để tự động giảm thiểu tấn công tầng 7
- Cung cấp hỗ trợ 24/7 và bảo vệ chi phí khi đăng ký Shield Advanced
