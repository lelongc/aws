## Bài toán: Chuyển 200TB dữ liệu lên Cloud với đường truyền Internet 100 Mbps 🐌

Giả sử chúng ta có một "kho báu" 200 Terabytes (TB) dữ liệu cần chuyển lên AWS, nhưng đường truyền Internet hiện tại chỉ có tốc độ 100 Megabits mỗi giây (Mbps). Giờ xem xét các lựa chọn nhé:

### 1. Dùng Internet công cộng / Site-to-Site VPN 🌐

- **Ưu điểm:**
  - Thiết lập **nhanh chóng**, có thể tận dụng ngay đường truyền hiện có.
- **Nhược điểm (cho ví dụ 200TB):**
  - Thử làm một phép tính nhanh: 200TB dữ liệu, với tốc độ 100 Mbps, sẽ mất khoảng... **16 triệu giây**, tương đương **185 ngày**! Gần nửa năm trời chỉ để chuyển dữ liệu. 😱
- **Kết luận:** Với lượng dữ liệu lớn như 200TB và tốc độ Internet này, phương án này rõ ràng là **không khả thi** vì quá tốn thời gian. Tuy nhiên, với lượng dữ liệu nhỏ hơn, đây vẫn có thể là một lựa chọn.

---

### 2. Dùng AWS Direct Connect 🚀

AWS Direct Connect là một kết nối mạng riêng, chuyên dụng giữa trung tâm dữ liệu của bạn và AWS.

- **Ưu điểm:**
  - Tốc độ cao và ổn định hơn Internet công cộng.
- **Nhược điểm:**
  - **Thời gian thiết lập ban đầu lâu:** Nếu bạn chưa có Direct Connect, việc thiết lập có thể mất khoảng **1 tháng**.
- **Thời gian chuyển (cho ví dụ 200TB với đường truyền 1 Gbps):**
  - Giả sử bạn có đường Direct Connect 1 Gigabit mỗi giây (Gbps), nhanh hơn gấp 10 lần so với đường 100 Mbps ở trên.
  - Thời gian chuyển sẽ giảm xuống còn khoảng **18.5 ngày**. Nhanh hơn đáng kể, nhưng vẫn là một khoảng thời gian khá dài cho lần chuyển đầu tiên.

---

### 3. Dùng Gia đình AWS Snow (ví dụ: Snowball) ❄️🚚

AWS Snowball là một thiết bị vật lý bạn đặt hàng từ AWS, chép dữ liệu vào đó rồi gửi lại cho AWS để họ tải lên S3.

- **Quy trình:**
  1.  Đặt hàng thiết bị Snowball.
  2.  AWS gửi thiết bị đến cho bạn.
  3.  Bạn chép dữ liệu vào Snowball.
  4.  Gửi thiết bị lại cho AWS.
  5.  AWS tải dữ liệu từ Snowball vào các dịch vụ lưu trữ của họ.
- **Tổng thời gian (từ đầu đến cuối):**
  - Toàn bộ quá trình này thường mất khoảng **1 tuần**. Nhanh hơn RẤT NHIỀU so với hai phương án trên cho lượng dữ liệu lớn!
- **Kết hợp "ăn ý":**
  - Nếu dữ liệu cần chuyển là database, Snowball có thể được kết hợp với **AWS DMS (Database Migration Service)**. Snowball dùng để chuyển phần lớn dữ liệu ban đầu (full load), sau đó DMS sẽ lo phần dữ liệu thay đổi phát sinh (ongoing changes).
- **Kết luận:** **Snowball cực kỳ hữu ích** để tăng tốc việc chuyển một lượng lớn dữ liệu ban đầu (one-off large transfers) lên AWS.

---

## Chuyển dữ liệu liên tục (Ongoing Replication) thì sao? 🔄

Snowball rất tuyệt cho việc "chuyển nhà" một lần với khối lượng lớn. Nhưng nếu bạn cần sao chép dữ liệu liên tục, thường xuyên (thường là lượng nhỏ hơn mỗi lần), thì có các lựa chọn khác phù hợp hơn:

- **Site-to-Site VPN:** Nếu lượng dữ liệu không quá lớn.
- **AWS Direct Connect:** Cho kết nối ổn định và băng thông cao.
- **AWS DMS:** Chuyên cho việc đồng bộ hóa cơ sở dữ liệu.
- **AWS DataSync:** Một dịch vụ khác được thiết kế để tự động hóa và tăng tốc việc di chuyển dữ liệu giữa on-premises và AWS Storage services.

---

## "Bí kíp" cho kỳ thi 📝

Bài giảng này muốn bạn nhận ra:

- **Không có giải pháp nào là tốt nhất cho mọi trường hợp.** Lựa chọn phụ thuộc vào:
  - **Lượng dữ liệu** cần chuyển (nhỏ hay cực lớn).
  - **Tốc độ đường truyền** hiện có.
  - **Thời gian** cho phép để hoàn thành việc chuyển.
  - Đây là việc chuyển **một lần (one-off)** hay **liên tục (ongoing)**.
- **Snowball là "ngôi sao"** khi cần chuyển một lượng dữ liệu RẤT LỚN trong thời gian ngắn nhất cho lần đầu.
- Các câu hỏi trong kỳ thi có thể yêu cầu bạn xác định cách **dễ nhất, nhanh nhất, hoặc đáng tin cậy nhất** để gửi dữ liệu lên AWS dựa trên các kịch bản cụ thể về kích thước dữ liệu.
