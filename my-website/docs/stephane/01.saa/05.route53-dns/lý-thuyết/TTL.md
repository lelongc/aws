### TTL (Time To Live) trong Bản Ghi DNS

#### TTL là gì?
- **Định nghĩa**: TTL là một giá trị tính bằng giây, xác định thời gian mà một bản ghi DNS được lưu trữ trong bộ nhớ đệm (cache) của máy khách hoặc các bộ phân giải trung gian.
- **Mục đích**: Giảm tải truy vấn DNS, cải thiện hiệu suất bằng cách tái sử dụng kết quả đã lưu trữ.

---

#### TTL Hoạt Động Như Thế Nào?
1. **Ví dụ Truy Vấn DNS**:
   - Máy khách gửi yêu cầu DNS tới `myapp.example.com`.
   - DNS phản hồi với:
     - **Bản ghi A**: Chỉ định địa chỉ IP (ví dụ: `192.0.2.1`).
     - **TTL**: Yêu cầu máy khách lưu trữ kết quả trong một khoảng thời gian nhất định (ví dụ: 300 giây).

2. **Hành Vi của Máy Khách**:
   - Trong thời gian TTL:
     - Sử dụng kết quả được lưu trong bộ nhớ đệm.
     - Không gửi lại truy vấn DNS, giảm tải và độ trễ.
   - Sau khi TTL hết hạn:
     - Bộ nhớ đệm bị xóa.
     - Máy khách gửi truy vấn mới tới máy chủ DNS để lấy thông tin cập nhật.

---

#### Ưu và Nhược Điểm của TTL:

| Giá trị TTL      | Ưu điểm                                        | Nhược điểm                                             |
|-------------------|------------------------------------------------|-------------------------------------------------------|
| **TTL Cao**       | - Giảm truy vấn DNS → Giảm chi phí DNS. <br> - Cải thiện tốc độ nhờ tái sử dụng kết quả trong cache. | - Kết quả có thể bị lỗi thời. <br> - Cần thời gian lâu hơn để thay đổi được cập nhật (ví dụ: đổi IP). |
| **TTL Thấp**      | - Bản ghi được cập nhật nhanh chóng. <br> - Phù hợp với các bản ghi thường xuyên thay đổi. | - Tăng số lượng truy vấn DNS → Tăng chi phí. <br> - Có thể làm tăng độ trễ nhẹ. |

---

#### Chiến Lược TTL Thực Tế:
1. **Trước Khi Thay Đổi Bản Ghi**:
   - Giảm TTL xuống giá trị nhỏ hơn (ví dụ: 60 giây) trước đó (ví dụ: 24 giờ).
   - Đảm bảo các thay đổi được cập nhật nhanh hơn.

2. **Sau Khi Thay Đổi Bản Ghi**:
   - Khôi phục TTL về giá trị cao hơn sau khi cập nhật để giảm tải và chi phí.

---

#### Quy Trình Minh Họa TTL:
1. **Tạo Một Bản Ghi DNS**:
   - Ví dụ: `demo.stephanetheteacher.com` với bản ghi A trỏ tới một instance EC2.
   - TTL: Đặt thành 120 giây (2 phút).

2. **Truy Vấn Bản Ghi**:
   - Sử dụng các lệnh như `nslookup` hoặc `dig` để kiểm tra phản hồi DNS.
   - Quan sát giá trị TTL giảm dần mỗi lần truy vấn cho đến khi về 0.

3. **Thay Đổi Bản Ghi**:
   - Thay đổi địa chỉ IP (ví dụ: sang instance ở vùng khác).
   - Kết quả được lưu trong bộ nhớ đệm vẫn tồn tại cho đến khi TTL hết hạn.
   - Sau khi hết TTL, truy vấn mới sẽ lấy được địa chỉ IP mới.

---

#### Lưu Ý Quan Trọng:
- TTL là **bắt buộc** đối với tất cả các bản ghi DNS ngoại trừ bản ghi Alias.
- Quản lý TTL hiệu quả giúp cân bằng giữa:
  - Lưu lượng truy vấn DNS và chi phí.
  - Tốc độ phản hồi khi thay đổi bản ghi.