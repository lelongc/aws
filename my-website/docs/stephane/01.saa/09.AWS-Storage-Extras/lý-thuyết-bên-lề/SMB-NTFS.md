### **Giải thích SMB Protocol và NTFS**

#### **1. SMB Protocol (Server Message Block)**
- **SMB là gì?**
  - **SMB** là giao thức mạng được sử dụng để chia sẻ tệp, máy in, và các tài nguyên khác giữa các máy tính trong mạng.
  - Được phát triển bởi Microsoft, SMB phổ biến trong các hệ thống Windows nhưng cũng hỗ trợ trên Linux và macOS (qua Samba).

- **Cách hoạt động:**
  - **Client-Server Model:** Một máy (client) gửi yêu cầu truy cập tài nguyên (tệp, thư mục, máy in) tới một máy khác (server).
  - Dữ liệu được chia sẻ qua mạng dưới dạng các "block" (khối dữ liệu).

- **Các tính năng chính:**
  - **Chia sẻ tệp và thư mục:** Người dùng có thể truy cập, sửa đổi, và lưu trữ tệp từ xa như trên ổ đĩa cục bộ.
  - **Chia sẻ máy in:** Cho phép các máy trong mạng sử dụng chung một máy in.
  - **Authentication & Authorization:** Cung cấp cơ chế bảo mật, yêu cầu xác thực (username/password) và kiểm tra quyền truy cập.

- **Ưu điểm:**
  - Dễ tích hợp với hệ sinh thái Windows.
  - Hỗ trợ quản lý quyền chi tiết (Access Control Lists).

#### **2. NTFS (Windows NT File System)**
- **NTFS là gì?**
  - **NTFS** là hệ thống tệp mặc định của các hệ điều hành Windows hiện đại, được Microsoft giới thiệu lần đầu tiên trong Windows NT.
  - NTFS thay thế FAT32 nhờ các tính năng bảo mật và hiệu suất cao hơn.

- **Các tính năng chính:**
  - **Quản lý dung lượng lớn:** Hỗ trợ lưu trữ các tệp kích thước lớn và ổ đĩa có dung lượng lên tới hàng petabyte.
  - **Bảo mật:** 
    - Hỗ trợ **Access Control Lists (ACLs)**, cho phép quản lý quyền truy cập chi tiết cho từng tệp/thư mục.
    - Hỗ trợ mã hóa (Encrypting File System - EFS).
  - **Tính năng khôi phục:** NTFS có khả năng tự sửa lỗi (self-healing) qua tính năng **journaling** (ghi nhật ký các thao tác).
  - **Tối ưu hóa lưu trữ:** 
    - Nén tệp để tiết kiệm không gian ổ đĩa.
    - Hỗ trợ quota (hạn mức dung lượng) cho người dùng.

---

### **So sánh SMB và NTFS**

| **Tiêu chí**            | **SMB Protocol**                   | **NTFS**                           |
|-------------------------|-------------------------------------|-------------------------------------|
| **Chức năng chính**     | Chia sẻ tài nguyên qua mạng         | Quản lý hệ thống tệp cục bộ        |
| **Phạm vi hoạt động**   | Mạng (LAN/WAN)                     | Ổ đĩa cục bộ                       |
| **Hỗ trợ nền tảng**     | Windows, Linux, macOS (qua Samba)  | Hệ điều hành Windows               |
| **Bảo mật**             | Xác thực người dùng qua mạng        | Quản lý quyền truy cập trên tệp/thư mục |
| **Ứng dụng**            | Chia sẻ tệp, máy in, ổ đĩa qua mạng | Lưu trữ và quản lý tệp trên ổ đĩa cục bộ |

---

### **Kết hợp SMB và NTFS**
Trong môi trường Windows:
- **SMB** được dùng để chia sẻ tài nguyên qua mạng (cho phép máy khác truy cập).
- **NTFS** được dùng để quản lý tệp và bảo mật dữ liệu cục bộ trên ổ đĩa.

Ví dụ:
- Khi bạn chia sẻ một thư mục từ máy tính của mình qua mạng, SMB sẽ xử lý việc chia sẻ qua mạng, nhưng quyền truy cập sẽ do NTFS kiểm soát (dựa trên các ACL được thiết lập).