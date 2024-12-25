### **Phân Biệt Địa Chỉ IP Private và Public trong IPv4**

Trong mạng máy tính, địa chỉ IP là yếu tố quan trọng để định danh thiết bị và hỗ trợ giao tiếp giữa chúng. Bài viết này sẽ giúp bạn hiểu rõ sự khác biệt giữa **địa chỉ IP private** và **địa chỉ IP public** trong IPv4, cùng các khái niệm liên quan như Elastic IP và các thực tiễn thiết kế mạng tốt nhất.

---

### **1. Các Loại Địa Chỉ IP**
#### **IPv4 vs IPv6**
- **IPv4 (Internet Protocol Version 4):**
  - Ví dụ: `1.160.10.240`
  - Định dạng: Bốn số thập phân từ `0-255`, ngăn cách bằng dấu chấm.
  - Tổng số địa chỉ: Khoảng 3,7 tỷ địa chỉ duy nhất trong không gian công cộng.
  - IPv4 vẫn là giao thức phổ biến nhất hiện nay dù IPv6 đã ra đời.
  
- **IPv6 (Internet Protocol Version 6):**
  - Ví dụ: `3ffe:1900:4545:3:200:f8ff:fe21:67cf`
  - Giao thức mới, khắc phục hạn chế của IPv4, đặc biệt hữu ích cho Internet vạn vật (IoT).
  - Cung cấp không gian địa chỉ cực kỳ lớn và hiệu suất tốt hơn.

> **Lưu ý:** Bài viết này tập trung vào IPv4, giao thức được sử dụng phổ biến hiện nay.

---

### **2. Địa Chỉ Public IP Là Gì?**
- **Public IP** là địa chỉ duy nhất trên toàn cầu, cho phép các thiết bị được nhận diện trực tiếp trên internet.

#### **Đặc Điểm**:
- Phải **duy nhất** trên toàn bộ internet.
- Thiết bị có Public IP có thể giao tiếp trực tiếp qua web (ví dụ: website, máy chủ email).
- Public IP có thể được **định vị địa lý** (geo-located), giúp xác định vị trí vật lý của thiết bị.

#### **Ví Dụ**:
- Cổng internet (Internet Gateway): `149.140.72.10`
- Máy chủ web: `79.216.59.75`

#### **Ứng Dụng Chính**:
- Lưu trữ website hoặc dịch vụ công khai.
- Kết nối các dịch vụ cloud yêu cầu danh tính ngoài mạng.

---

### **3. Địa Chỉ Private IP Là Gì?**
- **Private IP** là địa chỉ sử dụng trong mạng nội bộ và không thể truy cập trực tiếp từ internet.

#### **Đặc Điểm**:
- Phải **duy nhất** trong mạng nội bộ mà nó được sử dụng.
- Các thiết bị dùng Private IP cần **Network Address Translation (NAT)** và **cổng internet** để giao tiếp với internet.
- Phạm vi Private IP được quy định sẵn và không được dùng làm Public IP:
  - `192.168.0.0 - 192.168.255.255`
  - `10.0.0.0 - 10.255.255.255`
  - `172.16.0.0 - 172.31.255.255`

#### **Ứng Dụng Chính**:
- Giao tiếp nội bộ trong công ty, gia đình.
- Tăng cường bảo mật bằng cách cô lập thiết bị khỏi internet công khai.

**Ví Dụ Thực Tế**:
- **Công ty A** và **Công ty B** có thể cùng sử dụng dải địa chỉ `192.168.0.1/22` trong mạng nội bộ của họ mà không gây xung đột, vì các mạng này được tách biệt.

---

### **4. Elastic IP trong AWS**
Trong môi trường cloud như AWS, Elastic IP giúp quản lý địa chỉ Public IP linh hoạt và đáng tin cậy.

#### **Elastic IP Là Gì?**
- Elastic IP là một địa chỉ **Public IPv4 cố định** mà bạn sở hữu trong tài khoản AWS.
  
#### **Đặc Điểm Chính**:
- Giữ nguyên ngay cả khi bạn tắt và khởi động lại máy ảo (EC2).
- Có thể chuyển nhanh Elastic IP sang một máy ảo khác khi cần (để khắc phục lỗi).
- Giới hạn: Mỗi tài khoản AWS chỉ được cấp **5 Elastic IP** (có thể yêu cầu tăng thêm).

#### **Thực Tiễn Tốt Nhất**:
- Hạn chế sử dụng Elastic IP:
  - Sử dụng nhiều Elastic IP thường là dấu hiệu của thiết kế mạng không tối ưu.
  - **Thay thế tốt hơn**:
    - Sử dụng IP công khai ngẫu nhiên và liên kết nó với tên miền DNS.
    - Sử dụng **Load Balancer** để phân phối lưu lượng, không cần Public IP trực tiếp.

---

### **5. So Sánh Địa Chỉ Public IP và Private IP**

| **Yếu Tố**           | **Public IP**                              | **Private IP**                             |
|-----------------------|--------------------------------------------|--------------------------------------------|
| **Khả năng truy cập** | Truy cập trực tiếp trên internet           | Chỉ truy cập trong mạng nội bộ             |
| **Tính duy nhất**     | Duy nhất trên toàn bộ internet             | Duy nhất trong mạng nội bộ                 |
| **Ứng dụng**          | Website, máy chủ, dịch vụ cloud            | Thiết bị nội bộ như máy in, máy tính       |
| **Định vị địa lý**    | Có thể định vị                             | Không thể định vị                          |
| **Giao tiếp**         | Giao tiếp trực tiếp qua web                | Cần NAT và internet Gateway                |

---


### . **So sánh các loại IP và chi phí:**
| **Loại Public IP**                                 | **Trước 1/2/2024** | **Từ 1/2/2024**     | **Ghi chú**                                                                                     |
|----------------------------------------------------|---------------------|----------------------|------------------------------------------------------------------------------------------------|
| Amazon Provided Public IPv4 (tự động cấp)         | Miễn phí            | $0.005/giờ           | IP tự động cấp sẽ bị tính phí.                                                                |
| Elastic IP bổ sung trên EC2 đang chạy              | $0.005/giờ          | $0.005/giờ           | Không thay đổi. Chỉ tính phí với các Elastic IP thứ 2 trở lên trên cùng một instance.         |
| Elastic IP không sử dụng (Idle)                    | $0.005/giờ          | $0.005/giờ           | Không thay đổi. Elastic IP không gắn vào instance nào sẽ bị tính phí.                         |

---

### **6. Lời Khuyên Thực Tế**
- **Lựa chọn đúng loại IP**:
  - Sử dụng **Private IP** cho các thiết bị và ứng dụng nội bộ.
  - Chỉ gán **Public IP** khi cần truy cập từ bên ngoài.
  
- **Tối ưu hóa thiết kế cloud**:
  - Hạn chế sử dụng Elastic IP; ưu tiên sử dụng tên miền DNS và Load Balancer.
  
- **Bảo mật là trên hết**:
  - Giữ các mạng nội bộ tách biệt và cấu hình tường lửa hợp lý.
  - Giám sát thường xuyên các dịch vụ công khai để phát hiện lỗ hổng bảo mật.

---

Hiểu rõ sự khác biệt giữa Private IP và Public IP giúp bạn thiết kế mạng hiệu quả, an toàn và mở rộng tốt hơn. Dù là quản trị mạng nội bộ hay triển khai dịch vụ trên cloud, những kiến thức này là nền tảng quan trọng!