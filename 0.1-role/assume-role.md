Tạo Role trong tài khoản A và cấu hình policy cần  cho tài khoản B  .

Khi tạo role  bạn chọn "Another AWS account"từ A  và nhập ID tài khoản B trong quá trình tạo role, AWS sẽ tự động thêm một statement vào Trust Relationship để tài khoản B đó có thể giả định role này mà không cần bạn phải làm thêm bất kỳ cấu hình gì thủ công. Vì thế, bạn không cần phải chỉnh sửa Trust Relationship sau khi tạo role.

tài khoản B Cấp 1 cái policy sts:AssumeRole đến arn  role vừa tạo  cho tài khoản B,  để nó có thể giả định role của tài khoản A.
You sent

# để B có quyền AA trên A , tạo role AA ở A gắn cho B - trust relationship tự động cho B full quyền , admin bên B tự gắn assume role trỏ đến AA (cho phép đảm nhiệm role ở account khác ) cho user B

### Quy trình chi tiết

#### 1. *Tạo IAM Role trong tài khoản A và cấu hình Trust Relationship*

*Mục đích*: Tạo một IAM role trong tài khoản A và cấu hình *Trust Relationship* sao cho tài khoản B có thể giả định role này.

##### Các bước:

1. *Đăng nhập vào Console AWS của tài khoản A*.
2. *Vào IAM Console*: Truy cập vào [IAM console](https://console.aws.amazon.com/iam/).
3. *Tạo Role trong tài khoản A*:
   - Trong *IAM Console*, chọn *Roles* từ menu bên trái, rồi nhấn *Create role*.
   - Chọn *Another AWS account* (để cho phép tài khoản khác giả định role này).
   - Nhập *Account ID* của tài khoản B (ví dụ: 123456789012).
   - *Chọn Permissions*: Bạn có thể chọn các chính sách (policies) cho role này. Ví dụ: nếu bạn muốn cho tài khoản B quyền truy cập vào S3 trong tài khoản A, bạn có thể chọn AmazonS3ReadOnlyAccess. Nếu muốn quyền tùy chỉnh, bạn tạo và gán policy riêng cho role này.
   - *Hoàn tất* tạo role và lưu lại *ARN* của role, ví dụ: arn:aws:iam::Tài-Khoản-A-ID:role/RoleName.

4. *Cấu hình Trust Relationship cho role trong tài khoản A*:
   - Sau khi tạo role, bạn cần chỉnh sửa *Trust Relationship* để tài khoản B có thể giả định role này.
   - Trong phần *Trust relationships* của role trong tài khoản A, nhấn *Edit trust relationship* và thêm đoạn JSON sau vào (thay Tài-Khoản-B-ID bằng ID của tài khoản B):

   
{
"Version": "2012-10-17",
"Statement": [
{
"Effect": "Allow",
"Principal": {
"AWS": "arn:aws:iam::Tài-Khoản-B-ID:root"
},
"Action": "sts:AssumeRole"
}
]
}

   *Giải thích*:
   - *Principal*: Cho phép tài khoản B giả định role. Cấu hình như trên chỉ định tài khoản B (bằng cách sử dụng ARN của tài khoản B).
   - *Action*: Đảm bảo *Action* là sts:AssumeRole, nghĩa là tài khoản B có quyền giả định role này.

5. *Lưu lại* các thay đổi trong Trust Relationship.

---

#### 2. **Cấp quyền sts:AssumeRole cho tài khoản B**

*Mục đích*: Tài khoản B cần có quyền sts:AssumeRole để giả định role trong tài khoản A.

##### Các bước:

1. *Đăng nhập vào Console AWS của tài khoản B*.
2. *Truy cập IAM Console* của tài khoản B: [IAM console](https://console.aws.amazon.com/iam/).
3. Chọn *Users* (nếu bạn làm việc với IAM User) hoặc *Roles* (nếu tài khoản B sử dụng IAM Role).
4. *Chỉnh sửa chính sách IAM* của User hoặc Role trong tài khoản B để cấp quyền sts:AssumeRole đối với role của tài khoản A.
   - Chọn *User* hoặc *Role* mà bạn muốn cấp quyền, rồi nhấn *Add inline policy* hoặc *Attach policies directly*.
   - Chọn tab *JSON* và thêm chính sách sau:

   
{
"Version": "2012-10-17",
"Statement": [
{
"Effect": "Allow",
"Action": "sts:AssumeRole",
"Resource": "arn:aws:iam::Tài-Khoản-A-ID:role/RoleName"
}
]
}

   *Giải thích*:
   - *Action*: sts:AssumeRole cho phép tài khoản B giả định role của tài khoản A.
   - *Resource*: ARN của role trong tài khoản A mà tài khoản B sẽ giả định, ví dụ: arn:aws:iam::Tài-Khoản-A-ID:role/RoleName.

5. *Lưu lại chính sách*.

---

#### 3. *Tài khoản B giả định role của tài khoản A*

Sau khi đã cấu hình Trust Relationship trong tài khoản A và cấp quyền sts:AssumeRole trong tài khoản B, tài khoản B có thể giả định role của tài khoản A.

*Cách giả định role sử dụng AWS CLI*:

1. *Cấu hình AWS CLI cho tài khoản B* nếu chưa có:

   
aws configure

   - Nhập *Access Key ID* và *Secret Access Key* của tài khoản B.
   - Nhập *Default region name* (ví dụ: us-east-1).
   - Nhập *Default output format* (ví dụ: json).

2. *Giả định role* trong tài khoản A:

   Sử dụng lệnh sts:assume-role để giả định role của tài khoản A:

   
aws sts assume-role \
--role-arn arn:aws:iam::Tài-Khoản-A-ID:role/RoleName \
--role-session-name MySessionName

   - *role-arn*: ARN của role trong tài khoản A mà tài khoản B sẽ giả định.
   - *role-session-name*: Tên phiên làm việc (có thể đặt bất kỳ tên nào).

3. *Kết quả trả về*: Lệnh trên sẽ trả về các *temporary credentials* (Access Key, Secret Key và Session Token) cho tài khoản B:

   
{
"Credentials": {
"AccessKeyId": "ASIA...example",
"SecretAccessKey": "Secret...example",
"SessionToken": "Fwo...example",
"Expiration": "2025-01-02T12:34:56Z"
},
"AssumedRoleUser": {
"AssumedRoleId": "AROA...example",
"Arn": "arn:aws:sts::Tài-Khoản-A-ID:assumed-role/RoleName/MySessionName"
}
}

4. *Sử dụng Temporary Credentials*: Sau khi nhận được temporary credentials, bạn có thể sử dụng chúng để thực hiện các hành động trong tài khoản A. Ví dụ:

   
export AWS_ACCESS_KEY_ID=ASIA...example
export AWS_SECRET_ACCESS_KEY=Secret...example
export AWS_SESSION_TOKEN=Fwo...example

# Truy cập vào S3 trong tài khoản A
aws s3 ls s3://your-bucket-name

---

### Tóm tắt các bước:

1. *Tạo Role trong tài khoản A* và cấu hình *Trust Relationship* cho phép tài khoản B giả định role.
2. **Cấp quyền sts:AssumeRole cho tài khoản B** trong chính sách IAM của tài khoản B để nó có thể giả định role từ tài khoản A.
3. *Tài khoản B* sử dụng AWS CLI để giả định role trong tài khoản A và nhận temporary credentials.

### Lưu ý:
- *Trust Relationship* chỉ cho phép tài khoản B giả định role trong tài khoản A, nhưng quyền thực sự để truy cập tài nguyên (ví dụ: S3, EC2) phải được cấp trong chính sách của role AA trong tài khoản A.
- Thời gian tồn tại của *temporary credentials* khi giả định role là khoảng *1 giờ*. Sau thời gian này, bạn sẽ cần giả định lại role để có quyền truy cập mới.
