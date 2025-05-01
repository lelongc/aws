# Các Khái Niệm Về Tường Lửa (Firewall) Trong Cloud

## Tường Lửa Là Gì?

Tường lửa (Firewall) là một hệ thống bảo mật mạng theo dõi và kiểm soát lưu lượng mạng đến và đi dựa trên các quy tắc bảo mật đã được xác định. Tường lửa hoạt động như một rào chắn giữa mạng đáng tin cậy và các mạng không đáng tin cậy (như Internet).

## Các Loại Tường Lửa

### 1. Tường Lửa Tầng Mạng (Network Firewall)

- Hoạt động ở tầng 3-4 của mô hình OSI
- Phân tích các đặc điểm của gói tin như địa chỉ IP nguồn/đích, cổng và giao thức
- Ví dụ trong AWS: Security Groups, Network ACLs, AWS Network Firewall

### 2. Tường Lửa Ứng Dụng Web (Web Application Firewall - WAF)

- Hoạt động ở tầng 7 của mô hình OSI (tầng ứng dụng)
- Phân tích lưu lượng HTTP/HTTPS để bảo vệ các ứng dụng web
- Ví dụ trong AWS: AWS WAF

### 3. Tường Lửa Thế Hệ Tiếp Theo (Next-Generation Firewall - NGFW)

- Kết hợp các tính năng của tường lửa truyền thống với các khả năng nâng cao
- Bao gồm phòng chống xâm nhập, kiểm tra sâu các gói tin, và bảo vệ ứng dụng

## Mô Hình OSI và Tường Lửa

| Tầng OSI | Tên Tầng                     | Loại Tường Lửa           | Dịch Vụ AWS                        |
| -------- | ---------------------------- | ------------------------ | ---------------------------------- |
| 7        | Ứng dụng (Application)       | Web Application Firewall | AWS WAF                            |
| 6        | Trình diễn (Presentation)    |                          |                                    |
| 5        | Phiên (Session)              |                          |                                    |
| 4        | Vận chuyển (Transport)       | Stateful Firewall        | Security Groups                    |
| 3        | Mạng (Network)               | Packet Filtering         | Network ACLs, AWS Network Firewall |
| 2        | Liên kết dữ liệu (Data Link) |                          |                                    |
| 1        | Vật lý (Physical)            |                          |                                    |

## Các Khái Niệm Phòng Thủ Theo Chiều Sâu trong AWS

### 1. Security Groups (SGs)

- **Định nghĩa**: Tường lửa ảo ở cấp độ instance
- **Đặc điểm**:
  - Stateful: Lưu lượng phản hồi tự động được cho phép
  - Mặc định chặn tất cả lưu lượng đến (inbound)
  - Mặc định cho phép tất cả lưu lượng đi ra (outbound)
  - Chỉ có quy tắc cho phép (Allow), không có quy tắc từ chối (Deny)

### 2. Network Access Control Lists (NACLs)

- **Định nghĩa**: Tường lửa ở cấp độ subnet
- **Đặc điểm**:
  - Stateless: Phải định nghĩa quy tắc riêng cho lưu lượng đến và đi
  - Kiểm tra theo thứ tự quy tắc (từ thấp đến cao)
  - Có cả quy tắc cho phép (Allow) và từ chối (Deny)

### 3. AWS WAF (Web Application Firewall)

- **Định nghĩa**: Tường lửa bảo vệ ứng dụng web
- **Đặc điểm**:
  - Lọc lưu lượng HTTP/HTTPS ở tầng 7
  - Bảo vệ khỏi các tấn công phổ biến như SQL Injection, XSS
  - Sử dụng Web ACL (Access Control Lists) để định nghĩa quy tắc

### 4. AWS Network Firewall

- **Định nghĩa**: Dịch vụ tường lửa mạng có trạng thái (stateful) cho VPC
- **Đặc điểm**:
  - Bảo vệ tất cả các subnet trong VPC
  - Có thể lọc lưu lượng từ VPC đến Internet hoặc từ VPC đến VPC khác
  - Hỗ trợ kiểm tra sâu các gói tin và phòng chống xâm nhập

### 5. AWS Firewall Manager

- **Định nghĩa**: Dịch vụ quản lý tập trung các tường lửa
- **Đặc điểm**:
  - Quản lý các quy tắc bảo mật trên nhiều tài khoản
  - Tự động áp dụng quy tắc cho tài nguyên mới
  - Giám sát việc tuân thủ từ một giao diện tập trung

## Chiến Lược Phòng Thủ Nhiều Lớp

Một chiến lược phòng thủ theo chiều sâu hiệu quả trong AWS thường kết hợp nhiều lớp bảo mật:

1. **Lớp Perimeter**: Route 53, Shield, WAF
2. **Lớp VPC**: Network ACLs, Network Firewall, VPC Endpoints
3. **Lớp Compute**: Security Groups, IMDSv2, Systems Manager
4. **Lớp Ứng dụng**: IAM, WAF, Cognito
5. **Lớp Dữ liệu**: Mã hóa, IAM, S3 Bucket Policies

## So Sánh Giữa Các Dịch Vụ Bảo Mật AWS

### Security Groups vs. NACLs

| Tính năng  | Security Groups                               | NACLs                      |
| ---------- | --------------------------------------------- | -------------------------- |
| Phạm vi    | Hoạt động ở cấp instance                      | Hoạt động ở cấp subnet     |
| Trạng thái | Stateful                                      | Stateless                  |
| Quy tắc    | Chỉ có Allow                                  | Có cả Allow và Deny        |
| Đánh giá   | Tất cả quy tắc                                | Theo thứ tự số quy tắc     |
| Mặc định   | Chặn tất cả inbound, cho phép tất cả outbound | Thay đổi tùy theo cấu hình |

### WAF vs. Network Firewall

| Tính năng  | AWS WAF                      | AWS Network Firewall         |
| ---------- | ---------------------------- | ---------------------------- |
| Tầng OSI   | Tầng 7 (Application)         | Tầng 3-4 (Network-Transport) |
| Bảo vệ     | Ứng dụng web                 | Mạng VPC                     |
| Triển khai | CloudFront, ALB, API Gateway | VPC                          |
| Khả năng   | Lọc HTTP/HTTPS               | Lọc nhiều giao thức, IPS/IDS |

## Các Bước Thực Hiện Tối Ưu Bảo Mật Tường Lửa Trong AWS

1. **Sử dụng nguyên tắc đặc quyền tối thiểu**

   - Chỉ mở các cổng và giao thức cần thiết
   - Chỉ định rõ các nguồn/đích IP cho phép

2. **Triển khai phòng thủ nhiều lớp**

   - Security Groups + NACLs
   - WAF + Shield cho ứng dụng web

3. **Giám sát và logging**

   - VPC Flow Logs
   - WAF Logs
   - CloudWatch Logs

4. **Quản lý tập trung**

   - Sử dụng AWS Firewall Manager cho tổ chức lớn
   - Infrastructure as Code (Terraform, CloudFormation)

5. **Kiểm tra định kỳ**
   - Sử dụng AWS Config để kiểm tra tuân thủ
   - Thực hiện đánh giá bảo mật thường xuyên

## Tóm Tắt

Trong môi trường AWS, việc hiểu và triển khai đúng đắn các dịch vụ tường lửa là nền tảng quan trọng để bảo vệ ứng dụng và dữ liệu. Phương pháp phòng thủ theo chiều sâu kết hợp nhiều lớp bảo mật - từ Security Groups và NACLs đến WAF và Firewall Manager - giúp tạo ra một hệ thống phòng thủ toàn diện chống lại các mối đe dọa từ nhiều hướng khác nhau.
