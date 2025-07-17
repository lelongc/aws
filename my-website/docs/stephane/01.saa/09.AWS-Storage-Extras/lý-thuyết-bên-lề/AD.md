### **Microsoft Active Directory (AD) là gì?**

**Microsoft Active Directory (AD)** là một dịch vụ do Microsoft phát triển, được sử dụng để quản lý và điều hành tài nguyên mạng như người dùng, nhóm, thiết bị, và các ứng dụng trong môi trường Windows. 

AD là thành phần quan trọng trong việc xây dựng mạng doanh nghiệp hoặc tổ chức lớn, đảm bảo tính tập trung và bảo mật trong quản lý.

---

### **Chức năng chính của Active Directory**
1. **Quản lý danh tính và quyền truy cập (Identity and Access Management - IAM):**
   - Lưu trữ thông tin về người dùng, nhóm, thiết bị, ứng dụng và tài nguyên trong mạng.
   - Cung cấp cơ chế xác thực và phân quyền để kiểm soát ai được phép truy cập tài nguyên nào.

2. **Xác thực tập trung:**
   - AD sử dụng giao thức **Kerberos** hoặc **NTLM** để xác thực người dùng khi họ đăng nhập vào hệ thống mạng.
   - Một lần đăng nhập (Single Sign-On - SSO): Người dùng chỉ cần đăng nhập một lần và có thể truy cập tất cả tài nguyên được phép trong mạng.

3. **Cấu trúc thư mục:**
   - AD tổ chức tài nguyên mạng theo cấu trúc **hierarchical directory** (thư mục phân cấp), giúp dễ dàng quản lý và tìm kiếm.
   - Các thành phần chính:
     - **Domain:** Đơn vị quản lý cơ bản, chứa thông tin về tất cả người dùng và tài nguyên trong một mạng.
     - **Tree:** Một nhóm domain liên kết với nhau theo quan hệ tin cậy (trust relationship).
     - **Forest:** Nhóm các domain tree liên kết lại với nhau.

4. **Chính sách nhóm (Group Policy):**
   - Quản lý các cài đặt và chính sách cho người dùng và thiết bị trong mạng như:
     - Quy định mật khẩu.
     - Hạn chế phần mềm hoặc tính năng.
     - Triển khai ứng dụng tự động.

5. **Hỗ trợ quản lý tài nguyên phân tán:**
   - Tích hợp và quản lý các tài nguyên trên nhiều máy chủ, địa điểm, hoặc chi nhánh khác nhau.

---

### **Thành phần chính của Active Directory**
1. **Domain Controller (DC):**
   - Là máy chủ chạy Active Directory, lưu trữ thông tin về tài khoản và tài nguyên trong domain.
   - Xử lý yêu cầu đăng nhập, xác thực, và phân quyền.

2. **Global Catalog (GC):**
   - Là một thư mục toàn cầu lưu trữ thông tin về tất cả tài nguyên trong forest.
   - GC giúp người dùng tìm kiếm tài nguyên trong toàn bộ forest nhanh chóng.

3. **Organizational Units (OUs):**
   - Đơn vị tổ chức giúp phân nhóm người dùng, nhóm, hoặc thiết bị trong domain để quản lý dễ dàng.

4. **Group Policy Objects (GPOs):**
   - Tập hợp các chính sách được áp dụng cho người dùng hoặc thiết bị trong domain.

5. **Trust Relationships:**
   - Thiết lập mối quan hệ tin cậy giữa các domain hoặc forest, cho phép chia sẻ tài nguyên.

---

### **Lợi ích của Active Directory**
1. **Quản lý tập trung:**
   - Cung cấp một giao diện duy nhất để quản lý tất cả người dùng, nhóm, và tài nguyên.
2. **Tăng cường bảo mật:**
   - Quản lý mật khẩu, xác thực người dùng, và kiểm soát truy cập tài nguyên.
3. **Hiệu quả cao:**
   - Triển khai chính sách và ứng dụng nhanh chóng trên toàn bộ mạng.
4. **Khả năng mở rộng:**
   - Dễ dàng mở rộng để hỗ trợ mạng lớn hơn với hàng ngàn người dùng hoặc nhiều địa điểm khác nhau.

---

### **Ứng dụng phổ biến của Active Directory**
- Quản lý nhân viên và quyền truy cập trong tổ chức.
- Thiết lập và duy trì môi trường **Single Sign-On (SSO)**.
- Triển khai chính sách bảo mật như mã hóa hoặc khóa thiết bị.
- Kết nối với các dịch vụ đám mây như **Azure Active Directory** để mở rộng tính năng.

---

### **So sánh Active Directory và Azure Active Directory**
| **Tiêu chí**             | **Active Directory (AD)**             | **Azure Active Directory (Azure AD)**           |
|--------------------------|---------------------------------------|-----------------------------------------------|
| **Môi trường**            | On-premises                          | Cloud-based                                  |
| **Quản lý tài nguyên**    | Thiết bị, người dùng trong mạng nội bộ | Ứng dụng và dịch vụ SaaS (Office 365, Teams) |
| **Cách xác thực**         | Kerberos, NTLM                       | OAuth, SAML, OpenID                          |
| **Ứng dụng chính**        | Doanh nghiệp dùng mạng nội bộ         | Doanh nghiệp chuyển đổi lên đám mây           |

---

### **Kết luận**
Microsoft Active Directory là một giải pháp mạnh mẽ để quản lý mạng doanh nghiệp, đặc biệt trong môi trường sử dụng nhiều thiết bị và tài nguyên. Nó không chỉ đảm bảo tính bảo mật mà còn giúp quản lý tập trung và hiệu quả hơn.