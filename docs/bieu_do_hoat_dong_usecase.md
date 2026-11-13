# 3.4. BIỂU ĐỒ HOẠT ĐỘNG CHO CÁC USE CASE

Các sơ đồ dưới đây được dựng từ luồng sự kiện chính, luồng thay thế, ngoại lệ và ràng buộc thông tin trong tài liệu đặc tả. Mỗi sơ đồ dùng điểm bắt đầu, điểm kết thúc, hành động và nhánh quyết định. Các nhánh lỗi quay lại bước nhập/thử lại khi đặc tả cho phép.

**Lưu ý về mã:** Tài liệu đặc tả hiện có 17 mục nhưng thiếu UC09 và dùng mã UC15 cho cả “Liên hệ khẩn cấp” lẫn “Quản lý hồ sơ khám và tài liệu”. Vì vậy tiêu đề sơ đồ giữ nguyên số mục 3.3 và mã đang ghi trong đặc tả; cần thống nhất lại mã trước khi đưa vào bản nộp cuối.

## 3.3.1 – UC01 Đăng ký

```mermaid
flowchart TD
 S([Bắt đầu]) --> A[Chọn Đăng ký]
 A --> B[Hiển thị biểu mẫu]
 B --> C[Nhập số điện thoại, email, mật khẩu, họ tên, giới tính, vai trò]
 C --> D[Chọn Gửi mã xác thực]
 D --> E{Thông tin hợp lệ và chưa được sử dụng?}
 E -- Không --> X[Thông báo lỗi tại trường tương ứng] --> C
 E -- Có --> F[Gửi mã 6 chữ số đến email]
 F --> G{Gửi mã thành công?}
 G -- Không --> X2[Thông báo mất kết nối] --> C
 G -- Có --> H[Người dùng nhập mã xác nhận]
 H --> I{Mã đúng, còn hạn và chưa vượt số lần thử?}
 I -- Không --> J[Thông báo lỗi hoặc yêu cầu lấy mã mới] --> H
 I -- Có --> K[Tạo tài khoản và lưu hồ sơ]
 K --> L[Thông báo đăng ký thành công]
 L --> T([Kết thúc])
```

## 3.3.2 – UC02 Đăng nhập

```mermaid
flowchart TD
 S([Bắt đầu]) --> A[Mở màn hình Đăng nhập]
 A --> B[Nhập số điện thoại và mật khẩu]
 B --> C[Chọn Đăng nhập]
 C --> D{Thông tin hợp lệ?}
 D -- Không --> E[Thông báo sai thông tin] --> B
 D -- Có --> F{Tài khoản tồn tại và được phép sử dụng?}
 F -- Không --> G[Thông báo không tìm thấy tài khoản hoặc không thể đăng nhập] --> B
 F -- Có --> H[Tải hồ sơ và vai trò]
 H --> I[Mở màn hình chính theo vai trò]
 I --> T([Kết thúc])
```

## 3.3.3 – UC03 Đăng xuất

```mermaid
flowchart TD
 S([Bắt đầu]) --> A[Mở Cài đặt]
 A --> B[Chọn Đăng xuất]
 B --> C[Hiển thị xác nhận]
 C --> D{Người dùng xác nhận?}
 D -- Không --> E[Đóng thông báo, giữ phiên hiện tại] --> T([Kết thúc])
 D -- Có --> F[Kết thúc phiên sử dụng]
 F --> G{Đăng xuất thành công?}
 G -- Không --> H[Thông báo lỗi] --> C
 G -- Có --> I[Chuyển về màn hình đăng nhập]
 I --> T
```

## 3.3.4 – UC04 Chỉnh sửa thông tin cá nhân

```mermaid
flowchart TD
 S([Bắt đầu]) --> A[Mở Cài đặt]
 A --> B[Chọn Chỉnh sửa hồ sơ]
 B --> C[Hiển thị họ tên và giới tính hiện tại]
 C --> D[Thay đổi họ tên hoặc giới tính]
 D --> E[Chọn Lưu thay đổi]
 E --> F{Họ tên và giới tính hợp lệ?}
 F -- Không --> G[Thông báo họ tên không hợp lệ] --> D
 F -- Có --> H[Lưu thông tin]
 H --> I{Lưu thành công?}
 I -- Không --> J[Thông báo lỗi, giữ nội dung đã nhập] --> D
 I -- Có --> K[Thông báo cập nhật thành công]
 K --> T([Kết thúc])
```

## 3.3.5 – UC05 Gửi cảnh báo SOS

```mermaid
flowchart TD
 S([Bắt đầu]) --> A{Cách phát hiện sự cố?}
 A -- Người cao tuổi chủ động --> B[Chọn nút SOS]
 A -- Thiết bị phát hiện dấu hiệu té ngã --> C[Hiển thị câu hỏi xác nhận và đếm ngược]
 C --> D{Người cao tuổi chọn Tôi vẫn ổn?}
 D -- Có --> E[Đóng thông báo, không gửi cảnh báo] --> T([Kết thúc])
 D -- Không hoặc hết giờ --> F[Ghi nhận cảnh báo và thời điểm]
 B --> F
 F --> G[Lấy vị trí nếu thiết bị cho phép]
 G --> H[Gửi thông báo đến người chăm sóc đã liên kết]
 H --> I{Gửi thông báo thành công?}
 I -- Có --> J[Hiển thị đã gửi cảnh báo] --> T
 I -- Không --> K[Thông báo chưa gửi được, hiển thị lựa chọn gọi 115]
 K --> T
```

## 3.3.6 – UC06 Tiếp nhận và xử lý cảnh báo

```mermaid
flowchart TD
 S([Bắt đầu]) --> A[Người chăm sóc nhận thông báo SOS]
 A --> B[Mở thông báo]
 B --> C[Hiển thị người gặp sự cố, thời điểm, nguyên nhân, số điện thoại và vị trí nếu có]
 C --> D{Có quyền xem và cảnh báo còn hiệu lực?}
 D -- Không --> E[Thông báo không thể xử lý cảnh báo] --> T([Kết thúc])
 D -- Có --> F[Chọn Tiếp nhận]
 F --> G{Người khác đã tiếp nhận trước?}
 G -- Có --> H[Hiển thị người đang xử lý và dữ liệu mới nhất] --> T
 G -- Không --> I[Ghi nhận người tiếp nhận, báo cho người chăm sóc liên quan]
 I --> J[Thực hiện hỗ trợ: gọi người cao tuổi, gọi 115 hoặc mở bản đồ]
 J --> K{Đã liên hệ hoặc hỗ trợ?}
 K -- Chưa --> L[Tiếp tục gọi 115 hoặc nhờ người ở gần hỗ trợ] --> J
 K -- Rồi --> M[Chọn Kết thúc cảnh báo]
 M --> N[Chọn kết quả hỗ trợ và nhập ghi chú nếu cần]
 N --> O[Lưu kết quả và kết thúc cảnh báo]
 O --> P{Lưu thành công?}
 P -- Không --> Q[Thông báo lỗi, giữ cảnh báo chờ kết thúc] --> N
 P -- Có --> R[Thông báo kết quả cho người chăm sóc liên quan]
 R --> T
```

## 3.3.7 – UC07 Ghi chỉ số và theo dõi cảnh báo huyết áp

```mermaid
flowchart TD
 S([Bắt đầu]) --> A[Mở Nhật ký sức khỏe]
 A --> B[Chọn Ghi chỉ số]
 B --> C[Hiển thị màn hình nhập kết quả]
 C --> D[Nhập huyết áp trên và huyết áp dưới]
 D --> E[Chọn Lưu kết quả đo]
 E --> F{Hai chỉ số nằm trong khoảng cho phép và huyết áp trên lớn hơn huyết áp dưới?}
 F -- Không --> G[Thông báo chỉ số chưa hợp lệ] --> D
 F -- Có --> H[Lưu kết quả đo]
 H --> I{Lưu thành công?}
 I -- Không --> J[Thông báo lỗi và cho phép thử lại] --> E
 I -- Có --> K[Đánh giá mức độ và hiển thị hướng dẫn]
 K --> L[Hiển thị kết quả trong lịch sử]
 L --> T([Kết thúc])
```

## 3.3.8 – UC08 Theo dõi lịch sử huyết áp

```mermaid
flowchart TD
 S([Bắt đầu]) --> A[Mở Nhật ký sức khỏe]
 A --> B[Tải các lần đo đã lưu]
 B --> C{Có dữ liệu?}
 C -- Không --> D[Hiển thị hướng dẫn ghi chỉ số lần đầu] --> T([Kết thúc])
 C -- Có --> E[Hiển thị biểu đồ tối đa 7 lần đo gần nhất]
 E --> F[Hiển thị danh sách từ mới nhất đến cũ nhất]
 F --> G[Người dùng chọn một lần đo]
 G --> H[Hiển thị chi tiết và mức đánh giá]
 H --> T
```

## 3.3.10 – UC10 Thiết lập lịch uống thuốc

```mermaid
flowchart TD
 S([Bắt đầu]) --> A[Mở mục Thuốc]
 A --> B[Chọn Thêm thuốc]
 B --> C[Nhập tên thuốc, liều dùng và hướng dẫn]
 C --> D[Chọn khung giờ và ngày bắt đầu]
 D --> E{Có ngày kết thúc?}
 E -- Có --> F[Chọn ngày kết thúc]
 E -- Không --> G[Bỏ qua ngày kết thúc]
 F --> H[Chọn Lưu thuốc]
 G --> H
 H --> I{Thông tin hợp lệ?}
 I -- Không --> J[Thông báo trường còn thiếu hoặc ngày không hợp lệ] --> C
 I -- Có --> K[Lưu lịch uống thuốc]
 K --> L{Lưu thành công?}
 L -- Không --> M[Thông báo lỗi, giữ thông tin đã nhập] --> H
 L -- Có --> N[Thiết lập các lần nhắc theo giờ đã chọn]
 N --> T([Kết thúc])
 A --> O[Chọn lịch thuốc đã có]
 O --> P[Thay đổi thông tin hoặc dừng thuốc]
 P --> T
```

## 3.3.11 – UC11 Nhắc nhở và theo dõi lịch uống thuốc

```mermaid
flowchart TD
 S([Bắt đầu]) --> A[Hệ thống kiểm tra lịch thuốc còn hiệu lực]
 A --> B{Lịch đang dùng và đã đến giờ nhắc?}
 B -- Không --> C[Không phát lời nhắc ở thời điểm này] --> T([Kết thúc])
 B -- Có --> D{Thiết bị cho phép thông báo?}
 D -- Không --> E[Hiển thị hướng dẫn bật quyền thông báo] --> F[Người cao tuổi vẫn có thể mở ứng dụng xem lịch] --> T
 D -- Có --> G[Gửi thông báo nhắc uống thuốc]
 G --> H[Người cao tuổi mở thông báo hoặc mục Thuốc]
 H --> I[Hiển thị các lần uống trong ngày theo giờ]
 I --> J[Người chăm sóc có thể mở phần theo dõi]
 J --> T
```

## 3.3.12 – UC12 Ghi nhận nhật ký uống thuốc

```mermaid
flowchart TD
 S([Bắt đầu]) --> A[Người cao tuổi mở mục Thuốc]
 A --> B[Hiển thị các lần uống trong ngày]
 B --> C[Chọn Đã uống tại lần uống tương ứng]
 C --> D{Lần uống đã được ghi nhận chưa?}
 D -- Có --> E[Không tạo bản ghi trùng] --> T([Kết thúc])
 D -- Không --> F[Ghi thời điểm xác nhận]
 F --> G{Lưu thành công?}
 G -- Không --> H[Thông báo lỗi và cho phép thử lại] --> C
 G -- Có --> I[Cập nhật lần uống thành đã uống]
 I --> J[Người chăm sóc xem thông tin cập nhật]
 J --> K[Hệ thống kiểm tra liều quá giờ 5 tiếng chưa xác nhận]
 K --> L[Đánh dấu liều quá hạn là bỏ lỡ]
 L --> T
```

## 3.3.13 – UC13 Liên kết và quản lý người chăm sóc

```mermaid
flowchart TD
 S([Bắt đầu]) --> A[Người chăm sóc mở mục Người chăm sóc của tôi]
 A --> B[Nhập số điện thoại người cao tuổi]
 B --> C[Chọn Gửi yêu cầu]
 C --> D{Tìm thấy tài khoản phù hợp và chưa liên kết/chờ?}
 D -- Không --> E[Thông báo không tìm thấy hoặc đã có liên kết/yêu cầu] --> B
 D -- Có --> F[Gửi yêu cầu đến người cao tuổi]
 F --> G{Người cao tuổi phản hồi?}
 G -- Chưa --> H[Người chăm sóc có thể hủy yêu cầu] --> T([Kết thúc])
 G -- Có --> I{Chấp nhận yêu cầu?}
 I -- Không --> J[Không tạo liên kết] --> T
 I -- Có --> K[Ghi nhận liên kết giữa hai tài khoản]
 K --> L[Hiển thị danh sách người đã liên kết]
 L --> M[Người dùng chọn một người để xem thông tin liên hệ]
 M --> T
```

## 3.3.15 – UC15 Liên hệ khẩn cấp

```mermaid
flowchart TD
 S([Bắt đầu]) --> A[Mở mục Liên hệ khẩn cấp]
 A --> B[Hiển thị nút gọi 115 và người chăm sóc đã liên kết]
 B --> C[Chọn Gọi 115]
 C --> D[Hiển thị thông báo xác nhận]
 D --> E{Người dùng xác nhận gọi?}
 E -- Không --> F[Đóng thông báo, không gọi] --> T([Kết thúc])
 E -- Có --> G[Thiết bị mở chức năng gọi điện]
 G --> H{Thiết bị hỗ trợ gọi?}
 H -- Không --> I[Thông báo không thể thực hiện cuộc gọi] --> T
 H -- Có --> J[Người dùng thực hiện cuộc gọi 115]
 J --> T
```

## 3.3.14 – UC14 Quản lý lịch khám gia đình

```mermaid
flowchart TD
 S([Bắt đầu]) --> A[Mở mục Lịch khám]
 A --> B[Chọn Thêm lịch]
 B --> C[Nhập nội dung khám, cơ sở y tế, khoa, thời gian và ghi chú]
 C --> D[Chọn người dự kiến đưa đi nếu đã xác định]
 D --> E[Chọn Lưu]
 E --> F{Thông tin hợp lệ và người phụ trách hợp lệ?}
 F -- Không --> G[Thông báo nội dung thiếu hoặc thời gian/người phụ trách không hợp lệ] --> C
 F -- Có --> H[Tạo lịch khám]
 H --> I{Lịch có người phụ trách?}
 I -- Không --> J[Hiển thị lịch chưa có người nhận]
 I -- Có --> K[Hiển thị lịch với người phụ trách]
 J --> L[Thành viên chọn Tôi sẽ đưa đi]
 K --> M[Theo dõi lịch khám]
 L --> N{Lịch vẫn chưa có người nhận?}
 N -- Không --> O[Thông báo người khác đã nhận lịch] --> M
 N -- Có --> P[Ghi nhận người phụ trách] --> M
 M --> Q{Người phụ trách cần trả lịch?}
 Q -- Có --> R[Chọn Nhờ người khác, bỏ người phụ trách] --> J
 Q -- Không --> U{Đã đến hoặc qua giờ hẹn và đúng người phụ trách?}
 U -- Không --> M
 U -- Có --> V[Chọn Hoàn thành]
 V --> W[Cập nhật lịch đã hoàn thành]
 W --> X[Mở phần thêm hồ sơ khám, điền sẵn cơ sở và ngày khám]
 X --> Y{Thêm hồ sơ ngay?}
 Y -- Không --> T([Kết thúc])
 Y -- Có --> Z[Chuyển sang chức năng quản lý hồ sơ khám]
 Z --> T
```

## 3.3.15 – UC15 Quản lý hồ sơ khám và tài liệu

```mermaid
flowchart TD
 S([Bắt đầu]) --> A[Mở mục Hồ sơ khám]
 A --> B[Tải danh sách các lần khám]
 B --> C{Có hồ sơ?}
 C -- Không --> D[Hiển thị hướng dẫn thêm hồ sơ] --> E{Người dùng muốn thêm?}
 E -- Không --> T([Kết thúc])
 E -- Có --> F[Chọn Thêm hồ sơ]
 C -- Có --> G[Hiển thị lịch sử khám mới nhất trước]
 G --> H{Chọn hồ sơ để xem hay thêm mới?}
 H -- Xem --> I[Hiển thị chi tiết và tài liệu đính kèm] --> T
 H -- Thêm --> F
 F --> J[Nhập ngày khám, bệnh viện, chẩn đoán và ghi chú nếu có]
 J --> K[Chọn Lưu]
 K --> L{Thông tin hợp lệ và có quyền thêm?}
 L -- Không --> M[Thông báo lỗi hoặc thiếu thông tin] --> J
 L -- Có --> N[Lưu hồ sơ khám]
 N --> O{Lưu thành công?}
 O -- Không --> P[Thông báo lỗi, giữ nội dung đã nhập] --> K
 O -- Có --> Q[Mở hồ sơ vừa tạo]
 Q --> R[Chọn thêm tài liệu]
 R --> U[Chọn ảnh hoặc PDF]
 U --> V{Định dạng đúng và dung lượng dưới 15 MB?}
 V -- Không --> W[Thông báo tệp không hợp lệ] --> U
 V -- Có --> X[Lưu tài liệu vào hồ sơ]
 X --> Y{Tải tệp thành công?}
 Y -- Không --> Z[Thông báo lỗi tải tệp] --> U
 Y -- Có --> AA[Hiển thị tài liệu trong hồ sơ]
 AA --> T
```

## 3.3.16 – UC16 Ghi âm lời nhắc

```mermaid
flowchart TD
 S([Bắt đầu]) --> A[Mở Cài đặt]
 A --> B[Chọn Ghi âm lời nhắc]
 B --> C[Hiển thị màn hình ghi âm]
 C --> D[Nhập tên lời nhắc nếu muốn]
 D --> E[Chọn Bắt đầu ghi âm]
 E --> F{Đã cấp quyền micro?}
 F -- Không --> G[Thông báo cần cấp quyền micro] --> T([Kết thúc])
 F -- Có --> H[Bắt đầu ghi âm]
 H --> I[Người dùng dừng hoặc đạt giới hạn 29 giây]
 I --> J{Bản ghi có thời lượng lớn hơn 0?}
 J -- Không --> K[Yêu cầu ghi âm lại] --> E
 J -- Có --> L[Nghe lại bản ghi]
 L --> M{Muốn ghi lại?}
 M -- Có --> E
 M -- Không --> N[Chọn Lưu bản ghi]
 N --> O{Lưu thành công?}
 O -- Không --> P[Thông báo lỗi] --> N
 O -- Có --> Q{Có đặt làm âm thanh nhắc thuốc trên Android?}
 Q -- Không --> R[Giữ bản ghi trong tài khoản] --> T
 Q -- Có --> U[Đặt bản ghi làm âm thanh nhắc thuốc]
 U --> V{Đặt âm thanh thành công?}
 V -- Không --> W[Thông báo riêng lỗi đặt âm thanh] --> T
 V -- Có --> T
```

## 3.3.17 – UC17 Xem vị trí người cao tuổi

```mermaid
flowchart TD
 S([Bắt đầu]) --> A[Người cao tuổi đăng nhập và mở ứng dụng]
 A --> B[Ứng dụng xin quyền và lấy vị trí theo chu kỳ]
 B --> C{Được cấp quyền và lấy được vị trí?}
 C -- Không --> D[Không cập nhật vị trí mới] --> E[Người chăm sóc mở màn hình gia đình]
 C -- Có --> F[Lưu vị trí và thời điểm cập nhật]
 F --> E
 E --> G{Có dữ liệu vị trí đã lưu?}
 G -- Không --> H[Thông báo chưa có thông tin vị trí] --> T([Kết thúc])
 G -- Có --> I[Hiển thị vị trí gần nhất và thời điểm cập nhật]
 I --> T
```
