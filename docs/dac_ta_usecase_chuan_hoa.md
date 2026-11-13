# 3.3. BẢNG ĐẶC TẢ USE CASE

Tài liệu được trình bày theo mẫu trong đồ án Word. Mỗi chức năng gồm: UsecaseID, Tên usecase, Tác nhân, Tiền điều kiện, Luồng sự kiện chính, Luồng thay thế (nếu có) và Ngoại lệ. Không sử dụng mục Hậu điều kiện.

Các mô tả dưới đây được đối chiếu với mã nguồn hiện có. Những chức năng chưa có đầy đủ màn hình hoặc thao tác trong dự án được ghi rõ, không mô tả như thể đã hoàn thiện.

---

## 3.3.1. Usecase đăng ký

**UsecaseID:** UC01

**Tên usecase:** Đăng ký

**Tác nhân:** Người cao tuổi, Con cái / Người thân, Người chăm sóc.

**Tiền điều kiện:** Thiết bị có kết nối Internet; email và số điện thoại chưa được sử dụng để đăng ký.

**Luồng sự kiện chính:**
1. Người dùng mở ứng dụng và chọn chức năng “Đăng ký”.
2. Hệ thống hiển thị biểu mẫu đăng ký.
3. Người dùng nhập số điện thoại, email, mật khẩu, họ tên, giới tính và vai trò.
4. Người dùng chọn “Gửi mã xác thực”.
5. Hệ thống kiểm tra thông tin, sau đó gửi mã gồm 6 chữ số đến email đã nhập. Mã có hiệu lực trong 10 phút.
6. Người dùng mở email, lấy mã và nhập vào màn hình xác nhận.
7. Người dùng chọn “Hoàn tất đăng ký”.
8. Hệ thống kiểm tra mã xác nhận và tạo tài khoản.
9. Hệ thống lưu thông tin người dùng và thông báo đăng ký thành công.

**Luồng thay thế:**
- Tại bước 6, nếu chưa nhận được email, người dùng có thể yêu cầu gửi lại mã sau thời gian chờ.

**Ngoại lệ:**
- E1 (Email đã được sử dụng): Hệ thống thông báo email đã tồn tại và yêu cầu dùng email khác hoặc đăng nhập.
- E2 (Số điện thoại đã được sử dụng): Hệ thống thông báo số điện thoại đã tồn tại.
- E3 (Thông tin không hợp lệ): Hệ thống chỉ rõ nội dung còn thiếu hoặc chưa đúng để người dùng sửa lại.
- E4 (Mã xác nhận sai, hết hạn hoặc nhập sai quá số lần cho phép): Hệ thống thông báo và yêu cầu lấy mã mới.
- E5 (Mất kết nối): Hệ thống thông báo không thể tiếp tục và giữ lại thông tin đã nhập nếu màn hình còn mở.

## 3.3.2. Usecase đăng nhập

**UsecaseID:** UC02

**Tên usecase:** Đăng nhập

**Tác nhân:** Người cao tuổi, Con cái / Người thân, Người chăm sóc.

**Tiền điều kiện:** Người dùng đã có tài khoản trong hệ thống.

**Luồng sự kiện chính:**
1. Người dùng mở ứng dụng và chọn “Đăng nhập”.
2. Người dùng nhập số điện thoại và mật khẩu đã đăng ký.
3. Người dùng chọn nút “Đăng nhập”.
4. Hệ thống kiểm tra thông tin tài khoản.
5. Nếu thông tin chính xác, hệ thống tải hồ sơ và xác định vai trò của người dùng.
6. Hệ thống mở màn hình chính phù hợp với vai trò đã đăng ký.

**Luồng thay thế:** Không có.

**Ngoại lệ:**
- E1 (Sai số điện thoại hoặc mật khẩu): Hệ thống thông báo thông tin đăng nhập không chính xác.
- E2 (Tài khoản không tồn tại): Hệ thống thông báo chưa tìm thấy tài khoản tương ứng.
- E3 (Mất kết nối): Hệ thống thông báo không thể đăng nhập và cho phép thử lại.

## 3.3.3. Usecase đăng xuất

**UsecaseID:** UC03

**Tên usecase:** Đăng xuất

**Tác nhân:** Người cao tuổi, Con cái / Người thân, Người chăm sóc.

**Tiền điều kiện:** Người dùng đang đăng nhập vào ứng dụng.

**Luồng sự kiện chính:**
1. Người dùng mở mục “Cài đặt”.
2. Người dùng chọn “Đăng xuất”.
3. Hệ thống hiển thị thông báo xác nhận.
4. Người dùng chọn “Đăng xuất”.
5. Hệ thống kết thúc phiên sử dụng trên thiết bị.
6. Ứng dụng chuyển về màn hình đăng nhập.

**Luồng thay thế:**
- Tại bước 4, nếu người dùng chọn “Ở lại” hoặc “Hủy”, hệ thống đóng thông báo và giữ nguyên màn hình đang sử dụng.

**Ngoại lệ:**
- E1 (Không thể đăng xuất): Hệ thống thông báo lỗi; người dùng có thể thử lại.

## 3.3.4. Usecase chỉnh sửa thông tin cá nhân

**UsecaseID:** UC04

**Tên usecase:** Chỉnh sửa thông tin cá nhân

**Tác nhân:** Người cao tuổi, Con cái / Người thân, Người chăm sóc.

**Tiền điều kiện:** Người dùng đã đăng nhập và hồ sơ cá nhân đã được tạo.

**Luồng sự kiện chính:**
1. Người dùng mở mục “Cài đặt”.
2. Người dùng chọn chức năng “Chỉnh sửa hồ sơ”.
3. Hệ thống hiển thị họ tên và giới tính hiện tại.
4. Người dùng thay đổi họ tên hoặc giới tính.
5. Người dùng chọn “Lưu thay đổi”.
6. Hệ thống kiểm tra thông tin vừa nhập.
7. Nếu thông tin hợp lệ, hệ thống lưu thay đổi và hiển thị thông báo thành công.

**Luồng thay thế:**
- Tại bước 5, người dùng chọn “Hủy” để đóng biểu mẫu và giữ nguyên thông tin cũ.

**Ngoại lệ:**
- E1 (Họ tên bị bỏ trống hoặc quá ngắn): Hệ thống yêu cầu nhập lại họ tên.
- E2 (Không lưu được thông tin): Hệ thống thông báo lỗi và giữ lại nội dung người dùng vừa nhập.

## 3.3.5. Usecase gửi cảnh báo SOS

**UsecaseID:** UC05

**Tên usecase:** Gửi cảnh báo SOS

**Tác nhân:** Người cao tuổi; hệ thống phát hiện dấu hiệu té ngã.

**Tiền điều kiện:** Người cao tuổi đã đăng nhập; ứng dụng đang được sử dụng trên thiết bị có kết nối Internet để gửi cảnh báo.

**Luồng sự kiện chính:**
1. Người cao tuổi chọn nút “SOS” trên màn hình.
2. Trường hợp thiết bị phát hiện dấu hiệu té ngã, ứng dụng hiển thị thông báo hỏi người dùng có cần trợ giúp hay không.
3. Người cao tuổi xác nhận cần trợ giúp hoặc không phản hồi trong thời gian đếm ngược.
4. Hệ thống ghi nhận cảnh báo cùng thời điểm xảy ra.
5. Hệ thống lấy vị trí hiện tại nếu thiết bị cho phép.
6. Hệ thống gửi thông báo đến những người thân đã liên kết với tài khoản người cao tuổi.
7. Ứng dụng hiển thị thông báo đã gửi cảnh báo.

**Luồng thay thế:**
- Nếu người cao tuổi chọn “Tôi vẫn ổn” trong thời gian đếm ngược, ứng dụng đóng thông báo té ngã và không gửi cảnh báo.

**Ngoại lệ:**
- E1 (Không lấy được vị trí): Hệ thống vẫn gửi cảnh báo và thông báo rằng chưa có thông tin vị trí.
- E2 (Không có kết nối Internet): Hệ thống thông báo chưa gửi được cảnh báo và hiển thị lựa chọn gọi cấp cứu 115.
- E3 (Không có người thân đã liên kết): Hệ thống vẫn ghi nhận cảnh báo nhưng không có người thân để nhận thông báo.

## 3.3.6. Usecase tiếp nhận và xử lý cảnh báo

**UsecaseID:** UC06

**Tên usecase:** Tiếp nhận và xử lý cảnh báo

**Tác nhân:** Con cái / Người thân đã liên kết với người cao tuổi; Người cao tuổi.

**Tiền điều kiện:** Có cảnh báo SOS chưa được xử lý của người cao tuổi đã liên kết.

**Luồng sự kiện chính:**
1. Người thân nhận thông báo có cảnh báo SOS.
2. Người thân mở thông báo để xem chi tiết.
3. Hệ thống hiển thị tên người cao tuổi, thời điểm gửi cảnh báo, nguyên nhân cảnh báo và vị trí nếu có.
4. Người thân chọn “Tiếp nhận”.
5. Hệ thống ghi nhận người đầu tiên tiếp nhận cảnh báo.
6. Người thân di chuyển đến hỗ trợ và có thể chọn cập nhật tình trạng đang trên đường hoặc đã đến nơi.
7. Sau khi hỗ trợ, người thân chọn chức năng kết thúc xử lý và nhập kết quả hỗ trợ.
8. Hệ thống cập nhật tình trạng cảnh báo và thông báo cho những người thân liên quan.

**Luồng thay thế:**
- Người thân có thể chọn gọi điện hoặc mở bản đồ để tìm đường đến vị trí người cao tuổi trước khi cập nhật quá trình hỗ trợ.

**Ngoại lệ:**
- E1 (Người khác đã tiếp nhận): Hệ thống thông báo tên người đã nhận xử lý và không cho người dùng tiếp nhận lần nữa.
- E2 (Cảnh báo đã kết thúc): Hệ thống hiển thị thông tin mới nhất và không cho cập nhật tiếp.
- E3 (Người dùng không có quyền xem cảnh báo): Hệ thống từ chối truy cập.
- E4 (Không lưu được thay đổi): Hệ thống thông báo lỗi và giữ nguyên thông tin cảnh báo trước đó.

## 3.3.7. Usecase ghi chỉ số huyết áp

**UsecaseID:** UC07

**Tên usecase:** Ghi chỉ số huyết áp

**Tác nhân:** Người cao tuổi.

**Tiền điều kiện:** Người cao tuổi đã đăng nhập vào ứng dụng.

**Luồng sự kiện chính:**
1. Người cao tuổi mở mục “Nhật ký sức khỏe”.
2. Người dùng chọn “Ghi chỉ số”.
3. Hệ thống hiển thị màn hình nhập kết quả đo.
4. Người dùng nhập chỉ số huyết áp trên và huyết áp dưới.
5. Người dùng chọn “Lưu kết quả đo”.
6. Hệ thống kiểm tra hai chỉ số, trong đó chỉ số trên phải lớn hơn chỉ số dưới.
7. Hệ thống lưu kết quả đo và hiển thị mức đánh giá kèm hướng dẫn phù hợp.

**Luồng thay thế:** Không có.

**Ngoại lệ:**
- E1 (Thiếu chỉ số): Hệ thống yêu cầu nhập đầy đủ hai chỉ số.
- E2 (Chỉ số không hợp lệ): Hệ thống thông báo nếu chỉ số trên nằm ngoài khoảng 70–250, chỉ số dưới nằm ngoài khoảng 40–150 hoặc chỉ số trên không lớn hơn chỉ số dưới.
- E3 (Không lưu được): Hệ thống thông báo lỗi và cho phép người dùng thử lại.

## 3.3.8. Usecase theo dõi lịch sử huyết áp

**UsecaseID:** UC08

**Tên usecase:** Theo dõi lịch sử huyết áp

**Tác nhân:** Người cao tuổi.

**Tiền điều kiện:** Người dùng đã đăng nhập vào ứng dụng.

**Luồng sự kiện chính:**
1. Người dùng mở mục “Nhật ký sức khỏe”.
2. Hệ thống tải các lần đo huyết áp đã lưu.
3. Hệ thống hiển thị biểu đồ hai đường thể hiện chỉ số huyết áp trên và huyết áp dưới trong tối đa 7 lần đo gần nhất.
4. Hệ thống hiển thị danh sách các lần đo, sắp xếp từ mới nhất đến cũ nhất.
5. Người dùng chọn một lần đo để xem thông tin chi tiết và mức đánh giá.

**Luồng thay thế:** Không có.

**Ngoại lệ:**
- E1 (Chưa có dữ liệu): Hệ thống hiển thị thông báo chưa có kết quả đo và hướng dẫn người dùng ghi chỉ số lần đầu.
- E2 (Không tải được dữ liệu): Hệ thống thông báo lỗi và cho phép tải lại.

## 3.3.9. Usecase cảnh báo chỉ số huyết áp bất thường

**UsecaseID:** UC09

**Tên usecase:** Cảnh báo chỉ số huyết áp bất thường

**Tác nhân:** Người cao tuổi.

**Tiền điều kiện:** Người dùng đang nhập hoặc vừa ghi nhận kết quả đo huyết áp.

**Luồng sự kiện chính:**
1. Người dùng nhập hai chỉ số huyết áp.
2. Hệ thống kiểm tra và đánh giá kết quả vừa nhập.
3. Nếu chỉ số ở mức cần chú ý, hệ thống hiển thị thông báo hướng dẫn nghỉ ngơi và đo lại.
4. Nếu chỉ số ở mức rất cao, hệ thống hiển thị hướng dẫn khẩn cấp.
5. Người dùng đọc hướng dẫn và thực hiện theo tình trạng thực tế.

**Luồng thay thế:**
- Nếu chỉ số ở mức bình thường hoặc tốt, hệ thống hiển thị lời khuyên tiếp tục theo dõi định kỳ.

**Ngoại lệ:**
- E1 (Chỉ số nhập không hợp lệ): Hệ thống yêu cầu nhập lại và không đưa ra đánh giá.
- E2 (Người dùng có dấu hiệu nguy hiểm): Hệ thống hướng dẫn gọi cấp cứu 115 khi có các dấu hiệu như đau ngực, khó thở, yếu liệt hoặc khó nói.

## 3.3.10. Usecase thiết lập lịch uống thuốc

**UsecaseID:** UC10

**Tên usecase:** Thiết lập lịch uống thuốc

**Tác nhân:** Người cao tuổi.

**Tiền điều kiện:** Người dùng đã đăng nhập vào ứng dụng.

**Luồng sự kiện chính:**
1. Người dùng mở mục “Thuốc”.
2. Người dùng chọn chức năng thêm thuốc.
3. Người dùng nhập tên thuốc, liều dùng và hướng dẫn uống thuốc.
4. Người dùng chọn một hoặc nhiều khung giờ uống trong ngày và ngày bắt đầu sử dụng.
5. Người dùng có thể chọn ngày kết thúc nếu có.
6. Người dùng chọn “Lưu thuốc”.
7. Hệ thống kiểm tra thông tin và lưu lịch uống thuốc.
8. Ứng dụng thiết lập các lần nhắc uống thuốc theo những khung giờ đã chọn.

**Luồng thay thế:**
- Người dùng có thể mở một lịch thuốc đã có để thay đổi thông tin hoặc chọn “Dừng thuốc” khi không còn sử dụng lịch đó.

**Ngoại lệ:**
- E1 (Thiếu tên thuốc hoặc giờ uống): Hệ thống yêu cầu bổ sung thông tin còn thiếu.
- E2 (Ngày kết thúc trước ngày bắt đầu): Hệ thống yêu cầu chọn lại ngày.
- E3 (Không lưu được lịch): Hệ thống thông báo lỗi và giữ lại thông tin đã nhập.

## 3.3.11. Usecase nhắc nhở và theo dõi lịch uống thuốc

**UsecaseID:** UC11

**Tên usecase:** Nhắc nhở và theo dõi lịch uống thuốc

**Tác nhân:** Người cao tuổi, Con cái / Người thân, Hệ thống.

**Tiền điều kiện:** Người cao tuổi đã có lịch uống thuốc còn hiệu lực.

**Luồng sự kiện chính:**
1. Hệ thống kiểm tra các lịch uống thuốc đang được sử dụng.
2. Đến giờ đã chọn, ứng dụng gửi thông báo nhắc người cao tuổi uống thuốc.
3. Người cao tuổi mở mục “Thuốc” để xem các lần uống trong ngày.
4. Các lần uống được sắp xếp theo giờ đã cài đặt.
5. Người thân đã liên kết có thể mở phần theo dõi để xem lịch uống thuốc của người cao tuổi.

**Luồng thay thế:**
- Người dùng có thể mở thông báo để chuyển thẳng đến phần lịch uống thuốc.

**Ngoại lệ:**
- E1 (Chưa cho phép thông báo): Ứng dụng hiển thị hướng dẫn bật quyền thông báo trên thiết bị.
- E2 (Lịch thuốc đã dừng hoặc chưa đến ngày bắt đầu): Ứng dụng không tạo lời nhắc cho lịch đó.
- E3 (Thiết bị không hỗ trợ lời nhắc): Người dùng vẫn có thể xem lịch uống thuốc trong ứng dụng.

## 3.3.12. Usecase ghi nhận nhật ký uống thuốc

**UsecaseID:** UC12

**Tên usecase:** Ghi nhận nhật ký uống thuốc

**Tác nhân:** Người cao tuổi, Hệ thống.

**Tiền điều kiện:** Người cao tuổi có lịch uống thuốc trong ngày.

**Luồng sự kiện chính:**
1. Người cao tuổi mở mục “Thuốc”.
2. Hệ thống hiển thị các lần uống thuốc trong ngày.
3. Sau khi uống thuốc, người cao tuổi chọn “Đã uống” tại lần uống tương ứng.
4. Hệ thống ghi nhận thời điểm người dùng xác nhận.
5. Ứng dụng cập nhật lần uống thành đã uống.
6. Người thân đã liên kết có thể xem thông tin vừa được cập nhật.
7. Hệ thống kiểm tra các lần uống đã quá giờ 5 tiếng mà chưa được xác nhận và ghi nhận là bỏ lỡ.

**Luồng thay thế:**
- Người dùng có thể xem lại các lần uống đã hoàn thành hoặc bị bỏ lỡ trong phần lịch sử.

**Ngoại lệ:**
- E1 (Lần uống đã được ghi nhận): Hệ thống không tạo thêm bản ghi trùng cho cùng một lần uống.
- E2 (Không lưu được): Hệ thống thông báo lỗi và cho phép người dùng thử lại.

## 3.3.13. Usecase gửi và phản hồi yêu cầu liên kết

**UsecaseID:** UC13

**Tên usecase:** Gửi và phản hồi yêu cầu liên kết

**Tác nhân:** Con cái / Người thân (gửi yêu cầu), Người cao tuổi (phản hồi).

**Tiền điều kiện:** Cả hai người đã có tài khoản trong hệ thống.

**Luồng sự kiện chính:**
1. Người thân mở mục “Người thân của tôi”.
2. Người thân nhập số điện thoại của người cao tuổi và chọn gửi yêu cầu.
3. Hệ thống kiểm tra tài khoản theo số điện thoại đã nhập.
4. Hệ thống gửi yêu cầu đến tài khoản người cao tuổi.
5. Người cao tuổi mở mục “Liên hệ khẩn cấp” để xem yêu cầu.
6. Người cao tuổi chọn “Chấp nhận” hoặc “Từ chối”.
7. Nếu chấp nhận, hệ thống ghi nhận hai tài khoản đã liên kết.
8. Người thân có thể xem thông tin người cao tuổi đã liên kết.

**Luồng thay thế:**
- Khi yêu cầu còn đang chờ phản hồi, người gửi có thể chọn hủy yêu cầu.

**Ngoại lệ:**
- E1 (Không tìm thấy số điện thoại): Hệ thống thông báo chưa có tài khoản phù hợp.
- E2 (Tài khoản được chọn không phải người cao tuổi): Hệ thống không cho gửi yêu cầu.
- E3 (Đã liên kết hoặc đang chờ phản hồi): Hệ thống thông báo không thể tạo yêu cầu trùng.
- E4 (Yêu cầu không còn hiệu lực): Hệ thống thông báo và tải lại danh sách yêu cầu.

## 3.3.14. Usecase quản lý danh sách người thân

**UsecaseID:** UC14

**Tên usecase:** Quản lý danh sách người thân

**Tác nhân:** Người cao tuổi, Con cái / Người thân.

**Tiền điều kiện:** Người dùng đã đăng nhập vào ứng dụng.

**Luồng sự kiện chính:**
1. Người dùng mở mục “Liên hệ” hoặc “Người thân của tôi”.
2. Hệ thống tải danh sách các tài khoản đã liên kết.
3. Người cao tuổi xem danh sách người thân đã chấp nhận liên kết.
4. Người thân xem danh sách người cao tuổi đã liên kết.
5. Người dùng chọn một người trong danh sách để xem thông tin liên hệ được hiển thị.

**Luồng thay thế:**
- Nếu có yêu cầu đang chờ, người dùng mở phần yêu cầu để xem và phản hồi.

**Ngoại lệ:**
- E1 (Chưa có người thân liên kết): Hệ thống hiển thị hướng dẫn gửi hoặc xác nhận yêu cầu liên kết.
- E2 (Không tải được danh sách): Hệ thống thông báo lỗi và cho phép tải lại.

## 3.3.15. Usecase liên hệ khẩn cấp

**UsecaseID:** UC15

**Tên usecase:** Liên hệ khẩn cấp

**Tác nhân:** Người cao tuổi, Con cái / Người thân.

**Tiền điều kiện:** Người dùng đang mở ứng dụng trên thiết bị có thể thực hiện cuộc gọi.

**Luồng sự kiện chính:**
1. Người dùng mở mục “Liên hệ khẩn cấp”.
2. Hệ thống hiển thị nút gọi cấp cứu 115.
3. Người dùng chọn nút gọi 115.
4. Hệ thống hiển thị thông báo xác nhận cuộc gọi.
5. Người dùng chọn “Gọi 115”.
6. Thiết bị mở chức năng gọi điện để người dùng thực hiện cuộc gọi.

**Luồng thay thế:**
- Người dùng chọn “Hủy” để đóng thông báo và không thực hiện cuộc gọi.

**Ngoại lệ:**
- E1 (Thiết bị không thể gọi điện): Hệ thống thông báo không thể thực hiện cuộc gọi trên thiết bị hiện tại.

**Ghi chú:** Mã nguồn hiện có nút gọi cấp cứu 115 và hiển thị người thân đã liên kết. Chưa thấy chức năng thêm, sửa, xóa danh bạ khẩn cấp riêng; vì vậy đặc tả không mô tả các thao tác này.

## 3.3.16. Usecase tạo lịch khám sức khỏe

**UsecaseID:** UC16

**Tên usecase:** Tạo lịch khám sức khỏe

**Tác nhân:** Con cái / Người thân đã liên kết với người cao tuổi.

**Tiền điều kiện:** Người thân đã liên kết với tài khoản người cao tuổi.

**Luồng sự kiện chính:**
1. Người thân mở mục “Lịch khám”.
2. Người thân chọn “Thêm lịch”.
3. Người thân nhập nội dung khám, tên bệnh viện hoặc cơ sở y tế, khoa khám, ngày giờ và ghi chú cần thiết.
4. Người thân chọn người dự kiến đưa người cao tuổi đi khám nếu đã xác định được người phụ trách.
5. Người thân chọn “Lưu”.
6. Hệ thống kiểm tra thông tin và tạo lịch khám.
7. Lịch khám được hiển thị trong danh sách để các thành viên liên quan theo dõi.

**Luồng thay thế:**
- Nếu chưa xác định người đưa đi khám, lịch được lưu ở tình trạng chưa có người phụ trách để thành viên phù hợp nhận sau.

**Ngoại lệ:**
- E1 (Thiếu thông tin cần thiết): Hệ thống yêu cầu bổ sung nội dung khám hoặc thời gian khám.
- E2 (Thời gian đã qua): Hệ thống thông báo cần chọn thời gian trong tương lai.
- E3 (Người được chọn không thuộc gia đình đã liên kết): Hệ thống không chấp nhận người phụ trách đó.
- E4 (Không lưu được lịch): Hệ thống thông báo lỗi và giữ lại thông tin đã nhập.

## 3.3.17. Usecase điều phối người đưa đi khám

**UsecaseID:** UC17

**Tên usecase:** Điều phối người đưa đi khám

**Tác nhân:** Con cái / Người thân đã liên kết.

**Tiền điều kiện:** Có lịch khám chưa có người phụ trách hoặc lịch đang do người dùng đảm nhận.

**Luồng sự kiện chính:**
1. Người thân mở danh sách lịch khám của gia đình.
2. Với lịch chưa có người phụ trách, người thân chọn “Tôi sẽ đưa đi”.
3. Hệ thống kiểm tra lịch vẫn chưa có người nhận.
4. Hệ thống ghi nhận người vừa chọn là người phụ trách lịch khám.
5. Những thành viên khác nhìn thấy tên người đang phụ trách.
6. Nếu người phụ trách không thể tiếp tục, họ chọn “Nhờ người khác”.
7. Hệ thống bỏ tên người phụ trách hiện tại và đưa lịch về tình trạng chưa có người nhận.

**Luồng thay thế:**
- Sau khi lịch được trả lại, một thành viên khác có thể chọn “Tôi sẽ đưa đi” để nhận trách nhiệm.

**Ngoại lệ:**
- E1 (Lịch đã có người nhận): Hệ thống thông báo lịch đã được thành viên khác đảm nhận.
- E2 (Người dùng không phải người phụ trách): Hệ thống không cho phép trả lại lịch.
- E3 (Lịch đã hoàn tất): Hệ thống không cho nhận hoặc trả lại lịch đã kết thúc.

## 3.3.18. Usecase xác nhận hoàn tất lịch khám

**UsecaseID:** UC18

**Tên usecase:** Xác nhận hoàn tất lịch khám

**Tác nhân:** Con cái / Người thân đang phụ trách lịch khám.

**Tiền điều kiện:** Lịch khám đã có người phụ trách và đã đến hoặc qua thời gian hẹn.

**Luồng sự kiện chính:**
1. Người phụ trách mở danh sách lịch khám.
2. Người phụ trách chọn lịch khám cần cập nhật.
3. Người phụ trách chọn “Hoàn thành”.
4. Hệ thống kiểm tra người đang thao tác có phải người phụ trách lịch khám hay không và thời gian hẹn đã đến chưa.
5. Hệ thống cập nhật lịch khám thành đã hoàn thành.
6. Ứng dụng mở phần thêm hồ sơ khám và điền sẵn tên cơ sở y tế cùng ngày khám nếu có thông tin.

**Luồng thay thế:**
- Người dùng có thể bỏ qua việc thêm hồ sơ khám ở thời điểm này và thực hiện sau.

**Ngoại lệ:**
- E1 (Chưa đến giờ hẹn): Hệ thống thông báo chỉ có thể hoàn thành lịch sau thời gian đã hẹn.
- E2 (Không phải người phụ trách): Hệ thống không cho phép hoàn tất lịch.
- E3 (Lịch đã được hoàn thành hoặc không còn tồn tại): Hệ thống tải lại thông tin mới nhất.

## 3.3.19. Usecase lưu hồ sơ y tế

**UsecaseID:** UC19

**Tên usecase:** Lưu hồ sơ y tế

**Tác nhân:** Người cao tuổi, Con cái / Người thân đã liên kết.

**Tiền điều kiện:** Người dùng đã đăng nhập và có quyền lưu hồ sơ cho người cao tuổi được chọn.

**Luồng sự kiện chính:**
1. Người dùng mở mục “Hồ sơ khám”.
2. Người dùng chọn “Thêm hồ sơ”.
3. Người dùng chọn ngày khám và nhập tên bệnh viện, khoa khám, tên bác sĩ, chẩn đoán, kết luận và ghi chú nếu có.
4. Người dùng có thể nhập ngày tái khám.
5. Người dùng chọn “Lưu”.
6. Hệ thống kiểm tra thông tin và lưu hồ sơ khám.
7. Hồ sơ mới được hiển thị trong danh sách lịch sử khám.

**Luồng thay thế:**
- Người dùng có thể mở chức năng thêm hồ sơ từ màn hình xác nhận hoàn tất lịch khám; thông tin cơ sở y tế và ngày khám được điền sẵn nếu có.

**Ngoại lệ:**
- E1 (Thiếu thông tin bắt buộc): Hệ thống yêu cầu bổ sung ngày khám, cơ sở y tế hoặc chẩn đoán.
- E2 (Ngày khám ở tương lai): Hệ thống yêu cầu kiểm tra lại ngày khám.
- E3 (Không có quyền lưu): Hệ thống thông báo người dùng không được phép thêm hồ sơ cho tài khoản đã chọn.
- E4 (Không lưu được hồ sơ): Hệ thống thông báo lỗi và giữ lại nội dung đã nhập.

## 3.3.20. Usecase quản lý tài liệu đính kèm

**UsecaseID:** UC20

**Tên usecase:** Quản lý tài liệu đính kèm

**Tác nhân:** Người cao tuổi, Con cái / Người thân đã liên kết.

**Tiền điều kiện:** Đã có hồ sơ khám và người dùng có quyền xem hoặc thêm tài liệu cho hồ sơ đó.

**Luồng sự kiện chính:**
1. Người dùng mở một hồ sơ khám cụ thể.
2. Người dùng chọn chức năng thêm tài liệu.
3. Người dùng chọn hình ảnh hoặc tệp PDF từ thiết bị.
4. Hệ thống kiểm tra loại tệp và dung lượng.
5. Hệ thống gửi tài liệu lên nơi lưu trữ và ghi nhận tài liệu thuộc hồ sơ khám đã chọn.
6. Khi cần xem, người dùng chọn tài liệu trong hồ sơ.
7. Hệ thống kiểm tra quyền truy cập và hiển thị tài liệu.

**Luồng thay thế:**
- Người dùng có thể chọn mở tài liệu PDF bằng chức năng xem tài liệu trên thiết bị.

**Ngoại lệ:**
- E1 (Loại tệp không được hỗ trợ): Hệ thống chỉ chấp nhận hình ảnh hoặc PDF.
- E2 (Tệp lớn hơn 15 MB): Hệ thống thông báo tệp vượt quá dung lượng cho phép.
- E3 (Không có quyền truy cập): Hệ thống từ chối xem hoặc thêm tài liệu.
- E4 (Không tải được tệp): Hệ thống thông báo lỗi và không hiển thị tài liệu như thể đã tải thành công.

## 3.3.21. Usecase tra cứu lịch sử khám bệnh

**UsecaseID:** UC21

**Tên usecase:** Tra cứu lịch sử khám bệnh

**Tác nhân:** Người cao tuổi, Con cái / Người thân đã liên kết.

**Tiền điều kiện:** Người dùng đã đăng nhập và có quyền xem hồ sơ khám của tài khoản được chọn.

**Luồng sự kiện chính:**
1. Người dùng mở mục “Hồ sơ khám”.
2. Hệ thống tải danh sách các lần khám đã lưu.
3. Hệ thống sắp xếp các lần khám theo ngày gần nhất.
4. Người dùng chọn một lần khám để xem chi tiết.
5. Hệ thống hiển thị ngày khám, cơ sở y tế, khoa khám, bác sĩ, chẩn đoán, kết luận và ghi chú.
6. Người dùng có thể mở các tài liệu được đính kèm trong lần khám đó.

**Luồng thay thế:** Không có.

**Ngoại lệ:**
- E1 (Chưa có hồ sơ khám): Hệ thống hiển thị thông báo chưa có hồ sơ và hướng dẫn thêm hồ sơ mới.
- E2 (Tài liệu không còn hoặc không mở được): Hệ thống thông báo tài liệu hiện không thể xem.
- E3 (Không có quyền xem): Hệ thống từ chối truy cập hồ sơ.
- E4 (Không tải được danh sách): Hệ thống thông báo lỗi và cho phép thử lại.

---

## Ghi chú rà soát so với dự án

1. Tài khoản hiện đăng ký bằng email, số điện thoại, mật khẩu 6 chữ số, họ tên, giới tính và vai trò; mã xác nhận email có hiệu lực 10 phút. Vì vậy tài liệu đã sửa thời hạn từ 5 phút thành 10 phút.
2. Màn hình chỉnh sửa hồ sơ hiện chỉ cho sửa họ tên và giới tính; không mô tả sửa email, số điện thoại hoặc ảnh đại diện.
3. Phát hiện té ngã hiện dựa trên cảm biến chuyển động và có bước hỏi xác nhận; không mô tả là tự động gọi cấp cứu.
4. Cảnh báo SOS có thể lưu và gửi thông báo đến người thân đã liên kết; vị trí có thể không có nếu thiết bị không lấy được vị trí.
5. Ghi chỉ số huyết áp và xem lịch sử được triển khai trong ứng dụng. Hướng dẫn khi chỉ số rất cao được hiển thị cho người dùng; không mô tả đây là kết luận của bác sĩ.
6. Lịch uống thuốc được nhắc trên thiết bị; lịch sử bỏ lỡ được ghi khi quá giờ 5 tiếng. Không mô tả hệ thống tự biết người dùng đã uống thuốc nếu họ chưa xác nhận.
7. Yêu cầu liên kết chỉ được chấp nhận khi người cao tuổi phản hồi đồng ý. Dự án hiện chưa có thao tác thu hồi một liên kết đã được chấp nhận.
8. Lịch khám cho phép để trống người phụ trách, một thành viên nhận lịch và người đang phụ trách trả lại lịch. Việc nhận lịch chưa có nghĩa là đã đặt lịch với bệnh viện.
9. Tài liệu đính kèm hiện hỗ trợ hình ảnh và PDF, dung lượng tối đa 15 MB.
10. Chức năng liên hệ khẩn cấp hiện có nút gọi 115 và hiển thị thông tin người thân đã liên kết; chưa thấy phần quản lý một danh bạ số khẩn cấp riêng.
11. Trong bản Word, phần mục lục liệt kê 21 chức năng nhưng nội dung chi tiết bị thiếu một số mục và có mục chỉnh sửa thông tin bị chép nhầm từ đăng xuất. Bản này khôi phục cấu trúc 21 mục theo danh sách trong mục lục, đồng thời ghi chú rõ các giới hạn triển khai để tránh mô tả sai chức năng.
