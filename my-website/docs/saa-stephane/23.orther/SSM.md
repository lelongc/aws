# SSM Session Manager là gì mà "vi diệu" vậy? 🤔

**SSM Session Manager** cho phép bạn khởi tạo một phiên làm việc dòng lệnh an toàn (secure shell) trên các EC2 instance của bạn (và cả máy chủ on-premises nữa) mà **KHÔNG CẦN**:
- Quyền truy cập SSH truyền thống.
- Bastion host (máy chủ trung gian để SSH).
- Bất kỳ SSH key nào.

👉 Điều này có nghĩa là **port 22 trên EC2 instance của bạn có thể được đóng hoàn toàn**, giúp tăng cường bảo mật lên một tầm cao mới!

---

## ✨ Cách thức hoạt động (Phép màu đằng sau)

- **Trên EC2 instance**: Cần có một "điệp viên" là **SSM Agent** được cài đặt và đang chạy (các AMI Amazon Linux 2 thường có sẵn).
- **Kết nối**: SSM Agent này sẽ **chủ động kết nối ra ngoài** đến dịch vụ Session Manager của AWS.
- **Người dùng truy cập**: Bạn (người dùng) sẽ thông qua **dịch vụ Session Manager** để thiết lập phiên làm việc với EC2 instance. Mọi giao tiếp đều **được mã hóa**.

---

## 🌟 Những điểm nổi bật khác

- **Hỗ trợ đa nền tảng**: Linux, macOS, và Windows.
- **Ghi log phiên làm việc**: Toàn bộ dữ liệu của phiên (lệnh đã gõ, output) có thể được **ghi lại và lưu trữ** trên Amazon S3 hoặc CloudWatch Logs để kiểm toán (audit) và theo dõi bảo mật.

---

## 📋 Điều kiện "Cần và Đủ" để Session Manager hoạt động với EC2

Đây là phần **cực kỳ quan trọng** bạn cần nhớ:

- **SSM Agent**: Phải được **cài đặt và chạy** trên EC2 instance.
- **IAM Role cho EC2**: Đây là mấu chốt!  
  EC2 instance của bạn **BẮT BUỘC** phải được gắn một IAM instance profile (role).  
  Role này phải có quyền cho phép instance giao tiếp với dịch vụ SSM.
  - Một policy thường dùng là `AmazonSSMManagedInstanceCore` (policy quản lý bởi AWS).
- **Security Group**:  
  Tuyệt vời nhất là **Security Group của EC2 instance KHÔNG CẦN mở bất kỳ inbound rule nào** (kể cả port 22).  
  Session Manager **không cần inbound port**.

---

## 💻 Trải nghiệm thực tế (Qua lời kể trong bài giảng)

- **Khởi chạy EC2**: Chọn AMI Amazon Linux 2, **không cần Key Pair**, Security Group **không mở port nào**.
- **Gắn IAM Role**: Tạo và gắn IAM Role có policy `AmazonSSMManagedInstanceCore` cho EC2.
- **Kiểm tra trong Systems Manager**:
  - Vào `Systems Manager > Fleet Manager`.  
    Instance của bạn sẽ xuất hiện ở đây dưới dạng **"managed node"** khi SSM Agent kết nối thành công.
- **Bắt đầu phiên làm việc**:
  - Vào `Systems Manager > Session Manager`.
  - Chọn instance và nhấn **Start session**.
  - Một **cửa sổ dòng lệnh sẽ mở ra ngay trên trình duyệt của bạn**!  
    Bạn có thể gõ lệnh như `ping google.com`, `hostname`, v.v.
  - Lệnh `hostname` sẽ cho thấy bạn đang ở trên **private IP của instance đó**.

---

## 🆚 So sánh với các phương thức truy cập khác (Tại sao Session Manager "đỉnh"?)

Bài giảng có so sánh **3 cách truy cập EC2**:

### 1. SSH truyền thống:
- Mở port 22.
- Cần quản lý SSH keys.
- Dùng terminal để gõ lệnh ssh.

### 2. EC2 Instance Connect:
- Không cần bạn phải lưu trữ SSH key lâu dài (key được tạo tạm thời và đẩy lên instance).
- **NHƯNG**: Vẫn **YÊU CẦU port 22 phải được mở** trên Security Group của EC2.

### 3. SSM Session Manager:
- **KHÔNG CẦN** SSH key do người dùng quản lý.
- **PORT 22 CÓ THỂ ĐÓNG HOÀN TOÀN**.
- Dựa vào **IAM role** để xác thực và ủy quyền.
- Đây là **phương pháp an toàn nhất** trong ba cách để có quyền truy cập shell.

---

## 📖 Lợi ích phụ: Lịch sử phiên (Session History)

Các phiên làm việc qua Session Manager có thể được **ghi lại lịch sử**, giúp bạn dễ dàng:
- Xem lại **ai đã làm gì**, **khi nào**.
- Đáp ứng yêu cầu **audit** trong môi trường doanh nghiệp.

---

## 🎯 "Bí kíp" mang vào phòng thi

- **SSM Session Manager**: Cung cấp quyền truy cập shell an toàn mà **không cần mở port 22** và **không cần quản lý SSH key** cho người dùng.
- **Yêu cầu cốt lõi**: SSM Agent trên instance và IAM Role phù hợp được gắn vào instance.
- **Ưu điểm vượt trội**: Tăng cường đáng kể tình hình bảo mật (security posture).
- **Hiểu rõ sự khác biệt** của nó so với SSH truyền thống và EC2 Instance Connect, đặc biệt là về yêu cầu mở port 22.

---

> ✅ **Kết luận**:  
> **SSM Session Manager** thực sự là một công cụ tuyệt vời để quản trị EC2 instance một cách **an toàn và tiện lợi** hơn rất nhiều.