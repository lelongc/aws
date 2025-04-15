### **Sử Dụng CloudWatch Agents để Thu Thập Logs và Metrics từ EC2 Instances**

CloudWatch Agents là một công cụ mạnh mẽ giúp bạn thu thập logs và metrics từ các EC2 instances (hoặc máy chủ on-premises) và gửi chúng đến CloudWatch. Dưới đây là chi tiết về cách hoạt động và cách sử dụng CloudWatch Agents.

---

### **1. Tại Sao Cần CloudWatch Agents?**

- **Mặc định**, EC2 instances không tự động gửi logs hoặc metrics đến CloudWatch.
- Để thu thập dữ liệu từ EC2 instances, bạn cần cài đặt và cấu hình một **CloudWatch Agent** trên mỗi instance.
- CloudWatch Agent là một chương trình nhỏ chạy trên EC2 instances, có nhiệm vụ thu thập và gửi logs/metrics đến CloudWatch.

---

### **2. Cách CloudWatch Agents Hoạt Động**

- **Bước 1**: Cài đặt CloudWatch Agent trên EC2 instances.
- **Bước 2**: Cấu hình agent để thu thập logs và metrics cụ thể.
- **Bước 3**: Agent sẽ gửi dữ liệu đến CloudWatch Logs và CloudWatch Metrics.
- **Yêu cầu**:
  - EC2 instances phải có một **IAM Role** với quyền gửi dữ liệu đến CloudWatch.
  - IAM Role cần có các policy như `CloudWatchLogsFullAccess` và `CloudWatchAgentServerPolicy`.

---

### **3. CloudWatch Agents Trên On-Premises Servers**

- CloudWatch Agents không chỉ hoạt động trên EC2 instances mà còn có thể được cài đặt trên các máy chủ **on-premises** (ví dụ: máy chủ VMware).
- Bằng cách cài đặt agent trên các máy chủ này, bạn có thể gửi logs và metrics từ môi trường on-premises đến CloudWatch.

---

### **4. Hai Loại CloudWatch Agents**

#### **a. CloudWatch Logs Agent (Phiên Bản Cũ)**

- **Chức năng**: Chỉ có thể gửi **logs** đến CloudWatch Logs.
- **Hạn chế**:
  - Không thu thập được metrics.
  - Không hỗ trợ cấu hình tập trung thông qua SSM Parameter Store.

#### **b. CloudWatch Unified Agent (Phiên Bản Mới)**

- **Chức năng**:
  - Gửi **logs** đến CloudWatch Logs.
  - Thu thập **metrics** hệ thống (như CPU, RAM, disk, network) với độ chi tiết cao.
- **Ưu điểm**:
  - Hỗ trợ cả logs và metrics (do đó được gọi là "Unified").
  - Có thể cấu hình tập trung thông qua **SSM Parameter Store**, giúp quản lý dễ dàng hơn.
  - Thu thập các metrics chi tiết hơn so với monitoring mặc định của EC2.

---

### **5. Các Metrics Thu Thập Bởi CloudWatch Unified Agent**

CloudWatch Unified Agent có thể thu thập các metrics hệ thống với độ chi tiết cao, bao gồm:

#### **a. CPU Metrics**

- **Chi tiết**: active, guest, idle, system, user, steal.
- Ví dụ: Bạn có thể theo dõi % CPU đang được sử dụng bởi người dùng hoặc hệ thống.

#### **b. Disk Metrics**

- **Chi tiết**: free, used, total disk space.
- **Disk IO**: Số lần đọc/ghi (reads/writes), số byte, IOPS.

#### **c. RAM Metrics**

- **Chi tiết**: free, inactive, used, total, cached memory.

#### **d. Network Metrics**

- **Chi tiết**: Số lượng kết nối TCP/UDP, số gói tin (packets), số byte.

#### **e. Process Metrics**

- **Chi tiết**: Tổng số tiến trình (processes), số tiến trình đang chạy (running), sleep, blocked, dead.

#### **f. Swap Space Metrics**

- **Chi tiết**: free, used, used percentage của swap space.

---

### **6. So Sánh CloudWatch Unified Agent Với Monitoring Mặc Định của EC2**

- **Monitoring mặc định của EC2**:
  - Chỉ cung cấp các metrics cơ bản như CPU utilization, disk activity, và network activity.
  - Không cung cấp thông tin về **RAM**, **swap space**, hoặc các metrics chi tiết khác.
- **CloudWatch Unified Agent**:
  - Cung cấp các metrics chi tiết hơn, bao gồm cả RAM, swap space, và các thông tin hệ thống khác.
  - Hỗ trợ thu thập logs và metrics từ cả EC2 instances và máy chủ on-premises.

---

### **7. Cấu Hình CloudWatch Unified Agent**

- **Bước 1**: Cài đặt CloudWatch Unified Agent trên EC2 instances hoặc máy chủ on-premises.
- **Bước 2**: Sử dụng **SSM Parameter Store** để cấu hình tập trung cho agent.
- **Bước 3**: Chỉ định các logs và metrics cần thu thập.
- **Bước 4**: Khởi động agent và kiểm tra dữ liệu trong CloudWatch.

---

### **8. Ví Dụ Về Cấu Hình CloudWatch Unified Agent**

1. **Cài đặt Agent**:
   - Trên Linux: Sử dụng lệnh `sudo yum install amazon-cloudwatch-agent`.
   - Trên Windows: Tải và cài đặt từ AWS Management Console.
2. **Cấu hình Agent**:
   - Tạo một tệp cấu hình JSON hoặc sử dụng SSM Parameter Store.
   - Ví dụ cấu hình thu thập CPU và RAM metrics:
     ```json
     {
       "metrics": {
         "metrics_collected": {
           "cpu": {
             "measurement": ["cpu_usage_idle", "cpu_usage_system"]
           },
           "mem": {
             "measurement": ["mem_used", "mem_free"]
           }
         }
       }
     }
     ```
3. **Khởi động Agent**:
   - Trên Linux: `sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/path/to/config.json`.
   - Trên Windows: Sử dụng PowerShell để khởi động agent.

---

### **9. Lợi Ích Của CloudWatch Unified Agent**

- **Thu thập dữ liệu chi tiết**: Cung cấp các metrics hệ thống chi tiết hơn so với monitoring mặc định.
- **Hỗ trợ đa nền tảng**: Làm việc trên cả EC2 instances và máy chủ on-premises.
- **Cấu hình tập trung**: Dễ dàng quản lý cấu hình thông qua SSM Parameter Store.
- **Tích hợp với CloudWatch**: Dữ liệu được gửi trực tiếp đến CloudWatch Logs và CloudWatch Metrics.

---

### **10. Kết Luận**

CloudWatch Unified Agent là một công cụ mạnh mẽ để thu thập logs và metrics từ EC2 instances và máy chủ on-premises. Với khả năng thu thập dữ liệu chi tiết và cấu hình linh hoạt, nó giúp bạn giám sát và phân tích hiệu suất hệ thống một cách hiệu quả. Nếu bạn cần độ chi tiết cao hơn so với monitoring mặc định của EC2, hãy cân nhắc sử dụng CloudWatch Unified Agent.
