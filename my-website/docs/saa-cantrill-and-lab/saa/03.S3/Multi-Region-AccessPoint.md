## AWS S3 Multi-Region Access Points - Hướng dẫn từ Zero đến Hero 🚀

## 🎯 Mục tiêu học tập
Sau khi hoàn thành bài học này, bạn sẽ:
- Hiểu **Multi-Region Access Points** là gì và tại sao cần dùng
- Biết cách tạo và cấu hình từ A-Z
- Thực hành hands-on với AWS Console
- Sẵn sàng cho AWS Certification
- Áp dụng được vào dự án thực tế

---

## 📚 Mục lục
1. [Khái niệm cơ bản - Bắt đầu từ đây](#khái-niệm-cơ-bản)
2. [Tại sao cần Multi-Region Access Points?](#tại-sao-cần)
3. [Chuẩn bị trước khi bắt đầu](#chuẩn-bị)
4. [Thực hành Step-by-Step](#thực-hành)
5. [Test và kiểm tra](#test-và-kiểm-tra)
6. [Xử lý lỗi thường gặp](#xử-lý-lỗi)
7. [Best Practices](#best-practices)
8. [Câu hỏi ôn tập](#câu-hỏi-ôn-tập)

---

## 1. Khái niệm cơ bản - Bắt đầu từ đây {#khái-niệm-cơ-bản}

### 🤔 S3 Multi-Region Access Points là gì?

Hãy tưởng tượng bạn có một cửa hàng online bán sách:

**❌ Cách truyền thống:**
- Kho sách ở Hà Nội → Khách ở TP.HCM order phải chờ ship lâu
- Kho sách ở TP.HCM → Khách ở Hà Nội order phải chờ ship lâu
- Bạn phải nhớ 2 địa chỉ kho khác nhau

**✅ Với Multi-Region Access Points:**
- Chỉ có **1 địa chỉ** duy nhất cho cả 2 kho
- Hệ thống **tự động** giao hàng từ kho gần nhất
- Nếu kho Hà Nội hết hàng → Tự động chuyển sang kho TP.HCM

### 🏗️ Kiến trúc đơn giản

```
Người dùng → Multi-Region Access Point → Bucket gần nhất
    ↓               ↓                        ↓
Ở Hà Nội    →   Địa chỉ duy nhất      →   Bucket Singapore
Ở TP.HCM    →   example.mrap         →   Bucket Sydney  
Ở Đà Nẵng   →   (Tự động chọn)       →   Bucket Tokyo
```

### 💡 Các thuật ngữ cần biết

| Thuật ngữ | Giải thích đơn giản | Ví dụ |
|-----------|-------------------|-------|
| **Region** | Khu vực địa lý của AWS | ap-southeast-1 (Singapore) |
| **Bucket** | Thùng chứa files trên S3 | my-photos-bucket |
| **MRAP** | Multi-Region Access Point | Địa chỉ toàn cầu duy nhất |
| **Endpoint** | Đường link để truy cập | example.mrap |
| **Replication** | Sao chép dữ liệu | Copy từ bucket này sang bucket khác |

---

## 2. Tại sao cần Multi-Region Access Points? {#tại-sao-cần}

### 🌍 Bài toán thực tế

**Scenario:** Bạn làm cho công ty có app mobile với 1 triệu users trên toàn thế giới.

#### ❌ Không dùng MRAP:
```
User Việt Nam → S3 bucket ở Ireland → Chậm (300-500ms)
User Singapore → S3 bucket ở Ireland → Chậm (200-300ms)
User Mỹ → S3 bucket ở Ireland → Chậm (100-200ms)

➜ Tất cả users đều phải chờ lâu!
```

#### ✅ Dùng MRAP:
```
User Việt Nam → MRAP → S3 Singapore → Nhanh (50ms)
User Singapore → MRAP → S3 Singapore → Nhanh (20ms)  
User Mỹ → MRAP → S3 Virginia → Nhanh (30ms)

➜ Mọi user đều có trải nghiệm tốt!
```

### 🎯 Lợi ích cụ thể

#### 1. **Tốc độ nhanh hơn**
- Giảm latency từ 300ms xuống 50ms
- Users hài lòng hơn → Retention rate cao hơn

#### 2. **Đơn giản hóa code**
```javascript
// Trước khi có MRAP
const getS3Endpoint = (userLocation) => {
  if (userLocation === 'Asia') return 'https://s3.ap-southeast-1.amazonaws.com'
  if (userLocation === 'US') return 'https://s3.us-east-1.amazonaws.com'
  if (userLocation === 'EU') return 'https://s3.eu-west-1.amazonaws.com'
}

// Với MRAP
const S3_ENDPOINT = 'https://example.mrap' // Duy nhất!
```

#### 3. **High Availability**
- Một region down → Tự động chuyển sang region khác
- 99.99% uptime thay vì 99.9%

#### 4. **Disaster Recovery**
- Dữ liệu được backup tự động ở nhiều nơi
- Không lo mất data khi có sự cố

---

## 3. Chuẩn bị trước khi bắt đầu {#chuẩn-bị}

### 🔐 Requirements

#### 3.1 AWS Account
```bash
# Kiểm tra bạn đã login AWS chưa
aws sts get-caller-identity

# Output mong muốn:
{
    "UserId": "AIDXXXXXXXXXXXXXXXXX",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/lelongc"
}
```

#### 3.2 IAM Permissions cần thiết
Bạn cần có các permissions sau:
- `s3:*` (để tạo buckets)
- `s3-control:*` (để tạo MRAP)
- `iam:CreateRole` (để tạo replication role)

### 🛠️ Tools cần có

1. **AWS Console** - Giao diện web (dễ nhất cho người mới)
2. **AWS CLI** - Command line (tùy chọn)
3. **CloudShell** - Terminal trên AWS (khuyên dùng)

### 📋 Checklist trước khi bắt đầu

- [ ] Đã có AWS account
- [ ] Đã login vào AWS Console
- [ ] Hiểu cơ bản về S3 (bucket, object)
- [ ] Đã chọn 2 regions để test (VD: Singapore + Sydney)

---

## 4. Thực hành Step-by-Step {#thực-hành}

### 🎬 Video walkthrough mindset
> Hãy làm theo từng bước như đang xem video hướng dẫn. Không bỏ qua bước nào!

### Bước 1: Tạo S3 Buckets 🪣

#### 1.1 Đăng nhập AWS Console
1. Vào [AWS Console](https://console.aws.amazon.com)
2. Đăng nhập với account của bạn
3. Ở thanh search trên cùng, gõ **"S3"** và click vào **Amazon S3**

#### 1.2 Tạo Bucket đầu tiên (Singapore)

**Bước 2.1:** Click nút **"Create bucket"** (màu cam)

**Bước 2.2:** Điền thông tin bucket:
```
Bucket name: multi-region-demo-singapore-1691234567
AWS Region: Asia Pacific (Singapore) ap-southeast-1
```

> 💡 **Tip:** Thêm timestamp vào cuối tên để tránh trùng lặp. VD: `1691234567` là Unix timestamp.

**Bước 2.3:** Scroll xuống tìm **"Bucket Versioning"**
- Click **"Enable"** ✅ (Bắt buộc cho MRAP!)

**Bước 2.4:** Để mọi thứ khác mặc định, scroll xuống cuối và click **"Create bucket"**

#### 1.3 Tạo Bucket thứ hai (Sydney)

Lặp lại các bước trên với thông tin sau:
```
Bucket name: multi-region-demo-sydney-1691234567  
AWS Region: Asia Pacific (Sydney) ap-southeast-2
Bucket Versioning: Enable ✅
```

#### 1.4 Verify kết quả

Bạn sẽ thấy 2 buckets trong danh sách:
- ✅ multi-region-demo-singapore-1691234567 (Singapore)
- ✅ multi-region-demo-sydney-1691234567 (Sydney)

### Bước 2: Tạo Multi-Region Access Point 🌐

#### 2.1 Navigate đến MRAP

Trong S3 Console:
1. Nhìn menu bên trái
2. Tìm **"Multi-Region Access Points"**
3. Click vào đó

#### 2.2 Create MRAP

**Bước 2.1:** Click **"Create Multi-Region Access Point"**

**Bước 2.2:** Điền thông tin:
```
Multi-Region Access Point name: critical-cat-data
```

> 💡 **Lưu ý:** Tên này chỉ cần unique trong account của bạn, không cần globally unique như bucket name.

**Bước 2.3:** Thêm buckets
- Scroll xuống tìm **"Buckets"**
- Click **"Add buckets"**
- Chọn 2 buckets vừa tạo:
  - ✅ multi-region-demo-singapore-1691234567
  - ✅ multi-region-demo-sydney-1691234567
- Click **"Add buckets"**

**Bước 2.4:** Review và tạo
- Scroll xuống cuối
- Click **"Create Multi-Region Access Point"**

#### 2.3 Đợi MRAP được tạo

⏰ **Thời gian:** 10-30 phút (có thể tới 24h trong trường hợp xấu nhất)

**Status sẽ hiển thị:**
- 🟡 `Creating` - Đang tạo
- 🟢 `Ready` - Hoàn thành

> 🍕 **Tip:** Đây là lúc tốt để nghỉ giải lao, uống cà phê!

### Bước 3: Lấy thông tin MRAP 📝

Khi status chuyển thành **Ready**:

#### 3.1 Click vào tên MRAP
Click vào **"critical-cat-data"** để xem chi tiết

#### 3.2 Copy thông tin quan trọng
Bạn sẽ thấy:
```
Amazon Resource Name (ARN): 
arn:aws:s3::123456789012:accesspoint/critical-cat-data

Alias: 
mfzwi23gnjvgw8ouqr00-x1uk9lyqze5g-s3alias
```

> 📝 **Lưu lại:** Copy ARN này ra notepad, chúng ta sẽ dùng sau.

### Bước 4: Cấu hình Cross-Region Replication 🔄

#### 4.1 Tại sao cần Replication?

Hiện tại:
- Upload file vào MRAP từ Singapore → File chỉ có ở Singapore bucket
- User ở Sydney access MRAP → Được route đến Sydney bucket → **File không có!** ❌

Cần Replication để:
- Upload file ở Singapore → Tự động copy sang Sydney
- User ở đâu cũng thấy file ✅

#### 4.2 Setup Replication

**Trong trang chi tiết MRAP:**

**Bước 4.1:** Click tab **"Replication and failover"**

**Bước 4.2:** Click tab **"Replication"** (bên trong)

**Bước 4.3:** Click **"Create replication rule"**

**Bước 4.4:** Chọn template:
- ✅ **"Replicate objects among all specified buckets"**
- Click để chọn template này

**Bước 4.5:** Chọn buckets:
- ✅ Singapore bucket  
- ✅ Sydney bucket

**Bước 4.6:** Cấu hình options:
```
Status when created: Enabled ✅
Scope: Apply to all objects in the bucket ✅
Replication metrics and notifications: Enabled ✅
Replicate delete markers: Disabled ❌ (để mặc định)
Replica modification sync: Enabled ✅
```

**Bước 4.7:** Click **"Create replication rule"**

#### 4.3 Verify Replication

Sau khi tạo thành công, bạn sẽ thấy:
- Biểu đồ có 2 mũi tên qua lại giữa Singapore ↔ Sydney
- Status: **"Replication configured"**

---

## 5. Test và kiểm tra {#test-và-kiểm-tra}

### 🧪 Test Plan

Chúng ta sẽ test 3 scenarios:
1. **Test 1:** Upload từ gần Singapore → Xem file xuất hiện ở đâu trước
2. **Test 2:** Upload từ gần Sydney → Xem file xuất hiện ở đâu trước  
3. **Test 3:** Upload từ giữa 2 region → Xem MRAP chọn region nào

### Test 1: Upload từ Tokyo (gần Singapore) 🗾

#### 5.1 Mở CloudShell

**Bước 5.1:** Đổi region
- Click dropdown region ở góc phải trên
- Chọn **"Asia Pacific (Tokyo) ap-northeast-1"**

**Bước 5.2:** Mở CloudShell
- Click icon **CloudShell** ở thanh toolbar (icon terminal)
- Đợi CloudShell khởi động (2-3 phút lần đầu)

#### 5.2 Tạo test file

```bash
# Tạo file test 10MB
dd if=/dev/urandom of=test1.file bs=1M count=10

# Kiểm tra file đã tạo
ls -lh test1.file
```

#### 5.3 Upload lên MRAP

```bash
# Thay YOUR_MRAP_ARN bằng ARN thực tế của bạn
aws s3 cp test1.file s3://arn:aws:s3::123456789012:accesspoint/critical-cat-data/
```

> 💡 **Chú ý:** Thay `123456789012` bằng Account ID thực của bạn!

#### 5.4 Kiểm tra kết quả

**Mở tab mới và check Singapore bucket:**
1. Vào S3 Console
2. Click vào Singapore bucket
3. Refresh trang
4. ✅ Bạn sẽ thấy `test1.file` xuất hiện **ngay lập tức**

**Check Sydney bucket:**
1. Click vào Sydney bucket  
2. Refresh trang
3. ⏳ File **chưa có** (vì đang replicate)
4. Đợi 2-3 phút và refresh lại
5. ✅ File xuất hiện (đã replicate xong)

### Test 2: Upload từ Oregon (gần Sydney) 🇺🇸

#### 5.1 Đổi CloudShell region

**Bước 5.1:** Click dropdown region, chọn **"US West (Oregon) us-west-2"**

**Bước 5.2:** Mở CloudShell ở region mới

#### 5.2 Tạo và upload file test

```bash
# Tạo file test thứ 2
dd if=/dev/urandom of=test2.file bs=1M count=10

# Upload lên MRAP  
aws s3 cp test2.file s3://arn:aws:s3::123456789012:accesspoint/critical-cat-data/
```

#### 5.3 Kiểm tra kết quả

**Dự đoán:**
- Sydney bucket: File xuất hiện ngay ✅
- Singapore bucket: File xuất hiện sau vài phút ⏳

**Thực tế check:**
1. Sydney bucket → Refresh → ✅ `test2.file` có ngay
2. Singapore bucket → Refresh → ⏳ Chưa có
3. Đợi 2-3 phút → ✅ File đã replicate

### Test 3: Upload từ Mumbai (ở giữa) 🇮🇳

#### 5.1 Setup

Đổi region sang **"Asia Pacific (Mumbai) ap-south-1"**

#### 5.2 Test với monitoring

```bash
# Tạo file test
dd if=/dev/urandom of=test3.file bs=1M count=5

# Upload
aws s3 cp test3.file s3://arn:aws:s3::123456789012:accesspoint/critical-cat-data/
```

#### 5.3 Quick check

Ngay sau khi upload xong:
1. Mở 2 tabs: Singapore bucket + Sydney bucket
2. Refresh cả 2 tabs đồng thời
3. Xem bucket nào có file trước → Đó là bucket được MRAP chọn

**Kết quả có thể:**
- Nếu Singapore bucket có trước → MRAP route đến Singapore
- Nếu Sydney bucket có trước → MRAP route đến Sydney

---

## 6. Xử lý lỗi thường gặp {#xử-lý-lỗi}

### ❌ Lỗi 1: "NoSuchKey" Error

#### Triệu chứng:
```bash
aws s3 cp s3://your-mrap-arn/test.file ./
# Output: fatal error: NoSuchKey: The specified key does not exist.
```

#### Nguyên nhân:
File được upload vào bucket A, nhưng bạn đang try download từ bucket B (chưa replicate xong).

#### Giải pháp:

**Cách 1: Đợi replication**
```bash
# Retry sau 2-3 phút
sleep 180
aws s3 cp s3://your-mrap-arn/test.file ./
```

**Cách 2: Implement retry logic**
```bash
#!/bin/bash
MAX_RETRIES=5
DELAY=30

for i in $(seq 1 $MAX_RETRIES); do
  if aws s3 cp s3://your-mrap-arn/test.file ./; then
    echo "Download successful!"
    break
  else
    echo "Attempt $i failed, retrying in $DELAY seconds..."
    sleep $DELAY
  fi
done
```

### ❌ Lỗi 2: "Access Denied"

#### Triệu chứng:
```
An error occurred (AccessDenied) when calling the PutObject operation
```

#### Nguyên nhân:
- IAM permissions thiếu
- Bucket policy chặn
- MRAP chưa ready

#### Giải pháp:

**Check 1: MRAP status**
```bash
aws s3control describe-multi-region-access-point \
  --account-id YOUR_ACCOUNT_ID \
  --name critical-cat-data
```

**Check 2: IAM permissions**
Đảm bảo user có permissions:
- `s3:GetObject`
- `s3:PutObject` 
- `s3:ListBucket`

### ❌ Lỗi 3: "Bucket versioning not enabled"

#### Triệu chứng:
Console báo lỗi khi tạo MRAP

#### Giải pháp:
```bash
# Enable versioning cho bucket
aws s3api put-bucket-versioning \
  --bucket your-bucket-name \
  --versioning-configuration Status=Enabled
```

### ❌ Lỗi 4: MRAP creation stuck ở "Creating"

#### Nguyên nhân:
- AWS service issue
- Bucket configuration sai
- Permission thiếu

#### Giải pháp:
1. Đợi thêm (có thể lên tới 24h)
2. Check CloudTrail logs để xem error details
3. Delete và tạo lại MRAP

---

## 7. Best Practices {#best-practices}

### 🎯 For Beginners

#### 7.1 Quy tắc đặt tên

**✅ DO:**
```
# Bucket names - descriptive và unique
company-photos-singapore-20240810
company-photos-sydney-20240810

# MRAP names - business-focused
user-profile-images
product-catalog-data
```

**❌ DON'T:**
```
# Bucket names - confusing
bucket1, bucket2
my-test-bucket
```

#### 7.2 Region selection

**Chọn regions gần users:**
```
Users ở Việt Nam/Thái Lan → Singapore (ap-southeast-1)
Users ở Australia → Sydney (ap-southeast-2)  
Users ở Nhật/Hàn → Tokyo (ap-northeast-1)
Users ở Mỹ → Virginia (us-east-1) hoặc Oregon (us-west-2)
Users ở EU → Ireland (eu-west-1)
```

#### 7.3 Testing strategy

**Luôn test theo thứ tự:**
1. Create buckets → Test upload/download direct
2. Create MRAP → Test routing
3. Setup replication → Test consistency
4. Load testing → Test performance

### 🚀 For Production

#### 7.1 Monitoring và Alerting

```bash
# Setup CloudWatch alarms cho replication lag
aws cloudwatch put-metric-alarm \
  --alarm-name "S3-Replication-Lag" \
  --alarm-description "Alert khi replication > 15 phút" \
  --metric-name ReplicationLatency \
  --namespace AWS/S3 \
  --statistic Average \
  --period 900 \
  --threshold 900 \
  --comparison-operator GreaterThanThreshold
```

#### 7.2 Cost optimization

**Lifecycle policies:**
```json
{
  "Rules": [
    {
      "ID": "CostOptimization",
      "Status": "Enabled",
      "Transitions": [
        {
          "Days": 30,
          "StorageClass": "STANDARD_IA"
        },
        {
          "Days": 90, 
          "StorageClass": "GLACIER"
        }
      ]
    }
  ]
}
```

#### 7.3 Security hardening

**Bucket policy example:**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowMRAPOnly",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::your-bucket",
        "arn:aws:s3:::your-bucket/*"
      ],
      "Condition": {
        "StringEquals": {
          "s3:AccessedViaAccessPoint": "arn:aws:s3::123456789012:accesspoint/critical-cat-data"
        }
      }
    }
  ]
}
```

---

## 8. Dọn dẹp Resources 🧹

### ⚠️ Quan trọng: Luôn cleanup sau khi test!

AWS sẽ charge tiền cho:
- Storage trong buckets
- MRAP requests  
- Cross-region data transfer

### Bước 1: Xóa objects trong buckets

```bash
# Empty Singapore bucket
aws s3 rm s3://multi-region-demo-singapore-1691234567 --recursive

# Empty Sydney bucket  
aws s3 rm s3://multi-region-demo-sydney-1691234567 --recursive
```

### Bước 2: Xóa object versions

```bash
# List và delete tất cả versions (vì đã enable versioning)
aws s3api list-object-versions \
  --bucket multi-region-demo-singapore-1691234567 \
  --query 'Versions[].{Key:Key,VersionId:VersionId}' \
  --output json > versions.json

# Delete versions (script phức tạp hơn, dùng Console dễ hơn)
```

### Bước 3: Xóa MRAP (qua Console)

1. Vào S3 Console → Multi-Region Access Points
2. Select MRAP → Click **Delete**
3. Type tên MRAP để confirm
4. Đợi deletion complete (có thể mất 10-20 phút)

### Bước 4: Xóa buckets

1. Vào S3 Console → Buckets
2. Select Singapore bucket → **Empty** → **Delete**
3. Select Sydney bucket → **Empty** → **Delete**

### Verification

Check không còn charges:
- S3 Console: 0 buckets
- Billing dashboard: No ongoing S3 charges

---

## 9. Câu hỏi ôn tập {#câu-hỏi-ôn-tập}

### 🎓 Level 1: Cơ bản

#### Câu 1: Multiple Choice
**Multi-Region Access Point giải quyết vấn đề gì?**

A) Tăng storage capacity của S3  
B) Giảm latency bằng cách route request đến region gần nhất  
C) Tăng security cho S3 buckets  
D) Giảm cost của S3 storage  

<details>
<summary>👆 Click để xem đáp án</summary>

**Đáp án: B**

**Giải thích:**
- A) Sai - MRAP không tăng storage capacity
- B) **Đúng** - MRAP tự động route request đến bucket ở region gần nhất
- C) Sai - Security không phải mục đích chính
- D) Sai - MRAP thực tế có thể tăng cost (duplicate storage + MRAP charges)

**Key point:** MRAP chủ yếu để **optimize performance** bằng cách giảm latency.
</details>

#### Câu 2: True/False
**"Để tạo Multi-Region Access Point, tất cả buckets phải enable versioning."**

<details>
<summary>👆 Click để xem đáp án</summary>

**Đáp án: TRUE**

**Giải thích:**
- Versioning là **requirement bắt buộc** cho MRAP
- Cần cho Cross-Region Replication
- Nếu chưa enable, sẽ không tạo được MRAP

**Lưu ý:** Versioning có thể tăng storage cost vì lưu multiple versions của cùng 1 object.
</details>

### 🎓 Level 2: Trung bình

#### Câu 3: Scenario-based
**Bạn có app mobile với users ở 3 regions: Singapore, Sydney, và Tokyo. Bạn tạo MRAP với buckets ở Singapore và Sydney. User ở Tokyo upload 1 file, sau đó user ở Sydney immediately download file đó nhưng gặp "NoSuchKey" error. Tại sao?**

<details>
<summary>👆 Click để xem đáp án</summary>

**Nguyên nhân:**
1. User Tokyo upload → MRAP route đến Singapore bucket (gần hơn Sydney)
2. File được lưu ở Singapore bucket
3. User Sydney download → MRAP route đến Sydney bucket  
4. File chưa replicate từ Singapore sang Sydney → NoSuchKey error

**Giải pháp:**
- Đợi replication complete (2-5 phút)
- Implement retry logic trong app
- Enable RTC (Replication Time Control) để có SLA 15 phút
- Sử dụng read-your-writes pattern

**Lesson learned:** MRAP có **eventually consistent** model, không phải immediate consistent.
</details>

### 🎓 Level 3: Nâng cao

#### Câu 4: Architecture Design
**Thiết kế MRAP solution cho e-commerce website với requirements:**
- 10 triệu users toàn cầu
- 99.9% availability SLA  
- Budget $5000/tháng cho storage
- Compliance: Data của EU users phải stay trong EU

<details>
<summary>👆 Click để xem sample solution</summary>

**Architecture Design:**

```yaml
# Primary Solution
Global MRAP: ecommerce-global-data
Regions:
  - us-east-1 (Virginia) - North America users
  - eu-west-1 (Ireland) - EU users  
  - ap-southeast-1 (Singapore) - Asia users

# Compliance Solution cho EU
Separate MRAP: ecommerce-eu-only
Regions:
  - eu-west-1 (Ireland)
  - eu-central-1 (Frankfurt)

Configuration:
  - Cross-Region Replication: Enabled
  - RTC: Enabled (cho SLA requirement)
  - Storage Classes: 
    * Hot data: Standard
    * Warm data: Standard-IA (after 30 days)
    * Cold data: Glacier (after 90 days)

Cost Optimization:
  - Intelligent Tiering: Enabled
  - Lifecycle policies: Configured
  - CloudWatch monitoring: Setup alerts

Security:
  - Bucket policies: Restrict access via MRAP only
  - IAM roles: Principle of least privilege  
  - Encryption: SSE-S3 enabled
```

**Key Decisions:**
1. **Dual MRAP approach** để handle EU compliance
2. **RTC enabled** để meet availability SLA  
3. **Lifecycle policies** để control costs
4. **3 regions** cho optimal global coverage

**Expected Monthly Cost:**
- Storage (3 regions × 1TB): ~$75
- MRAP requests (10M): ~$33
- Cross-region transfer: ~$150
- RTC: ~$15
- **Total: ~$273/month** (well under $5000 budget)
</details>

### 🎯 Certification Practice

#### Câu 5: AWS Solutions Architect
**Company XYZ đang migrate application từ on-premises lên AWS. Application serve files cho users ở North America, Europe, và Asia. Current architecture sử dụng single S3 bucket ở us-east-1, causing high latency cho users ở xa. Architect muốn optimize performance while maintaining single endpoint. Solution nào 
