# Mã Hóa Đối Xứng và Bất Đối Xứng

Mã hóa là nền tảng của bảo mật dữ liệu trong môi trường đám mây. Có hai loại mã hóa chính được sử dụng rộng rãi: mã hóa đối xứng (symmetric) và mã hóa bất đối xứng (asymmetric). Bài viết này sẽ giải thích chi tiết hai phương pháp này và ứng dụng của chúng trong AWS.

## Mã Hóa Đối Xứng (Symmetric Encryption)

### Khái Niệm

Mã hóa đối xứng sử dụng **cùng một khóa** cho cả hai quá trình mã hóa và giải mã dữ liệu. Điều này có nghĩa rằng bất kỳ ai có khóa đều có thể mã hóa và giải mã thông tin.

### Quy Trình Hoạt Động

1. **Tạo khóa**: Một khóa mã hóa duy nhất được tạo ra
2. **Mã hóa**: Dữ liệu gốc (plaintext) được kết hợp với khóa thông qua thuật toán mã hóa để tạo ra dữ liệu đã mã hóa (ciphertext)
3. **Truyền tải**: Cả dữ liệu đã mã hóa và khóa cần được truyền đi (qua các kênh khác nhau để đảm bảo an toàn)
4. **Giải mã**: Người nhận sử dụng cùng khóa để giải mã dữ liệu về trạng thái ban đầu

![Mã hóa đối xứng](https://example.com/symmetric-encryption.png)

### Thuật Toán Phổ Biến

- **AES (Advanced Encryption Standard)**: Sử dụng khóa 128, 192 hoặc 256 bit
- **DES (Data Encryption Standard)**: Thuật toán cũ hơn với khóa 56 bit (hiện nay ít được sử dụng do không còn bảo mật)
- **3DES (Triple DES)**: Phiên bản mở rộng của DES
- **Blowfish**: Thuật toán mã hóa nhanh với khóa có độ dài thay đổi

### Ưu Điểm

- **Tốc độ nhanh**: Mã hóa và giải mã nhanh hơn so với mã hóa bất đối xứng
- **Hiệu quả với dữ liệu lớn**: Phù hợp cho việc mã hóa các tập tin và dữ liệu lớn
- **Ít tài nguyên**: Yêu cầu ít công suất tính toán hơn

### Nhược Điểm

- **Vấn đề phân phối khóa**: Cần có cơ chế bảo mật để chia sẻ khóa
- **Số lượng khóa lớn**: Trong môi trường nhiều người dùng, số lượng khóa cần quản lý có thể tăng nhanh

## Mã Hóa Bất Đối Xứng (Asymmetric Encryption)

### Khái Niệm

Mã hóa bất đối xứng sử dụng **cặp khóa** - một khóa công khai (public key) và một khóa riêng tư (private key). Dữ liệu được mã hóa bằng khóa công khai chỉ có thể được giải mã bằng khóa riêng tư tương ứng.

### Quy Trình Hoạt Động

1. **Tạo cặp khóa**: Hệ thống tạo một cặp khóa công khai và khóa riêng tư
2. **Chia sẻ khóa công khai**: Khóa công khai được chia sẻ rộng rãi với bất kỳ ai muốn gửi dữ liệu mã hóa
3. **Mã hóa**: Người gửi sử dụng khóa công khai để mã hóa thông điệp
4. **Giải mã**: Chỉ người sở hữu khóa riêng tư mới có thể giải mã thông điệp

![Mã hóa bất đối xứng](https://example.com/asymmetric-encryption.png)

### Thuật Toán Phổ Biến

- **RSA (Rivest–Shamir–Adleman)**: Thuật toán phổ biến nhất, sử dụng khóa có độ dài từ 1024 đến 4096 bit
- **ECC (Elliptic Curve Cryptography)**: Sử dụng toán học đường cong elliptic, cung cấp bảo mật tương đương RSA với khóa ngắn hơn
- **Diffie-Hellman**: Thường dùng để trao đổi khóa an toàn qua kênh không bảo mật
- **DSA (Digital Signature Algorithm)**: Thường dùng cho chữ ký số

### Ưu Điểm

- **Không cần chia sẻ khóa bí mật**: Khóa công khai có thể được chia sẻ tự do
- **Xác thực nguồn gốc**: Hỗ trợ chữ ký số để xác minh danh tính người gửi
- **Bảo mật cao**: Khó phá vỡ hơn so với mã hóa đối xứng khi sử dụng khóa đủ dài

### Nhược Điểm

- **Chậm hơn**: Quá trình mã hóa và giải mã đòi hỏi nhiều tài nguyên tính toán hơn
- **Không hiệu quả với dữ liệu lớn**: Không phù hợp để mã hóa lượng dữ liệu lớn

## So Sánh Hai Phương Pháp

| Tiêu Chí       | Mã Hóa Đối Xứng                | Mã Hóa Bất Đối Xứng                |
| -------------- | ------------------------------ | ---------------------------------- |
| Khóa sử dụng   | Một khóa duy nhất              | Cặp khóa (công khai/riêng tư)      |
| Tốc độ         | Nhanh                          | Chậm hơn                           |
| Mức độ bảo mật | Cao (nếu khóa được bảo vệ tốt) | Rất cao                            |
| Phù hợp với    | Mã hóa lượng dữ liệu lớn       | Trao đổi khóa, xác thực, chữ ký số |
| Độ phức tạp    | Đơn giản                       | Phức tạp hơn                       |
| Vấn đề chính   | Phân phối khóa an toàn         | Tính toán phức tạp                 |

## Mã Hóa Lai (Hybrid Encryption)

Trong thực tế, nhiều hệ thống sử dụng phương pháp mã hóa lai, kết hợp ưu điểm của cả hai phương pháp:

1. Sử dụng mã hóa bất đối xứng để trao đổi khóa đối xứng an toàn
2. Sử dụng mã hóa đối xứng với khóa đã trao đổi để mã hóa dữ liệu thực tế

Mã hóa lai được sử dụng rộng rãi trong các giao thức như TLS/SSL, bảo mật email, và nhiều ứng dụng bảo mật khác.

## Ứng Dụng Trong AWS

### AWS KMS (Key Management Service)

AWS KMS sử dụng cả hai loại mã hóa:

- **Customer Master Keys (CMKs)**: Các khóa gốc được bảo vệ bằng cả mã hóa đối xứng và bất đối xứng
- **Data Keys**: Khóa đối xứng được sử dụng để mã hóa dữ liệu thực tế

### Mã Hóa Trong S3

- **SSE-S3**: Sử dụng mã hóa đối xứng với khóa do AWS quản lý
- **SSE-KMS**: Kết hợp AWS KMS và mã hóa đối xứng
- **SSE-C**: Sử dụng khóa đối xứng do khách hàng cung cấp

### Mã Hóa Trong CloudFront và SSL/TLS

- Sử dụng mã hóa lai thông qua giao thức TLS
- Chứng chỉ SSL sử dụng mã hóa bất đối xứng để thiết lập kết nối an toàn

### VPN và Mã Hóa Truyền Tải

- AWS Site-to-Site VPN sử dụng IPsec, một giao thức sử dụng cả mã hóa đối xứng và bất đối xứng
- Diffie-Hellman thường được sử dụng để trao đổi khóa an toàn trong thiết lập VPN

## Các Tiêu Chuẩn và Quy Định

Khi triển khai mã hóa trong AWS, cần tuân thủ các tiêu chuẩn và quy định về bảo mật như:

- **FIPS 140-2/140-3**: Tiêu chuẩn về mô-đun mã hóa
- **PCI DSS**: Yêu cầu mã hóa dữ liệu thẻ thanh toán
- **HIPAA**: Yêu cầu mã hóa thông tin y tế
- **GDPR**: Khuyến nghị mã hóa dữ liệu cá nhân

## Tóm Tắt

- **Mã hóa đối xứng**: Nhanh, hiệu quả cho dữ liệu lớn, nhưng có thách thức trong việc phân phối khóa an toàn
- **Mã hóa bất đối xứng**: An toàn cao, không cần chia sẻ khóa bí mật, nhưng chậm hơn và tốn tài nguyên hơn
- **Mã hóa lai**: Kết hợp ưu điểm của cả hai phương pháp, là giải pháp phổ biến trong các ứng dụng thực tế

Hiểu rõ về các phương pháp mã hóa này sẽ giúp bạn lựa chọn phương pháp bảo vệ dữ liệu phù hợp nhất trong môi trường AWS và đám mây nói chung.
