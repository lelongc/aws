**Network File System (NFS)** là một giao thức mạng cho phép người dùng chia sẻ tệp tin và thư mục trên các hệ thống máy tính qua mạng. Được phát triển bởi **Sun Microsystems** vào năm 1984, NFS là một trong những giao thức chia sẻ tệp phổ biến nhất hiện nay, đặc biệt trên các hệ thống **UNIX** và **Linux**.

### **Các đặc điểm chính của NFS**:
1. **Chia sẻ tài nguyên qua mạng**:
   - Người dùng trên một máy tính có thể truy cập và sử dụng các tệp, thư mục được chia sẻ từ một máy tính khác giống như chúng được lưu trữ cục bộ.

2. **Hoạt động trên mạng TCP/IP**:
   - NFS sử dụng giao thức TCP/IP để truyền dữ liệu qua mạng, đảm bảo tính tương thích và hiệu quả trong truyền tải.

3. **Tương thích đa hệ thống**:
   - Hỗ trợ nhiều hệ điều hành khác nhau như Linux, UNIX, macOS, và các phiên bản Windows thông qua các phần mềm tương thích.

4. **Mô hình Client-Server**:
   - Máy chủ (Server) lưu trữ các tài nguyên chia sẻ.
   - Máy khách (Client) gửi yêu cầu để truy cập vào các tài nguyên này.

5. **Hoạt động với cơ chế ánh xạ tệp**:
   - Sử dụng hệ thống ánh xạ để liên kết các thư mục và tệp từ máy chủ sang máy khách, cho phép máy khách xử lý tài nguyên từ xa như tài nguyên cục bộ.

---

### **Lợi ích của NFS**:
- **Chia sẻ tài nguyên linh hoạt**: Dễ dàng chia sẻ tệp tin và thư mục trên mạng.
- **Tiết kiệm tài nguyên**: Tập trung dữ liệu trên một máy chủ thay vì phân tán dữ liệu trên nhiều máy.
- **Quản lý tập trung**: Quản lý quyền truy cập và bảo mật từ một nơi duy nhất.

---

### **Cách hoạt động của NFS**:
1. **Cấu hình máy chủ (Server)**:
   - Máy chủ cần cấu hình để xuất (export) các thư mục hoặc tệp mà nó muốn chia sẻ.
2. **Kết nối máy khách (Client)**:
   - Máy khách cần gắn kết (mount) các thư mục hoặc tệp được chia sẻ từ máy chủ vào hệ thống tệp của mình.

---

### **Phiên bản NFS**:
Hiện nay, NFS có các phiên bản chính:
1. **NFSv2**: Phiên bản đầu tiên, hỗ trợ các giao dịch cơ bản.
2. **NFSv3**: Cải thiện hiệu năng và hỗ trợ tệp lớn hơn 2GB.
3. **NFSv4**: Tăng cường bảo mật (hỗ trợ Kerberos), giảm độ trễ, và hỗ trợ tốt hơn cho mạng Internet.

---

### **Ứng dụng của NFS**:
- Lưu trữ dữ liệu cho các máy trạm (workstation).
- Chia sẻ tệp và thư mục giữa các máy chủ trong hệ thống doanh nghiệp.
- Tích hợp trong các hệ thống lưu trữ đám mây hoặc trung tâm dữ liệu.

