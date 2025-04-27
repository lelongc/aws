# Network - Hướng dẫn toàn diện cho DevOps, SysOps và AWS SAA

## Mục lục

- [Kiến thức cơ bản về mạng](#kiến-thức-cơ-bản-về-mạng)
- [Mô hình OSI và TCP/IP](#mô-hình-osi-và-tcpip)
- [Địa chỉ IP và Subnetting](#địa-chỉ-ip-và-subnetting)
- [DNS (Domain Name System)](#dns-domain-name-system)
- [Giao thức mạng](#giao-thức-mạng)
- [Thiết bị mạng và hạ tầng](#thiết-bị-mạng-và-hạ-tầng)
- [Firewall và Security](#firewall-và-security)
- [Load Balancing](#load-balancing)
- [VPN và Tunneling](#vpn-và-tunneling)
- [SDN (Software-Defined Networking)](#sdn-software-defined-networking)
- [Cloud Networking](#cloud-networking)
  - [AWS Networking](#aws-networking)
  - [Azure Networking](#azure-networking)
  - [GCP Networking](#gcp-networking)
- [Container Networking](#container-networking)
- [Network Monitoring và Troubleshooting](#network-monitoring-và-troubleshooting)
- [Network Automation](#network-automation)
- [Network Security](#network-security)
- [Best Practices](#best-practices)

## Kiến thức cơ bản về mạng

### Khái niệm mạng máy tính

Mạng máy tính là hệ thống các máy tính và thiết bị được kết nối với nhau để chia sẻ tài nguyên và thông tin. Mạng có thể nhỏ như mạng gia đình (LAN) hoặc lớn như Internet toàn cầu (WAN).

### Các loại mạng

1. **LAN (Local Area Network)**: Mạng cục bộ trong phạm vi nhỏ (văn phòng, tòa nhà)
2. **WAN (Wide Area Network)**: Mạng diện rộng kết nối nhiều LAN (Internet là WAN lớn nhất)
3. **MAN (Metropolitan Area Network)**: Mạng đô thị, phạm vi một thành phố
4. **PAN (Personal Area Network)**: Mạng cá nhân (Bluetooth, kết nối thiết bị cá nhân)
5. **CAN (Campus Area Network)**: Mạng trong khuôn viên (trường học, bệnh viện)
6. **SAN (Storage Area Network)**: Mạng lưu trữ chuyên dụng
7. **VLAN (Virtual LAN)**: Mạng LAN ảo tạo từ một mạng vật lý
8. **WLAN (Wireless LAN)**: Mạng LAN không dây

### Topo mạng

1. **Bus**: Tất cả thiết bị kết nối vào một đường truyền chính (backbone)
2. **Star**: Tất cả thiết bị kết nối vào một thiết bị trung tâm (hub/switch)
3. **Ring**: Thiết bị kết nối thành vòng tròn, dữ liệu truyền theo một chiều
4. **Mesh**: Mỗi thiết bị kết nối trực tiếp với nhiều/tất cả thiết bị khác
   - **Full mesh**: Mọi node kết nối với tất cả node khác
   - **Partial mesh**: Chỉ một số node kết nối với nhau
5. **Tree/Hierarchical**: Cấu trúc phân cấp như cây
6. **Hybrid**: Kết hợp nhiều topo khác nhau

## Mô hình OSI và TCP/IP

### Mô hình OSI (Open Systems Interconnection)

Mô hình 7 tầng giúp hiểu cách dữ liệu được truyền qua mạng:

1. **Physical (Vật lý)**: Truyền bit qua môi trường vật lý (dây, sóng radio)

   - Thiết bị: Cable, hub, repeater
   - Đơn vị dữ liệu: Bits
   - Giao thức: Ethernet, USB, Bluetooth physical specs

2. **Data Link (Liên kết dữ liệu)**: Kết nối tin cậy giữa hai node kề nhau

   - Chia làm hai lớp con: MAC (Media Access Control) và LLC (Logical Link Control)
   - Thiết bị: Switch, bridge
   - Đơn vị dữ liệu: Frame
   - Giao thức: Ethernet, PPP, HDLC, ATM

3. **Network (Mạng)**: Định tuyến và chuyển tiếp gói tin giữa các mạng

   - Thiết bị: Router
   - Đơn vị dữ liệu: Packet
   - Giao thức: IP, ICMP, OSPF, BGP

4. **Transport (Vận chuyển)**: End-to-end connection, phân đoạn dữ liệu

   - Đơn vị dữ liệu: Segment
   - Giao thức: TCP, UDP, SCTP

5. **Session (Phiên)**: Quản lý phiên kết nối giữa các ứng dụng

   - Giao thức: NetBIOS, RPC, PPTP

6. **Presentation (Trình diễn)**: Biến đổi dữ liệu giữa các format khác nhau

   - Mã hóa, nén dữ liệu
   - Giao thức: SSL/TLS, JPEG, MPEG

7. **Application (Ứng dụng)**: Giao diện với user và ứng dụng
   - Giao thức: HTTP, SMTP, FTP, DNS, DHCP

### Mô hình TCP/IP

Mô hình 4 tầng được sử dụng phổ biến trong thực tế:

1. **Link Layer**: Tương đương tầng Physical và Data Link của OSI

   - Giao thức: Ethernet, ARP, NDP

2. **Internet Layer**: Tương đương Network layer của OSI

   - Giao thức: IPv4, IPv6, ICMP

3. **Transport Layer**: Tương đương Transport layer của OSI

   - Giao thức: TCP, UDP

4. **Application Layer**: Gộp Session, Presentation, Application của OSI
   - Giao thức: HTTP, SMTP, FTP, DNS, SSH, TLS/SSL

### So sánh OSI và TCP/IP

| OSI                     | TCP/IP                     |
| ----------------------- | -------------------------- |
| 7 tầng lý thuyết        | 4 tầng thực tế             |
| Phát triển trước        | Phát triển sau, chuẩn hóa  |
| Tách biệt các chức năng | Gộp các chức năng tương tự |
| Ít được triển khai      | Triển khai rộng rãi        |

### Quá trình đóng gói dữ liệu

1. **Dữ liệu** (Application layer)
2. **+ Header** = **Segment** (Transport layer)
3. **+ IP Header** = **Packet** (Network layer)
4. **+ Frame Header & Footer** = **Frame** (Data link layer)
5. **Bit stream** (Physical layer)

## Địa chỉ IP và Subnetting

### Địa chỉ IPv4

- Dài 32 bit, biểu diễn dạng thập phân với 4 octet (x.x.x.x)
- Mỗi octet có giá trị từ 0-255
- Ví dụ: 192.168.1.1

#### Các lớp địa chỉ IPv4:

| Lớp | Dải     | Dạng    | Mặt nạ mặc định     | Số mạng    | Số host/mạng |
| --- | ------- | ------- | ------------------- | ---------- | ------------ |
| A   | 1-126   | N.H.H.H | /8 (255.0.0.0)      | 126        | 16,777,214   |
| B   | 128-191 | N.N.H.H | /16 (255.255.0.0)   | 16,384     | 65,534       |
| C   | 192-223 | N.N.N.H | /24 (255.255.255.0) | 2,097,152  | 254          |
| D   | 224-239 | N/A     | N/A                 | Multicast  | N/A          |
| E   | 240-255 | N/A     | N/A                 | Dành riêng | N/A          |

**Chú ý**: 127.x.x.x là loopback address

#### Địa chỉ IP đặc biệt:

- **Địa chỉ mạng**: Octet cuối = 0 (192.168.1.0)
- **Địa chỉ broadcast**: Octet cuối = 255 (192.168.1.255)
- **Địa chỉ Private**:
  - Lớp A: 10.0.0.0 - 10.255.255.255
  - Lớp B: 172.16.0.0 - 172.31.255.255
  - Lớp C: 192.168.0.0 - 192.168.255.255
- **Loopback**: 127.0.0.0 - 127.255.255.255 (thường dùng 127.0.0.1)
- **APIPA**: 169.254.0.0 - 169.254.255.255

### Địa chỉ IPv6

- Dài 128 bit, biểu diễn dạng hex với 8 nhóm, mỗi nhóm 4 hex digit
- Ví dụ: 2001:0db8:85a3:0000:0000:8a2e:0370:7334
- Rút gọn: Bỏ các số 0 đứng đầu và thay chuỗi 0 liên tiếp bằng ::
  - 2001:db8:85a3::8a2e:370:7334

#### Loại địa chỉ IPv6:

- **Unicast**: Địa chỉ của một interface
  - **Global Unicast**: Tương đương Public IPv4
  - **Link-Local**: Tự động cấu hình, bắt đầu với fe80::/10
  - **Unique Local**: Tương đương Private IPv4, bắt đầu với fc00::/7
- **Multicast**: Địa chỉ cho nhóm interface, bắt đầu với ff00::/8
- **Anycast**: Địa chỉ cho nhóm interface, gói tin được gửi đến interface gần nhất

### Subnetting

Subnetting là quá trình chia một mạng lớn thành nhiều mạng con nhỏ hơn.

#### Subnet Mask

Là một dãy bit 1 liên tiếp từ trái sang phải, theo sau là các bit 0.

- Ví dụ: 255.255.255.0 = 11111111.11111111.11111111.00000000
- Biểu diễn CIDR: /24 = 24 bit 1

#### CIDR (Classless Inter-Domain Routing)

Phương pháp đánh địa chỉ không theo lớp, sử dụng prefix để chỉ số bit mạng.

- Ví dụ: 192.168.1.0/24
  - 192.168.1.0 là địa chỉ mạng
  - /24 chỉ 24 bit đầu là phần mạng (network prefix)

#### Cách tính subnet:

1. **Số subnet**: 2^n (n là số bit mượn từ host)
2. **Số host/subnet**: 2^m - 2 (m là số bit host còn lại, trừ 2 vì loại bỏ địa chỉ mạng và broadcast)
3. **Block size/Subnet increment**: 2^(32-prefix)
   - Ví dụ: /24 có block size = 2^(32-24) = 2^8 = 256

#### Ví dụ subnet:

Chia 192.168.1.0/24 thành 4 subnet:

1. Số bit cần mượn: 2 (vì 2^2 = 4 subnet)
2. Prefix mới: /26 (24 + 2)
3. Subnet mask mới: 255.255.255.192
4. Block size: 2^(32-26) = 2^6 = 64
5. Các subnet:
   - 192.168.1.0/26 (0-63)
   - 192.168.1.64/26 (64-127)
   - 192.168.1.128/26 (128-191)
   - 192.168.1.192/26 (192-255)

#### VLSM (Variable Length Subnet Mask)

Kỹ thuật cho phép sử dụng subnet mask có độ dài khác nhau trong cùng một mạng để tối ưu hóa việc sử dụng địa chỉ IP.

## DNS (Domain Name System)

### Tổng quan về DNS

DNS là hệ thống phân giải tên miền, chuyển đổi tên miền (dễ nhớ) sang địa chỉ IP (dạng số) và ngược lại.

### Cấu trúc DNS

1. **Root nameserver**: Đỉnh của hệ thống DNS (13 root server)
2. **TLD (Top-Level Domain) nameserver**: Quản lý .com, .org, .net, .vn,...
3. **Authoritative nameserver**: Chứa thông tin về domain cụ thể
4. **Recursive resolver**: Thực hiện truy vấn cho client

### Các loại bản ghi DNS

- **A**: Maps domain name to IPv4 address
- **AAAA**: Maps domain name to IPv6 address
- **CNAME**: Canonical name (alias) for a domain
- **MX**: Mail exchange server for the domain
- **TXT**: Text information (often used for verification)
- **NS**: Nameserver for the domain
- **SOA**: Start of Authority - chứa thông tin quản lý zone
- **PTR**: Pointer record (reverse DNS)
- **SRV**: Service record - xác định service và port
- **CAA**: Certificate Authority Authorization

### Quá trình phân giải DNS

1. Client yêu cầu phân giải domain (ví dụ: www.example.com)
2. Nếu recursive resolver không có cache, nó hỏi root nameserver
3. Root nameserver chỉ định TLD nameserver (.com)
4. TLD nameserver chỉ định authoritative nameserver cho example.com
5. Authoritative nameserver cung cấp địa chỉ IP của www.example.com
6. Recursive resolver trả kết quả về cho client
7. Client kết nối đến IP của www.example.com

### DNS caching

- **Browser cache**: DNS cache trong trình duyệt
- **OS cache**: DNS cache trong hệ điều hành
- **Recursive resolver cache**: DNS cache trong resolver
- **TTL (Time To Live)**: Thời gian bản ghi DNS được cache

### DNS bảo mật

- **DNSSEC (DNS Security Extensions)**: Bảo vệ chống DNS spoofing và poisoning
- **DoT (DNS over TLS)**: Mã hóa truy vấn DNS qua TLS
- **DoH (DNS over HTTPS)**: Mã hóa truy vấn DNS qua HTTPS

### DNS troubleshooting

```bash
# Kiểm tra phân giải tên miền
nslookup example.com
dig example.com

# Kiểm tra bản ghi cụ thể
dig example.com MX
dig example.com NS

# Kiểm tra DNS reverse lookup
nslookup 8.8.8.8
dig -x 8.8.8.8

# Kiểm tra DNS server cụ thể
dig @8.8.8.8 example.com
```

## Giao thức mạng

### TCP (Transmission Control Protocol)

Giao thức truyền tin cậy, hướng kết nối.

#### Đặc điểm:

- **Connection-oriented**: Thiết lập kết nối trước khi truyền dữ liệu
- **Reliable**: Đảm bảo dữ liệu đến đúng và đủ
- **Stream-oriented**: Dữ liệu được truyền như một luồng byte
- **Flow control**: Ngăn người gửi quá tải người nhận
- **Congestion control**: Tránh nghẽn mạng

#### TCP 3-way handshake:

1. **SYN**: Client gửi segment với cờ SYN=1, seq=x
2. **SYN-ACK**: Server phản hồi với SYN=1, ACK=1, seq=y, ack=x+1
3. **ACK**: Client gửi ACK=1, seq=x+1, ack=y+1

#### TCP 4-way termination:

1. **FIN**: Bên kết thúc gửi segment với cờ FIN=1
2. **ACK**: Bên còn lại gửi ACK
3. **FIN**: Bên còn lại gửi FIN khi sẵn sàng đóng kết nối
4. **ACK**: Bên đầu tiên gửi ACK

### UDP (User Datagram Protocol)

Giao thức truyền không kết nối, không đảm bảo độ tin cậy.

#### Đặc điểm:

- **Connectionless**: Không cần thiết lập kết nối
- **Unreliable**: Không đảm bảo dữ liệu đến đúng và đủ
- **Datagram-oriented**: Dữ liệu được truyền theo từng datagram độc lập
- **No flow control or congestion control**
- **Faster than TCP**: Ít overhead hơn

#### Khi nào dùng UDP:

- Truyền phát trực tuyến (streaming)
- VoIP, video conference
- DNS queries
- Game online
- Trường hợp cần tốc độ, chấp nhận mất gói

### HTTP/HTTPS (Hypertext Transfer Protocol)

Giao thức truyền tải web content.

#### HTTP:

- **Port**: 80
- **Text-based**: Truyền dữ liệu dạng text
- **Stateless**: Mỗi request độc lập
- **Methods**: GET, POST, PUT, DELETE, PATCH, HEAD, OPTIONS...

#### HTTPS:

- **Port**: 443
- **Secured**: Mã hóa với TLS/SSL
- **Certificate-based**: Sử dụng SSL/TLS certificate
- **Trust chain**: Xác thực qua Certificate Authority (CA)

#### HTTP Status Codes:

- **1xx**: Informational
- **2xx**: Success (200 OK, 201 Created, 204 No Content)
- **3xx**: Redirection (301 Moved Permanently, 302 Found, 304 Not Modified)
- **4xx**: Client Error (400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found)
- **5xx**: Server Error (500 Internal Server Error, 502 Bad Gateway, 503 Service Unavailable)

#### HTTP/2 và HTTP/3:

- **HTTP/2**: Multiplexing, header compression, server push
- **HTTP/3**: Dựa trên QUIC (không TCP), cải thiện hiệu suất mobile và unstable networks

### FTP (File Transfer Protocol)

Giao thức truyền file.

- **Port**: 21 (control), 20 (data) hoặc random port (passive mode)
- **Authentication**: Username/password
- **Modes**: Active và Passive
- **FTPS**: Bảo mật với SSL/TLS
- **SFTP**: File transfer qua SSH

### SMTP, POP3, IMAP (Email Protocols)

- **SMTP (Simple Mail Transfer Protocol)**:
  - **Port**: 25 (unencrypted), 465 (SSL/TLS), 587 (STARTTLS)
  - **Function**: Gửi email
- **POP3 (Post Office Protocol)**:
  - **Port**: 110 (unencrypted), 995 (SSL/TLS)
  - **Function**: Nhận email, tải xuống và xóa khỏi server
- **IMAP (Internet Message Access Protocol)**:
  - **Port**: 143 (unencrypted), 993 (SSL/TLS)
  - **Function**: Nhận email, đồng bộ với server

### SSH (Secure Shell)

Giao thức truy cập từ xa an toàn.

- **Port**: 22
- **Function**: Remote login, command execution, tunneling
- **Authentication**: Password, public key, certificates
- **Features**: Port forwarding, X11 forwarding, SFTP

### DHCP (Dynamic Host Configuration Protocol)

Giao thức cấp phát địa chỉ IP động.

#### DHCP process (DORA):

1. **Discover**: Client broadcasts DHCP discover message
2. **Offer**: DHCP server offers IP configuration
3. **Request**: Client requests the offered IP
4. **Acknowledge**: Server acknowledges and finalizes lease

#### DHCP options:

- **IP address**: Địa chỉ cấp phát cho client
- **Subnet mask**: Mặt nạ mạng
- **Default gateway**: Router gateway
- **DNS servers**: Danh sách DNS server
- **Lease time**: Thời gian thuê IP

### NTP (Network Time Protocol)

Giao thức đồng bộ thời gian.

- **Port**: 123 (UDP)
- **Function**: Đồng bộ đồng hồ giữa các computer systems
- **Stratum**: Phân cấp độ chính xác (stratum 0 là nguồn thời gian chính xác nhất)

### SNMP (Simple Network Management Protocol)

Giao thức quản lý mạng.

- **Port**: 161 (queries), 162 (traps)
- **Versions**: SNMPv1, v2c, v3 (bảo mật nhất)
- **Components**: Manager, agent, MIB (Management Information Base)
- **Operations**: Get, GetNext, GetBulk, Set, Trap, Inform

### TLS/SSL (Transport Layer Security)

Giao thức bảo mật truyền thông.

- **Function**: Mã hóa dữ liệu truyền
- **Handshake process**: Thiết lập kết nối an toàn
- **Certificates**: X.509 certificates, public/private key
- **Versions**: SSL 3.0, TLS 1.0-1.3 (TLS 1.3 là mới và bảo mật nhất)

## Thiết bị mạng và hạ tầng

### Router

Thiết bị định tuyến, chuyển tiếp gói tin giữa các mạng khác nhau.

- **Function**: Chọn đường đi tốt nhất cho gói tin
- **Routing table**: Bảng chứa thông tin đường đi
- **Routing protocols**: RIP, OSPF, EIGRP, BGP
- **Interfaces**: LAN, WAN, wireless
- **Features**: NAT, firewall, QoS, VPN

### Switch

Thiết bị chuyển mạch, chuyển tiếp frame dựa trên địa chỉ MAC.

- **Function**: Kết nối các thiết bị trong cùng mạng LAN
- **MAC table**: Bảng địa chỉ MAC và port tương ứng
- **Types**:
  - **Unmanaged**: Plug and play, không cấu hình được
  - **Managed**: Có thể cấu hình (VLAN, QoS, port mirroring)
  - **Layer 2**: Hoạt động ở tầng Data Link
  - **Layer 3**: Có khả năng định tuyến như router

### Hub

Thiết bị kết nối mạng cơ bản, hiện không còn phổ biến.

- **Function**: Chuyển tiếp tín hiệu đến tất cả cổng (broadcast)
- **Layer**: Hoạt động ở tầng Physical
- **Half-duplex**: Chỉ truyền hoặc nhận tại một thời điểm

### Bridge

Thiết bị kết nối hai segment mạng, lọc frame dựa trên địa chỉ MAC.

- **Function**: Chia mạng LAN thành các segment nhỏ hơn
- **Layer**: Hoạt động ở tầng Data Link

### WAP (Wireless Access Point)

Thiết bị cung cấp kết nối không dây.

- **Function**: Kết nối thiết bị không dây vào mạng có dây
- **Standards**: 802.11a/b/g/n/ac/ax
- **Security**: WEP, WPA, WPA2, WPA3
- **Features**: MIMO, beamforming, band steering

### Modem

Thiết bị chuyển đổi tín hiệu analog/digital.

- **Function**: Kết nối mạng LAN với Internet qua đường điện thoại/cáp
- **Types**: DSL, cable, fiber, satellite
- **Features**: Tích hợp router, switch, WAP (all-in-one)

### Repeater và Range Extender

Thiết bị mở rộng phạm vi tín hiệu.

- **Repeater**: Nhận và phát lại tín hiệu để mở rộng phạm vi
- **Range Extender**: Mở rộng phạm vi mạng WiFi

### Media Converter

Thiết bị chuyển đổi giữa các loại phương tiện truyền dẫn khác nhau.

- **Function**: Chuyển đổi tín hiệu giữa cáp đồng và cáp quang
- **Types**: Single-mode, multi-mode, bi-directional

### Proxy Server

Server đứng giữa client và destination server.

- **Functions**:
  - Caching
  - Filtering
  - Authentication
  - Logging
  - Privacy
- **Types**:
  - Forward proxy: Đại diện cho client
  - Reverse proxy: Đại diện cho server
  - Transparent proxy: Không cần cấu hình client

### Cáp mạng và đầu nối

1. **Twisted Pair Cable**:

   - **UTP (Unshielded Twisted Pair)**: Không có lớp bảo vệ
   - **STP (Shielded Twisted Pair)**: Có lớp bảo vệ chống nhiễu
   - **Categories**: Cat5, Cat5e, Cat6, Cat6a, Cat7, Cat8
   - **Connector**: RJ-45
   - **Max length**: ~100m

2. **Fiber Optic Cable**:

   - **Single-mode**: Đường kính lõi nhỏ, truyền xa
   - **Multi-mode**: Đường kính lõi lớn hơn, truyền gần
   - **Connectors**: LC, SC, ST, FC, MTRJ
   - **Max length**: Single-mode ~10-100km, Multi-mode ~500-2000m

3. **Coaxial Cable**:
   - **Types**: RG-6, RG-59
   - **Connector**: BNC, F-type
   - **Uses**: Cable TV, older Ethernet (10BASE-2, 10BASE-5)

### Rack và Data Center

- **Rack Units (U)**: Đơn vị đo chiều cao thiết bị (1U = 1.75 inch)
- **Rack types**: 2-post, 4-post, cabinet
- **PDU (Power Distribution Unit)**: Cấp nguồn cho thiết bị trong rack
- **Cooling**: In-row cooling, CRAC (Computer Room Air Conditioning)
- **Cable management**: Horizontal, vertical, overhead, under-floor

## Firewall và Security

### Firewall

Hệ thống bảo mật kiểm soát lưu lượng mạng.

#### Loại firewall:

1. **Packet filtering firewall**: Kiểm tra từng gói tin dựa trên header
2. **Stateful firewall**: Theo dõi trạng thái kết nối
3. **Application firewall (proxy firewall)**: Kiểm tra ở tầng ứng dụng
4. **Next-generation firewall (NGFW)**: Kết hợp nhiều tính năng (IPS, application awareness, deep packet inspection)

#### Firewall rules:

- **Source/destination IP**: Địa chỉ nguồn/đích
- **Source/destination port**: Cổng nguồn/đích
- **Protocol**: TCP, UDP, ICMP,...
- **Action**: Allow, deny, drop, log
- **Direction**: Inbound, outbound

#### Network security zones:

- **DMZ (Demilitarized Zone)**: Vùng trung gian giữa mạng nội bộ và internet
- **Trust zone**: Mạng nội bộ, tin cậy
- **Untrust zone**: Internet, không tin cậy

### IDS/IPS (Intrusion Detection/Prevention System)

- **IDS**: Phát hiện xâm nhập, cảnh báo
- **IPS**: Phát hiện và ngăn chặn xâm nhập
- **Types**:
  - **Network-based (NIDS/NIPS)**: Giám sát traffic mạng
  - **Host-based (HIDS/HIPS)**: Giám sát hoạt động trên host
  - **Signature-based**: Dựa trên mẫu tấn công đã biết
  - **Anomaly-based**: Dựa trên hành vi bất thường
  - **Hybrid**: Kết hợp cả signature và anomaly

### WAF (Web Application Firewall)

- **Function**: Bảo vệ web application khỏi các cuộc tấn công
- **Protection**: SQL injection, XSS, CSRF, file inclusion

### DDoS Protection

- **DDoS (Distributed Denial of Service)**: Tấn công từ chối dịch vụ phân tán
- **Protection methods**:
  - Traffic scrubbing
  - Rate limiting
  - Anycast network
  - CDN
  - BGP flowspec

### NAT (Network Address Translation)

Kỹ thuật chuyển đổi địa chỉ IP.

#### Loại NAT:

1. **Static NAT**: 1 IP private map cố định với 1 IP public
2. **Dynamic NAT**: Nhiều IP private chia sẻ pool IP public
3. **PAT (Port Address Translation/NAT Overload)**: Nhiều IP private chia sẻ 1 IP public bằng cách sử dụng port khác nhau
4. **Twice NAT**: Thay đổi cả địa chỉ nguồn và đích
5. **NAT64**: Chuyển đổi giữa IPv6 và IPv4

#### NAT pros and cons:

- **Pros**:
  - Tiết kiệm địa chỉ IPv4
  - Tăng tính bảo mật (ẩn địa chỉ IP nội bộ)
- **Cons**:
  - Phức tạp hóa một số giao thức (FTP, SIP, H.323)
  - Gây khó khăn cho traceability
  - Tạo single point of failure

## Load Balancing

### Tổng quan về Load Balancing

Load balancing là kỹ thuật phân phối tải công việc đều cho nhiều server, tăng khả năng chịu tải và high availability.

### Các thuật toán Load Balancing

1. **Round Robin**: Luân phiên các server theo thứ tự
2. **Weighted Round Robin**: Luân phiên với trọng số ưu tiên
3. **Least Connections**: Chuyển request đến server có ít kết nối nhất
4. **Least Response Time**: Chuyển request đến server đáp ứng nhanh nhất
5. **IP Hash**: Dựa trên hash của IP nguồn để chọn server (session persistence)
6. **URL Hash**: Dựa trên hash của URL để chọn server (content caching)

### Layer 4 vs Layer 7 Load Balancing

1. **Layer 4 (Transport)**: Phân phối dựa trên IP và port

   - Pros: Đơn giản, hiệu năng cao
   - Cons: Không biết nội dung request

2. **Layer 7 (Application)**: Phân phối dựa trên nội dung request (URL, headers, cookies)
   - Pros: Linh hoạt, routing thông minh
   - Cons: Tốn tài nguyên hơn

### Session persistence

- **Source IP**: Duy trì session dựa trên IP nguồn
- **Cookie-based**: Sử dụng cookie để nhận dạng session
- **SSL session ID**: Duy trì session dựa trên SSL session ID

### Health checks

- **TCP check**: Kiểm tra kết nối TCP
- **HTTP check**: Kiểm tra response HTTP
- **Custom script**: Kiểm tra application-specific logic
- **Passive monitoring**: Theo dõi traffic thực tế

### Load balancer types:

1. **Hardware load balancers**: Thiết bị vật lý chuyên dụng (F5, Citrix NetScaler)
2. **Software load balancers**: Phần mềm (HAProxy, NGINX, Apache)
3. **Cloud load balancers**: Dịch vụ cloud (AWS ELB, Azure Load Balancer, GCP Load Balancing)

### High availability cho load balancer

- **Active-Passive**: Một load balancer chính, một dự phòng
- **Active-Active**: Nhiều load balancer hoạt động đồng thời
- **Floating IP/Virtual IP**: IP ảo di chuyển giữa các load balancer

## VPN và Tunneling

### Tổng quan về VPN

VPN (Virtual Private Network) là công nghệ tạo kết nối riêng tư và an toàn qua mạng công cộng (Internet).

### Loại VPN

1. **Remote Access VPN**: Cho phép user từ xa kết nối vào mạng nội bộ
2. **Site-to-Site VPN**: Kết nối hai mạng riêng qua Internet
   - **Intranet VPN**: Kết nối các mạng nội bộ trong cùng công ty
   - **Extranet VPN**: Kết nối mạng công ty với đối tác

### VPN Protocols

1. **IPsec (Internet Protocol Security)**:

   - **Modes**: Transport mode, Tunnel mode
   - **Components**: Authentication Header (AH), Encapsulating Security Payload (ESP)
   - **Key exchange**: IKE (Internet Key Exchange)

2. **SSL/TLS VPN**:

   - **Types**: Portal VPN, Tunnel VPN
   - **Pros**: Không cần client riêng, hoạt động trên HTTPS (port 443)

3. **OpenVPN**:

   - **Port**: Linh hoạt (thường là 1194)
   - **Encryption**: Sử dụng OpenSSL
   - **Modes**: Layer 2 or Layer 3

4. **WireGuard**:

   - **Modern**: Mã nguồn mở, hiệu năng cao
   - **Simple**: Code base nhỏ gọn
   - **Secure**: Cryptography mới nhất

5. **PPTP (Point-to-Point Tunneling Protocol)**:

   - **Port**: TCP 1723
   - **Note**: Legacy protocol, không còn an toàn

6. **L2TP/IPsec (Layer 2 Tunneling Protocol)**:
   - **Port**: UDP 1701, 500, 4500
   - **Security**: L2TP (không mã hóa) + IPsec (bảo mật)

### VPN Topologies

1. **Hub-and-Spoke**: Một site trung tâm kết nối nhiều site nhỏ
2. **Full mesh**: Mọi site kết nối trực tiếp với nhau
3. **Partial mesh**: Chỉ một số site kết nối trực tiếp với nhau

### Tunneling Protocols

1. **GRE (Generic Routing Encapsulation)**:

   - Giao thức tunneling đơn giản, không mã hóa
   - Cho phép encapsulate nhiều protocol layer 3

2. **VXLAN (Virtual Extensible LAN)**:

   - Mở rộng VLAN qua layer 3
   - Sử dụng UDP encapsulation
   - VXLAN Network Identifier (VNI): 24-bit (hỗ trợ 16 triệu VXLAN)

3. **MPLS (Multiprotocol Label Switching)**:
   - Chuyển tiếp gói tin dựa trên labels
   - Hỗ trợ Traffic Engineering
   - Label Distribution Protocol (LDP)

### SDN Tunneling

1. **VXLAN**: Layer 2 overlay trên Layer 3
2. **NVGRE**: Network Virtualization using GRE
3. **STT**: Stateless Transport Tunneling
4. **Geneve**: Generic Network Virtualization Encapsulation

## SDN (Software-Defined Networking)

### Tổng quan về SDN

SDN tách biệt control plane và data plane, cho phép quản lý mạng tập trung và lập trình được.

### Kiến trúc SDN

1. **Application Layer**: SDN Applications
2. **Control Layer**: SDN Controller
3. **Infrastructure Layer**: Network Devices (switches, routers)

### SDN Components

1. **Controller**: Phần mềm điều khiển trung tâm

   - **Southbound Interface**: Giao tiếp với thiết bị mạng
   - **Northbound Interface**: Giao tiếp với applications
   - **East/West Interface**: Giao tiếp giữa các controller

2. **OpenFlow**: Giao thức giao tiếp giữa controller và switches

   - **Flow tables**: Các quy tắc xử lý gói tin
   - **Match fields**: Các trường để so sánh (source/dest IP, ports, etc.)
   - **Actions**: Các hành động (forward, drop, modify)

3. **Network Function Virtualization (NFV)**: Ảo hóa các network functions

### SDN Controllers

1. **Open Source**:

   - OpenDaylight
   - ONOS (Open Network Operating System)
   - Ryu
   - Floodlight

2. **Commercial**:
   - Cisco ACI
   - VMware NSX
   - Juniper Contrail
   - Nokia Nuage

### SDN Use Cases

1. **Data Center Networking**: Tự động hóa, tối ưu hóa
2. **Network Virtualization**: Tạo nhiều mạng ảo trên cùng hạ tầng vật lý
3. **Security**: Microsegmentation, policy-based security
4. **Traffic Engineering**: Kiểm soát luồng traffic
5. **Service Chaining**: Liên kết các network services

## Cloud Networking

### Cloud Network Basics

1. **Virtual Network**: Mạng ảo trong cloud
2. **Subnet**: Phân đoạn mạng ảo
3. **Network Interface**: Kết nối VM đến mạng ảo
4. **Security Group**: Firewall rules cho resources
5. **ACL (Access Control List)**: Kiểm soát traffic ở subnet level
6. **VPC Peering**: Kết nối các VPC với nhau
7. **Transit Gateway/Virtual Network Gateway**: Hub kết nối nhiều VPC

### Hybrid Cloud Networking

1. **Site-to-Site VPN**: Kết nối mạng on-premises với cloud
2. **Direct Connect/ExpressRoute/Cloud Interconnect**: Kết nối riêng, độ trễ thấp
3. **Transit VPC/VNet**: Hub trung gian kết nối nhiều VPC và on-premises

### AWS Networking

1. **VPC (Virtual Private Cloud)**:

   - Mạng ảo riêng trong AWS
   - CIDR block: Dải địa chỉ IP cho VPC
   - Subnet: Public/Private, AZ-specific

2. **Internet Gateway**: Cho phép resources trong VPC access internet

3. **NAT Gateway**: Cho phép resources trong private subnet access internet

4. **Route Tables**: Điều khiển traffic giữa subnets

5. **Security Groups**: Stateful firewall cho instances

   - Inbound/outbound rules
   - Stateful (track connections)

6. **Network ACLs**: Stateless firewall cho subnets

   - Inbound/outbound rules
   - Stateless (không track connections)

7. **VPC Peering**: Kết nối hai VPC

   - Non-transitive

8. **Transit Gateway**: Hub kết nối nhiều VPC và on-premises

   - Transitive routing

9. **Direct Connect**: Dedicated connection từ on-premises đến AWS

   - Private VIF: Kết nối đến VPC
   - Public VIF: Kết nối đến AWS public services
   - Transit VIF: Kết nối đến Transit Gateway

10. **AWS Global Accelerator**: Cải thiện performance cho global users

    - Anycast IP addresses
    - Edge location routing

11. **Route 53 (DNS)**:

    - Domain registration
    - DNS routing
    - Health checking

12. **CloudFront (CDN)**:
    - Content caching
    - Edge locations
    - Origin servers

### Azure Networking

1. **VNet (Virtual Network)**:

   - Mạng ảo riêng trong Azure
   - Address space: Dải địa chỉ IP cho VNet

2. **Subnet**: Phân đoạn của VNet

3. **Network Security Group (NSG)**: Firewall rules

   - Applied to subnet or NIC
   - Inbound/outbound rules

4. **Application Security Group (ASG)**: Logical grouping của VMs

5. **VNet Peering**: Kết nối hai VNet

   - Global peering (cross-region)

6. **Virtual Network Gateway**: VPN gateway

   - Site-to-site VPN
   - Point-to-site VPN
   - VNet-to-VNet connection

7. **ExpressRoute**: Dedicated connection từ on-premises đến Azure

   - Private peering
   - Microsoft peering

8. **Azure Front Door**: Global load balancer

   - HTTP/HTTPS routing
   - Web Application Firewall

9. **Azure CDN**: Content delivery network

10. **Azure DNS**: Domain hosting

11. **Azure Firewall**: Managed firewall service

    - Stateful
    - Threat intelligence
    - FQDN filtering

12. **Azure Private Link**: Private access to Azure PaaS services

### GCP Networking

1. **VPC (Virtual Private Cloud)**:

   - Global resource
   - Auto mode/custom mode

2. **Subnets**: Regional resources

3. **Firewall Rules**: Control traffic

   - Direction
   - Priority
   - Action (allow/deny)

4. **VPC Peering**: Connect VPCs

   - Non-transitive

5. **Shared VPC**: Share VPC across projects

6. **Cloud VPN**: Connect on-premises to GCP

   - Classic VPN
   - HA VPN

7. **Cloud Interconnect**: Dedicated connection

   - Dedicated Interconnect
   - Partner Interconnect

8. **Cloud Load Balancing**:

   - Global/regional
   - External/internal
   - HTTP(S)/TCP/UDP

9. **Cloud CDN**: Content delivery

10. **Cloud DNS**: Domain management

11. **Network Service Tiers**:

    - Premium: Google's global network
    - Standard: ISP networks

12. **Cloud Armor**: DDoS protection and WAF

## Container Networking

### Docker Networking

1. **Bridge**: Default network driver

   - Internal private network
   - NAT for internet access

2. **Host**: Container uses host's network stack

   - No network isolation
   - Direct access to host's interfaces

3. **Overlay**: Multi-host networking

   - Container-to-container across hosts
   - Uses VXLAN

4. **Macvlan**: Container gets own MAC address

   - Appears as physical device on network
   - Direct access to physical network

5. **None**: Disable networking

### Kubernetes Networking

1. **Pod Networking**:

   - Every Pod gets unique IP
   - Pods on same node can communicate directly
   - Pods on different nodes can communicate without NAT

2. **Service**:

   - Stable endpoint for Pods
   - Types: ClusterIP, NodePort, LoadBalancer, ExternalName
   - kube-proxy implements Services using iptables/IPVS

3. **Ingress**:

   - HTTP/HTTPS routing to Services
   - Path-based, host-based routing
   - TLS termination

4. **Network Policies**:

   - Pod-level firewall rules
   - Namespace isolation
   - Policy enforcement by CNI plugin

5. **CNI (Container Network Interface)**:
   - Standardized interface for network plugins
   - Popular implementations:
     - Calico: Network policy, BGP routing
     - Flannel: Simple overlay network
     - Cilium: eBPF-based networking and security
     - Weave: Mesh network
     - AWS VPC CNI: Use AWS VPC networking
     - Azure CNI: Use Azure VNet

### Service Mesh

1. **Concept**: Infrastructure layer for microservices communication

   - Service-to-service communication
   - Traffic management
   - Security
   - Observability

2. **Implementations**:

   - Istio
   - Linkerd
   - Consul Connect
   - AWS App Mesh
   - Azure Service Fabric Mesh

3. **Components**:

   - **Control Plane**: Centralized management
   - **Data Plane**: Proxies (usually Envoy) alongside each service
   - **Sidecar Pattern**: Proxy container in each Pod

4. **Features**:
   - Traffic routing and splitting
   - Retries, circuit breaking
   - TLS encryption
   - mTLS authentication
   - Authorization policies
   - Metrics collection
   - Distributed tracing

## Network Monitoring và Troubleshooting

### Network Monitoring Tools

1. **SNMP-based tools**:

   - Nagios
   - Zabbix
   - PRTG
   - Cacti
   - LibreNMS

2. **Flow-based monitoring**:

   - NetFlow (Cisco)
   - sFlow
   - IPFIX
   - JFlow (Juniper)
   - Flow analyzers: nTop, ntopng

3. **Log analysis**:

   - ELK Stack (Elasticsearch, Logstash, Kibana)
   - Graylog
   - Splunk

4. **Packet analyzers**:

   - Wireshark
   - tcpdump
   - TShark

5. **APM (Application Performance Monitoring)**:
   - New Relic
   - AppDynamics
   - Dynatrace

### Metrics to monitor

1. **Availability/reachability**:

   - Uptime
   - Ping response time
   - Packet loss

2. **Performance**:

   - Bandwidth utilization
   - Throughput
   - Latency
   - Jitter

3. **Errors**:

   - Interface errors
   - Packet drops
   - Retransmissions
   - CRC errors

4. **Application-specific**:
   - HTTP response time
   - DNS resolution time
   - Database query time

### Troubleshooting methodology

1. **Define the problem**: Xác định vấn đề chính xác
2. **Gather information**: Thu thập thông tin và logs
3. **Analyze data**: Phân tích data để tìm root cause
4. **Plan solution**: Lập kế hoạch khắc phục
5. **Implement solution**: Thực hiện giải pháp
6. **Verify solution**: Kiểm tra vấn đề đã được giải quyết
7. **Document**: Ghi lại vấn đề và giải pháp

### Troubleshooting tools

1. **Basic tools**:

   - ping: Test connectivity
   - traceroute/tracert: Display route to destination
   - nslookup/dig: DNS lookup
   - ipconfig/ifconfig/ip: View network configuration
   - netstat/ss: View network connections
   - route: View routing table

2. **Advanced tools**:
   - mtr: Combine ping and traceroute
   - iperf: Measure bandwidth
   - nmap: Port scanning, network discovery
   - tcpdump/Wireshark: Packet capture
   - netcat (nc): Network utility for reading/writing to connections

### Common issues and solutions

1. **Connectivity issues**:

   - Check physical connection
   - Verify IP configuration
   - Check routing table
   - Test with ping/traceroute
   - Verify firewall rules

2. **Performance issues**:

   - Check bandwidth utilization
   - Look for packet loss
   - Analyze network congestion
   - Check for duplex mismatch
   - Verify QoS settings

3. **DNS issues**:

   - Verify DNS server configuration
   - Check DNS records
   - Test with nslookup/dig
   - Check for DNS cache issues

4. **Routing issues**:
   - Verify routing tables
   - Check for asymmetric routing
   - Test with traceroute
   - Verify routing protocol operation

## Network Automation

### Network Automation Basics

1. **Benefits**:

   - Consistency and standardization
   - Reduced human error
   - Faster deployment
   - Scalability
   - Version control

2. **Automation types**:
   - Configuration management
   - Compliance verification
   - Monitoring and reporting
   - Provisioning and deployment
   - Remediation

### Configuration Management Tools

1. **Ansible**:

   - Agentless (uses SSH)
   - YAML-based playbooks
   - Network modules for various vendors
   - Simple, easy to learn

2. **Puppet**:

   - Agent-based (requires puppet agent)
   - Uses Puppet DSL
   - Declarative approach
   - Strong for policy enforcement

3. **Chef**:

   - Agent-based
   - Ruby-based recipes
   - Procedural approach
   - Good for complex configurations

4. **SaltStack**:
   - Agent-based (minions)
   - YAML-based states
   - Event-driven architecture
   - Good for real-time execution

### Infrastructure as Code (IaC)

1. **Terraform**:

   - Multi-cloud support
   - HCL (HashiCorp Configuration Language)
   - Declarative approach
   - State management

2. **AWS CloudFormation**:

   - YAML/JSON templates
   - AWS-specific
   - Nested stacks
   - Change sets

3. **Azure ARM Templates**:

   - JSON templates
   - Azure-specific
   - Deployment modes (incremental/complete)

4. **Google Cloud Deployment Manager**:
   - YAML templates
   - GCP-specific
   - Jinja2/Python templates

### Network Programming and APIs

1. **RESTful APIs**:

   - HTTP-based
   - JSON/XML data format
   - CRUD operations
   - Stateless

2. **NETCONF**:

   - XML-based
   - Connection-oriented (SSH)
   - Configuration datastores
   - YANG data modeling

3. **RESTCONF**:

   - HTTP-based
   - Subset of NETCONF
   - JSON/XML data format
   - YANG data modeling

4. **gRPC**:
   - High performance RPC framework
   - Protocol Buffers
   - Bidirectional streaming
   - Used in OpenConfig

### Network Programmability Tools

1. **Python libraries**:

   - Netmiko: SSH connection handling
   - NAPALM: Network automation abstraction
   - Paramiko: SSH implementation
   - PyEZ: Junos automation
   - ncclient: NETCONF client

2. **SDKs**:

   - Cisco DevNet
   - AWS SDK
   - Azure SDK
   - GCP SDK

3. **Postman**: API testing and documentation

4. **curl/HTTPie**: Command-line HTTP clients

### CI/CD for Network Automation

1. **CI/CD tools**:

   - Jenkins
   - GitLab CI/CD
   - GitHub Actions
   - CircleCI
   - Azure DevOps Pipelines

2. **Network CI/CD process**:
   - Configuration validation
   - Syntax checking
   - Test in lab environment
   - Automated deployment
   - Post-deployment verification

## Network Security

### Security Framework

1. **Defense in depth**: Multiple layers of security
2. **Least privilege**: Grant minimum access needed
3. **Segregation of duties**: Split critical tasks among individuals
4. **Zero trust**: "Never trust, always verify"

### Network Security Controls

1. **Perimeter security**:

   - Firewall
   - IDS/IPS
   - DMZ
   - Proxy servers

2. **Network segmentation**:

   - VLANs
   - Zones
   - Microsegmentation
   - Internal firewalls

3. **Access control**:

   - ACLs
   - NAC (Network Access Control)
   - 802.1X authentication
   - Role-based access

4. **Encryption**:
   - TLS/SSL
   - IPsec
   - MACsec (802.1AE)
   - VPNs

### Common Network Attacks

1. **Reconnaissance**:

   - Port scanning
   - Network mapping
   - OS fingerprinting
   - Packet sniffing

2. **Access attacks**:

   - Brute force
   - Password cracking
   - Social engineering
   - Phishing

3. **DoS/DDoS attacks**:

   - Volumetric attacks
   - Protocol attacks
   - Application layer attacks
   - Amplification attacks

4. **Man-in-the-Middle (MITM)**:

   - ARP poisoning
   - DNS spoofing
   - SSL stripping
   - Session hijacking

5. **Wireless attacks**:
   - Evil twin
   - Rogue AP
   - WPA cracking
   - Deauthentication attack

### Security Assessment

1. **Vulnerability scanning**:

   - Nessus
   - OpenVAS
   - Qualys
   - Nmap scripts

2. **Penetration testing**:

   - Kali Linux
   - Metasploit
   - Burp Suite
   - OWASP ZAP

3. **Security auditing**:

   - Configuration review
   - Compliance checking
   - Log analysis
   - Security controls assessment

4. **Security monitoring**:
   - SIEM (Security Information and Event Management)
   - SOC (Security Operations Center)
   - Threat hunting
   - User and Entity Behavior Analytics (UEBA)

### Secure Network Design

1. **Secure architecture**:

   - Segmentation
   - Redundancy
   - Defense in depth
   - Single points of failure elimination

2. **Secure configuration**:

   - Hardening guidelines
   - Disable unused services
   - Change default credentials
   - Role-based administration

3. **Patch management**:

   - Regular updates
   - Vulnerability assessment
   - Change control
   - Testing before deployment

4. **Security policies**:
   - Acceptable use policy
   - Remote access policy
   - Incident response plan
   - Disaster recovery plan

## Best Practices

### Network Design Best Practices

1. **Hierarchical design**:

   - Access, distribution, core layers
   - Modularity
   - Scalability

2. **High availability**:

   - Redundant paths
   - No single points of failure
   - Load balancing
   - Failover mechanisms

3. **Scalability**:

   - Room for growth
   - Modular design
   - Standardized configurations
   - Avoid design limitations

4. **Manageability**:
   - Consistent naming conventions
   - Documentation
   - Network management systems
   - Monitoring and alerting

### Network Security Best Practices

1. **Defense in depth**:

   - Multiple security layers
   - Overlapping controls
   - Complementary technologies

2. **Regular updates**:

   - Firmware updates
   - Security patches
   - Known vulnerability remediation

3. **Strong authentication**:

   - Multi-factor authentication
   - Certificate-based authentication
   - Strong password policies
   - AAA (Authentication, Authorization, Accounting)

4. **Continuous monitoring**:
   - Real-time alerts
   - Log analysis
   - Behavioral analysis
   - Security incident response

### Network Management Best Practices

1. **Documentation**:

   - Network diagrams
   - IP addressing scheme
   - Configuration standards
   - Change logs

2. **Change management**:

   - Approval process
   - Testing procedures
   - Rollback plans
   - Scheduled maintenance windows

3. **Monitoring and alerting**:

   - Performance baselines
   - Capacity planning
   - Trend analysis
   - Proactive alerting

4. **Disaster recovery**:
   - Backup configurations
   - Recovery procedures
   - Regular testing
   - RTO/RPO objectives

### Cloud Networking Best Practices

1. **Well-Architected Framework**:

   - Security
   - Reliability
   - Performance efficiency
   - Cost optimization
   - Operational excellence

2. **Multi-AZ/Multi-Region**:

   - Geo-redundancy
   - Disaster recovery
   - Failover testing

3. **Least privilege**:

   - Minimize permissions
   - Just-in-time access
   - Regular access review

4. **Network isolation**:
   - Private subnets
   - Security groups/NACLs
   - VPC endpoints/Private Link
   - Transit Gateway/Hub-and-Spoke
