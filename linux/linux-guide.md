# Linux - Hướng dẫn toàn diện

## Mục lục

- [Giới thiệu về Linux](#giới-thiệu-về-linux)
- [Các bản phân phối Linux](#các-bản-phân-phối-linux)
- [Cài đặt Linux](#cài-đặt-linux)
- [Hệ thống file Linux](#hệ-thống-file-linux)
- [Terminal & Shell](#terminal--shell)
- [Quản lý người dùng](#quản-lý-người-dùng)
- [Quản lý file và thư mục](#quản-lý-file-và-thư-mục)
- [Quyền và permission](#quyền-và-permission)
- [Quản lý gói phần mềm](#quản-lý-gói-phần-mềm)
- [Quản lý tiến trình](#quản-lý-tiến-trình)
- [Quản lý dịch vụ](#quản-lý-dịch-vụ)
- [Quản lý mạng](#quản-lý-mạng)
- [Quản lý ổ đĩa](#quản-lý-ổ-đĩa)
- [Text processing](#text-processing)
- [Shell scripting](#shell-scripting)
- [Bảo mật Linux](#bảo-mật-linux)
- [Giám sát hệ thống](#giám-sát-hệ-thống)
- [Linux trong Server & Cloud](#linux-trong-server--cloud)
- [Khắc phục sự cố](#khắc-phục-sự-cố)
- [Tài liệu tham khảo](#tài-liệu-tham-khảo)

## Giới thiệu về Linux

Linux là một hệ điều hành mã nguồn mở được phát triển dựa trên UNIX. Được tạo ra bởi Linus Torvalds vào năm 1991, Linux ngày nay đóng vai trò quan trọng trong các máy chủ, siêu máy tính, và ngày càng phổ biến trong các thiết bị di động, máy tính để bàn, và nhúng.

### Đặc điểm chính của Linux:

- **Mã nguồn mở**: Miễn phí tải về, sửa đổi và tái phân phối
- **Đa nền tảng**: Chạy trên nhiều loại phần cứng khác nhau
- **Đa nhiệm**: Cho phép chạy nhiều chương trình đồng thời
- **Ổn định**: Có thể chạy liên tục trong thời gian dài không cần khởi động lại
- **Bảo mật**: Thiết kế với cơ chế phân quyền chặt chẽ
- **Cộng đồng mạnh**: Nhiều người đóng góp và hỗ trợ

### Kiến trúc của Linux:

1. **Kernel**: Nhân hệ điều hành, tương tác trực tiếp với phần cứng
2. **Shell**: Giao diện dòng lệnh để người dùng tương tác với kernel
3. **Filesystem**: Hệ thống quản lý file và thư mục
4. **Utilities**: Các công cụ và ứng dụng hệ thống
5. **X Window System**: Cung cấp framework cho giao diện đồ họa
6. **Desktop Environment**: Môi trường đồ họa người dùng (GNOME, KDE, XFCE, v.v.)

## Các bản phân phối Linux

Linux có nhiều bản phân phối (distro) khác nhau, mỗi bản phục vụ những mục đích và đối tượng người dùng khác nhau.

### Nhóm Red Hat:

- **Red Hat Enterprise Linux (RHEL)**: Hướng đến doanh nghiệp, có hỗ trợ chính thức
- **Fedora**: Bản thử nghiệm của Red Hat, cập nhật công nghệ mới nhất
- **CentOS/Rocky Linux/AlmaLinux**: Bản miễn phí dựa trên RHEL, hướng đến server

### Nhóm Debian:

- **Debian**: Ổn định, hỗ trợ nhiều kiến trúc phần cứng
- **Ubuntu**: Dễ sử dụng, phổ biến với người dùng mới và desktop
- **Linux Mint**: Dễ sử dụng hơn nữa, giao diện thân thiện

### Nhóm SUSE:

- **SUSE Linux Enterprise**: Hướng đến doanh nghiệp, có hỗ trợ chính thức
- **openSUSE**: Bản miễn phí, có hai nhánh: Leap (ổn định) và Tumbleweed (cập nhật liên tục)

### Nhóm Arch:

- **Arch Linux**: Đơn giản, cập nhật liên tục (rolling release)
- **Manjaro**: Dựa trên Arch nhưng dễ sử dụng hơn

### Các bản phân phối nhẹ:

- **Lubuntu**: Ubuntu với LXDE/LXQt nhẹ hơn
- **Xubuntu**: Ubuntu với XFCE nhẹ hơn
- **Puppy Linux**: Rất nhẹ, chạy được trên máy tính cũ
- **Tiny Core Linux**: Siêu nhẹ, chỉ vài MB

### Bản phân phối chuyên dụng:

- **Kali Linux**: Chuyên về bảo mật và kiểm tra thâm nhập
- **Ubuntu Studio**: Cho sản xuất đa phương tiện
- **Scientific Linux**: Cho nghiên cứu khoa học
- **Qubes OS**: Tập trung vào bảo mật thông qua ảo hóa

## Cài đặt Linux

### Chuẩn bị trước khi cài đặt:

1. **Sao lưu dữ liệu** quan trọng
2. **Tải ISO** của bản phân phối mong muốn
3. **Tạo USB boot** hoặc đĩa cài đặt
4. **Phân vùng ổ cứng** nếu dual-boot với hệ điều hành khác

### Cài đặt từ USB:

```bash
# Tạo USB boot trên Linux
sudo dd if=/path/to/linux-distro.iso of=/dev/sdX bs=4M status=progress

# Hoặc sử dụng công cụ như:
# - Rufus (Windows)
# - Etcher (Cross-platform)
# - UNetbootin (Cross-platform)
```

### Phương pháp cài đặt:

1. **Cài đặt độc lập**: Linux là hệ điều hành duy nhất
2. **Dual-boot**: Cài song song với hệ điều hành khác (Windows, macOS)
3. **Máy ảo**: Sử dụng VirtualBox, VMware, KVM, v.v.
4. **WSL (Windows Subsystem for Linux)**: Chạy Linux trong Windows
5. **Live USB/CD**: Chạy Linux trực tiếp từ USB/CD không cần cài đặt

### Các bước cài đặt cơ bản:

1. **Boot từ USB/CD** cài đặt
2. **Chọn ngôn ngữ** và khu vực
3. **Phân vùng ổ cứng**:
   - `/` (root): Thư mục gốc (tối thiểu 15-20GB)
   - `/home`: Dữ liệu người dùng (tùy nhu cầu)
   - `swap`: Bộ nhớ ảo (thường bằng RAM hoặc 2GB)
4. **Thiết lập tài khoản** người dùng và mật khẩu
5. **Cài đặt boot loader** (GRUB)
6. **Khởi động lại** và đăng nhập vào hệ thống mới

## Hệ thống file Linux

Linux tổ chức dữ liệu theo cấu trúc cây thư mục, với thư mục gốc `/` (root) ở đầu cây.

### Các thư mục quan trọng:

- `/`: Thư mục gốc chứa toàn bộ hệ thống
- `/bin`: Chứa các lệnh cơ bản (binary) cho người dùng (ls, cp, mv)
- `/sbin`: Chứa lệnh quản trị hệ thống (fdisk, ifconfig)
- `/etc`: Chứa các file cấu hình hệ thống
- `/home`: Thư mục cá nhân của người dùng
- `/root`: Thư mục home của tài khoản root
- `/var`: Chứa dữ liệu biến động (logs, mail, databases)
- `/tmp`: Chứa file tạm thời
- `/usr`: Chứa ứng dụng và dữ liệu của người dùng
- `/opt`: Chứa phần mềm tùy chọn và phần mềm của bên thứ ba
- `/boot`: Chứa kernel và bootloader
- `/dev`: Chứa file thiết bị
- `/lib`: Chứa thư viện chia sẻ cho `/bin` và `/sbin`
- `/mnt`: Điểm mount tạm thời
- `/media`: Điểm mount tự động cho thiết bị di động
- `/proc`: Hệ thống file ảo cung cấp thông tin về tiến trình và kernel
- `/sys`: Hệ thống file ảo cung cấp thông tin về thiết bị

### Hệ thống file Linux phổ biến:

- **ext4**: Mặc định trên nhiều bản phân phối Linux
- **btrfs**: B-tree file system với tính năng nâng cao
- **xfs**: Hiệu năng cao, phù hợp với file lớn
- **zfs**: Hệ thống file tiên tiến, hỗ trợ RAID, snapshot
- **f2fs**: Hệ thống file cho SSD
- **NTFS/FAT32**: Hỗ trợ đọc/ghi đĩa Windows

### Các loại liên kết:

- **Hard link**: Nhiều tên cho cùng một inode
  ```bash
  ln file1 file2
  ```
- **Symbolic link** (symlink): Con trỏ đến file hoặc thư mục khác
  ```bash
  ln -s target_file link_name
  ```

## Terminal & Shell

### Terminal:

Terminal là một chương trình cung cấp giao diện dòng lệnh (CLI) cho phép người dùng tương tác với shell.

### Shell phổ biến:

- **Bash (Bourne Again SHell)**: Shell mặc định trên nhiều hệ thống Linux
- **Zsh**: Shell nâng cao với nhiều tính năng
- **Fish**: Shell thân thiện với người dùng mới
- **Dash**: Shell nhỏ gọn, thường dùng cho script
- **Ksh (KornShell)**: Shell mạnh cho lập trình

### Các phím tắt trong terminal:

- `Ctrl + C`: Hủy lệnh đang chạy
- `Ctrl + Z`: Tạm dừng lệnh đang chạy
- `Ctrl + D`: Gửi EOF (End of File)
- `Ctrl + L`: Xóa màn hình (clear)
- `Ctrl + A`: Di chuyển con trỏ về đầu dòng
- `Ctrl + E`: Di chuyển con trỏ về cuối dòng
- `Ctrl + U`: Xóa từ vị trí con trỏ đến đầu dòng
- `Ctrl + K`: Xóa từ vị trí con trỏ đến cuối dòng
- `Ctrl + R`: Tìm kiếm lịch sử lệnh
- `Tab`: Tự động hoàn thành lệnh/tên file

### Lệnh giúp đỡ:

```bash
# Xem hướng dẫn về lệnh
man command

# Hiển thị trang hướng dẫn ngắn gọn
command --help

# Hiển thị thông tin về lệnh
info command

# Hiển thị mô tả ngắn về lệnh
whatis command

# Tìm vị trí của lệnh
which command
whereis command
```

### Lịch sử lệnh:

```bash
# Hiển thị lịch sử lệnh
history

# Chạy lại lệnh gần đây
!!

# Chạy lại lệnh thứ n trong lịch sử
!n

# Chạy lệnh gần đây nhất bắt đầu bằng "string"
!string
```

## Quản lý người dùng

Linux là hệ điều hành đa người dùng, cho phép nhiều người dùng làm việc đồng thời.

### Các lệnh quản lý người dùng:

```bash
# Tạo người dùng mới
sudo useradd username

# Tạo người dùng với thông tin đầy đủ
sudo useradd -m -d /home/username -s /bin/bash -c "Full Name" username

# Tạo người dùng với giao diện tương tác
sudo adduser username

# Đặt mật khẩu cho người dùng
sudo passwd username

# Thay đổi thông tin người dùng
sudo usermod -options username

# Xóa người dùng
sudo userdel username

# Xóa người dùng và thư mục home
sudo userdel -r username

# Chuyển đổi sang người dùng khác
su - username

# Chạy lệnh với quyền root
sudo command

# Hiển thị các người dùng đang đăng nhập
who
w
```

### Các lệnh quản lý nhóm:

```bash
# Tạo nhóm mới
sudo groupadd groupname

# Thêm người dùng vào nhóm
sudo usermod -aG groupname username

# Xóa người dùng khỏi nhóm
sudo gpasswd -d username groupname

# Hiển thị các nhóm của người dùng
groups username

# Xóa nhóm
sudo groupdel groupname
```

### File cấu hình người dùng và nhóm:

- `/etc/passwd`: Thông tin người dùng
- `/etc/shadow`: Mật khẩu mã hóa của người dùng
- `/etc/group`: Thông tin nhóm
- `/etc/gshadow`: Mật khẩu mã hóa của nhóm
- `/etc/sudoers`: Cấu hình sudo
- `/etc/login.defs`: Cấu hình mặc định cho người dùng

## Quản lý file và thư mục

### Các lệnh cơ bản:

```bash
# Xem nội dung thư mục
ls
ls -l    # Hiển thị chi tiết
ls -a    # Hiển thị file ẩn
ls -lh   # Hiển thị kích thước dễ đọc

# Thay đổi thư mục
cd /path/to/directory
cd ~     # Đến thư mục home
cd -     # Trở về thư mục trước đó

# Hiển thị thư mục hiện tại
pwd

# Tạo thư mục
mkdir directory
mkdir -p parent/child/directory    # Tạo cả thư mục cha

# Xóa thư mục trống
rmdir directory

# Tạo file trống
touch filename

# Sao chép file và thư mục
cp source destination
cp -r source_dir destination_dir   # Sao chép thư mục và nội dung

# Di chuyển/đổi tên file và thư mục
mv source destination

# Xóa file
rm filename
rm -f filename    # Force delete

# Xóa thư mục và nội dung
rm -r directory
rm -rf directory  # Force delete

# Hiển thị nội dung file
cat filename
less filename     # Xem theo trang
more filename     # Xem theo trang
head filename     # Xem 10 dòng đầu
tail filename     # Xem 10 dòng cuối
tail -f filename  # Xem nội dung cập nhật liên tục

# Tìm kiếm file
find /path -name "pattern"
find /path -type f -name "*.txt"   # Tìm file .txt
find /path -type d -name "dir*"    # Tìm thư mục bắt đầu bằng "dir"
find /path -size +10M              # Tìm file lớn hơn 10MB

# Tìm kiếm văn bản trong file
grep "pattern" filename
grep -r "pattern" directory        # Tìm trong thư mục và thư mục con
```

### Liên kết file:

```bash
# Tạo hard link
ln source link_name

# Tạo symbolic link
ln -s source link_name
```

### So sánh file:

```bash
# So sánh hai file
diff file1 file2

# So sánh hai file theo dạng trực quan
vimdiff file1 file2

# So sánh hai thư mục
diff -r dir1 dir2
```

### Nén và giải nén:

```bash
# Tạo archive tar
tar -cvf archive.tar files/

# Giải nén archive tar
tar -xvf archive.tar

# Tạo archive và nén gzip
tar -czvf archive.tar.gz files/

# Giải nén archive gzip
tar -xzvf archive.tar.gz

# Tạo archive và nén bzip2
tar -cjvf archive.tar.bz2 files/

# Giải nén archive bzip2
tar -xjvf archive.tar.bz2

# Nén file với gzip
gzip filename

# Giải nén file gzip
gzip -d filename.gz

# Nén file với zip
zip -r archive.zip directory/

# Giải nén file zip
unzip archive.zip
```

## Quyền và permission

Linux có hệ thống phân quyền chi tiết cho file và thư mục.

### Loại quyền cơ bản:

- `r` (read): Quyền đọc - 4
- `w` (write): Quyền ghi - 2
- `x` (execute): Quyền thực thi - 1

### Áp dụng quyền cho:

- `u` (user): Chủ sở hữu file
- `g` (group): Nhóm sở hữu
- `o` (others): Người dùng khác
- `a` (all): Tất cả (user, group, others)

### Thay đổi quyền:

```bash
# Sử dụng ký hiệu chữ
chmod u+x filename        # Thêm quyền thực thi cho user
chmod g-w filename        # Xóa quyền ghi cho group
chmod o=r filename        # Set quyền đọc cho others
chmod a+r filename        # Thêm quyền đọc cho tất cả

# Sử dụng số
chmod 755 filename        # rwxr-xr-x (user: rwx, group: r-x, others: r-x)
chmod 644 filename        # rw-r--r-- (user: rw-, group: r--, others: r--)
chmod 700 filename        # rwx------ (user: rwx, group: ---, others: ---)

# Thay đổi đệ quy cho thư mục
chmod -R 755 directory
```

### Quyền đặc biệt:

- `SUID (Set User ID)`: Khi thực thi, file sẽ chạy với quyền của chủ sở hữu
- `SGID (Set Group ID)`: Khi thực thi, file sẽ chạy với quyền của nhóm sở hữu
- `Sticky Bit`: Chỉ chủ sở hữu file mới có thể xóa file trong thư mục

```bash
# Set SUID
chmod u+s filename    # Hoặc chmod 4755 filename

# Set SGID
chmod g+s filename    # Hoặc chmod 2755 filename

# Set Sticky Bit
chmod +t directory    # Hoặc chmod 1755 directory
```

### Thay đổi chủ sở hữu:

```bash
# Thay đổi chủ sở hữu
chown user filename

# Thay đổi chủ sở hữu và nhóm
chown user:group filename

# Thay đổi chủ sở hữu đệ quy cho thư mục
chown -R user:group directory
```

### Thay đổi nhóm:

```bash
# Thay đổi nhóm
chgrp group filename

# Thay đổi nhóm đệ quy cho thư mục
chgrp -R group directory
```

### Access Control Lists (ACL):

ACLs cung cấp quyền chi tiết hơn so với quyền Unix truyền thống.

```bash
# Xem ACL của file
getfacl filename

# Đặt ACL cho người dùng
setfacl -m u:username:rwx filename

# Đặt ACL cho nhóm
setfacl -m g:groupname:rx filename

# Xóa tất cả ACL
setfacl -b filename
```

## Quản lý gói phần mềm

Linux có nhiều hệ thống quản lý gói tùy thuộc vào bản phân phối.

### Debian và Ubuntu (APT):

```bash
# Cập nhật danh sách gói
apt update

# Nâng cấp tất cả các gói
apt upgrade

# Nâng cấp hệ thống (thêm/xóa gói nếu cần)
apt full-upgrade

# Cài đặt gói
apt install package

# Xóa gói
apt remove package

# Xóa gói và file cấu hình
apt purge package

# Tìm kiếm gói
apt search keyword

# Hiển thị thông tin gói
apt show package

# Xóa các gói không cần thiết
apt autoremove

# Xóa cache gói đã tải
apt clean
```

### Red Hat, Fedora, CentOS (DNF/YUM):

```bash
# Cập nhật tất cả các gói
dnf update

# Cài đặt gói
dnf install package

# Xóa gói
dnf remove package

# Tìm kiếm gói
dnf search keyword

# Hiển thị thông tin gói
dnf info package

# Liệt kê các nhóm gói
dnf group list

# Cài đặt nhóm gói
dnf group install "group_name"

# Xóa các gói không cần thiết
dnf autoremove

# Xóa cache gói đã tải
dnf clean all
```

### Arch Linux (Pacman):

```bash
# Đồng bộ và cập nhật tất cả các gói
pacman -Syu

# Cài đặt gói
pacman -S package

# Xóa gói
pacman -R package

# Xóa gói và các dependencies không sử dụng
pacman -Rs package

# Tìm kiếm gói
pacman -Ss keyword

# Hiển thị thông tin gói
pacman -Si package

# Liệt kê các gói đã cài đặt
pacman -Q

# Xóa cache gói đã tải
pacman -Sc
```

### SUSE và openSUSE (Zypper):

```bash
# Cập nhật tất cả các gói
zypper update

# Cài đặt gói
zypper install package

# Xóa gói
zypper remove package

# Tìm kiếm gói
zypper search keyword

# Hiển thị thông tin gói
zypper info package
```

### Cài đặt từ mã nguồn:

```bash
# Cài đặt công cụ build
sudo apt install build-essential  # Ubuntu
sudo dnf groupinstall "Development Tools"  # Fedora/RHEL

# Cài đặt từ mã nguồn
./configure
make
sudo make install
```

## Quản lý tiến trình

Linux cho phép xem và quản lý các tiến trình (process) đang chạy trên hệ thống.

### Các lệnh hiển thị tiến trình:

```bash
# Hiển thị tất cả tiến trình
ps aux

# Hiển thị tiến trình trong dạng cây
ps -ejH
pstree

# Hiển thị tiến trình theo thời gian thực
top
htop        # Phiên bản nâng cao của top
btop        # Phiên bản đồ họa hơn

# Hiển thị tiến trình của người dùng cụ thể
ps -u username
```

### Quản lý tiến trình:

```bash
# Chạy chương trình ở background
command &

# Đưa tiến trình đang chạy vào background
Ctrl+Z
bg

# Đưa tiến trình từ background về foreground
fg

# Liệt kê các job đang chạy
jobs

# Gửi tín hiệu đến tiến trình
kill PID
kill -9 PID    # Buộc kết thúc
kill -l        # Liệt kê các tín hiệu

# Kết thúc tiến trình theo tên
pkill process_name
killall process_name

# Tìm PID của tiến trình
pgrep process_name
pidof process_name

# Hiển thị tiến trình sử dụng file/port
lsof /path/to/file
lsof -i :port

# Đặt nice level (ưu tiên tiến trình, -20 đến 19)
nice -n value command
renice value -p PID
```

### Giám sát hệ thống:

```bash
# Thông tin CPU, RAM, v.v theo thời gian thực
vmstat
iostat
dstat

# Thông tin CPU
mpstat

# Thông tin bộ nhớ
free -h
```

## Quản lý dịch vụ

Linux sử dụng các hệ thống init khác nhau để quản lý dịch vụ (services).

### systemd (hầu hết các bản phân phối hiện đại):

```bash
# Khởi động dịch vụ
systemctl start service_name

# Dừng dịch vụ
systemctl stop service_name

# Khởi động lại dịch vụ
systemctl restart service_name

# Tải lại cấu hình dịch vụ
systemctl reload service_name

# Kích hoạt dịch vụ (chạy khi boot)
systemctl enable service_name

# Vô hiệu hóa dịch vụ (không chạy khi boot)
systemctl disable service_name

# Kiểm tra trạng thái dịch vụ
systemctl status service_name

# Xem tất cả dịch vụ đang chạy
systemctl list-units --type=service

# Xem log của dịch vụ
journalctl -u service_name

# Xem log theo thời gian thực
journalctl -f -u service_name
```

### SysVinit (các bản phân phối cũ):

```bash
# Khởi động dịch vụ
service service_name start

# Dừng dịch vụ
service service_name stop

# Khởi động lại dịch vụ
service service_name restart

# Kiểm tra trạng thái dịch vụ
service service_name status

# Kích hoạt dịch vụ (chạy khi boot)
chkconfig service_name on

# Vô hiệu hóa dịch vụ (không chạy khi boot)
chkconfig service_name off
```

### Upstart (Ubuntu cũ):

```bash
# Khởi động dịch vụ
start service_name

# Dừng dịch vụ
stop service_name

# Khởi động lại dịch vụ
restart service_name

# Kiểm tra trạng thái dịch vụ
status service_name
```

## Quản lý mạng

### Cấu hình mạng cơ bản:

```bash
# Xem thông tin mạng
ip address show
ifconfig

# Kích hoạt/vô hiệu hóa interface
ip link set eth0 up
ip link set eth0 down

# Đặt địa chỉ IP
ip address add 192.168.1.100/24 dev eth0

# Xem bảng routing
ip route show
route -n

# Thêm route mặc định
ip route add default via 192.168.1.1

# Xem kết nối mạng
netstat -tuln
ss -tuln

# Kiểm tra kết nối
ping hostname
traceroute hostname
tracepath hostname
```

### NetworkManager (quản lý trực quan):

```bash
# Kiểm tra trạng thái
nmcli general status

# Liệt kê tất cả kết nối
nmcli connection show

# Kích hoạt kết nối
nmcli connection up connection_name

# Vô hiệu hóa kết nối
nmcli connection down connection_name

# Tạo kết nối wifi mới
nmcli device wifi connect SSID password PASSWORD

# Quét wifi
nmcli device wifi list
```

### Cấu hình DNS:

```bash
# Kiểm tra DNS resolution
host example.com
dig example.com
nslookup example.com

# File cấu hình DNS
# /etc/resolv.conf
# /etc/hosts
```

### Tường lửa:

#### UFW (Ubuntu):

```bash
# Kích hoạt UFW
sudo ufw enable

# Cho phép dịch vụ
sudo ufw allow ssh
sudo ufw allow http

# Cho phép port cụ thể
sudo ufw allow 8080/tcp

# Từ chối kết nối
sudo ufw deny 3306

# Kiểm tra trạng thái
sudo ufw status verbose
```

#### firewalld (Fedora, RHEL, CentOS):

```bash
# Kiểm tra trạng thái
sudo firewall-cmd --state

# Liệt kê zones
sudo firewall-cmd --list-all-zones

# Cho phép dịch vụ
sudo firewall-cmd --permanent --add-service=http

# Cho phép port
sudo firewall-cmd --permanent --add-port=8080/tcp

# Tải lại cấu hình
sudo firewall-cmd --reload
```

### Công cụ mạng hữu ích:

```bash
# Theo dõi kết nối mạng
iftop     # theo dõi băng thông
nethogs   # theo dõi theo process
tcpdump   # phân tích gói tin

# Công cụ download
wget URL
curl -O URL

# Truyền file qua ssh
scp file.txt user@remote:/path
rsync -avz source/ user@remote:/path
```

## Quản lý ổ đĩa

### Xem thông tin ổ đĩa:

```bash
# Liệt kê ổ đĩa và phân vùng
lsblk
fdisk -l
parted -l

# Hiển thị không gian ổ đĩa
df -h
du -sh /path/to/directory

# Kiểm tra loại filesystem
file -s /dev/sda1
blkid
```

### Quản lý phân vùng:

```bash
# Tạo/quản lý phân vùng
fdisk /dev/sdb
gdisk /dev/sdb    # Cho GPT
parted /dev/sdb   # Công cụ nâng cao

# Tạo filesystem
mkfs.ext4 /dev/sdb1    # ext4
mkfs.xfs /dev/sdb1     # XFS
mkfs.btrfs /dev/sdb1   # Btrfs
mkswap /dev/sdb2       # swap

# Mount/unmount
mount /dev/sdb1 /mnt/data
umount /mnt/data

# Mount tự động khi khởi động
# Sửa file /etc/fstab
```

### Logical Volume Management (LVM):

```bash
# Tạo Physical Volume
pvcreate /dev/sdb

# Hiển thị Physical Volumes
pvs
pvdisplay

# Tạo Volume Group
vgcreate vg_name /dev/sdb

# Hiển thị Volume Groups
vgs
vgdisplay

# Tạo Logical Volume
lvcreate -L 10G -n lv_name vg_name

# Hiển thị Logical Volumes
lvs
lvdisplay

# Mở rộng Logical Volume
lvextend -L +5G /dev/vg_name/lv_name
resize2fs /dev/vg_name/lv_name
```

### Kiểm tra và sửa chữa filesystem:

```bash
# Kiểm tra filesystem
fsck /dev/sdb1

# Kiểm tra và sửa bad blocks
badblocks -v /dev/sdb1

# Tune filesystem
tune2fs -options /dev/sdb1
```

### RAID:

```bash
# Kiểm tra thông tin RAID
cat /proc/mdstat
mdadm --detail /dev/md0

# Tạo RAID
mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
```

## Text processing

Linux cung cấp nhiều công cụ mạnh mẽ để xử lý văn bản.

### Editors:

```bash
# Editors cơ bản
nano filename    # Beginner-friendly
vi filename      # Tiêu chuẩn Unix
vim filename     # Vi cải tiến

# Mở và đi đến dòng cụ thể
vi +10 filename
```

### Xử lý văn bản:

```bash
# Đếm dòng, từ, bytes
wc filename
wc -l filename    # Chỉ đếm dòng

# Sắp xếp
sort filename
sort -r filename  # Đảo ngược
sort -n filename  # Theo số

# Loại bỏ dòng trùng lặp
uniq filename
sort filename | uniq

# Cut columns
cut -d ',' -f 1,3 filename    # Cắt cột 1 và 3, delimiter là dấu phẩy

# Ghép file
paste file1 file2

# Thay thế văn bản
sed 's/old/new/g' filename
sed -i 's/old/new/g' filename    # Thay đổi file gốc

# Xử lý mẫu nâng cao
awk '{print $1, $3}' filename    # In cột 1 và 3
```

### Tìm kiếm nội dung:

```bash
# Tìm văn bản trong file
grep "pattern" filename
grep -i "pattern" filename    # Không phân biệt hoa/thường
grep -r "pattern" directory   # Tìm đệ quy

# Tìm kiếm mẫu kết hợp
grep -E "pattern1|pattern2" filename
egrep "pattern1|pattern2" filename

# Lọc dòng
grep -v "pattern" filename    # Dòng không chứa pattern
```

### Xử lý luồng dữ liệu:

```bash
# Chuyển hướng output
command > file      # Ghi đè file
command >> file     # Nối vào file

# Chuyển hướng input
command < file

# Chuyển hướng error
command 2> error.log

# Chuyển hướng output và error
command > file 2>&1
command &> file     # Cú pháp ngắn hơn

# Pipe output to another command
command1 | command2
```

### Trình soạn thảo vi/vim cơ bản:

#### Chế độ:

- `i` - Insert mode: Chèn văn bản
- `Esc` - Command mode: Thực hiện lệnh
- `:` - Last-line mode: Thực hiện lệnh cao cấp

#### Các lệnh di chuyển:

- `h` `j` `k` `l` - Trái, xuống, lên, phải
- `w` - Đầu từ tiếp theo
- `b` - Đầu từ trước
- `0` - Đầu dòng
- `$` - Cuối dòng
- `G` - Cuối file
- `gg` - Đầu file
- `:n` - Đi đến dòng n

#### Các lệnh chỉnh sửa:

- `x` - Xóa ký tự
- `dd` - Xóa dòng
- `yy` - Copy dòng
- `p` - Paste sau con trỏ
- `u` - Undo
- `Ctrl+r` - Redo

#### Các lệnh lưu và thoát:

- `:w` - Lưu
- `:q` - Thoát
- `:wq` - Lưu và thoát
- `:q!` - Thoát không lưu

## Shell scripting

Shell scripting cho phép tự động hóa các tác vụ trên Linux.

### Tạo script:

```bash
# Tạo file script
touch script.sh

# Thêm quyền thực thi
chmod +x script.sh

# Chỉ định shell
#!/bin/bash
```

### Cú pháp cơ bản:

```bash
#!/bin/bash

# Comment

# Biến
NAME="World"
echo "Hello, $NAME!"

# Input từ người dùng
echo "Nhập tên của bạn: "
read USERNAME
echo "Xin chào, $USERNAME!"

# Arguments
echo "Script name: $0"
echo "First argument: $1"
echo "All arguments: $@"
echo "Number of arguments: $#"

# Toán tử
A=10
B=5
echo $((A + B))
echo $((A - B))
echo $((A * B))
echo $((A / B))
```

### Điều kiện:

```bash
# If-else
if [ "$A" -eq "$B" ]; then
    echo "A equals B"
elif [ "$A" -gt "$B" ]; then
    echo "A is greater than B"
else
    echo "A is less than B"
fi

# So sánh với chuỗi
if [ "$STRING1" = "$STRING2" ]; then
    echo "Strings are equal"
fi

# Kiểm tra file
if [ -f "$FILE" ]; then
    echo "File exists"
fi
if [ -d "$DIR" ]; then
    echo "Directory exists"
fi

# Logical operators
if [ "$A" -eq 10 ] && [ "$B" -eq 5 ]; then
    echo "A=10 and B=5"
fi

if [ "$A" -eq 10 ] || [ "$B" -eq 5 ]; then
    echo "A=10 or B=5"
fi
```

### Vòng lặp:

```bash
# For loop
for i in 1 2 3 4 5; do
    echo "Number: $i"
done

# For loop với range
for i in {1..5}; do
    echo "Number: $i"
done

# For với increment
for ((i=1; i<=5; i++)); do
    echo "Number: $i"
done

# While loop
COUNT=1
while [ $COUNT -le 5 ]; do
    echo "Count: $COUNT"
    COUNT=$((COUNT + 1))
done

# Until loop
COUNT=1
until [ $COUNT -gt 5 ]; do
    echo "Count: $COUNT"
    COUNT=$((COUNT + 1))
done
```

### Functions:

```bash
# Định nghĩa function
function greet {
    echo "Hello, $1!"
}

# Gọi function
greet "John"

# Function với return
function add {
    local RESULT=$(($1 + $2))
    echo $RESULT
}

SUM=$(add 5 3)
echo "Sum: $SUM"
```

### Arrays:

```bash
# Khai báo array
FRUITS=("Apple" "Banana" "Cherry")

# Truy cập phần tử
echo ${FRUITS[0]}   # Apple

# Tất cả phần tử
echo ${FRUITS[@]}

# Số phần tử
echo ${#FRUITS[@]}

# Thêm phần tử
FRUITS+=("Orange")

# Lặp qua array
for FRUIT in "${FRUITS[@]}"; do
    echo $FRUIT
done
```

### Xử lý errors:

```bash
# Exit codes
echo "Exit code of last command: $?"

# Exit với code
exit 0   # Success
exit 1   # Error

# Trap signals
trap "echo 'Script interrupted'; exit" SIGINT SIGTERM
```

## Bảo mật Linux

### Quản lý mật khẩu:

```bash
# Thay đổi mật khẩu người dùng
passwd username

# Chính sách mật khẩu
# /etc/login.defs
# /etc/security/pwquality.conf

# Khóa tài khoản
passwd -l username

# Mở khóa tài khoản
passwd -u username
```

### Sudo và quyền nâng cao:

```bash
# Cấu hình sudo
visudo

# Ví dụ cấu hình sudo
username ALL=(ALL) ALL
```

### Bảo mật SSH:

```bash
# Tạo key SSH
ssh-keygen -t ed25519

# Copy public key đến server
ssh-copy-id user@server

# Cấu hình SSH server (/etc/ssh/sshd_config)
# Vô hiệu hóa đăng nhập root
PermitRootLogin no

# Vô hiệu hóa đăng nhập bằng mật khẩu
PasswordAuthentication no

# Khởi động lại SSH server
systemctl restart sshd
```

### SELinux/AppArmor:

#### SELinux (Fedora, RHEL, CentOS):

```bash
# Kiểm tra trạng thái SELinux
getenforce
sestatus

# Thay đổi mode
setenforce 0   # Permissive
setenforce 1   # Enforcing

# Cấu hình SELinux (/etc/selinux/config)

# Quản lý context
ls -Z
chcon -t httpd_sys_content_t /var/www/html/file
restorecon -v /var/www/html/file
```

#### AppArmor (Ubuntu, SUSE):

```bash
# Kiểm tra trạng thái AppArmor
aa-status

# Cấu hình profile
cd /etc/apparmor.d/

# Quản lý profile
aa-enforce profile
aa-complain profile
```

### Quét lỗ hổng:

```bash
# Lynis (security auditing tool)
lynis audit system

# Chkrootkit (rootkit detector)
chkrootkit

# Rkhunter (rootkit hunter)
rkhunter --check
```

### Cập nhật bảo mật:

```bash
# Ubuntu
apt update && apt upgrade

# Fedora/RHEL/CentOS
dnf upgrade --security

# Arch Linux
pacman -Syu
```

## Giám sát hệ thống

### Giám sát tài nguyên:

```bash
# Giám sát CPU, RAM, disk I/O, network
top
htop
atop
glances

# Giám sát disk usage
df -h
du -sh /path

# Giám sát network
iftop
nethogs
iptraf
```

### Giám sát log:

```bash
# System logs
less /var/log/syslog
less /var/log/messages

# Authentication logs
less /var/log/auth.log
less /var/log/secure

# Boot logs
journalctl -b

# Kernel messages
dmesg

# Log real-time
tail -f /var/log/syslog

# Systemd journal
journalctl -u service_name
journalctl -f    # Follow logs
```

### Công cụ giám sát:

- **Prometheus**: Hệ thống giám sát và cảnh báo
- **Grafana**: Visualization dashboard
- **Nagios**: Giám sát hệ thống và mạng
- **Zabbix**: Enterprise monitoring solution
- **ELK Stack (Elasticsearch, Logstash, Kibana)**: Log analysis

### Backup và khôi phục:

```bash
# Simple backup with tar
tar -czvf backup.tar.gz /path/to/backup

# Incremental backup with rsync
rsync -avz --delete /source/ /destination/

# Remote backup with rsync over SSH
rsync -avz -e ssh /source/ user@remote:/destination/

# Clone disk with dd
dd if=/dev/sda of=/dev/sdb bs=4M status=progress

# Backup MBR
dd if=/dev/sda of=mbr_backup bs=512 count=1
```

## Linux trong Server & Cloud

### Web server:

```bash
# Apache
apt install apache2
systemctl start apache2
systemctl enable apache2

# Nginx
apt install nginx
systemctl start nginx
systemctl enable nginx
```

### Database:

```bash
# MySQL/MariaDB
apt install mariadb-server
systemctl start mariadb
mysql_secure_installation

# PostgreSQL
apt install postgresql
systemctl start postgresql
```

### Containerization:

```bash
# Docker
apt install docker.io
systemctl start docker
systemctl enable docker

# Basic Docker commands
docker pull image
docker run -d -p 80:80 image
docker ps
docker stop container_id
```

### CI/CD:

- **Jenkins**: Automation server
- **GitLab CI/CD**: Integrated CI/CD with GitLab
- **GitHub Actions**: CI/CD integrated with GitHub

### Cloud integration:

- **AWS CLI**: Interact with Amazon Web Services
- **Azure CLI**: Interact with Microsoft Azure
- **Google Cloud SDK**: Interact with Google Cloud Platform

### Automation:

```bash
# Ansible
apt install ansible

# Terraform
# Download from terraform.io
```

## Khắc phục sự cố

### Boot issues:

1. **Grub rescue mode**:

```bash
set prefix=(hd0,1)/boot/grub
set root=(hd0,1)
insmod normal
normal
```

2. **Emergency mode**:

```bash
journalctl -xb    # View logs
mount -o remount,rw /    # Remount root as read-write
```

### Khôi phục mật khẩu root:

1. Boot vào recovery/single user mode
2. Remount filesystem với write access:

```bash
mount -o remount,rw /
```

3. Đặt lại mật khẩu:

```bash
passwd root
```

### Xử lý disk đầy:

```bash
# Tìm file/thư mục lớn
du -h --max-depth=1 /
find / -type f -size +100M

# Xóa cache và logs
apt clean
journalctl --vacuum-time=3d

# Xóa core dumps
find /var -name "core" -delete
```

### Xử lý CPU/RAM cao:

```bash
# Tìm process sử dụng nhiều CPU/RAM
top
ps aux --sort=-%cpu
ps aux --sort=-%mem

# Kill process
kill PID
kill -9 PID
```

### Xử lý lỗi mạng:

```bash
# Kiểm tra card mạng
ip link
ethtool eth0

# Kiểm tra kết nối
ping gateway
ping 8.8.8.8
ping google.com

# Kiểm tra DNS
dig domain.com
nslookup domain.com
cat /etc/resolv.conf

# Troubleshoot routing
traceroute domain.com
ip route
```

### Xử lý lỗi dịch vụ:

```bash
# Kiểm tra status
systemctl status service_name

# Kiểm tra logs
journalctl -u service_name
cat /var/log/service_name.log

# Restart service
systemctl restart service_name
```

## Tài liệu tham khảo

### Official Documentation:

- [The Linux Documentation Project](https://tldp.org/)
- [ArchWiki](https://wiki.archlinux.org/) - Tài liệu xuất sắc ngay cả cho các bản phân phối khác
- [Ubuntu Documentation](https://help.ubuntu.com/)
- [RHEL Documentation](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/)

### Online Tutorials:

- [Linux Journey](https://linuxjourney.com/) - Học Linux từ cơ bản
- [Linux Command Library](https://linuxcommandlibrary.com/) - Tham khảo lệnh
- [Ryans Tutorials](https://ryanstutorials.net/linuxtutorial/) - Hướng dẫn Linux cơ bản

### Books:

- "The Linux Command Line" - William Shotts
- "How Linux Works" - Brian Ward
- "Linux Bible" - Christopher Negus
- "UNIX and Linux System Administration Handbook" - Evi Nemeth, et al.

### Communities:

- [StackOverflow](https://stackoverflow.com/questions/tagged/linux)
- [Unix & Linux StackExchange](https://unix.stackexchange.com/)
- [Reddit r/linux](https://www.reddit.com/r/linux/)
- [Reddit r/linuxquestions](https://www.reddit.com/r/linuxquestions/)
