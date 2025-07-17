Khi **Network Load Balancer (NLB)** có **một IP tĩnh cho mỗi Availability Zone (AZ)**, việc **DNS trỏ vào** hoạt động như sau trong thực tế:

---

### **Cách DNS trỏ đến NLB với nhiều IP tĩnh**
- **Mỗi AZ của NLB có một IP tĩnh**, nhưng:
  - **Tên DNS của NLB** (ví dụ: `my-nlb-123456.elb.amazonaws.com`) được thiết lập để trỏ đến **tất cả các IP tĩnh của NLB trong mọi AZ**.
  - Khi client thực hiện truy vấn DNS, hệ thống DNS sẽ trả về danh sách các IP tĩnh (mỗi IP tương ứng với một AZ).

---

### **Ví dụ thực tế:**
#### **1. NLB được triển khai trong 3 AZ:**
- **IP tĩnh của NLB:**
  - AZ A: `192.0.2.10`
  - AZ B: `192.0.2.20`
  - AZ C: `192.0.2.30`
- **Tên DNS của NLB**: `my-nlb-123456.elb.amazonaws.com`

#### **2. DNS động trả về danh sách các IP tĩnh:**
- Khi client thực hiện truy vấn đến DNS của NLB, câu trả lời sẽ là:
```
  my-nlb-123456.elb.amazonaws.com:
  - 192.0.2.10
  - 192.0.2.20
  - 192.0.2.30
```

---

### **So sánh với ALB:**
| **Đặc điểm**              | **NLB (IP tĩnh)**                          | **ALB (DNS động)**                      |
|---------------------------|--------------------------------------------|-----------------------------------------|
| **IP cố định mỗi AZ**     | Có (mỗi AZ có một IP tĩnh)                 | Không (DNS tự động cập nhật IP động)    |
| **DNS trả về**            | Danh sách IP tĩnh (toàn bộ AZ)             | Một hoặc nhiều IP động                  |
| **Client chọn IP**        | Client tự chọn IP từ danh sách trả về       | Client tự động sử dụng DNS động         |
| **Tương thích firewall**  | Dễ cấu hình với IP tĩnh                    | Phải kết hợp NLB hoặc AWS Global Accelerator để có IP cố định |
| **Giao thức hỗ trợ**       | TCP/UDP                                   | HTTP/HTTPS                             |




- DNS động của alb nghĩa là tên miền (ví dụ: my-load-balancer-123456.elb.amazonaws.com) không trỏ đến một địa chỉ IP cố định. Thay vào đó, AWS có thể cập nhật địa chỉ IP động phía sau tên miền tùy vào tình trạng hoạt động của các AZ hoặc backend instances.
---

### **Khi nào sử dụng NLB với IP tĩnh và DNS?**
- Bạn cần **IP tĩnh cố định** để:
  - Cấu hình whitelist trên firewall.
  - Hỗ trợ các ứng dụng không thể sử dụng DNS động.
- Yêu cầu xử lý lưu lượng tầng 4 (TCP/UDP) với độ trễ thấp.

---

### **Lưu ý:**
1. **Client thông minh sẽ tự xử lý lỗi (failover):**
   - Nếu một AZ hoặc IP tĩnh không khả dụng, client sẽ thử các IP khác trong danh sách DNS.
2. **Route 53 nâng cao khả năng kiểm soát DNS:**
   - Bạn có thể cấu hình **Route 53 Health Checks** để loại bỏ IP của AZ không khả dụng ra khỏi bản ghi DNS trả về.
