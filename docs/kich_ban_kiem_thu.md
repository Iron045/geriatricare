# KỊCH BẢN KIỂM THỬ HỆ THỐNG GERIATRICCARE

## 1. Mục đích

Tài liệu mô tả các kịch bản kiểm thử chức năng, phân quyền, xử lý lỗi và khả năng tích hợp của ứng dụng GeriatricCare. Kết quả kiểm thử dùng để xác nhận các luồng nghiệp vụ chính hoạt động đúng trước khi nghiệm thu hoặc phát hành.

## 2. Phạm vi

- Đăng ký bằng email, số điện thoại và mật khẩu sáu chữ số.
- Xác thực email và đăng nhập bằng số điện thoại, mật khẩu.
- Quản lý hồ sơ và vai trò người dùng.
- Liên kết người cao tuổi với nhiều người con.
- Chuyển đổi giữa nhiều người được chăm sóc.
- Theo dõi huyết áp, thuốc, lịch sử dùng thuốc và lời nhắc.
- Lịch khám và phân công người đưa đi khám.
- Hồ sơ khám bệnh, chụp ảnh và nhập PDF.
- SOS, vị trí, thông báo và phân quyền dữ liệu.

Không thuộc phạm vi hiện tại: OCR tự động, thông báo nhắc lịch khám và migration tự động tài khoản Firebase Phone Authentication cũ.

## 3. Môi trường kiểm thử

| Thành phần | Yêu cầu |
|---|---|
| Thiết bị | Android 8 trở lên; kiểm tra bổ sung trên iOS nếu có thiết bị |
| Mạng | Wi-Fi/4G ổn định và trường hợp mất mạng |
| Backend | Firebase Authentication, Firestore, Storage và máy chủ OTP Node.js cục bộ |
| Firebase Auth | Bật Email/Password, cấu hình mẫu email xác thực |
| Quy tắc | Deploy phiên bản mới nhất của `firestore.rules` và `storage.rules` |
| Thông báo | Thiết bị cho phép notification và đã có FCM token |
| Vị trí | Thiết bị bật GPS và cấp quyền vị trí |

## 4. Dữ liệu kiểm thử

| Mã | Dữ liệu |
|---|---|
| ELDER01 | Người cao tuổi: Nguyễn Văn A, email chưa từng đăng ký, số điện thoại hợp lệ |
| ELDER02 | Người cao tuổi: Trần Thị B, email chưa từng đăng ký, số điện thoại hợp lệ |
| CHILD01 | Người con thứ nhất, email và số điện thoại riêng |
| CHILD02 | Người con thứ hai, email và số điện thoại riêng |
| PASS01 | Mật khẩu hợp lệ gồm đúng 6 chữ số, ví dụ `123456` |
| IMG01 | Ảnh JPEG/PNG rõ nét, nhỏ hơn 15 MB |
| PDF01 | Hồ sơ PDF hợp lệ, nhỏ hơn 15 MB |
| FILE01 | Tệp không hợp lệ hoặc lớn hơn 15 MB |

Mỗi lần chạy toàn bộ bộ kiểm thử nên sử dụng email và số điện thoại mới hoặc xóa sạch dữ liệu thử nghiệm trên Firebase trước khi bắt đầu.

## 5. Quy ước kết quả

| Trạng thái | Ý nghĩa |
|---|---|
| Pass | Kết quả thực tế đúng với kết quả mong đợi |
| Fail | Kết quả thực tế khác kết quả mong đợi |
| Blocked | Không thể kiểm thử do môi trường hoặc phụ thuộc bên ngoài |
| Not run | Chưa thực hiện |

## 6. Kịch bản kiểm thử

### 6.1. Đăng ký, xác thực và đăng nhập

| ID | Kịch bản | Tiền điều kiện | Các bước thực hiện | Kết quả mong đợi | Ưu tiên |
|---|---|---|---|---|---|
| AUTH-01 | Đăng ký tài khoản người cao tuổi hợp lệ | Email và số điện thoại chưa tồn tại | Mở Đăng ký; nhập đủ thông tin; chọn vai trò Người cao tuổi; nhấn Đăng ký; nhập đúng mã nhận qua email | Hiển thị màn hình nhập mã; sau khi xác thực, tài khoản Auth và hồ sơ được tạo; người dùng đăng nhập tự động | Cao |
| AUTH-02 | Đăng ký tài khoản người con hợp lệ | Dữ liệu CHILD01 chưa tồn tại | Thực hiện như AUTH-01 và chọn vai trò Con cái | Mã được gửi qua email; tài khoản được tạo với role `child` sau khi nhập đúng mã | Cao |
| AUTH-03 | Bỏ trống trường bắt buộc | Đang ở màn hình Đăng ký | Lần lượt bỏ trống họ tên, email, số điện thoại, mật khẩu hoặc vai trò; nhấn Đăng ký | Hiển thị lỗi tại trường tương ứng; không tạo tài khoản | Cao |
| AUTH-04 | Email sai định dạng | Đang ở màn hình Đăng ký | Nhập `abc`, các trường khác hợp lệ; nhấn Đăng ký | Báo email chưa hợp lệ | Cao |
| AUTH-05 | Mật khẩu không đúng 6 số | Đang ở màn hình Đăng ký | Thử 5 số, 7 số, chữ hoặc ký tự đặc biệt | Form không hợp lệ; không gửi yêu cầu đăng ký | Cao |
| AUTH-06 | Email đã được sử dụng | Đã tồn tại tài khoản với email thử nghiệm | Đăng ký bằng email cũ và số điện thoại mới | Báo email đã được sử dụng; không tạo hồ sơ không hoàn chỉnh | Cao |
| AUTH-07 | Số điện thoại sai định dạng | Đang ở màn hình đăng ký hoặc đăng nhập | Thử số không đủ 10 chữ số hoặc không bắt đầu bằng `0` | Form báo số điện thoại không hợp lệ và không gửi yêu cầu | Cao |
| AUTH-08 | Nhập sai hoặc mã hết hạn | Đang ở màn hình nhập mã | Nhập sai mã hoặc dùng mã sau 10 phút | Báo lỗi; không tạo tài khoản; khóa xác thực sau 5 lần nhập sai | Cao |
| AUTH-09 | Gửi lại mã xác thực | Đang ở màn hình nhập mã | Nhấn Gửi lại trước và sau 60 giây | Nút bị khóa trong 60 giây; sau đó gửi được mã mới và mã cũ hết hiệu lực | Trung bình |
| AUTH-10 | Hoàn tất xác thực email | Có mã OTP còn hiệu lực | Nhập đúng mã gồm 6 chữ số; nhấn Xác nhận | Máy chủ xác nhận OTP; ứng dụng tạo tài khoản Firebase và đăng nhập vào giao diện đúng vai trò | Cao |
| AUTH-11 | Đăng nhập hợp lệ | Tài khoản đã xác thực email | Nhập số điện thoại và mật khẩu đúng; nhấn Đăng nhập | Đăng nhập thành công và điều hướng đúng role | Cao |
| AUTH-12 | Sai số điện thoại hoặc mật khẩu | Có tài khoản hợp lệ | Nhập sai một trong hai giá trị | Hiển thị thông báo chung; không tiết lộ số điện thoại có tồn tại hay không | Cao |
| AUTH-13 | Chuẩn hóa số điện thoại Việt Nam | Có tài khoản lưu nội bộ dạng `+84...` | Đăng nhập bằng số nội địa gồm 10 chữ số, bắt đầu bằng `0` | Số được chuyển nội bộ sang `+84...` và đăng nhập đúng tài khoản | Trung bình |
| AUTH-14 | Đăng xuất | Đang đăng nhập | Vào Cài đặt; chọn Đăng xuất và xác nhận | Phiên bị xóa; trở về màn hình đăng nhập; không còn xem dữ liệu cũ | Cao |
| AUTH-15 | Mất mạng khi đăng ký/đăng nhập | Tắt mạng | Gửi form hợp lệ | Hiển thị lỗi kết nối; không treo giao diện; nút được bật lại | Trung bình |

### 6.2. Hồ sơ và liên kết gia đình

| ID | Kịch bản | Tiền điều kiện | Các bước thực hiện | Kết quả mong đợi | Ưu tiên |
|---|---|---|---|---|---|
| LINK-01 | Người con gửi yêu cầu liên kết | CHILD01 và ELDER01 đã xác thực | CHILD01 mở Liên kết; nhập số điện thoại ELDER01; gửi yêu cầu | ELDER01 nhận yêu cầu ở trạng thái chờ | Cao |
| LINK-02 | Người cao tuổi chấp nhận liên kết | Có yêu cầu LINK-01 | ELDER01 mở Liên hệ; chấp nhận | Tạo `care_relationships`; CHILD01 xem được dữ liệu ELDER01 | Cao |
| LINK-03 | Từ chối yêu cầu | Có yêu cầu đang chờ | Người cao tuổi nhấn Từ chối | Trạng thái thành `rejected`; người gửi không có quyền xem dữ liệu | Cao |
| LINK-04 | Gửi yêu cầu trùng | Đã có yêu cầu chờ hoặc liên kết được chấp nhận | CHILD01 gửi lại cùng số điện thoại | Hệ thống không tạo thêm yêu cầu; hiển thị hộp thoại “Không thể gửi yêu cầu” với nội dung đã liên kết/đang chờ và nút “Xác nhận”; không xuất hiện màn hình lỗi Flutter | Trung bình |
| LINK-05 | Nhiều người con cùng liên kết một người cao tuổi | ELDER01, CHILD01 và CHILD02 đã xác thực | Hai người con lần lượt gửi yêu cầu; ELDER01 chấp nhận cả hai | Cả hai người con đều xem được dữ liệu được chia sẻ | Cao |
| LINK-06 | Một người con theo dõi nhiều bố/mẹ | CHILD01 liên kết ELDER01 và ELDER02 | Mở bộ chọn người được chăm sóc; chuyển qua lại | Tên, sức khỏe, thuốc, SOS, vị trí, lịch và hồ sơ đổi đúng theo người được chọn | Cao |
| LINK-07 | Cập nhật hồ sơ cá nhân | Đang đăng nhập | Sửa họ tên/giới tính trong Cài đặt; lưu | Hồ sơ cập nhật; email, số điện thoại và role không bị thay đổi ngoài ý muốn | Trung bình |

### 6.3. Huyết áp và theo dõi sức khỏe

| ID | Kịch bản | Tiền điều kiện | Các bước thực hiện | Kết quả mong đợi | Ưu tiên |
|---|---|---|---|---|---|
| HEALTH-01 | Ghi huyết áp hợp lệ | Đăng nhập ELDER01 | Nhập tâm thu/tâm trương hợp lệ; lưu | Bản ghi được lưu, phân loại và xuất hiện trong lịch sử | Cao |
| HEALTH-02 | Tâm thu không lớn hơn tâm trương | Đăng nhập ELDER01 | Nhập tâm thu nhỏ hơn hoặc bằng tâm trương | Hiển thị lỗi; không lưu dữ liệu | Cao |
| HEALTH-03 | Giá trị ngoài giới hạn | Đăng nhập ELDER01 | Nhập tâm thu ngoài 70–250 hoặc tâm trương ngoài 40–150 | Bị từ chối ở UI hoặc Firestore Rules | Cao |
| HEALTH-04 | Người con xem lịch sử | CHILD01 đã liên kết ELDER01 | Mở Sức khỏe | Hiển thị các bản ghi mới nhất, biểu đồ và trạng thái đúng | Cao |
| HEALTH-05 | Đánh dấu đã liên hệ | Có bản ghi bất thường | CHILD01 nhấn hành động liên hệ/đã liên hệ | Lưu `contactedAt`, `contactedById`; các thành viên thấy trạng thái mới | Trung bình |

### 6.4. Thuốc và lời nhắc

| ID | Kịch bản | Tiền điều kiện | Các bước thực hiện | Kết quả mong đợi | Ưu tiên |
|---|---|---|---|---|---|
| MED-01 | Tạo lịch uống thuốc | Đăng nhập tài khoản có quyền | Nhập tên thuốc, liều, hướng dẫn, ngày và giờ; lưu | Lịch xuất hiện đúng ngày/giờ | Cao |
| MED-02 | Người con thêm thuốc cho bố/mẹ | CHILD01 liên kết ELDER01 | Chọn ELDER01; thêm thuốc | Thuốc xuất hiện cho ELDER01 và các thành viên liên kết | Cao |
| MED-03 | Xác nhận đã uống | Có liều đến giờ | ELDER01 nhấn xác nhận | Lịch sử ghi trạng thái `taken` và thời gian thực tế | Cao |
| MED-04 | Ghi nhận liều bỏ lỡ | Có lịch đã quá hạn | Đồng bộ lịch sử sau thời gian quy định | Tạo bản ghi `missed`, không tạo trùng khi đồng bộ lại | Trung bình |
| MED-05 | Dừng lịch thuốc | Có lịch đang hoạt động | Chọn Dừng thuốc và xác nhận | Lịch không còn sinh liều mới; lịch sử cũ được giữ | Trung bình |
| MED-06 | Ghi âm lời nhắc | Đã cấp quyền micro | Ghi, nghe thử và tải lời nhắc | Âm thanh được lưu và có thể phát lại | Trung bình |
| MED-07 | Từ chối quyền thông báo/micro | Chưa cấp quyền | Từ chối quyền khi ứng dụng yêu cầu | Ứng dụng không crash và hướng dẫn người dùng phù hợp | Trung bình |

### 6.5. Lịch khám và phân công

| ID | Kịch bản | Tiền điều kiện | Các bước thực hiện | Kết quả mong đợi | Ưu tiên |
|---|---|---|---|---|---|
| APPT-01 | Tạo lịch khám | CHILD01 đã liên kết ELDER01 | Mở Chăm sóc > Lịch khám; nhập nội dung, bệnh viện, ngày giờ; lưu | Tạo lịch ở trạng thái `unassigned`; các thành viên liên kết cùng thấy | Cao |
| APPT-02 | Thiếu trường bắt buộc | Đang ở form thêm lịch | Bỏ trống nội dung hoặc bệnh viện | Form báo lỗi và không tạo lịch | Cao |
| APPT-03 | Nhận nhiệm vụ đưa đi khám | Lịch chưa có người nhận | CHILD01 nhấn Tôi sẽ đưa đi | Lịch chuyển `accepted`; hiển thị tên CHILD01 | Cao |
| APPT-04 | Hai người nhận đồng thời | CHILD01 và CHILD02 cùng mở một lịch chưa nhận | Hai thiết bị nhấn nhận gần như đồng thời | Firestore transaction chỉ cho một người nhận; người còn lại nhận thông báo lịch đã có người | Cao |
| APPT-05 | Nhờ người khác đưa đi khám | CHILD01 đang là người nhận | CHILD01 nhấn “Nhờ người khác” | Lịch trở lại `unassigned`; thành viên khác có thể nhận | Cao |
| APPT-06 | Thành viên khác cố nhờ người khác/hoàn thành | CHILD01 là người nhận; CHILD02 đăng nhập | CHILD02 sửa trực tiếp hoặc thực hiện hành động không được cấp | Firestore Rules từ chối | Cao |
| APPT-07 | Hoàn thành lịch khám sau giờ hẹn | Người đăng nhập là assignee; thời gian lịch khám đã qua | Nhấn Hoàn thành | Điều hướng sang form thêm hồ sơ bệnh án; khi lưu thành công, lịch chuyển `completed` và lưu người, thời gian hoàn thành | Cao |
| APPT-08 | Chuyển bố/mẹ đang theo dõi | CHILD01 liên kết hai người | Chuyển ELDER01 sang ELDER02 trong khi ở tab Chăm sóc | Chỉ hiển thị lịch của người đang chọn | Cao |
| APPT-09 | Hoàn thành lịch khám trước giờ hẹn | Người đăng nhập là assignee; chưa đến thời gian khám | Kiểm tra và thử nhấn Hoàn thành | Nút Hoàn thành bị vô hiệu hóa; không đổi trạng thái và không mở form hồ sơ | Cao |

### 6.6. Hồ sơ khám bệnh và tài liệu

| ID | Kịch bản | Tiền điều kiện | Các bước thực hiện | Kết quả mong đợi | Ưu tiên |
|---|---|---|---|---|---|
| RECORD-01 | Tạo hồ sơ khám thủ công | CHILD01 liên kết ELDER01 | Mở Hồ sơ khám; nhập bệnh viện, chẩn đoán, ngày khám, kết luận; lưu | Hồ sơ xuất hiện đúng thứ tự thời gian | Cao |
| RECORD-02 | Thiếu bệnh viện hoặc chẩn đoán | Đang ở form thêm hồ sơ | Bỏ trống trường bắt buộc; lưu | Báo lỗi và không tạo hồ sơ | Cao |
| RECORD-03 | Chụp ảnh hồ sơ | Có hồ sơ khám; đã cấp quyền camera | Chọn Thêm ảnh hoặc PDF > Chụp ảnh; chụp và xác nhận | Ảnh được nén, upload và hiển thị trong hồ sơ | Cao |
| RECORD-04 | Chọn ảnh từ thư viện | Có hồ sơ khám | Chọn ảnh IMG01 | Ảnh được upload; metadata lưu đúng tên, MIME type, kích thước và người tải | Cao |
| RECORD-05 | Nhập PDF | Có hồ sơ khám | Chọn PDF01 | PDF được lưu vào đúng đường dẫn và xuất hiện trong danh sách tài liệu | Cao |
| RECORD-06 | Tệp sai loại | Có hồ sơ khám | Cố chọn tệp không phải PDF từ bộ chọn file | Bộ chọn không cho chọn hoặc Storage Rules từ chối | Cao |
| RECORD-07 | Tệp vượt 15 MB | Có FILE01 | Thử tải lên | Storage Rules từ chối; không để lại metadata mồ côi | Cao |
| RECORD-08 | Hủy chọn ảnh/tệp | Đang mở camera hoặc bộ chọn | Nhấn Hủy/Quay lại | Không upload; ứng dụng trở về trạng thái trước và không crash | Trung bình |
| RECORD-09 | Thành viên liên kết xem hồ sơ | CHILD01 tạo hồ sơ cho ELDER01; CHILD02 cũng liên kết | CHILD02 mở hồ sơ ELDER01 | Xem được hồ sơ và danh sách tệp dùng chung | Cao |
| RECORD-10 | Người không liên kết truy cập hồ sơ | Dùng tài khoản thứ ba không liên kết | Thử đọc Firestore hoặc Storage path của ELDER01 | Firestore/Storage Rules từ chối | Cao |
| RECORD-11 | Lỗi mạng giữa upload và lưu metadata | Bắt đầu upload rồi ngắt mạng | Thêm tài liệu | Hiển thị lỗi; không tạo metadata sai; nếu metadata lỗi sau upload, tệp vừa upload được xóa | Trung bình |

### 6.7. SOS, vị trí và thông báo

| ID | Kịch bản | Tiền điều kiện | Các bước thực hiện | Kết quả mong đợi | Ưu tiên |
|---|---|---|---|---|---|
| SOS-01 | Gửi SOS không chờ GPS | ELDER01 đăng nhập và có mạng | Tắt GPS hoặc đặt thiết bị ở nơi lấy vị trí chậm; nhấn SOS | Cảnh báo được tạo ngay với `status=active`; quá trình lấy GPS không chặn việc gửi | Cao |
| SOS-02 | Bổ sung vị trí sau khi đã gửi | ELDER01 đã gửi SOS và cho phép vị trí | Chờ thiết bị xác định được vị trí; kiểm tra cảnh báo trên CHILD01 và Firestore | Cảnh báo được cập nhật `latitude`, `longitude`, `locationAccuracy`, `locationCapturedAt` mà không tạo cảnh báo mới | Cao |
| SOS-03 | Không cấp quyền vị trí | ELDER01 chưa cấp hoặc đã từ chối quyền vị trí | Nhấn SOS; từ chối quyền khi được hỏi | SOS vẫn được tạo và gửi đến người liên kết; giao diện thông báo cảnh báo chưa có vị trí; ứng dụng không treo hoặc crash | Cao |
| SOS-04 | Gửi thông báo đến tất cả người chăm sóc | ELDER01 liên kết CHILD01, CHILD02 và CAREGIVER01; các thiết bị có FCM token | Đưa các ứng dụng nhận về nền; ELDER01 gửi SOS | Mỗi thiết bị hợp lệ nhận đúng một thông báo đẩy có âm thanh/rung và đúng thông tin ELDER01 | Cao |
| SOS-05 | Mở SOS từ thông báo đẩy | CHILD01 nhận thông báo khi ứng dụng ở nền hoặc đã đóng nhưng không Force stop | Nhấn vào thông báo SOS | Ứng dụng mở đúng cảnh báo và đúng hồ sơ ELDER01 | Cao |
| SOS-06 | Tiếp nhận cảnh báo | SOS đang ở `active`; CHILD01 đã liên kết ELDER01 | CHILD01 mở cảnh báo và nhấn “Đã tiếp nhận” | Trạng thái thành `acknowledged`; lưu `acknowledgedById=CHILD01` và `acknowledgedAt`; ELDER01 thấy đã có người tiếp nhận | Cao |
| SOS-07 | Hai người tiếp nhận đồng thời | CHILD01 và CHILD02 cùng mở một SOS `active` trên hai thiết bị | Hai người nhấn “Đã tiếp nhận” gần như đồng thời | Transaction chỉ cho một người tiếp nhận; người còn lại thấy hộp thoại cảnh báo đã được cập nhật và không ghi đè người xử lý | Cao |
| SOS-08 | Người tiếp nhận xác nhận đang đến | CHILD01 là `acknowledgedById`; SOS ở `acknowledged` | CHILD01 nhấn “Tôi đang đến” | Trạng thái thành `enRoute`, lưu `enRouteAt` và tạo sự kiện chuyển trạng thái | Cao |
| SOS-09 | Xác nhận đã đến nơi | CHILD01 là người tiếp nhận; SOS ở `enRoute` | CHILD01 nhấn “Tôi đã đến” | Trạng thái thành `arrived`, lưu `arrivedAt` và tạo sự kiện chuyển trạng thái | Cao |
| SOS-10 | Kết thúc SOS sau khi đã đến | CHILD01 là người tiếp nhận; SOS ở `arrived` | Nhấn “Kết thúc cảnh báo”; chọn kết quả “Đã an toàn”; nhập ghi chú; nhấn Hoàn tất | Trạng thái thành `resolved`; lưu `resolvedAt`, `resolvedById`, `resolutionType=safe`, ghi chú và sự kiện kết thúc | Cao |
| SOS-11 | Kết thúc với kết quả đưa đi viện | CHILD01 là người tiếp nhận; SOS ở `arrived` | Kết thúc và chọn “Đã đưa đến cơ sở y tế” | Lưu `resolutionType=hospitalized`; cảnh báo biến mất khỏi danh sách đang hoạt động nhưng dữ liệu lịch sử được giữ | Cao |
| SOS-12 | Không kết thúc khi chưa đến | SOS mới ở `acknowledged` hoặc `enRoute` | Thử sửa trực tiếp document thành `resolved` hoặc dùng tài khoản không đúng quy trình | Giao diện chưa hiển thị nút kết thúc; Firestore Rules từ chối chuyển trạng thái không hợp lệ | Cao |
| SOS-13 | Hủy SOS và nhập lý do | SOS đang `active`; ELDER01 là người gửi | ELDER01 nhấn “Hủy báo động”; nhập “Bấm nhầm”; xác nhận | Trạng thái thành `cancelled`; lưu `cancelledById`, `cancellationReason`, `resolvedAt`; các màn hình người nhận tự đóng sau thông báo | Cao |
| SOS-14 | Không nhập lý do hủy | SOS đang `active`; hộp thoại hủy đang mở | Để trống lý do và thử xác nhận hoặc bấm ra ngoài | Không cập nhật cảnh báo; hộp thoại đóng an toàn khi bấm ra ngoài; SOS vẫn `active` | Cao |
| SOS-15 | Người cao tuổi xác nhận đã an toàn | SOS đã được tiếp nhận, đang đến hoặc đã đến | ELDER01 nhấn “Kết thúc cảnh báo” | Trạng thái thành `resolved`, `resolutionType=safe`; người nhận thấy thông báo kết thúc và màn hình SOS được đóng | Cao |
| SOS-16 | Người không được phân công cập nhật SOS | CHILD02 liên kết ELDER01 nhưng CHILD01 đã tiếp nhận | CHILD02 thử chuyển trạng thái sang `enRoute`, `arrived` hoặc `resolved` | Firestore Rules từ chối; trạng thái và `acknowledgedById` không thay đổi | Cao |
| SOS-17 | Người không liên kết truy cập SOS | Tài khoản thứ ba không liên kết ELDER01 | Đọc hoặc cập nhật `sos_alerts/{alertId}` và `events` | Firestore Rules từ chối toàn bộ yêu cầu | Cao |
| SOS-18 | Gọi điện từ màn hình SOS | Cảnh báo có số điện thoại ELDER01 | CHILD01 nhấn nút Liên hệ | Mở trình gọi điện với đúng số; nếu thiết bị không mở được thì sao chép số và hiển thị hộp thoại thông báo | Trung bình |
| SOS-19 | Xem vị trí SOS trên bản đồ | SOS đã có tọa độ | CHILD01 nhấn “Xem vị trí trên bản đồ” | Mở ứng dụng hoặc trang bản đồ tại đúng tọa độ; nếu không mở được thì sao chép liên kết | Trung bình |
| SOS-20 | Nhật ký vòng đời SOS | Đã hoàn thành chuỗi tiếp nhận → đang đến → đã đến → kết thúc | Mở Firestore `sos_alerts/{alertId}/events` | Có đủ sự kiện theo đúng thứ tự, gồm `fromStatus`, `toStatus`, `actorId`, `createdAt`; không cho sửa hoặc xóa sự kiện | Cao |
| SOS-21 | Nhấn gửi SOS nhiều lần | ELDER01 đã có một SOS đang hoạt động | Quay lại và kích hoạt SOS lần nữa | Không tạo thêm cảnh báo đang hoạt động trùng; ứng dụng sử dụng cảnh báo hiện có | Trung bình |
| SOS-22 | Mất mạng khi gửi SOS | ELDER01 tắt Wi-Fi và dữ liệu di động | Nhấn SOS; sau đó bật lại mạng và thử gửi lại | Hiển thị hộp thoại lỗi, không treo giao diện; có thể thử lại sau khi có mạng và tạo đúng một cảnh báo | Cao |
| LOC-01 | Người con xem vị trí chăm sóc | ELDER01 đã chia sẻ vị trí và liên kết CHILD01 | CHILD01 mở vị trí/bản đồ | Hiển thị đúng vị trí và thời gian cập nhật | Trung bình |
| LOC-02 | Người không liên kết đọc vị trí | Tài khoản không liên kết | Truy cập document vị trí ELDER01 | Firestore Rules từ chối | Cao |

### 6.8. Phân quyền và an toàn dữ liệu

| ID | Kịch bản | Tiền điều kiện | Các bước thực hiện | Kết quả mong đợi | Ưu tiên |
|---|---|---|---|---|---|
| SEC-01 | Liệt kê `login_directory` | Không đăng nhập | Thực hiện truy vấn collection | Bị từ chối; chỉ exact document get được phép | Cao |
| SEC-02 | Tự thay đổi role | Đăng nhập người dùng thường | Sửa trực tiếp `users/{uid}.role` | Firestore Rules từ chối | Cao |
| SEC-03 | Sửa số điện thoại hoặc email hồ sơ | Đang đăng nhập | Sửa trực tiếp trường định danh | Firestore Rules từ chối | Cao |
| SEC-04 | Đọc dữ liệu người cao tuổi không liên kết | Đăng nhập CHILD01 nhưng không liên kết ELDER02 | Truy vấn sức khỏe, thuốc, lịch, hồ sơ, SOS hoặc vị trí ELDER02 | Tất cả yêu cầu bị từ chối | Cao |
| SEC-05 | Tải file sai MIME type | Có quyền với ELDER01 | Upload executable nhưng khai báo loại không được phép | Storage Rules từ chối | Cao |
| SEC-06 | Người dùng chưa đăng nhập truy cập dữ liệu | Đã đăng xuất | Gọi trực tiếp các collection nghiệp vụ | Bị từ chối, trừ exact lookup trong `login_directory` | Cao |

### 6.9. Vai trò Người chăm sóc

#### Dữ liệu kiểm thử bổ sung

| Mã | Dữ liệu |
|---|---|
| CAREGIVER01 | Người chăm sóc đã đăng ký, có email và số điện thoại riêng, chưa liên kết với người cao tuổi |
| CAREGIVER02 | Người chăm sóc thứ hai, không liên kết với ELDER01 |

Trước khi kiểm thử nhóm này, cần triển khai phiên bản `firestore.rules` có hỗ trợ role `caregiver`, khởi động máy chủ Node.js và cấp quyền thông báo cho thiết bị CAREGIVER01.

| ID | Kịch bản | Tiền điều kiện | Các bước thực hiện | Kết quả mong đợi | Ưu tiên |
|---|---|---|---|---|---|
| CARE-01 | Đăng ký Người chăm sóc | Email và số điện thoại chưa tồn tại; máy chủ OTP hoạt động | Mở Đăng ký; nhập dữ liệu hợp lệ; chọn Người chăm sóc; nhập đúng OTP email | Tạo tài khoản có role `caregiver`; điều hướng đến giao diện chăm sóc | Cao |
| CARE-03 | Gửi yêu cầu liên kết | CAREGIVER01 và ELDER01 chưa liên kết | CAREGIVER01 nhập số điện thoại ELDER01 và gửi yêu cầu | Tạo yêu cầu `pending`; ELDER01 nhìn thấy tên và thông tin người chăm sóc | Cao |
| CARE-04 | Chưa được chấp nhận liên kết | Yêu cầu CARE-03 còn `pending` | CAREGIVER01 mở sức khỏe, thuốc, lịch khám, hồ sơ và vị trí của ELDER01 | Không đọc được dữ liệu nhạy cảm trước khi ELDER01 chấp nhận | Cao |
| CARE-05 | Chấp nhận liên kết | Có yêu cầu CARE-03 | ELDER01 chấp nhận yêu cầu; CAREGIVER01 tải lại dữ liệu | Tạo `care_relationships`; CAREGIVER01 xem được ELDER01 trong danh sách chăm sóc | Cao |
| CARE-06 | Xem dữ liệu sau liên kết | CAREGIVER01 đã liên kết ELDER01 | Mở lần lượt sức khỏe, thuốc, lịch khám, hồ sơ khám và vị trí | Chỉ hiển thị dữ liệu của ELDER01; không phát sinh lỗi quyền Firestore/Storage | Cao |
| CARE-07 | Quản lý lịch khám | CAREGIVER01 đã liên kết ELDER01 | Tạo lịch khám; nhận nhiệm vụ đưa đi khám; hoàn thành hoặc nhường nhiệm vụ | Trạng thái và người thực hiện được cập nhật đúng như luồng Con cái | Cao |
| CARE-08 | Quản lý hồ sơ khám | CAREGIVER01 đã liên kết ELDER01 | Tạo hồ sơ; chụp ảnh; chọn ảnh; nhập PDF hợp lệ | Hồ sơ và tài liệu được lưu đúng ELDER01; các thành viên đã liên kết cùng xem được | Cao |
| CARE-09 | Nhận SOS khi đang mở ứng dụng | CAREGIVER01 đã liên kết ELDER01; hai thiết bị có mạng | ELDER01 gửi SOS khi ứng dụng CAREGIVER01 đang mở | CAREGIVER01 nhận cảnh báo và xem đúng thông tin ELDER01 | Cao |
| CARE-10 | Nhận SOS khi ứng dụng chạy nền/đã đóng | Máy chủ Node.js đang chạy; CAREGIVER01 có FCM token và đã cấp quyền thông báo | Đưa ứng dụng CAREGIVER01 về nền hoặc vuốt khỏi danh sách gần đây, không Force stop; ELDER01 gửi SOS | Thiết bị nhận thông báo đẩy có âm thanh/rung; bấm thông báo mở đúng luồng SOS | Cao |
| CARE-11 | Không nhận dữ liệu của người không liên kết | CAREGIVER02 không liên kết ELDER01 | Dùng CAREGIVER02 truy cập trực tiếp document sức khỏe, thuốc, lịch, hồ sơ, SOS và vị trí của ELDER01 | Firestore/Storage Rules từ chối tất cả yêu cầu | Cao |
| CARE-12 | Không tự đổi role | CAREGIVER01 đã đăng nhập | Sửa trực tiếp role từ `caregiver` thành `child`, `elder` hoặc `unknown` | Firestore Rules từ chối; role vẫn là `caregiver` | Cao |
| CARE-13 | Đồng bộ tên Người chăm sóc | CAREGIVER01 đã liên kết ELDER01 | Đổi họ tên trong Cài đặt và lưu | Tên trong `users`, `user_directory` và trường `childName` của các bản ghi `account_links` liên quan được cập nhật | Trung bình |
| CARE-15 | Đăng ký token thông báo đúng role | CAREGIVER01 đăng nhập trên thiết bị thật và cho phép thông báo | Kiểm tra collection `fcm_tokens`; sau đó đăng xuất | Khi đăng nhập có token thuộc CAREGIVER01; sau khi đăng xuất token của phiên được xóa | Cao |

### 6.10. Kiểm thử hồi quy sau khi thêm role

| ID | Kịch bản | Tiền điều kiện | Các bước thực hiện | Kết quả mong đợi | Ưu tiên |
|---|---|---|---|---|---|
| REG-ROLE-01 | Luồng Người cao tuổi không bị ảnh hưởng | Có ELDER01 | Đăng nhập; ghi sức khỏe; xác nhận thuốc; gửi SOS | Tất cả chức năng Người cao tuổi hoạt động như trước | Cao |
| REG-ROLE-02 | Luồng Con cái không bị ảnh hưởng | Có CHILD01 đã liên kết ELDER01 | Đăng nhập; xem dữ liệu; nhận lịch khám; nhận SOS | Tất cả chức năng Con cái hoạt động như trước | Cao |
| REG-ROLE-03 | Từ chối vai trò không hỗ trợ | Firestore có hồ sơ dùng vai trò không thuộc `elder`, `child`, `caregiver` | Tải hồ sơ tài khoản | Ứng dụng từ chối hồ sơ thay vì gán nhầm vai trò | Cao |
| REG-ROLE-04 | SOS đến mọi bên chăm sóc hợp lệ | ELDER01 liên kết CHILD01 và CAREGIVER01; cả hai có FCM token | Đóng hai ứng dụng nhận; ELDER01 gửi SOS | CHILD01 và CAREGIVER01 đều nhận đúng một thông báo SOS | Cao |

## 7. Kiểm thử tự động hiện có

Chạy tại thư mục gốc dự án:

```powershell
flutter analyze
flutter test
flutter build apk --debug
```

Các kiểm thử tự động hiện có bao phủ:

- Phân loại huyết áp và các giá trị biên.
- Tạo, sắp xếp liều thuốc theo ngày và giới hạn thời gian lịch thuốc.
- Lưu hoặc từ chối bản ghi huyết áp theo quy tắc nghiệp vụ.
- Smoke test giao diện chính của người cao tuổi.

Các nhóm nên bổ sung test tự động tiếp theo:

1. Validation email, số điện thoại và mật khẩu sáu chữ số.
2. Repository đăng ký/đăng nhập với Firebase emulator.
3. Firestore Rules cho `login_directory`, lịch khám, hồ sơ y tế và toàn bộ vòng đời SOS.
4. Transaction hai thành viên cùng nhận lịch khám.
5. Transaction hai thành viên cùng tiếp nhận một cảnh báo SOS.
6. Kiểm thử các chuyển trạng thái SOS `active → acknowledged → enRoute → arrived → resolved`.
7. Storage Rules cho ảnh/PDF và giới hạn 15 MB.

## 8. Biên bản thực hiện

| Lần chạy | Ngày | Phiên bản/build | Thiết bị | Người kiểm thử | Pass | Fail | Blocked | Ghi chú |
|---|---|---|---|---|---:|---:|---:|---|
| 1 |  |  |  |  |  |  |  |  |

## 9. Mẫu ghi nhận lỗi

| Trường | Nội dung |
|---|---|
| Mã lỗi | BUG-xxx |
| Kịch bản liên quan | ID của test case |
| Mức độ | Blocker/Critical/Major/Minor |
| Môi trường | Thiết bị, hệ điều hành, build |
| Các bước tái hiện | Liệt kê từng bước |
| Kết quả thực tế | Hành vi đã xảy ra |
| Kết quả mong đợi | Hành vi đúng |
| Bằng chứng | Ảnh/video/log |
| Trạng thái | New/In progress/Resolved/Retest/Closed |
