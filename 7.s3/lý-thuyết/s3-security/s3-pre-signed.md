### **Giải thích Amazon S3 Pre-signed URLs**

**Pre-signed URL** là một cách **tạm thời cấp quyền truy cập** đến các file trong bucket S3 mà vẫn đảm bảo bucket không bị công khai hoàn toàn. Cụ thể, đây là cách bạn có thể hiểu và hình dung quy trình hoạt động:
 GlacierVaultLock-objectLock.md
---

### **1. Cách hoạt động**

#### **a. Tạo URL**
- **Người sở hữu bucket hoặc người dùng có quyền** sẽ sử dụng:
  - AWS Console
  - AWS CLI
  - AWS SDK (ví dụ: Python Boto3 hoặc Java SDK)

- Tạo một URL có thông tin sau:
  - Địa chỉ file trên S3.
  - Quyền thực hiện hành động (`GET` hoặc `PUT`).
  - Thời gian hết hạn (Expiration time):
    - Tối đa 12 giờ khi dùng **Console**.
    - Tối đa 168 giờ (7 ngày) khi dùng **CLI hoặc SDK**.

---

#### **b. Chia sẻ URL**
- Sau khi URL được tạo, bạn gửi nó đến người mà bạn muốn cấp quyền truy cập.

---

#### **c. Người dùng truy cập**
- Người nhận URL sẽ dùng nó để:
  - **Tải file xuống** (`GET`).
  - **Tải file lên** (`PUT`) vào một vị trí cụ thể trong bucket.

- URL này hoạt động nhờ:
  - Chữ ký số (digital signature) xác thực quyền truy cập.
  - Các quyền của người tạo URL.

---

### **2. Tại sao không bị công khai?**
- Bucket vẫn **giữ trạng thái private**. 
- Quyền truy cập chỉ được cấp qua URL và chỉ trong thời gian giới hạn.

---

### **3. Hình dung qua ví dụ**

#### **Tình huống 1: Tải file xuống (GET)**

1. Bạn là quản trị viên, có một file **`video.mp4`** trong bucket **`my-private-bucket`**.
2. Bạn không muốn công khai bucket nhưng cần gửi video này cho một khách hàng.
3. Bạn tạo một **pre-signed URL** cho file **`video.mp4`** và thiết lập thời gian hết hạn là 24 giờ.
4. Gửi URL này cho khách hàng:
   - Họ chỉ cần nhấp vào URL để tải file.
   - URL hết hạn sau 24 giờ, khách hàng không thể dùng nó sau thời gian này.

#### **Tình huống 2: Tải file lên (PUT)**

1. Bạn quản lý một trang web cho phép người dùng tải ảnh hồ sơ lên S3.
2. Bạn muốn giới hạn quyền:
   - Mỗi người dùng chỉ được tải file ảnh của họ vào một vị trí cụ thể.
   - Không được tải vào các vị trí khác hoặc truy cập file khác.
3. Tạo **pre-signed URL** cho mỗi người dùng với quyền `PUT`.
4. Khi họ tải ảnh qua URL này:
   - File được lưu đúng vị trí bạn định sẵn.
   - Bucket vẫn ở trạng thái private.

---

### **4. Lợi ích của Pre-signed URL**
1. **Bảo mật**:
   - Bucket không bị công khai.
   - Chỉ người có URL mới truy cập được file.

2. **Kiểm soát thời gian**:
   - Giới hạn thời gian truy cập.
   - URL hết hạn tự động sau thời gian thiết lập.

3. **Linh hoạt**:
   - Dùng URL để cấp quyền tạm thời, không cần thay đổi cấu hình bucket hoặc IAM policies.

---

### **5. Ứng dụng thực tế**
- **Cung cấp file premium**:
  - Ví dụ: Chỉ cho phép người dùng đã đăng nhập tải video khóa học.
- **Tải file lên động**:
  - Ví dụ: Cho phép người dùng tải file lên thư mục riêng của họ trong bucket.
- **Tạm thời cấp quyền**:
  - Ví dụ: Cấp quyền cho nhà thầu tải file từ bucket trong một thời gian ngắn.

---

### **6. Lưu ý**
- **Thời gian hết hạn ngắn**: Nên đặt thời gian hợp lý, đủ cho người dùng nhưng không quá dài để tránh lạm dụng.
- **Quản lý quyền**: Người tạo URL cần có quyền truy cập file (qua IAM).
- **Không chia sẻ URL công khai**: URL chứa thông tin nhạy cảm, nên chỉ gửi cho đúng người nhận.

---
