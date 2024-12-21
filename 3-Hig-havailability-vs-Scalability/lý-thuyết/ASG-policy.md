
---

### **1. Dynamic Scaling (Mở rộng động)**
Đây là cách mở rộng linh hoạt dựa trên các chỉ số giám sát. Có ba loại chính:

#### a. **Target Tracking Scaling**
- **Cách hoạt động**: 
  - Bạn chọn một chỉ số (**metric**) như **CPU Utilization**.
  - Đặt một giá trị mục tiêu, ví dụ: CPU luôn ở mức **40%**.
  - ASG sẽ tự động **thêm** hoặc **giảm** số lượng EC2 instances để duy trì chỉ số gần mục tiêu.
- **Ưu điểm**:
  - Rất dễ cài đặt.
  - Tự động điều chỉnh mà không cần nhiều cấu hình phức tạp.
- **Ví dụ**: 
  - Một website thương mại điện tử có lưu lượng thay đổi liên tục. Nếu CPU của các instance vượt 40%, hệ thống sẽ tự thêm instance mới.

#### b. **Simple/Step Scaling**
- **Cách hoạt động**:
  - Dựa trên **CloudWatch Alarms**:
    - Khi một ngưỡng được đạt tới, như CPU > 70%, một cảnh báo sẽ kích hoạt việc thêm instance.
    - Khi CPU < 30%, cảnh báo khác sẽ kích hoạt việc giảm instance.
  - **Step Scaling**: Cho phép cấu hình nhiều bước dựa trên độ lớn của chỉ số. Ví dụ:
    - Nếu CPU > 70%, thêm 1 instance.
    - Nếu CPU > 90%, thêm 2 instances.
- **Ưu điểm**:
  - Linh hoạt, có thể cấu hình chi tiết hơn so với Target Tracking Scaling.
- **Ví dụ**:
  - Một ứng dụng xử lý dữ liệu tăng thêm 2 instance nếu CPU vượt 90%, nhưng chỉ thêm 1 instance nếu CPU trong khoảng 70%-90%.

#### c. **Scheduled Scaling**
- **Cách hoạt động**:
  - Dựa trên lịch trình cố định, bạn có thể cấu hình ASG để thay đổi số lượng instance.
- **Ưu điểm**:
  - Phù hợp khi bạn biết trước thời gian cao điểm hoặc thấp điểm.
- **Ví dụ**:
  - Một hệ thống thường có nhiều người dùng đăng nhập lúc 5 giờ chiều thứ Sáu. Bạn có thể tăng số lượng tối thiểu instance lên **10** vào thời điểm đó.

---

### **2. Predictive Scaling (Mở rộng dự đoán)**
- **Cách hoạt động**:
  - ASG sử dụng lịch sử hoạt động để dự đoán tải trong tương lai.
  - Tự động lên lịch mở rộng dựa trên các dự báo này.
- **Ưu điểm**:
  - Hoạt động tốt với các ứng dụng có tải lặp lại (chu kỳ), ví dụ: giờ cao điểm mỗi ngày.
  - Giúp bạn chuẩn bị tài nguyên trước khi tải tăng.
- **Ví dụ**:
  - Một ứng dụng streaming nhận thấy rằng lúc 8 giờ tối mỗi ngày luôn có tăng đột biến người dùng. Predictive Scaling sẽ dự báo và thêm instance lúc 7:50 tối.

---

### **3. Chỉ số tốt để mở rộng**
Bạn cần chọn các chỉ số phù hợp với cách hoạt động của ứng dụng:

#### a. **CPU Utilization**
- **Ý nghĩa**: CPU của EC2 instance tăng khi ứng dụng nhận nhiều yêu cầu.
- **Cách dùng**:
  - Theo dõi mức trung bình của CPU trên tất cả các instance.
  - Khi CPU vượt một ngưỡng, thêm instance; khi thấp hơn, giảm instance.
- **Ví dụ**:
  - Nếu CPU trung bình vượt **60%**, thêm 1 instance.

#### b. **RequestCountPerTarget**
- **Ý nghĩa**: Số yêu cầu mà mỗi instance nhận được từ **Application Load Balancer (ALB)**.
- **Cách dùng**:
  - Tính toán số yêu cầu tối ưu mà một instance có thể xử lý.
  - Nếu vượt quá con số này, thêm instance để duy trì hiệu suất.
- **Ví dụ**:
  - Mỗi EC2 instance có thể xử lý **1000 yêu cầu/giây**. Khi vượt mức này, thêm 1 instance.

#### c. **Network In/Out**
- **Ý nghĩa**: Thích hợp cho ứng dụng tải nhiều dữ liệu (uploads/downloads).
- **Cách dùng**:
  - Theo dõi lưu lượng mạng (Network In/Out).
  - Nếu lưu lượng vượt ngưỡng, thêm instance.
- **Ví dụ**:
  - Nếu **Network In** vượt 1 GB/s, thêm instance để đảm bảo không bị tắc nghẽn.

#### d. **Custom Metrics**
- **Ý nghĩa**: Bạn tự định nghĩa các chỉ số đặc thù cho ứng dụng và đẩy lên CloudWatch.
- **Ví dụ**:
  - Một ứng dụng ghi log liên tục có thể đo số lượng log được xử lý. Khi vượt ngưỡng, thêm instance.

---

### **4. Scaling Cooldown (Thời gian hạ nhiệt)**
- **Ý nghĩa**:
  - Sau mỗi lần thêm hoặc giảm instance, hệ thống sẽ vào trạng thái hạ nhiệt (mặc định 5 phút).
  - Trong thời gian này, ASG không thực hiện hành động nào khác.
- **Mục đích**:
  - Giúp các chỉ số ổn định trước khi thực hiện bước tiếp theo.
- **Lời khuyên**:
  - Sử dụng **Ready-to-use AMI** để EC2 instance có thể khởi động nhanh hơn, giảm thời gian hạ nhiệt.
- **Ví dụ**:
  - Nếu một instance mới cần **1 phút** để sẵn sàng, bạn có thể giảm cooldown xuống còn **2 phút**.

---

### **5. Chiến lược tối ưu hóa**
- **Sử dụng AMI sẵn sàng**:
  - Tạo sẵn AMI với cấu hình đầy đủ để giảm thời gian chuẩn bị khi mở rộng.
- **Bật Detailed Monitoring**:
  - Giúp cập nhật chỉ số mỗi phút, tăng tốc độ phản hồi của ASG.
- **Cấu hình chỉ số phù hợp**:
  - Dựa trên cách ứng dụng hoạt động để chọn các chỉ số chính xác.

---

### **6. Lời khuyên tổng quát**
- **Dynamic Scaling**:
  - Sử dụng khi lưu lượng thay đổi thường xuyên.
- **Predictive Scaling**:
  - Phù hợp khi có chu kỳ sử dụng lặp lại.
- **Scheduled Scaling**:
  - Dùng cho các tình huống có lịch trình cố định.
- **Custom Metrics**:
  - Thích hợp cho ứng dụng đặc thù.

---

