### **Chi tiết kiến thức trong bài giảng về S3 Storage Lens**

#### **1. Giới thiệu S3 Storage Lens**
- **Mục đích**:
  - Hiểu, phân tích và tối ưu hóa việc lưu trữ trong AWS S3.
  - Hoạt động ở cấp độ toàn tổ chức AWS hoặc chi tiết đến từng tài khoản, vùng (region), bucket, và tiền tố (prefix).

---

#### **2. Các tính năng chính**
1. **Phát hiện bất thường (anomalies)**:
   - Giúp phát hiện các vấn đề như tăng trưởng không đồng đều hoặc các bucket ít sử dụng.

2. **Tối ưu chi phí (cost efficiencies)**:
   - Xác định các cơ hội để giảm chi phí, chẳng hạn như chuyển dữ liệu sang lớp lưu trữ giá rẻ hơn.

3. **Áp dụng best practices bảo vệ dữ liệu**:
   - Kiểm tra các thiết lập như mã hóa (encryption), versioning, MFA delete, và replication.

4. **Thống kê hoạt động trong 30 ngày**:
   - Cung cấp dữ liệu về hoạt động và việc sử dụng S3 trong vòng 30 ngày.

5. **Báo cáo tùy chỉnh hoặc mặc định**:
   - Có thể tạo báo cáo tùy chỉnh hoặc sử dụng bảng điều khiển mặc định từ AWS.

6. **Xuất báo cáo**:
   - Báo cáo có thể xuất ra file CSV hoặc Parquet lưu vào S3 để phân tích chi tiết.

---

#### **3. Dashboard mặc định (Default Dashboard)**
- **Tóm tắt dữ liệu**:
  - Hiển thị dữ liệu từ nhiều tài khoản, vùng (region), bucket.
  - Không cần cấu hình phức tạp.
- **Giới hạn**:
  - Không thể xóa, nhưng có thể vô hiệu hóa.

- **Dữ liệu hiển thị**:
  - Tổng dung lượng lưu trữ.
  - Số lượng đối tượng (objects).
  - Kích thước trung bình của các đối tượng.
  - Số lượng bucket, tài khoản.

---

#### **4. Các loại metrics (chỉ số đo lường)**
Metrics được chia thành nhiều nhóm với các mục đích khác nhau:

1. **Summary Metrics**:
   - **Ý nghĩa**: Tổng quan về S3, như dung lượng lưu trữ, số lượng đối tượng.
   - **Use case**: Phát hiện các bucket tăng trưởng nhanh hoặc ít sử dụng.

2. **Cost Optimization Metrics**:
   - **Ý nghĩa**: Quản lý và tối ưu hóa chi phí.
   - **Use case**: 
     - Xác định dữ liệu từ các tải lên không hoàn chỉnh.
     - Chuyển dữ liệu không cần thiết sang lớp lưu trữ chi phí thấp hơn.

3. **Data Protection Metrics**:
   - **Ý nghĩa**: Kiểm tra tính bảo mật, ví dụ:
     - Có bật phiên bản (versioning) hay chưa.
     - Bucket có bật MFA delete không.
   - **Use case**: Đảm bảo mọi bucket tuân thủ các quy chuẩn bảo vệ dữ liệu.

4. **Access Management Metrics**:
   - **Ý nghĩa**: Theo dõi quyền sở hữu và quyền truy cập vào bucket.

5. **Performance Metrics**:
   - **Ý nghĩa**: Thông tin về hiệu suất, ví dụ:
     - Có bật **S3 Transfer Acceleration** không.

6. **Activity Metrics**:
   - **Ý nghĩa**: Theo dõi các yêu cầu (GET, PUT), số bytes được tải xuống, và trạng thái HTTP (200 OK, 403 Forbidden...).

---

#### **5. Sự khác biệt giữa phiên bản miễn phí và trả phí**
- **Miễn phí**:
  - Có sẵn cho tất cả khách hàng.
  - 28 chỉ số cơ bản (basic metrics).
  - Dữ liệu lưu trong 14 ngày.

- **Trả phí**:
  - Thêm các chỉ số nâng cao, như:
    - Tối ưu hóa chi phí nâng cao (advanced cost optimization).
    - Mã trạng thái HTTP.
  - Tích hợp với CloudWatch để theo dõi sâu hơn.
  - Dữ liệu lưu trong 15 tháng.

---

#### **6. Tổng kết**
- **S3 Storage Lens** là công cụ hữu ích để:
  - Hiểu dữ liệu S3 qua các chỉ số.
  - Phát hiện bất thường, tối ưu chi phí và đảm bảo tuân thủ quy định bảo vệ dữ liệu.
- **Cần nhớ cho kỳ thi**:
  - Sự khác biệt giữa **metrics miễn phí** và **metrics trả phí**.
  - Mục đích của **default dashboard**.
  - Các tính năng bảo vệ dữ liệu như versioning và MFA delete.

