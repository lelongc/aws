**S3 Glacier Vault Lock** và **S3 Object Lock** trên AWS. các khái niệm chính:

---

### **1. S3 Glacier Vault Lock**
- **Mục đích**: Khóa Vault của S3 Glacier để sử dụng mô hình **WORM (Write Once, Read Many)**.
  - **WORM**: Dữ liệu được ghi vào một lần và không thể sửa đổi hoặc xóa.
- **Cách hoạt động**:
  1. Tạo một **Vault Lock Policy** cho Glacier Vault.
  2. **Khóa** chính sách này để ngăn chỉnh sửa hoặc xóa trong tương lai.
  3. Khi Vault đã được khóa, **không ai** (bao gồm cả admin hoặc AWS) có thể thay đổi hoặc xóa dữ liệu.
- **Ứng dụng**:
  - **Tuân thủ pháp lý**: Lưu trữ dữ liệu không thể thay đổi trong thời gian dài.
  - **Bảo vệ dữ liệu**: Đáp ứng các yêu cầu khắt khe về lưu trữ và bảo mật.

---

### **2. S3 Object Lock**
- **Mục đích**: Tương tự Glacier Vault Lock, nhưng hoạt động trên từng **object** trong S3 Bucket, không phải toàn bộ bucket.
- **Điều kiện**:
  - Phải bật **versioning** trên bucket.
  - Khóa đối tượng ở từng phiên bản (object version).

#### **Chế độ Retention (Retention Modes)**
1. **Compliance Mode**:
   - Cấm xóa hoặc thay đổi đối tượng bởi **bất kỳ ai**, kể cả admin.
   - Chế độ này **rất nghiêm ngặt** để đảm bảo tuân thủ pháp lý.
   - Thời gian giữ (retention period) không thể bị rút ngắn.

2. **Governance Mode**:
   - Người dùng thông thường **không thể** xóa hoặc thay đổi object.
   - Admin có thể thay đổi hoặc xóa object nếu được cấp quyền qua IAM.
   - Linh hoạt hơn so với Compliance Mode.

#### **Thời gian giữ (Retention Period)**:
- Đặt thời gian cụ thể để bảo vệ object.
- Có thể gia hạn thời gian này nếu cần thiết.

---

### **3. Legal Hold**
- **Mục đích**: Đánh dấu một object để bảo vệ **vô thời hạn**, không phụ thuộc vào Retention Mode hay Period.
- **Cách hoạt động**:
  - Dùng quyền IAM `S3:PutObjectLegalHold` để thêm hoặc xóa Legal Hold.
  - Thường được sử dụng trong các tình huống pháp lý, như khi dữ liệu cần cho một vụ kiện.
- **Ưu điểm**: Bảo vệ mạnh mẽ nhưng có thể linh hoạt điều chỉnh bởi admin.

---

### **So sánh chính:**
| **Tính năng**              | **Glacier Vault Lock**    | **S3 Object Lock**      | **Legal Hold**          |
|-----------------------------|---------------------------|--------------------------|--------------------------|
| **Phạm vi**                | Toàn bộ Glacier Vault     | Từng object trong bucket| Từng object             |
| **Loại bảo vệ**            | Không thay đổi hoặc xóa    | Chế độ Compliance/Governance | Bảo vệ vô thời hạn     |
| **Thay đổi quyền bảo vệ**   | Không thể                 | Phụ thuộc vào chế độ     | Có thể điều chỉnh       |

---

### **Ứng dụng thực tế:**
- Dùng Glacier Vault Lock cho lưu trữ dài hạn, dữ liệu pháp lý hoặc các trường hợp cần bảo mật tuyệt đối.
- Dùng Object Lock để bảo vệ linh hoạt các file riêng lẻ trong bucket.
- Sử dụng Legal Hold cho các dữ liệu quan trọng liên quan đến vụ kiện hoặc điều tra.

