# Các Loại Thông Tin Nhận Dạng Cá Nhân (PII)

## Thông Tin Nhận Dạng Cá Nhân (PII) Là Gì?

Thông tin nhận dạng cá nhân (Personally Identifiable Information - PII) là bất kỳ dữ liệu nào có thể được sử dụng để xác định danh tính của một cá nhân cụ thể. Trong bối cảnh bảo mật dữ liệu, PII đóng vai trò quan trọng và thường là đối tượng chính của các quy định bảo vệ dữ liệu trên toàn cầu.

## Các Loại PII Mà Amazon Macie Có Thể Phát Hiện

Amazon Macie có khả năng phát hiện nhiều loại dữ liệu nhạy cảm và PII, bao gồm:

### 1. Thông Tin Nhận Dạng Cá Nhân Cơ Bản

- Họ và tên
- Địa chỉ email
- Địa chỉ nhà/cơ quan
- Số điện thoại
- Ngày sinh
- Giới tính
- Quốc tịch

### 2. Thông Tin Tài Chính

- Số thẻ tín dụng
- Mã CVV/CVC
- Số tài khoản ngân hàng
- Mã định danh ngân hàng (routing numbers)
- Thông tin thuế (mã số thuế, mã số người đóng thuế)
- Thông tin bảo hiểm

### 3. Thông Tin Y Tế

- Mã số bảo hiểm y tế
- Mã số hồ sơ y tế
- Thông tin về tình trạng y tế
- Lịch sử điều trị
- Đơn thuốc

### 4. Thông Tin Nhận Dạng Chính Phủ

- Số căn cước công dân/CMND
- Số hộ chiếu
- Số an sinh xã hội (SSN)
- Số giấy phép lái xe
- Mã số thuế

### 5. Thông Tin Trực Tuyến

- Địa chỉ IP
- Cookie
- ID thiết bị
- Tên người dùng và mật khẩu

### 6. Thông Tin Sinh Trắc Học

- Dấu vân tay
- Nhận dạng khuôn mặt
- Mẫu mống mắt
- Mẫu giọng nói

### 7. Thông Tin Địa Lý

- Dữ liệu GPS
- Lịch sử vị trí

## Tùy Chỉnh Nhận Dạng PII Trong Macie

Amazon Macie cho phép bạn tùy chỉnh các định nghĩa về dữ liệu nhạy cảm thông qua:

1. **Định Nghĩa Nhận Dạng Tùy Chỉnh**: Tạo các mẫu regex riêng để phát hiện các loại PII cụ thể trong dữ liệu của bạn

2. **Danh Sách Cho Phép**: Xác định các mẫu cụ thể không nên được xem là PII trong môi trường của bạn

3. **Bộ Lọc**: Loại trừ các tệp hoặc đường dẫn S3 cụ thể khỏi việc quét PII

## Phân Loại Mức Độ Nhạy Cảm

Amazon Macie phân loại dữ liệu nhạy cảm theo các mức độ:

- **Nhạy Cảm Cao**: Thông tin có thể dẫn đến thiệt hại nghiêm trọng nếu bị lộ (ví dụ: số CMND, số thẻ tín dụng)
- **Nhạy Cảm Trung Bình**: Thông tin có thể gây bất lợi nếu bị lộ (ví dụ: ngày sinh, địa chỉ)
- **Nhạy Cảm Thấp**: Thông tin ít nhạy cảm hơn (ví dụ: tên công ty)

## Quy Định Bảo Vệ PII

Các quy định chính liên quan đến việc bảo vệ PII mà Amazon Macie giúp tuân thủ:

- **GDPR** (General Data Protection Regulation): Áp dụng trong EU
- **CCPA/CPRA** (California Consumer Privacy Act/California Privacy Rights Act): Áp dụng tại California, Hoa Kỳ
- **HIPAA** (Health Insurance Portability and Accountability Act): Liên quan đến thông tin y tế tại Hoa Kỳ
- **PCI DSS** (Payment Card Industry Data Security Standard): Bảo vệ dữ liệu thẻ tín dụng
- **GLBA** (Gramm-Leach-Bliley Act): Áp dụng cho thông tin tài chính

## Tóm Tắt

Việc hiểu về các loại PII khác nhau và cách Amazon Macie phát hiện chúng là rất quan trọng để tận dụng tối đa dịch vụ này. Bằng cách phát hiện chính xác PII trong dữ liệu S3 của bạn, Macie giúp bảo vệ thông tin nhạy cảm, tuân thủ các quy định và tránh các rủi ro bảo mật dữ liệu tiềm ẩn.
