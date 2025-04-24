**Sao chép S3 (S3 Replication) và Đối tượng được mã hóa**

- Khi bạn bật tính năng Sao chép S3 từ một bucket nguồn sang một bucket đích, các đối tượng trong bucket nguồn sẽ được sao chép tự động sang bucket đích theo cấu hình của bạn.

**Cách Xử lý các Loại Mã hóa Khác Nhau khi Sao chép:**

- **Đối tượng KHÔNG được mã hóa (Unencrypted objects):** Sẽ được sao chép theo **mặc định**.
- **Đối tượng được mã hóa bằng SSE-S3:** Sẽ được sao chép theo **mặc định**. AWS quản lý khóa và quá trình mã hóa/giải mã.
- **Đối tượng được mã hóa bằng SSE-C (dùng khóa do khách hàng cung cấp):** Cũng **có thể** được sao chép.
- **Đối tượng được mã hóa bằng SSE-KMS:** Đây là trường hợp đặc biệt.
  - Theo **mặc định, chúng SẼ KHÔNG được sao chép**.
  - Bạn cần **bật tùy chọn cụ thể** trong cấu hình Sao chép để cho phép sao chép các đối tượng SSE-KMS.
  - Khi bật tùy chọn này, bạn cần chỉ định **Khóa KMS đích (target KMS Key)** mà bạn muốn sử dụng để mã hóa các đối tượng trong bucket đích. Khóa này có thể khác hoặc giống với khóa nguồn.
  - Quá trình sao chép đối tượng SSE-KMS diễn ra như sau:
    1.  Dịch vụ S3 Replication cần quyền để **giải mã dữ liệu** trong bucket nguồn (sử dụng khóa KMS nguồn).
    2.  Sau đó, dịch vụ S3 Replication **mã hóa lại dữ liệu** trong bucket đích (sử dụng Khóa KMS đích bạn đã chỉ định).
  - Để S3 Replication có thể thực hiện việc giải mã ở nguồn và mã hóa lại ở đích, bạn cần:
    - Điều chỉnh **Chính sách Khóa KMS (KMS Key Policy)** cho **khóa KMS đích** để cho phép dịch vụ S3 Replication sử dụng nó.
    - Tạo một **Vai trò IAM (IAM Role)** cho dịch vụ S3 Replication. Vai trò này phải có các quyền cần thiết để gọi API giải mã (decrypt) trên khóa nguồn và gọi API mã hóa (encrypt) trên khóa đích.

**Vấn đề tiềm ẩn và Giải pháp:**

- Bởi vì quá trình sao chép đối tượng SSE-KMS liên quan đến nhiều hoạt động giải mã và mã hóa thông qua dịch vụ KMS, bạn có thể gặp phải **lỗi giới hạn (throttling errors)** của KMS nếu số lượng yêu cầu quá lớn.
- Nếu gặp lỗi này, bạn cần **yêu cầu tăng hạn mức dịch vụ (service quotas)** cho AWS KMS.

**Khóa KMS Đa Vùng (Multi-Region Key) với Sao chép S3:**

- Tài liệu của AWS có nói rằng bạn **có thể sử dụng Khóa KMS Đa Vùng** cho Sao chép S3.
- Tuy nhiên, **tại thời điểm nội dung này được tạo ra**: dịch vụ S3 vẫn xử lý các Khóa KMS Đa Vùng cho mục đích sao chép như thể chúng là các khóa **độc lập**.
- **Điều này có nghĩa là:** Ngay cả khi bạn sử dụng cùng một ID Khóa KMS Đa Vùng cho cả khóa nguồn và khóa đích trong cấu hình sao chép, đối tượng vẫn sẽ trải qua quá trình **giải mã** hoàn toàn ở Vùng nguồn và sau đó **mã hóa lại** hoàn toàn ở Vùng đích bằng khóa đích (có cùng ID Multi-Region Key). Quá trình sao chép S3 **không tận dụng được lợi thế** của Khóa KMS Đa Vùng là có cùng vật liệu khóa và ID để tránh quá trình giải mã/mã hóa lại này _trong bản thân quy trình sao chép S3_. (Nghĩa là, lợi ích "không cần mã hóa lại khi di chuyển dữ liệu" của Multi-Region Key không áp dụng cho _cách S3 Replication xử lý_ đối tượng SSE-KMS tại thời điểm đó).

Tóm lại, nội dung giải thích cách S3 Replication xử lý các loại mã hóa khác nhau, đặc biệt làm nổi bật sự phức tạp (và yêu cầu cấu hình bổ sung) khi sao chép các đối tượng được mã hóa bằng SSE-KMS, và lưu ý về cách S3 Replication hiện tại xử lý Khóa KMS Đa Vùng (không tận dụng được khả năng tránh mã hóa lại trong quy trình sao chép S3).
