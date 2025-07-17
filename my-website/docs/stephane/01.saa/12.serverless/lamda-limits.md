**Tóm tắt các giới hạn của AWS Lambda:**

### Giới hạn về thực thi:

- **Bộ nhớ:**
  - Phạm vi: Từ 128 MB đến 10 GB
  - Tăng dần theo mức 64 MB
  - **Lưu ý:** Càng nhiều bộ nhớ, hàm Lambda sẽ có càng nhiều sức mạnh tính toán (vCPU).
- **Thời gian thực thi:** Tối đa 900 giây (15 phút).
  - **Lưu ý:** Nếu công việc của bạn cần thời gian thực thi lâu hơn, Lambda có thể không phải là lựa chọn phù hợp.
- **Biến môi trường:** Tối đa 4 KB.
  - **Lưu ý:** Để lưu trữ thông tin cấu hình lớn hơn, hãy cân nhắc các tùy chọn lưu trữ khác.
- **Không gian tạm (/tmp):** Tối đa 10 GB.
  - **Lưu ý:** Dùng để xử lý các file lớn trong quá trình thực thi hàm.
- **Số lượng thực thi đồng thời:** Tối đa 1000.
  - **Lưu ý:** Bạn có thể yêu cầu tăng giới hạn này, nhưng nên sử dụng tính năng "reserved concurrency" để đảm bảo hiệu suất.

### Giới hạn về triển khai:

- **Kích thước gói triển khai:**
  - Nén: Tối đa 50 MB
  - Không nén: Tối đa 250 MB
  - **Lưu ý:** Đối với các ứng dụng lớn, hãy cân nhắc các cách đóng gói hoặc triển khai khác.

### Những điều cần lưu ý khi làm bài thi:

- **Yêu cầu về bộ nhớ:** Nếu công việc cần hơn 10 GB RAM, Lambda không phải là lựa chọn phù hợp.
- **Thời gian thực thi:** Nếu thời gian xử lý vượt quá 15 phút, hãy tìm kiếm các giải pháp khác.
- **Xử lý file lớn:** Nếu bạn cần xử lý hoặc lưu trữ các file lớn hơn giới hạn kích thước gói triển khai, hãy tận dụng không gian /tmp.

**Ví dụ câu hỏi và cách trả lời:**

- **Câu hỏi:** Chúng ta cần 30 GB RAM để chạy một ứng dụng. Bạn sẽ sử dụng dịch vụ nào của AWS?
- **Trả lời:** Với yêu cầu 30 GB RAM, AWS Lambda không phù hợp vì giới hạn bộ nhớ tối đa chỉ là 10 GB. Chúng ta nên xem xét các dịch vụ như EC2 hoặc ECS để đáp ứng nhu cầu này.
