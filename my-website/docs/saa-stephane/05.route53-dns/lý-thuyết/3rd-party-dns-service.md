
### 1. **Domain Registrar** (Nhà đăng ký tên miền)
- **Chức năng:** Nhà đăng ký tên miền là công ty mà bạn mua tên miền từ đó (ví dụ: GoDaddy, Google Domains).
- **Chi phí:** Bạn sẽ phải trả phí hàng năm để duy trì tên miền của mình.
- **Ví dụ:** Bạn có thể đăng ký tên miền với Amazon Registrar hoặc bất kỳ nhà đăng ký nào khác.

### 2. **DNS Service** (Dịch vụ DNS)
- **Chức năng:** DNS là hệ thống giúp ánh xạ tên miền (như example.com) tới các địa chỉ IP của máy chủ.
- Khi bạn mua tên miền từ nhà đăng ký, họ thường cung cấp dịch vụ DNS đi kèm để bạn có thể quản lý các bản ghi DNS cho tên miền của mình (ví dụ: bản ghi A, CNAME, MX, v.v.).
- **Amazon Route 53:** Đây là dịch vụ DNS của Amazon, có thể dùng để quản lý bản ghi DNS dù bạn đã mua tên miền từ nhà đăng ký nào.

### 3. **Kết hợp sử dụng Domain Registrar và DNS Service**
- Bạn có thể mua tên miền từ nhà đăng ký (ví dụ: GoDaddy) nhưng vẫn sử dụng Amazon Route 53 để quản lý bản ghi DNS cho tên miền của bạn.
- Để làm điều này, bạn cần tạo một **Hosted Zone** (Khu vực lưu trữ) công khai trên Amazon Route 53 cho tên miền của mình, sau đó thay đổi **NS records** (bản ghi Name Server) trên trang web của nhà đăng ký (GoDaddy) để trỏ đến các máy chủ tên của Amazon Route 53.

### 4. **Quy trình cài đặt**
- **Bước 1:** Đăng ký tên miền với một nhà đăng ký tên miền (ví dụ: GoDaddy).
- **Bước 2:** Truy cập Amazon Route 53 và tạo một Hosted Zone công khai cho tên miền của bạn.
- **Bước 3:** Trong thông tin của Hosted Zone, bạn sẽ nhận được 4 máy chủ tên (Name Servers) của Amazon Route 53.
- **Bước 4:** Truy cập trang quản lý tên miền của bạn (GoDaddy) và thay đổi bản ghi **NS** để trỏ về các máy chủ tên của Amazon Route 53.
- **Bước 5:** Sau khi thay đổi bản ghi, bạn sẽ có thể sử dụng Amazon Route 53 để quản lý DNS cho tên miền đã đăng ký.

### 5. **Tóm tắt:**
- **Domain Registrar** là nơi bạn đăng ký tên miền.
- **DNS Service** là dịch vụ giúp bạn quản lý bản ghi DNS cho tên miền của mình.
- Bạn có thể đăng ký tên miền ở bất kỳ nhà đăng ký nào, nhưng vẫn sử dụng Route 53 của Amazon để quản lý DNS cho tên miền đó.

### 6. **Lưu ý:**
- Mặc dù các nhà đăng ký tên miền thường cung cấp dịch vụ DNS, bạn vẫn có thể sử dụng dịch vụ DNS của bên thứ ba (như Route 53) để có nhiều tính năng hơn hoặc dễ dàng quản lý tên miền của mình.

