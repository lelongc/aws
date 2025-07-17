

## **1. EBS Volume**  
EBS (Elastic Block Store) là một dịch vụ lưu trữ do AWS cung cấp, thường được gắn vào EC2 Instances như các ổ đĩa.  

- **Các đặc điểm chính**:  
  - **Dữ liệu bền vững**: Dữ liệu vẫn tồn tại ngay cả khi bạn tắt máy EC2 Instance.  
  - **Có thể mở rộng**: Bạn có thể tăng dung lượng EBS volume bất cứ lúc nào mà không cần phải khởi động lại EC2.  
  - **Cần được gắn vào (attach)**: EBS volume phải được gắn vào EC2 instance để sử dụng.  

---

## **2. Thiết bị lưu trữ (Device)**  
Khi một EBS volume được gắn vào EC2, nó sẽ xuất hiện dưới dạng một thiết bị trong hệ thống Linux, ví dụ:  
- **`/dev/xvdf`**: Đây là ổ đĩa EBS mới được gắn.  
- **Phân vùng**: Ổ đĩa có thể chia thành các phân vùng (partition) để quản lý. Ví dụ:  
  - `/dev/xvdf1`: Phân vùng đầu tiên trên thiết bị `/dev/xvdf`.  

- **Lệnh liên quan**:  
  - **`lsblk`**: Xem các thiết bị lưu trữ và phân vùng của chúng.  
  - **`blkid`**: Lấy thông tin UUID, hệ thống tệp của các thiết bị.  

---

## **3. Phân vùng (Partition)**  
### **Phân vùng là gì?**  
- Một phân vùng là một phần được chia ra từ một ổ đĩa vật lý, để sử dụng cho một mục đích cụ thể (chứa hệ điều hành, dữ liệu, hoặc swap).  
- **Ví dụ**:
  - `/dev/xvdf1`: Phân vùng đầu tiên của ổ đĩa `/dev/xvdf`.  

### **Công cụ phân vùng**:
- **`fdisk`**: Công cụ dùng để quản lý các phân vùng trên ổ đĩa.  
- **Lệnh cơ bản**:  
  - `sudo fdisk /dev/xvdf`: Mở giao diện để tạo, xóa hoặc thay đổi phân vùng.  

---

## **4. Hệ thống tệp (Filesystem)**  
### **Hệ thống tệp là gì?**  
Hệ thống tệp là cấu trúc giúp hệ điều hành quản lý dữ liệu trên ổ đĩa.  
- **Các loại phổ biến**:  
  - **`ext4`**: Phổ biến trên Linux, hỗ trợ lưu trữ ổn định.  
  - **`xfs`**: Hiệu năng cao, thường dùng cho hệ thống lớn.  

### **Quy trình tạo hệ thống tệp**:  
- **Lệnh**:
  - `sudo mkfs -t xfs /dev/xvdf1`: Tạo hệ thống tệp XFS trên phân vùng `/dev/xvdf1`.  
  - nếu muốn nguyên ổ thì  `sudo mkfs -t xfs /dev/xvdf`


---

## **5. Mount (Gắn kết ổ đĩa)**  
### **Mount là gì?**  
Mount là quá trình "gắn kết" hệ thống tệp của ổ đĩa vào một thư mục trong hệ thống Linux.  
- Ví dụ:  
  - Mount ổ đĩa `/dev/xvdf1` vào thư mục `/data`:  
```bash
    sudo mount /dev/xvdf1 /data
```

### **Tại sao cần Mount?**  
- Để hệ điều hành có thể truy cập dữ liệu trên ổ đĩa.  
- Thư mục mount trở thành "điểm kết nối" giữa hệ thống tệp và ổ đĩa.

---

## **6. /etc/fstab (File cấu hình tự động Mount)**  
### **/etc/fstab là gì?**  
Là file cấu hình được dùng để tự động mount các ổ đĩa mỗi khi hệ thống khởi động lại.  

- **Ví dụ dòng trong /etc/fstab**:  
```bash
  UUID=aebf131c-6957-451e-8d34-ec978d9581ae  /data  xfs  defaults,nofail  0  2
```
  - **UUID**: Định danh duy nhất của ổ đĩa (thay đổi theo thiết bị).  
  - **/data**: Thư mục nơi hệ thống tệp sẽ được mount.  
  - **xfs**: Loại hệ thống tệp.  
  - **defaults,nofail**: Các tùy chọn mount (cho phép khởi động ngay cả khi mount thất bại).  

### **Quy trình kiểm tra /etc/fstab**:  
- Unmount ổ đĩa:  
```bash
  sudo umount /data
```
- Mount lại tất cả theo /etc/fstab:  
```bash
  sudo mount -a
```

---

## **7. Mở rộng phân vùng và hệ thống tệp**  
Khi bạn tăng dung lượng ổ đĩa EBS, các bước sau cần thực hiện:  

1. **Kiểm tra phân vùng và dung lượng**:  
```bash
   lsblk
```

2. **Mở rộng phân vùng với growpart**:  
```bash
   sudo growpart /dev/xvdf 1
```

3. **Mở rộng hệ thống tệp**:  
   - Nếu hệ thống tệp là `xfs`:  
```bash
     sudo xfs_growfs /data
```
   - Nếu là `ext4`:  
```bash
     sudo resize2fs /dev/xvdf1
```

---

## **8. Tóm tắt quy trình tổng thể**
1. Gắn EBS volume và kiểm tra với `lsblk`.  
2. Tạo phân vùng (nếu cần) với `fdisk`.  
3. Tạo hệ thống tệp với `mkfs`.  
4. Mount vào thư mục với `mount`.  
5. Cập nhật `/etc/fstab` để tự động mount.  
6. Nếu mở rộng dung lượng:  
   - Mở rộng phân vùng với `growpart`.  
   - Mở rộng hệ thống tệp với `xfs_growfs` hoặc `resize2fs`.  

---

