

### **Kiến thức chính**
1. **Amazon S3 và hosting website tĩnh**:
   - S3 hỗ trợ lưu trữ và truy cập website tĩnh thông qua URL.
   - URL của website phụ thuộc vào **region** và cấu hình, có thể chứa **dấu gạch ngang (-)** hoặc **dấu chấm (.)**.

2. **Cách cấu hình hosting trên S3**:
   - Tạo một **bucket** chứa các file của website (HTML, hình ảnh, CSS).
   - Bật tính năng hosting cho website tĩnh trong cấu hình bucket.

3. **Quyền truy cập công khai (Public Access)**:
   - Nếu không bật quyền **public reads**, người dùng sẽ gặp lỗi **403 Forbidden** khi truy cập.
   - Để khắc phục, cần cấu hình **bucket policy** cho phép truy cập công khai.

4. **Cấu trúc URL**:
   - URL được tự động tạo bởi AWS sau khi hosting được kích hoạt.
   - Dạng URL khác nhau giữa các khu vực nhưng chức năng tương tự.

---

### **Lý do lỗi thường gặp**
- Nếu sau khi cấu hình, website vẫn không thể truy cập được, khả năng cao là bucket chưa được bật chế độ công khai.
- Phải kiểm tra và gắn **bucket policy** để đảm bảo quyền truy cập.

---

### **Hướng dẫn thực hành tiếp theo**
1. Tạo bucket và upload file HTML cơ bản.
2. Kích hoạt tính năng **static website hosting**.
3. Cập nhật **bucket policy** để cho phép quyền truy cập công khai.
4. Kiểm tra URL để đảm bảo website hoạt động đúng cách.

