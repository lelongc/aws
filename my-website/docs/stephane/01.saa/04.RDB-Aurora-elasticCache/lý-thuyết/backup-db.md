### Kiến thức chi tiết về RDS Backup (Sao lưu RDS)

#### **1. Automated Backups (Sao lưu tự động)**
- **Khái niệm**: AWS RDS tự động thực hiện sao lưu toàn bộ cơ sở dữ liệu mỗi ngày trong thời gian "backup window" bạn cài đặt.
- **Transaction Logs**: Cứ mỗi 5 phút, các bản ghi giao dịch (transaction logs) được sao lưu.
- **Khả năng phục hồi**: Bạn có thể khôi phục dữ liệu về bất kỳ thời điểm nào trong khoảng từ hiện tại quay ngược 5 phút.
- **Retention Period (Thời gian giữ bản sao lưu)**:
  - Bạn có thể cài đặt thời gian giữ từ **1 đến 35 ngày**.
  - Nếu bạn muốn tắt sao lưu tự động, đặt retention về **0**.

#### **2. Manual DB Snapshots (Ảnh chụp cơ sở dữ liệu thủ công)**
- **Khái niệm**: Đây là các bản sao lưu do người dùng kích hoạt thủ công.
- **Lợi ích**:
  - Không hết hạn (giữ được vĩnh viễn).
  - Dùng để giảm chi phí nếu bạn không cần RDS hoạt động liên tục. Ví dụ:
    1. Chạy RDS 2 giờ/tháng.
    2. Tạo snapshot sau khi sử dụng.
    3. Xóa RDS để giảm chi phí lưu trữ.
    4. Khi cần, khôi phục lại từ snapshot.

#### **3. Aurora Backups**
- Tương tự như RDS với các điểm khác biệt:
  - **Automated Backups**:
     Automated Backups của Aurora cũng bao gồm:
    Sao lưu đầy đủ hàng ngày của cơ sở dữ liệu, giống như trong RDS.
    Sao lưu transaction logs (bản ghi giao dịch) để hỗ trợ phục hồi đến bất kỳ thời điểm nào (Point-in-Time Recovery) trong khoảng thời gian từ hiện tại quay ngược lại đến 1 đến 35 ngày.
    - **Không thể tắt được.**
  - **Manual Snapshots**: 
    - Có thể được kích hoạt thủ công và giữ vĩnh viễn.

#### **4. Restore Options (Các tùy chọn phục hồi)**
- **Phục hồi từ Automated Backups hoặc Manual Snapshots**:
  - Tạo một cơ sở dữ liệu mới từ bản sao lưu.
- **Phục hồi MySQL từ S3**:
  - Tạo bản sao lưu từ cơ sở dữ liệu on-premises.
  - Tải bản sao lưu lên Amazon S3.
  - Phục hồi từ S3 vào RDS MySQL hoặc Aurora MySQL.
- **Phục hồi Aurora MySQL từ S3**:
  - Cần sử dụng phần mềm **Percona XtraBackup** để tạo bản sao lưu.
  - Lưu trữ trên S3, sau đó khôi phục vào Aurora cluster.

#### **5. Aurora Database Cloning (Nhân bản cơ sở dữ liệu Aurora)**
- **Mục đích**: Tạo một bản sao của Aurora database nhanh chóng mà không ảnh hưởng đến bản gốc.
- **Lợi ích**:
  - **Nhanh chóng**: Không cần sao lưu và phục hồi, sử dụng giao thức **copy-on-write**.
  - **Hiệu quả chi phí**: Dùng chung dung lượng dữ liệu ban đầu.
  - **Tách biệt dữ liệu**: Khi có cập nhật ở database gốc hoặc bản sao, dữ liệu mới sẽ được lưu vào vùng lưu trữ riêng.
- **Ứng dụng**:
  - Tạo môi trường staging để thử nghiệm mà không ảnh hưởng đến database production.

---

### Tóm tắt
- RDS và Aurora cung cấp các tùy chọn sao lưu tự động và thủ công với khả năng phục hồi linh hoạt.
- Aurora hỗ trợ tính năng **Cloning** giúp nhân bản nhanh chóng và tiết kiệm chi phí.
- Các thao tác sao lưu/phục hồi từ S3 cần lưu ý công cụ và quy trình khác nhau giữa RDS MySQL và Aurora MySQL.

\