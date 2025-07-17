### Tóm tắt kiến thức về EBS Snapshots

1. **EBS Snapshot là gì?**
   - **EBS Snapshot** là bản sao lưu của volume EBS tại một thời điểm cụ thể.
   - Không cần phải tách EBS khỏi EC2 instance nhưng được khuyến nghị.

2. **Copy Snapshot**
   - Bạn có thể sao chép EBS Snapshots giữa các **Availability Zones (AZ)** hoặc thậm chí giữa các **Region**.

3. **Ví dụ về việc sử dụng Snapshot**
   - Bạn có thể sao lưu một EBS volume từ EC2 instance ở **US-EAST-1A** và phục hồi nó ở **US-EAST-1B**. Đây là cách chuyển một volume EBS giữa các AZ.

4. **Một số tính năng của EBS Snapshots**
   - **EBS Snapshot Archive**:
     - Di chuyển snapshot vào **"archive tier"** giúp giảm chi phí lên đến **75%**.
     - Việc khôi phục từ archive mất từ **24 đến 72 giờ**, không phải ngay lập tức.

   - **Recycle Bin cho EBS Snapshots**:
     - Nếu bạn xóa snapshot, nó sẽ không bị xóa vĩnh viễn mà sẽ chuyển vào **Recycle Bin**.
     - Bạn có thể khôi phục snapshot trong trường hợp xóa nhầm.
     - **Retention** có thể được thiết lập từ **1 ngày đến 1 năm**.
        Không có chi phí bổ sung cho việc sử dụng Recycle Bin hoặc các quy tắc retention.
        Phí lưu trữ snapshot trong Recycle Bin tính giống như phí của các snapshot thông thường.
   - **Fast Snapshot Restore (FSR)**:
     - Tính năng này buộc snapshot được khởi tạo hoàn toàn để giảm độ trễ khi sử dụng lần đầu tiên.
     - Thích hợp cho các snapshot lớn và yêu cầu khôi phục thành ebs nhanh chóng.
     - Tuy nhiên, tính năng này **đắt tiền**, cần cẩn trọng khi sử dụng.

5. **Kết luận**
   - Tóm lại, EBS Snapshots rất hữu ích để sao lưu và phục hồi dữ liệu, với các tính năng như Archive, Recycle Bin, và Fast Snapshot Restore, nhưng cũng có một số chi phí liên quan đến việc sử dụng chúng.

---

