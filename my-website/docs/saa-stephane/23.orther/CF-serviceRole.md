# CloudFormation Service Role là gì? 🤔

Bạn cứ hình dung **Service Role** giống như một **"giấy ủy quyền" đặc biệt** mà bạn tạo ra trong **IAM (Identity and Access Management)**.  
Giấy ủy quyền này được **dành riêng cho CloudFormation**.

Khi CloudFormation cần tạo, cập nhật, hay xóa các tài nguyên trong stack của bạn (ví dụ: tạo S3 bucket, EC2 instance),  
nó sẽ **"đội chiếc mũ" của Service Role** này và hành động với **các quyền hạn được định nghĩa** trong role đó — **không dùng quyền trực tiếp của bạn**.

---

## 🔐 Tại sao cần Service Role? — Lợi ích bảo mật (Nguyên tắc Đặc quyền Tối thiểu)

Đây chính là điểm "ăn tiền" của Service Role, giúp bạn **tuân thủ nguyên tắc least privilege** (chỉ cấp quyền tối thiểu cần thiết):

- **Tình huống**:  
  Bạn muốn cho phép một người dùng (hoặc nhóm) có thể tạo/cập nhật/xóa các stack CloudFormation,  
  **nhưng không muốn cấp cho họ quyền trực tiếp** với từng tài nguyên (S3, EC2, IAM, ...).

- **Giải pháp** với Service Role:
  - Tạo một **Service Role** với **quyền hạn vừa đủ** (VD: chỉ cho phép tạo S3 bucket).
  - Người dùng chỉ cần có quyền:
    - `cloudformation:CreateStack`
    - `iam:PassRole` (quyền quan trọng!)
  - Khi tạo stack, người dùng sẽ **"pass" role này cho CloudFormation**.
  - CloudFormation sẽ **assume (đảm nhận)** role và dùng quyền đó để hoạt động.

- ✅ **Kết quả**:  
  Người dùng có thể quản lý hạ tầng qua CloudFormation **mà không cần có quyền trên từng dịch vụ**, giúp **bảo mật tốt hơn**.

---

## 🤝 Service Role hoạt động như thế nào?

1. **Người dùng khởi tạo**: Ví dụ, tạo hoặc update một CloudFormation stack.
2. **Chuyển giao vai trò (Pass Role)**: Người dùng chỉ định IAM Role để CloudFormation sử dụng.
3. **CloudFormation hành động**:
   - Assume role đó.
   - Dùng quyền bên trong role để tạo/cập nhật/xóa tài nguyên (S3, EC2, IAM, ...).

---

## 🔑 Quyền `iam:PassRole` — "Chìa khóa" quan trọng

- Đây là **quyền bắt buộc** để người dùng có thể pass một Service Role cho CloudFormation.
- Vì sao? Để **ngăn người dùng leo thang đặc quyền** bằng cách pass một role có quyền cao hơn.

💡 *Người dùng chỉ có thể pass các role mà họ có quyền `iam:PassRole` rõ ràng trên đó.*

---

## 🎨 Ví dụ minh họa (theo bài giảng)

### 1. **Tạo Service Role cho CloudFormation**
- Vào IAM → tạo một Role mới.
- **Trusted entity**: AWS service
- **Use case**: chọn **CloudFormation**
- Gắn policy: VD `AmazonS3FullAccess`
- ➡️ Tạo role tên: `DemoRole-CFN-S3Access`

### 2. **Dùng role khi tạo Stack**
- Khi tạo stack → trong phần **Permissions**, chọn role `DemoRole-CFN-S3Access`.
- Nếu template cố gắng tạo EC2 instance (mà role không có quyền EC2) → Stack sẽ **fail** ở bước đó.
- ✅ Chứng minh CloudFormation **chỉ hoạt động trong giới hạn quyền** được cấp qua Service Role.

---

## ✍️ "Mẹo" ôn thi

- CloudFormation Service Role = **Giải pháp thực thi nguyên tắc least privilege**.
- Nắm rõ **luồng quyền**:
Người dùng (CFN + PassRole) → Pass Role → CloudFormation → Assume Role → Hành động với quyền của role

- Luôn nhớ: `iam:PassRole` là **quyền then chốt**.
- Cơ chế giúp **tách biệt quyền quản lý stack** khỏi quyền trên từng tài nguyên riêng lẻ.

---

> ✅ **Tóm lại**:  
> Sử dụng Service Role là một **chiến lược bảo mật quan trọng** khi làm việc với CloudFormation, giúp bạn kiểm soát quyền tốt hơn và giảm thiểu rủi ro trong môi trường AWS.