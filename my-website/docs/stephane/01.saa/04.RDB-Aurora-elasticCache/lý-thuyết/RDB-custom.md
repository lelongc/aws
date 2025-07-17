
1. **Tổng quan RDS và RDS Custom**:
   - **RDS** là dịch vụ cơ sở dữ liệu được quản lý bởi AWS, nơi người dùng không có quyền truy cập vào hệ điều hành (OS) cơ bản hoặc khả năng tùy chỉnh sâu.
   - **RDS Custom** cho phép người dùng có quyền truy cập vào hệ điều hành và khả năng tùy chỉnh, giúp hỗ trợ các nhu cầu đặc thù hơn.

2. **Cơ sở dữ liệu được hỗ trợ bởi RDS Custom**:
   - RDS Custom hỗ trợ **Oracle** và **Microsoft SQL Server**.
   - Với RDS Custom, người dùng có quyền truy cập đầy đủ vào hệ điều hành, cho phép cài đặt các gói phần mềm bổ sung, sửa đổi cấu hình nội bộ và tận dụng các tính năng gốc của cơ sở dữ liệu.

3. **Lợi ích của RDS và RDS Custom**:
   - **RDS chuẩn** cung cấp các lợi ích như thiết lập tự động, vận hành tự động và khả năng mở rộng cơ sở dữ liệu mà không cần can thiệp thủ công.
   - **RDS Custom** cung cấp những quyền tùy chỉnh, đặc biệt là truy cập SSH hoặc **SSM Session Manager** vào các phiên bản EC2 cơ bản chạy cơ sở dữ liệu.

4. **Tính năng tùy chỉnh trong RDS Custom**:
   - Người dùng có thể **cấu hình cài đặt nội bộ**, cài đặt bản vá lỗi và **truy cập phiên bản EC2 cơ bản**.
   - Để thực hiện tùy chỉnh, cần **vô hiệu hóa chế độ tự động** để RDS không thực hiện tự động bảo trì hay mở rộng trong lúc bạn tùy chỉnh.
   - Khuyến cáo nên **tạo bản snapshot của cơ sở dữ liệu** trước khi thực hiện tùy chỉnh vì có thể gây lỗi hoặc mất dữ liệu nếu tùy chỉnh không chính xác.

5. **Sự khác biệt giữa RDS và RDS Custom**:
   - **RDS chuẩn**: Quản lý hoàn toàn bởi AWS, không cần thực hiện bất kỳ thao tác nào cho hệ điều hành hoặc cơ sở dữ liệu.
   - **RDS Custom**: Quản lý bởi người dùng, cho phép tùy chỉnh toàn bộ hệ điều hành và cơ sở dữ liệu, phù hợp với các ứng dụng yêu cầu quyền truy cập sâu hơn.

6. **Tổng kết**:
   - **RDS** phù hợp cho những ai muốn một cơ sở dữ liệu dễ sử dụng, được quản lý hoàn toàn bởi AWS.
   - **RDS Custom** dành cho Oracle và SQL Server, cung cấp quyền quản trị đầy đủ và phù hợp cho các nhu cầu phức tạp hơn.

7. **Lời khuyên thực tế**:
   - Khi sử dụng RDS Custom, nếu bạn thực hiện tùy chỉnh hệ điều hành hoặc cấu hình cơ sở dữ liệu, hãy luôn **tắt chế độ tự động** và tạo bản snapshot để đảm bảo khôi phục dễ dàng nếu gặp sự cố.
   - Quyền truy cập SSH hoặc SSM giúp bạn có thể quản lý chi tiết hơn các cấu hình hệ thống, nhưng yêu cầu kiến thức quản trị máy chủ.

