

---

#### **1. Geo Restriction là gì?**
- **Khái niệm**:  
  Cho phép kiểm soát việc ai có thể truy cập vào **CloudFront Distribution** dựa trên quốc gia mà họ truy cập từ đó.
  
- **Ứng dụng**:
  - **Phù hợp với luật bản quyền**: Hạn chế hoặc cho phép truy cập nội dung ở một số quốc gia.
  - **Tăng cường bảo mật**: Ngăn chặn các khu vực có nguy cơ tấn công mạng cao.

---

#### **2. Cách hoạt động của Geo Restriction**
- **Phương thức xác định quốc gia**:
  - Sử dụng **cơ sở dữ liệu Geo-IP** của bên thứ ba.
  - Đối chiếu địa chỉ IP của người dùng với quốc gia tương ứng.

- **Tùy chọn cấu hình**:
  - **Allowlist**:  
    - Chỉ định danh sách các quốc gia được phép truy cập.
  - **Blocklist**:  
    - Chỉ định danh sách các quốc gia bị cấm truy cập.

---

#### **3. Quy trình thiết lập Geo Restriction**

- **Vị trí cấu hình**:
  - Vào phần **Security** trong cấu hình CloudFront.
  - Tìm đến **CloudFront Geographic Restrictions** và chọn **Edit**.

- **Các bước thực hiện**:
  1. **Chọn kiểu hạn chế**:
     - Allowlist (cho phép).
     - Blocklist (cấm).
  2. **Liệt kê quốc gia**:
     - Với Allowlist: Chỉ định các quốc gia luôn được phép.
     - Với Blocklist: Chỉ định các quốc gia bị chặn.
  3. **Lưu cấu hình**:
     - CloudFront sẽ tự động áp dụng hạn chế này.

---

#### **4. Ví dụ cụ thể**
- **Allowlist**:
  - Chỉ cho phép các quốc gia như **Ấn Độ** và **Hoa Kỳ** truy cập.
  - Các bước:
    - Chọn Allowlist.
    - Thêm **India** và **United States** vào danh sách.
    - Lưu lại cấu hình.
  - Kết quả: Chỉ các quốc gia này được truy cập nội dung.

---

#### **5. Các lưu ý quan trọng**
- **Giới hạn của Geo Restriction**:
  - Dựa vào cơ sở dữ liệu Geo-IP nên có thể có sai sót nếu IP không được định vị chính xác.
- **Thay đổi chính sách**:
  - Nếu danh sách quốc gia cần thay đổi, bạn chỉ cần chỉnh sửa danh sách hiện tại.
- **Ảnh hưởng đến người dùng**:
  - Những người dùng ở quốc gia không được phép sẽ nhận thông báo lỗi truy cập từ CloudFront.

---

#### **Tóm tắt**
| Thành phần              | Vai trò                                    |
|-------------------------|--------------------------------------------|
| **Geo Restriction**     | Kiểm soát truy cập CloudFront theo quốc gia. |
| **Allowlist**           | Chỉ cho phép các quốc gia trong danh sách. |
| **Blocklist**           | Chặn các quốc gia trong danh sách.         |
| **Geo-IP Database**     | Cơ sở dữ liệu dùng để định vị quốc gia qua IP. |

---

