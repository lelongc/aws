# Autonomous System Number (ASN) và Border Gateway Protocol (BGP)

## 1. Autonomous System Number (ASN)

### Định nghĩa

- **ASN** là một số định danh duy nhất được gán cho một nhóm các mạng IP được quản lý bởi một tổ chức duy nhất
- Được sử dụng để xác định các hệ thống tự trị (Autonomous Systems) trên Internet
- ASN có thể là số 16-bit (1-65535) hoặc số 32-bit (1-4294967295)

### Phân loại ASN

- **Public ASN**: Được IANA cấp phát, sử dụng trên Internet công cộng
- **Private ASN**: Sử dụng nội bộ, không được quảng bá trên Internet
  - 16-bit: 64512-65534
  - 32-bit: 4200000000-4294967294

### Ứng dụng

- Định tuyến giữa các ISP (Internet Service Providers)
- Xác định nguồn gốc của các tuyến đường mạng
- Kiểm soát chính sách định tuyến
- Trong AWS: sử dụng cho VPN Gateway, Direct Connect

## 2. Border Gateway Protocol (BGP)

### Định nghĩa

- **BGP** là giao thức định tuyến được sử dụng để trao đổi thông tin định tuyến giữa các Autonomous Systems
- Được gọi là "giao thức định tuyến của Internet"
- Phiên bản hiện tại: BGP-4 (RFC 4271)

### Đặc điểm chính

- **Path Vector Protocol**: Lưu trữ toàn bộ đường đi AS
- **Policy-based routing**: Cho phép kiểm soát chính sách định tuyến
- **Reliable**: Sử dụng TCP port 179
- **Scalable**: Xử lý được hàng triệu tuyến đường

### Các loại BGP

1. **External BGP (eBGP)**

   - Kết nối giữa các AS khác nhau
   - Administrative Distance: 20
   - TTL = 1 (thường)

2. **Internal BGP (iBGP)**
   - Kết nối trong cùng một AS
   - Administrative Distance: 200
   - Yêu cầu full mesh hoặc Route Reflector

### BGP Attributes

- **Well-known Mandatory**: AS_PATH, ORIGIN, NEXT_HOP
- **Well-known Discretionary**: LOCAL_PREF, ATOMIC_AGGREGATE
- **Optional Transitive**: AGGREGATOR, COMMUNITY
- **Optional Non-transitive**: MED, ORIGINATOR_ID

## 3. Mối quan hệ giữa ASN và BGP

### ASN trong BGP

- Mỗi BGP speaker phải có một ASN duy nhất
- AS_PATH attribute chứa danh sách các ASN mà route đã đi qua
- Ngăn chặn loop bằng cách từ chối route có chứa ASN của chính mình

### BGP Route Selection

1. Highest Weight (Cisco specific)
2. Highest Local Preference
3. Locally originated routes
4. Shortest AS_PATH
5. Lowest Origin code
6. Lowest MED
7. eBGP over iBGP
8. Lowest IGP metric to next hop
9. Oldest route
10. Lowest Router ID

## 4. Ứng dụng trong AWS

### AWS và ASN

- **Amazon ASN**: 16509 (US regions), 14618 (EU/APAC)
- **Customer Gateway**: Cần cấu hình ASN cho VPN connections
- **Virtual Private Gateway**: Có thể chọn ASN tùy chỉnh
- **Transit Gateway**: Hỗ trợ BGP routing

### BGP trong AWS

- **Direct Connect**: Sử dụng BGP để quảng bá routes
- **VPN Connections**: Dynamic routing qua BGP
- **Route 53 Resolver**: BGP cho DNS forwarding rules

## 5. Best Practices

### ASN Management

- Sử dụng Private ASN cho mạng nội bộ
- Đăng ký Public ASN khi cần kết nối Internet
- Tài liệu hóa việc sử dụng ASN

### BGP Security

- **Route filtering**: Chỉ accept/advertise routes hợp lệ
- **AS_PATH filtering**: Kiểm tra AS path hợp lệ
- **Prefix limits**: Giới hạn số lượng prefixes
- **RPKI**: Resource Public Key Infrastructure

### Monitoring

- Giám sát BGP sessions
- Theo dõi route changes
- Alert khi có bất thường trong routing table

## 6. Troubleshooting

### Common BGP Issues

- **Session not established**: Kiểm tra connectivity, authentication
- **Routes not received**: Kiểm tra filters, policies
- **Suboptimal routing**: Điều chỉnh attributes (LOCAL_PREF, MED)
- **Routing loops**: Kiểm tra AS_PATH, route reflector config

### Debug Commands

```
show ip bgp summary
show ip bgp neighbors
show ip bgp
show ip route bgp
debug ip bgp updates
```

## Tài liệu tham khảo

- RFC 4271: BGP-4
- RFC 7300: ASN Reservation
- AWS Documentation: BGP routing
- IANA ASN Registry
