# Quản Lý Quyền Truy Cập AWS Trên EC2 Instance: Sử Dụng IAM Role

Quản lý quyền truy cập AWS trên EC2 Instance là một trong những kỹ năng quan trọng để đảm bảo bảo mật và hiệu quả trong việc sử dụng AWS. Bài viết này sẽ hướng dẫn bạn cách sử dụng IAM Role thay cho việc nhập trực tiếp credentials trên EC2 Instance.

## AWS CLI Trên EC2 Instance
AWS CLI (Command Line Interface) được cài đặt sẵn trên Amazon Linux AMI, cho phép bạn dễ dàng thực hiện các lệnh để quản lý tài nguyên AWS. Khi chạy lệnh như `aws iam list users`, CLI sẽ yêu cầu thông tin **credentials** để xác thực.

## Không Nên Nhập Credentials Trực Tiếp
Một sai lầm phổ biến là sử dụng lệnh `aws configure` để nhập Access Key và Secret Key trực tiếp trên EC2 Instance. Đây là một cách làm cực kỳ rủi ro bởi:
- Credentials có thể bị lộ nếu ai đó truy cập được vào instance của bạn.
- Các thông tin nhạy cảm này có thể bị sử dụng trái phép, gây ra hậu quả nghiêm trọng.

**Lời khuyên:** Tuyệt đối không nhập credentials trực tiếp trên EC2 Instance.

## Sử Dụng IAM Role Thay Cho Credentials
Thay vì sử dụng Access Key và Secret Key, bạn nên sử dụng **IAM Role**, một phương pháp an toàn hơn để quản lý quyền truy cập AWS cho EC2 Instance. Sau đây là các bước thực hiện:

1. **Tạo IAM Role:**
   - Tạo một IAM Role (ví dụ: `DemoRoleForEC2`) với quyền phù hợp, chẳng hạn như `IAMReadOnlyAccess`.

2. **Gắn IAM Role vào EC2 Instance:**
   - Vào **Actions** > **Security** > **Modify IAM Role** trong giao diện AWS Management Console.
   - Chọn IAM Role vừa tạo và nhấn **Save** để gắn vào EC2 Instance.

3. **IAM Role hoạt động như thế nào:**
   - IAM Role tự động cung cấp các quyền truy cập cần thiết mà không yêu cầu nhập thủ công Access Key hay Secret Key.

## Kiểm Tra Quyền
Sau khi gắn IAM Role, bạn có thể kiểm tra quyền truy cập bằng cách:
- Chạy lại lệnh `aws iam list users`. Nếu IAM Role đã được gắn thành công, bạn sẽ thấy danh sách người dùng trong IAM.
- Nếu tháo IAM Role hoặc thay đổi quyền, lệnh trên sẽ trả về thông báo **Access Denied**.

## Kết Luận
Việc sử dụng **IAM Role** thay cho việc nhập credentials trực tiếp trên EC2 Instance là cách làm đúng đắn và an toàn nhất. IAM Role không chỉ giảm thiểu rủi ro bảo mật mà còn giúp bạn quản lý quyền truy cập một cách linh hoạt và hiệu quả hơn.

**Lưu ý:** Hãy luôn tuân thủ nguyên tắc bảo mật, tránh nhập credentials trên EC2 Instance và sử dụng IAM Role để bảo vệ tài nguyên AWS của bạn.

