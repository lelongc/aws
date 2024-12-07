
### **ENI là gì?**
- **Elastic Network Interface (ENI)** là một thành phần logic trong VPC, đại diện cho một **card mạng ảo**.
- ENI cho phép các **EC2 instances** kết nối với mạng và cũng có thể được sử dụng ngoài EC2 instances.

---

### **Tính năng chính của ENI:**
1. **Primary private IPv4 và Secondary IPv4**:  
   - Mỗi ENI có thể có một **Primary IPv4** và **nhiều Secondary IPv4**.
   - Bạn có thể gắn thêm ENI vào một EC2 instance (eth1, eth2,...) để có thêm các địa chỉ IP.

2. **Elastic IPv4 hoặc Public IPv4**:  
   - Mỗi ENI có thể có:
        Một hoặc nhiều địa chỉ Private IPv4.
        Elastic IPv4 (nếu bạn muốn địa chỉ IP tĩnh để sử dụng với dịch vụ bên ngoài).
        Public IPv4 (nếu bạn không cần Elastic IPv4 và chấp nhận sử dụng địa chỉ IP động).
   - Khi bạn gắn Elastic IP vào ENI, nó sẽ ánh xạ tới Private IP của ENI, và từ đó bạn có thể truy cập EC2 instance từ bên ngoài.
    Một ENI có thể có nhiều địa chỉ Private IPv4 (1 Primary + nhiều Secondary).
    [Link đến file chi tiết lý thuyết hơn về eni về failover ](../lý-thuyết-bên-lề/ENI.md)

    Sử dụng nhiều Private IPv4 giúp tối ưu hóa tài nguyên và hỗ trợ failover trong nhiều tình huống.

    
3. **Security Groups**:  
   - ENI có thể gắn với một hoặc nhiều **Security Groups** để quản lý lưu lượng mạng.

4. **MAC Address**:  
   - Mỗi ENI có một **MAC address** riêng, giúp định danh trong mạng.

5. **Tạo và Quản lý ENI**:  
   - ENI có thể được tạo độc lập và gắn hoặc tháo gỡ từ các EC2 instance bất kỳ lúc nào.
   - ENI có thể di chuyển từ EC2 instance này sang EC2 instance khác trong cùng **Availability Zone (AZ)** để hỗ trợ **failover**.

---

### **Hạn chế:**
- ENI được **ràng buộc với một AZ cụ thể**, nghĩa là nếu bạn tạo ENI trong một AZ (ví dụ: us-east-1a), nó chỉ có thể được sử dụng trong AZ đó và không thể di chuyển sang AZ khác.

---

### **Ví dụ sử dụng ENI:**
- Khi một EC2 instance bị lỗi, bạn có thể di chuyển ENI (và private IP của nó) từ instance bị lỗi sang instance khác để tiếp tục hoạt động, đảm bảo tính liên tục của dịch vụ.
- Điều này rất hữu ích khi dịch vụ của bạn yêu cầu một **Private IP cố định** để truy cập.

---

### **Ứng dụng thực tế:**
ENI hỗ trợ nhiều trường hợp như:
1. **Multi-homing**: Một EC2 instance có thể có nhiều ENI để kết nối với nhiều mạng khác nhau.
2. **Failover**: Di chuyển ENI giữa các EC2 instances để đảm bảo độ tin cậy.
3. **Network Separation**: Tách biệt lưu lượng giữa các dịch vụ trong cùng một instance. 

Bạn có thể kiểm tra thêm trong phần **hands-on** để hiểu rõ cách sử dụng thực tế của ENI trong AWS.