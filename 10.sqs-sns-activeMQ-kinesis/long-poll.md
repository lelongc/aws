### **Tìm Hiểu Về Long Polling trong Amazon SQS**

---

#### **1. Long Polling là gì?**
- **Khái niệm**:  
  - Long polling là một kỹ thuật giúp **consumer** (người tiêu thụ) có thể **chờ đợi** các message đến từ SQS queue mà không phải liên tục gửi yêu cầu API.  
  - Khi consumer thực hiện một **polling request** đến queue và không có message nào, thay vì trả lời ngay lập tức, SQS sẽ giữ kết nối mở và đợi một message mới xuất hiện.  
  - Khi có message, SQS sẽ gửi message đó tới consumer ngay lập tức.  

---

#### **2. Lợi ích của Long Polling**
- **Giảm Số Lượng API Calls**:  
  - Consumer không cần thực hiện nhiều yêu cầu API mỗi lần muốn nhận message, giúp tiết kiệm tài nguyên và giảm chi phí.  
  - Với long polling, consumer chỉ gửi yêu cầu API **một lần** và chờ đợi lâu hơn (từ 1 đến 20 giây).  
  - Điều này giảm bớt tần suất gọi API, giúp tiết kiệm băng thông và cải thiện hiệu quả.

- **Giảm Độ Trễ**:  
  - Khi có message mới, SQS gửi ngay lập tức cho consumer mà không phải đợi thêm.  
  - Nhờ vậy, độ trễ của ứng dụng sẽ được giảm thiểu.

- **Cải Thiện Hiệu Suất**:  
  - Long polling giúp giảm thiểu sự chậm trễ (latency) giữa việc gửi message và việc consumer nhận được message.

---

#### **3. Cài Đặt Long Polling**
- **Thời gian Wait**:  
  - Thời gian long polling có thể được cài đặt trong khoảng từ **1 đến 20 giây**.
  - **20 giây** là thời gian chờ tối ưu, giúp giảm thiểu số lượng yêu cầu API và tối ưu hóa việc nhận message.

- **Cài Đặt Long Polling**:
  - Long polling có thể được cấu hình ở **mức queue** (cài đặt cho tất cả consumer) hoặc **mức API** thông qua tham số **WaitTimeSeconds**.

---

#### **4. So Sánh Long Polling và Short Polling**
- **Short Polling**:
  - Khi consumer gửi yêu cầu và không có message, yêu cầu trả về **ngay lập tức**, có thể yêu cầu nhiều lần mà không nhận được message.
  - Điều này không tối ưu vì số lượng API calls lớn và có thể làm tăng chi phí.

- **Long Polling**:
  - Giảm thiểu số lượng yêu cầu API.
  - Giảm độ trễ và giúp consumer nhận message ngay khi có mà không cần gửi nhiều yêu cầu.

---

#### **5. Tóm Tắt**
1. **Long Polling** giúp consumer giảm số lượng API calls và nhận message với độ trễ thấp hơn.
2. **Thời gian Polling** có thể được cài đặt từ **1 đến 20 giây**, và thời gian **20 giây** là tối ưu cho hiệu suất.
3. Có thể bật long polling ở **mức queue** hoặc **mức API**.
4. **Ưu tiên long polling hơn short polling** để giảm chi phí và tối ưu hiệu suất.

---

### **Điểm Quan Trọng cho Kỳ Thi**
- Hiểu sự khác biệt giữa **long polling** và **short polling**.
- Biết cách **cấu hình long polling** và **tại sao long polling lại ưu việt hơn** trong các tình huống xử lý message.