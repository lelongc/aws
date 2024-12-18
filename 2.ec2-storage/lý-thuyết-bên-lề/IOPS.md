**IOPS** (Input/Output Operations Per Second) là một chỉ số đo lường hiệu suất của hệ thống lưu trữ, đặc biệt là đối với ổ đĩa hoặc các dịch vụ lưu trữ như **EBS** trong AWS. IOPS biểu thị số lần hệ thống có thể thực hiện các phép toán đọc và ghi dữ liệu trong một giây.

- **Input/Output**: Các phép toán đọc (input) và ghi (output) dữ liệu.
- **Per Second**: Số lượng phép toán trong một giây.

IOPS được sử dụng để đánh giá khả năng xử lý của hệ thống lưu trữ đối với các ứng dụng yêu cầu hiệu suất cao, như cơ sở dữ liệu, hệ thống giao dịch, hoặc các ứng dụng có tần suất truy xuất dữ liệu cao.

### Ví dụ:
- Một ổ đĩa có thể thực hiện 1000 IOPS có nghĩa là nó có thể thực hiện 1000 phép toán đọc hoặc ghi trong một giây.

Các dịch vụ lưu trữ như EBS trong AWS cung cấp nhiều loại volume với các mức IOPS khác nhau, giúp bạn lựa chọn phù hợp với nhu cầu của ứng dụng (ví dụ: SSD cho các ứng dụng yêu cầu hiệu suất cao và Magnetic cho các ứng dụng ít tần suất truy xuất).