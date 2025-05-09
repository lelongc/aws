# Tạo VPC trong AWS

## Tổng quan về VPC

VPC (Virtual Private Cloud) là một mạng ảo cô lập trong AWS Cloud. Dưới đây là những thông tin quan trọng về VPC:

- Mỗi tài khoản AWS có thể tạo tối đa 5 VPC mỗi Region (giới hạn mềm, có thể yêu cầu tăng)
- Mỗi VPC có thể được gán tối đa 5 dải CIDR IPv4
- Kích thước CIDR:
  - Tối thiểu: /28 (16 địa chỉ IP)
  - Tối đa: /16 (65.536 địa chỉ IP)
- VPC chỉ chấp nhận dải địa chỉ IPv4 riêng tư:
  - 10.0.0.0/8
  - 172.16.0.0/12
  - 192.168.0.0/16

> **Lưu ý quan trọng:** Khi chọn CIDR cho VPC, cần đảm bảo không trùng lặp với VPC khác hoặc mạng doanh nghiệp nếu bạn dự định kết nối chúng với nhau sau này.

## Hướng dẫn tạo VPC

### Bước 1: Tạo VPC mới

1. Truy cập vào dịch vụ VPC trong AWS Management Console
2. Chọn "Create VPC"
3. Nhập thông tin:
   - **Name tag**: DemoVPC
   - **IPv4 CIDR block**: 10.0.0.0/16 (cung cấp 65.536 địa chỉ IP)
   - **IPv6 CIDR block**: Chọn "No IPv6 CIDR block" (có thể thêm sau này)
   - **Tenancy**: Default (sử dụng phần cứng chia sẻ, tiết kiệm chi phí hơn so với Dedicated)
4. Nhấn "Create VPC"

### Bước 2: Xác nhận và kiểm tra VPC

Sau khi tạo VPC, AWS tự động tạo:

- Bảng định tuyến chính (Main route table)
- Danh sách kiểm soát truy cập mạng (Network ACL)

### Bước 3: (Tùy chọn) Thêm CIDR bổ sung

1. Chọn VPC vừa tạo
2. Chọn "Actions" > "Edit CIDRs"
3. Nhấn "Add new IPv4 CIDR"
4. Thêm CIDR mới (ví dụ: 10.1.0.0/16)
5. Nhấn "Save"

Mỗi VPC có thể có tối đa 5 dải CIDR IPv4, giúp mở rộng không gian địa chỉ IP khi cần thiết mà không cần tạo VPC mới.
