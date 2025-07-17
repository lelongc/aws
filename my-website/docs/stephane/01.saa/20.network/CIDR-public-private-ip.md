# CIDR (Định tuyến miền liên tác không lớp)

## Giới thiệu

- CIDR là phương pháp phân bổ địa chỉ IP
- Được sử dụng rộng rãi trong cấu hình mạng AWS
- Xác định phạm vi địa chỉ IP được sử dụng trong quy tắc nhóm bảo mật và các cấu hình mạng khác

## Cơ bản về CIDR

## CIDR Basics

### Thành phần của CIDR

1. **IP cơ sở**: Một IP nằm trong phạm vi (thường là địa chỉ bắt đầu)
   - Ví dụ: 10.0.0.0, 192.168.0.0
2. **Mặt nạ mạng con**: Xác định số bit có thể thay đổi trong IP
   - Biểu diễn dưới dạng /X (ví dụ: /8, /16, /24, /32)
   - Cũng có thể được viết dưới dạng subnet mark truyền thống (ví dụ: 255.0.0.0, 255.255.0.0)

### Ký hiệu CIDR phổ biến subnet mark truyền thống(e.g., 255.0.0.0, 255.255.0.0)

| Ký hiệu CIDR                                                                              | Mặt nạ mạng con       | Số IP cho phép              | Ví dụ phạm vi                 |                            |
| ----------------------------------------------------------------------------------------- | --------------------- | --------------------------- | ----------------------------- | -------------------------- |
| /32                                                                                       | 255.255.255.255       | 1 IP (2^0)                  | Chỉ một IP cụ thể             |                            |
| /31                                                                                       | 255.255.255.254       | 2 IP (2^1)                  | 192.168.0.0 - 192.168.0.1     | ge Example                 |
| /30                                                                                       | 255.255.255.252       | 4 IP (2^2)                  | 192.168.0.0 - 192.168.0.3     | -------------------------- |
| /29                                                                                       | 255.255.255.248       | 8 IP (2^3)                  | 192.168.0.0 - 192.168.0.7     | y the specific IP          |
| /28                                                                                       | 255.255.255.240       | 16 IP (2^4)                 | 192.168.0.0 - 192.168.0.15    | 68.0.0 - 192.168.0.1       |
| /24                                                                                       | 255.255.255.0         | 256 IP (2^8)                | 192.168.0.0 - 192.168.0.255   | 68.0.0 - 192.168.0.3       |
| /16                                                                                       | 255.255.0.0           | 65,536 IP (2^16)            | 192.168.0.0 - 192.168.255.255 | .0 - 192.168.0.7           |
| /8                                                                                        | 255.0.0.0             | 16,777,216 IP (2^24)        | 192.0.0.0 - 192.255.255.255   | 0.0 - 192.168.0.15         |
| /0                                                                                        | 0.0.0.0               | Tất cả địa chỉ IPv4 (2^32)  | 0.0.0.0 - 255.255.255.255     | 0.0 - 192.168.0.255        |
| /16                                                                                       | 255.255.0.0           | 65,536 IPs (2^16)           | 192.168.0.0 - 192.168.255.255 |                            |
| ### Hướng dẫn ghi nhớ nhanh0.0.0                                                          | 16,777,216 IPs (2^24) | 192.0.0.0 - 192.255.255.255 |                               |                            |
| - Địa chỉ IP bao gồm 4 octet (4 phần được phân tách bởi dấu chấm).0.0.0 - 255.255.255.255 |                       |                             |                               |                            |

- /32: Không octet nào có thể thay đổi (một IP duy nhất)
- /24: Octet cuối cùng có thể thay đổi (256 IP)
- /16: 2 octet cuối cùng có thể thay đổi (65,536 IP)
- /8: 3 octet cuối cùng có thể thay đổi (16,7 triệu IP)ated by periods)
- /0: Tất cả các octet có thể thay đổi (tất cả IP có thể)
- /24: Last octet can change (256 IPs)

* Tổng số địa chỉ IP trong subnet `/30`: 2^(32−30) = 4 địa chỉ
* Trong đó:

  - 1 địa chỉ là **network address**
  - 1 địa chỉ là **broadcast address**
  - **Còn lại 2 địa chỉ IP usable** cho các máy host
    [xem thêm ở đây về 2 địa chỉ trên ](./ly-thuyet-khac/netadd-broadcast.md)

## Ví dụ về CIDR octets can change (65,536 IPs)

- 192.168.0.0/24: 256 IP (octet cuối có thể thay đổi từ 0-255)
- 192.168.0.0/16: 65,536 IP (hai octet cuối có thể thay đổi)
- 134.56.78.123/32: Chỉ 1 IP (chính IP cụ thể đó)
- 0.0.0.0/0: Tất cả địa chỉ IPv4

## Công cụ hữu ích: 256 IPs (last octet can vary from 0-255)

Để tính toán phạm vi CIDR, hãy sử dụng các công cụ tính CIDR trực tuyến có thể:

[CIDR to IPv4 Address Range Utility Tool | IPAddressGuide](https://www.ipaddressguide.com/cidr)

- Chuyển đổi CIDR thành phạm vi IP (the specific IP itself)
- Chuyển đổi phạm vi IP thành CIDR
- Hiển thị IP đầu tiên và cuối cùng trong một phạm vi
- Tính số lượng IP trong một phạm vi

## Địa chỉ IP công cộng và riêng

### Dải IP riêng tư (Được IANA dành riêng)

| Phạm vi                       | Ký hiệu CIDR   | Mục đích sử dụng phổ biến       |
| ----------------------------- | -------------- | ------------------------------- |
| 10.0.0.0 - 10.255.255.255     | 10.0.0.0/8     | Mạng doanh nghiệp lớn           |
| 172.16.0.0 - 172.31.255.255   | 172.16.0.0/12  | Không gian VPC mặc định của AWS |
| 192.168.0.0 - 192.168.255.255 | 192.168.0.0/16 | Mạng gia đình, văn phòng nhỏ    |

### Địa chỉ IP công cộng Reserved by IANA)

- All other IP addresses not in the private ranges are public
- Used for internet-facing resources
- Globally unique and routable on the internet

## Tóm tắt.0 - 172.31.255.255 | 172.16.0.0/12 | AWS default VPC space |

- Ký hiệu CIDR cung cấp cách ngắn gọn để biểu diễn phạm vi địa chỉ IPll office |
- Hiểu về CIDR là điều cần thiết cho cấu hình mạng AWS
- Dải IP riêng tư được chỉ định cho mạng nội bộ
- IP công cộng được sử dụng cho giao tiếp Internet
