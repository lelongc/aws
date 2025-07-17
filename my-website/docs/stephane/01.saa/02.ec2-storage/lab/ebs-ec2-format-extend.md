Extend the file system after resizing an EBS volume
# mở rộng volume
https://docs.aws.amazon.com/ebs/latest/userguide/recognize-expanded-volume-linux.html#:~:text=Create%20a%20snapshot,Knowledge%20Center%20article.

# gán volume, định dạng để dùng 
https://docs.aws.amazon.com/ebs/latest/userguide/ebs-using-volumes.html
phía dưới chỉ là dịch phần linux trong 2 link trên còn window thì xem trong 2 link trên 
---
[đọc thêm lý thuyết cho nhớ ](../lý-thuyết/ebs-ec2-extend-volume.md)

Giả sử bạn có một instance EC2 với volume EBS cho thiết bị gốc, `/dev/xvda`, và bạn vừa đính kèm một volume EBS trống vào instance này thông qua `/dev/sdf`. Dưới đây là các bước để làm cho volume vừa đính kèm sẵn sàng sử dụng.

#### 1. Kết nối vào instance qua SSH
Để bắt đầu, bạn cần kết nối vào instance của mình qua SSH. Tham khảo thêm thông tin chi tiết tại phần **Kết nối vào instance Linux**.

Thiết bị có thể đã được đính kèm vào instance với một tên thiết bị khác so với tên bạn chỉ định trong bản đồ thiết bị khối. Bạn có thể tham khảo thêm về tên thiết bị trên các instance Linux tại mục **device names**. Dùng lệnh `lsblk` để xem các thiết bị đính kèm và các điểm gắn của chúng (nếu có), giúp bạn xác định đúng tên thiết bị. Kết quả của lệnh `lsblk` sẽ loại bỏ phần tiền tố `/dev/` từ đường dẫn thiết bị đầy đủ.

Dưới đây là ví dụ đầu ra cho một instance sử dụng Nitro System, nơi các volume EBS được hiển thị dưới dạng thiết bị khối NVMe. Thiết bị gốc là `/dev/nvme0n1`, có hai phân vùng tên là `nvme0n1p1` và `nvme0n1p128`. Volume đính kèm là `/dev/nvme1n1`, chưa có phân vùng và chưa được gắn.

```bash
[ec2-user ~]$ lsblk
NAME          MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
nvme1n1       259:0    0  10G  0 disk
nvme0n1       259:1    0   8G  0 disk
-nvme0n1p1    259:2    0   8G  0 part /
-nvme0n1p128  259:3    0   1M  0 part
```

Đây là ví dụ đầu ra cho instance T2. Thiết bị gốc là `/dev/xvda`, có một phân vùng tên là `xvda1`. Volume đính kèm là `/dev/xvdf`, chưa có phân vùng và chưa được gắn.

```bash
[ec2-user ~]$ lsblk
NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
xvda    202:0    0    8G  0 disk
-xvda1  202:1    0    8G  0 part /
xvdf    202:80   0   10G  0 disk
```

#### 2. Kiểm tra xem volume có hệ thống tập tin không
Volume mới tạo ra là thiết bị khối thô và bạn cần phải tạo hệ thống tập tin trên đó trước khi có thể gắn và sử dụng. Các volume được tạo từ snapshots có thể đã có hệ thống tập tin sẵn; nếu bạn tạo hệ thống tập tin mới, việc này sẽ ghi đè lên dữ liệu hiện tại.

Dùng một hoặc cả hai lệnh sau để kiểm tra xem volume có hệ thống tập tin không:

- Dùng lệnh `file -s` để lấy thông tin về một thiết bị cụ thể, như kiểu hệ thống tập tin. Nếu kết quả hiển thị chỉ "data", nghĩa là thiết bị này chưa có hệ thống tập tin.

```bash
[ec2-user ~]$ sudo file -s /dev/xvdf
/dev/xvdf: data
```

- Nếu thiết bị đã có hệ thống tập tin, lệnh sẽ hiển thị thông tin về loại hệ thống tập tin. Ví dụ, kết quả dưới đây hiển thị thiết bị gốc với hệ thống tập tin XFS.

```bash
[ec2-user ~]$ sudo file -s /dev/xvda1
/dev/xvda1: SGI XFS filesystem data (blksz 4096, inosz 512, v2 dirs)
```

Dùng lệnh `lsblk -f` để lấy thông tin về tất cả các thiết bị đã được đính kèm vào instance.

```bash
[ec2-user ~]$ sudo lsblk -f
```

Ví dụ đầu ra dưới đây cho thấy ba thiết bị đã được đính kèm vào instance: `nvme1n1`, `nvme0n1`, và `nvme2n1`. Cột FSTYPE hiển thị loại hệ thống tập tin cho mỗi thiết bị. Nếu cột này trống, có nghĩa là thiết bị không có hệ thống tập tin. Trong trường hợp này, thiết bị `nvme1n1` và phân vùng `nvme0n1p1` trên thiết bị `nvme0n1` đều được định dạng với hệ thống tập tin XFS, trong khi thiết bị `nvme2n1` và phân vùng `nvme0n1p128` trên thiết bị `nvme0n1` không có hệ thống tập tin.

```bash
NAME		FSTYPE	LABEL	UUID						MOUNTPOINT
nvme1n1	        xfs		7f939f28-6dcc-4315-8c42-6806080b94dd
nvme0n1
├─nvme0n1p1	xfs	    /	90e29211-2de8-4967-b0fb-16f51a6e464c	        /
└─nvme0n1p128
nvme2n1
```

Nếu đầu ra cho thấy không có hệ thống tập tin trên thiết bị, bạn cần tạo hệ thống tập tin.

#### 3. Tạo hệ thống tập tin
Nếu volume là mới và chưa có hệ thống tập tin, bạn cần tạo một hệ thống tập tin. Lưu ý không sử dụng lệnh này nếu bạn đang gắn volume đã có dữ liệu (ví dụ, volume được tạo từ một snapshot), vì lệnh này sẽ định dạng lại volume và xóa dữ liệu.

```bash
[ec2-user ~]$ sudo mkfs -t xfs /dev/xvdf
```

Nếu bạn gặp lỗi "mkfs.xfs not found", cài đặt công cụ XFS trước khi thực hiện lại lệnh trên.

```bash
[ec2-user ~]$ sudo yum install xfsprogs
```

#### 4. Tạo thư mục để gắn volume
Dùng lệnh `mkdir` để tạo thư mục gắn volume. Ví dụ, tạo thư mục `/data`:

```bash
[ec2-user ~]$ sudo mkdir /data
```

#### 5. Gắn volume vào thư mục
Gắn volume hoặc phân vùng vào thư mục đã tạo ở bước trước. Nếu volume không có phân vùng, bạn có thể gắn trực tiếp toàn bộ volume.

```bash
[ec2-user ~]$ sudo mount /dev/xvdf /data
```

Nếu volume có phân vùng, gắn phân vùng vào thư mục.

```bash
[ec2-user ~]$ sudo mount /dev/xvdf1 /data
```

#### 6. Kiểm tra quyền truy cập
Kiểm tra quyền truy cập của volume để đảm bảo rằng người dùng và ứng dụng có thể ghi vào volume.

#### 7. Tự động gắn volume sau khi khởi động lại
Để tự động gắn volume sau khi khởi động lại, bạn cần thêm một mục cho thiết bị trong tệp `/etc/fstab`.

Bạn có thể dùng tên thiết bị như `/dev/xvdf`, nhưng khuyến khích sử dụng UUID của thiết bị, vì UUID sẽ không thay đổi ngay cả khi tên thiết bị thay đổi. Để thêm UUID vào tệp `/etc/fstab`, thực hiện các bước sau:

- (Tùy chọn) Sao lưu tệp `/etc/fstab` trước khi chỉnh sửa.

```bash
[ec2-user ~]$ sudo cp /etc/fstab /etc/fstab.orig
```

- Dùng lệnh `blkid` để tìm UUID của thiết bị.

```bash
[ec2-user ~]$ sudo blkid
```

- Mở tệp `/etc/fstab` và thêm dòng sau:

```bash
UUID=aebf131c-6957-451e-8d34-ec978d9581ae  /data  xfs  defaults,nofail  0  2
```

- Để kiểm tra lại tệp `/etc/fstab`, bạn có thể unmount volume và sau đó mount lại tất cả các hệ thống tập tin trong `/etc/fstab`.

```bash
[ec2-user ~]$ sudo umount /data
[ec2-user ~]$ sudo mount -a
```

Nếu không có lỗi, tệp `/etc/fstab` đã đúng và volume sẽ tự động gắn khi instance khởi động lại.

------------------------
format và tạo  phân vùng rồi tăng volume ebs rồi format lại 


---

### 1. **Liệt kê tất cả các phân vùng và điểm mount**
- Sử dụng lệnh sau để hiển thị cấu trúc phân vùng và điểm mount:
```bash
  lsblk
```
  - **Ý nghĩa**: Hiển thị các thiết bị lưu trữ (block devices), phân vùng, và điểm mount.

---

### 2. **Hiển thị thông tin dung lượng và không gian trống của tất cả các volume**
- Dùng lệnh:
```bash
  df -h
```
  - **Ý nghĩa**: Hiển thị thông tin về dung lượng đã sử dụng, dung lượng còn trống của các volume theo định dạng dễ đọc (đơn vị GB/MB).

---

### 3. **Tạo phân vùng mới bằng `fdisk`**
- Thực hiện các bước sau để tạo phân vùng mới:
```bash
  sudo fdisk /dev/xvdf
```
  **Trong giao diện `fdisk`:**
  - Gõ `n` để tạo một phân vùng mới.
  - Chọn `p` cho phân vùng chính (primary partition).
  - Chọn số phân vùng (thường là `1` nếu đây là phân vùng đầu tiên).
  - Chấp nhận kích thước mặc định (hoặc nhập kích thước tùy chỉnh).
  - Gõ `w` để ghi các thay đổi và thoát.

---

### 4. **Định dạng phân vùng**
- Sau khi tạo phân vùng, định dạng nó bằng hệ thống tệp XFS:
```bash
  sudo mkfs -t xfs /dev/xvdf1
```
  - **Ý nghĩa**: Định dạng phân vùng `/dev/xvdf1` với hệ thống tệp XFS.

---

### 5. **Mount phân vùng**
- Tạo thư mục mount nếu chưa tồn tại:
```bash
  sudo mkdir -p /data
```
- Mount phân vùng vào thư mục `/data`:
```bash
  sudo mount /dev/xvdf1 /data
```
  - **Kiểm tra**: Dùng lệnh `df -h` để xác nhận phân vùng đã được mount.

---

### 6. **Cấu hình tự động mount sau khi khởi động lại**
- Lấy UUID của phân vùng:
```bash
  sudo blkid
```
  Hoặc:
```bash
  sudo lsblk -o +UUID
```
  **Kết quả**: UUID sẽ trông như sau:
```
  UUID="1234abcd-56ef-78gh-90ij-klmnopqrstuv"
```

- Chỉnh sửa file `/etc/fstab` để thêm cấu hình mount:
```bash
  sudo vi /etc/fstab
```
  Thêm dòng sau vào cuối file (thay thế `UUID="..."` bằng UUID của bạn):
```
  UUID="1234abcd-56ef-78gh-90ij-klmnopqrstuv" /data xfs defaults,nofail 0 0
```

- **Kiểm tra cấu hình**:
  - Tháo mount thư mục:
```bash
    sudo umount /data
```
  - Thực thi lại lệnh mount từ file `fstab`:
```bash
    sudo mount -a
```
  - **Kiểm tra lại**: Dùng `df -h` để đảm bảo `/data` đã được mount.

---

### 7. **Mở rộng phân vùng sau khi tăng kích thước EBS trên AWS Console**
- Dùng lệnh sau để mở rộng phân vùng mà không mất dữ liệu:
```bash
  sudo growpart /dev/xvdf 1
```
  - **Ý nghĩa**: Mở rộng phân vùng `1` trên thiết bị `/dev/xvdf`.

---

### 8. **Cập nhật lại kích thước hệ thống tệp**
- Sau khi mở rộng phân vùng, cập nhật lại kích thước hệ thống tệp:
```bash
  sudo xfs_growfs /data
```
  - **Ý nghĩa**: Mở rộng hệ thống tệp XFS để sử dụng toàn bộ không gian phân vùng.

---

### 9. **Xác minh**
- Dùng các lệnh sau để kiểm tra:
  - Kiểm tra dung lượng mới:
```bash
    df -h
```
  - Kiểm tra cấu trúc phân vùng:
```bash
    lsblk
```

Với các bước trên, bạn sẽ hoàn thành việc tạo, mount, và mở rộng phân vùng trên máy chủ Linux.
