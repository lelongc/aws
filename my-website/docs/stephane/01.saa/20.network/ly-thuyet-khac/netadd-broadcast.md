## 📌 **1. Network Address – Dùng để xác định tên mạng**

- Đây là **địa chỉ IP đầu tiên** trong dải subnet.
- Không thể gán cho bất kỳ thiết bị nào.
- Mục đích: dùng để **đại diện cho toàn bộ mạng con (subnet)**.
- Ví dụ: nếu bạn có subnet `192.168.1.0/30`, thì:

  - Network address là **192.168.1.0**
  - Điều đó có nghĩa là "đây là mạng 192.168.1.0 với mặt nạ /30"

✅ **Thiết bị định tuyến (router, switch Layer 3)** dùng network address để hiểu và quản lý mạng con.

---

## 📌 **2. Broadcast Address – Dùng để gửi thông báo đến tất cả máy trong mạng**

- Đây là **địa chỉ IP cuối cùng** trong dải subnet.
- Không thể gán cho bất kỳ thiết bị nào.
- Mục đích: **gửi dữ liệu đến tất cả các máy** trong mạng con đó.
- Ví dụ: `192.168.1.0/30` thì:

  - Broadcast address là **192.168.1.3**
  - Nếu một máy gửi gói tin đến 192.168.1.3, thì **cả 2 máy trong mạng** (192.168.1.1 và 192.168.1.2) sẽ nhận được.

✅ Broadcast rất hữu ích cho việc:

- Tìm máy in trong mạng nội bộ
- Tự động gán IP qua DHCP
- Gửi thông báo hệ thống

---

### 📥 Tóm lại:

| Loại địa chỉ      | Dùng để làm gì                                | Gán cho máy được không? |
| ----------------- | --------------------------------------------- | ----------------------- |
| Network Address   | Đại diện cho toàn bộ mạng con                 | ❌ Không được           |
| Broadcast Address | Gửi dữ liệu đến **tất cả các máy** trong mạng | ❌ Không được           |
| Host Address      | Gán cho thiết bị như PC, router, camera...    | ✅ Có thể gán           |
