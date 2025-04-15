![alt text](../image/policy-multi-values.png)
**Tóm tắt nội dung: Chính sách định tuyến Multi-Value trong Amazon Route 53**

### **Khái niệm chính**

1. **Mục đích của định tuyến Multi-Value**:  
   - Định tuyến lưu lượng truy cập đến nhiều tài nguyên cùng lúc.  
   - Trả về nhiều giá trị hoặc tài nguyên trong phản hồi truy vấn.

2. **Tích hợp Health Check (kiểm tra sức khỏe)**:  
   - Đảm bảo chỉ trả về các tài nguyên "khỏe mạnh".  
   - Hỗ trợ tối đa 8 bản ghi "khỏe mạnh" cho mỗi truy vấn.
   - Multi-Value Policy chỉ trả về các bản ghi có trạng thái "khỏe mạnh" dựa trên kết quả của Health Check.

3. **Load Balancing phía client**:  
   - Đóng vai trò như một cơ chế cân bằng tải đơn giản, nơi client chọn một tài nguyên "khỏe mạnh".  
   - Không thay thế cho ELB (Elastic Load Balancer).

---

### **Ví dụ triển khai**

- **Kịch bản**:
  - Tạo nhiều `A Record` cho `example.com`.  
  - Mỗi bản ghi được liên kết với một Health Check và có TTL (Time-to-Live) là 60 giây.

- **Các bản ghi được tạo**:
  1. **Khu vực US**:  
     - Liên kết với `us-east-1`.  
     - Chính sách định tuyến: Multi-Value.  
     - Health Check: `us-east-1`.  

  2. **Khu vực Asia**:  
     - Liên kết với `ap-southeast-1`.  
     - Chính sách định tuyến: Multi-Value.  
     - Health Check: `ap-southeast-1`.  

  3. **Khu vực EU**:  
     - Liên kết với `eu-central-1`.  
     - Chính sách định tuyến: Multi-Value.  
     - Health Check: `eu-central-1`.  

---

### **Quá trình kiểm tra**

1. **Truy vấn ban đầu**:  
   - Sử dụng lệnh `dig` để kiểm tra.  
   - Nhận được 3 địa chỉ IP vì tất cả các Health Checks đều "khỏe mạnh".  

2. **Tạo trạng thái không "khỏe mạnh"**:  
   - Làm một Health Check không "khỏe mạnh" (ví dụ: `eu-central-1`).  
   - Kết quả: Chỉ nhận lại 2 địa chỉ IP từ truy vấn, thể hiện Multi-Value hoạt động tốt.

3. **Khôi phục trạng thái "khỏe mạnh"**:  
   - Chỉnh sửa Health Check để khôi phục.  
   - Truy vấn lại sẽ trả về đầy đủ các bản ghi.

---

### **Kết luận**
- Chính sách Multi-Value hữu ích khi cần đảm bảo chỉ trả về các tài nguyên "khỏe mạnh".  
- Tích hợp Health Check mang lại sự tin cậy cao hơn so với các chính sách định tuyến khác như Simple Routing(k hỗ trợ health check).  