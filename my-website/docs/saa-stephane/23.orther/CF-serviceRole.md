CloudFormation Service Role là gì? 🤔
Bạn cứ hình dung Service Role giống như một "giấy ủy quyền" đặc biệt mà bạn tạo ra trong IAM (Identity and Access Management). Giấy ủy quyền này được dành riêng cho CloudFormation.
Khi CloudFormation cần tạo, cập nhật, hay xóa các tài nguyên trong stack của bạn (ví dụ: tạo S3 bucket, EC2 instance), nó sẽ "đội chiếc mũ" của Service Role này và hành động với các quyền hạn được định nghĩa trong Service Role đó, chứ không phải dùng quyền trực tiếp của bạn.
Tại sao lại cần Service Role? Lợi ích Bảo mật (Nguyên tắc Đặc quyền Tối thiểu) 🔐
Đây chính là điểm "ăn tiền" của Service Role, giúp bạn tuân thủ nguyên tắc đặc quyền tối thiểu (least privilege principle):
 * Tình huống: Bạn muốn cho phép một người dùng (hoặc một nhóm người dùng) có thể tạo/cập nhật/xóa các stack CloudFormation, nhưng bạn không muốn cấp cho họ quyền trực tiếp để tạo/cập nhật/xóa từng tài nguyên riêng lẻ (như S3, EC2) bên trong stack đó.
 * Giải pháp với Service Role:
   * Bạn tạo một Service Role với những quyền vừa đủ để CloudFormation có thể tạo các tài nguyên trong template (ví dụ: quyền tạo S3 bucket).
   * Người dùng chỉ cần có quyền thực hiện các hành động trên CloudFormation (ví dụ: cloudformation:CreateStack) và một quyền đặc biệt là iam:PassRole.
   * Khi người dùng tạo stack, họ sẽ "pass" (chuyển giao) Service Role này cho CloudFormation.
   * CloudFormation sẽ sử dụng quyền của Service Role đó để làm việc.
 * Kết quả: Người dùng có thể quản lý hạ tầng thông qua CloudFormation một cách an toàn mà không cần có quá nhiều quyền trực tiếp trên các dịch vụ khác.
Service Role hoạt động như thế nào? 🤝
 * Người dùng khởi tạo: Người dùng bắt đầu một hành động với CloudFormation stack (ví dụ: tạo mới, cập nhật).
 * "Chuyển giao vai trò" (Pass Role): Người dùng chỉ định một Service Role mà CloudFormation sẽ sử dụng.
 * CloudFormation hành động: CloudFormation "đội chiếc mũ" của Service Role đó và sử dụng các quyền hạn được cấp cho Service Role để tương tác với các dịch vụ AWS khác (S3, EC2,...) và tạo/cập nhật/xóa tài nguyên theo định nghĩa trong template.
Quyền iam:PassRole - "Chìa khóa" quan trọng 🔑
Đây là một quyền rất quan trọng mà người dùng cần có để có thể "giao" một Service Role cho CloudFormation (hoặc bất kỳ dịch vụ AWS nào khác).
 * Tại sao cần thiết? Nó ngăn chặn việc người dùng có thể leo thang đặc quyền (privilege escalation) bằng cách "pass" một role có nhiều quyền hơn những gì họ được phép sử dụng. Người dùng phải có quyền iam:PassRole đối với chính xác cái role mà họ muốn pass.
Ví dụ minh họa (như trong bài giảng) 🎨
 * Tạo Service Role:
   * Bạn vào IAM, tạo một Role mới.
   * Chọn "AWS service" làm trusted entity, và chọn "CloudFormation" làm use case.
   * Gắn policy cho Role này, ví dụ, chỉ cho phép "S3 full access" (DemoRole for CFN with S3 capabilities).
   * => Role này giờ đây cho phép CloudFormation làm mọi thứ với S3.
 * Sử dụng Role khi tạo CloudFormation Stack:
   * Khi bạn tạo một CloudFormation stack mới.
   * Trong phần "Permissions", bạn có thể chọn IAM role. Nếu bạn không chọn, CloudFormation sẽ dùng quyền cá nhân của bạn.
   * Nếu bạn chọn DemoRole for CFN with S3 capabilities đã tạo ở trên.
   * Điều gì xảy ra? CloudFormation sẽ chỉ sử dụng các quyền của DemoRole này. Nếu template của bạn cố gắng tạo một EC2 instance (mà DemoRole không có quyền cho EC2), thì việc tạo stack sẽ thất bại ở bước tạo EC2. Điều này chứng tỏ CloudFormation bị giới hạn bởi quyền của Service Role được pass vào.
"Mẹo" cho kỳ thi ✍️
 * CloudFormation Service Role là một công cụ mạnh mẽ để thực thi nguyên tắc đặc quyền tối thiểu.
 * Hiểu rõ luồng: Người dùng (có quyền CloudFormation + iam:PassRole) ➡️ Pass Role cho ➡️ CloudFormation ➡️ CloudFormation Assume (đảm nhận) Role đó ➡️ Hành động trên các Tài nguyên dựa trên quyền của Role.
 * Quyền iam:PassRole là bắt buộc để người dùng có thể chỉ định một Service Role cho CloudFormation.
 * Cơ chế này tách biệt quyền quản lý stack CloudFormation khỏi quyền quản lý trực tiếp từng tài nguyên riêng lẻ.
Đây là một khía cạnh bảo mật quan trọng khi làm việc với CloudFormation, giúp bạn kiểm soát quyền hạn chặt chẽ hơn trong môi trường AWS của mình. 
