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

**Ràng buộc thông tin nhập:**
- Họ và tên: bắt buộc, tối thiểu 2 ký tự sau khi bỏ khoảng trắng ở đầu và cuối; chưa quy định độ dài tối đa.
- Email: bắt buộc, phải có dạng địa chỉ email hợp lệ; hệ thống chuyển email về chữ thường khi xử lý.
- Số điện thoại: bắt buộc, đúng 10 chữ số và bắt đầu bằng số 0; chỉ nhận chữ số.
- Mật khẩu: bắt buộc, đúng 6 chữ số; không nhận chữ cái hoặc ký tự đặc biệt.
- Vai trò: bắt buộc chọn một trong ba lựa chọn: Người cao tuổi, Con cái hoặc Người chăm sóc.
- Giới tính: bắt buộc chọn Nam, Nữ hoặc Khác.
- Mã xác nhận: bắt buộc, đúng 6 chữ số; có hiệu lực 10 phút, được gửi lại sau 60 giây và tối đa 5 lần nhập sai.

**Luồng thay thế:**
- **6A:** Tại bước 6, nếu chưa nhận được email, người dùng có thể yêu cầu gửi lại mã sau thời gian chờ.

**Ngoại lệ:**
- **4E:** E1 (Email đã được sử dụng): Hệ thống thông báo email đã tồn tại và yêu cầu dùng email khác hoặc đăng nhập.
- **4E:** E2 (Số điện thoại đã được sử dụng): Hệ thống thông báo số điện thoại đã tồn tại.
- **3E:** E3 (Thông tin không hợp lệ): Hệ thống chỉ rõ nội dung còn thiếu hoặc chưa đúng để người dùng sửa lại.
- **7E:** E4 (Mã xác nhận sai, hết hạn hoặc nhập sai quá số lần cho phép): Hệ thống thông báo và yêu cầu lấy mã mới.
- **4E:** E5 (Mất kết nối): Hệ thống thông báo không thể tiếp tục và giữ lại thông tin đã nhập nếu màn hình còn mở.

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

**Ràng buộc thông tin nhập:**
- Số điện thoại: bắt buộc, đúng 10 chữ số và bắt đầu bằng số 0.
- Mật khẩu: bắt buộc, đúng 6 chữ số.
- Không chấp nhận để trống một trong hai trường.

**Luồng thay thế:** Không có.

**Ngoại lệ:**
- **3E:** E1 (Sai số điện thoại hoặc mật khẩu): Hệ thống thông báo thông tin đăng nhập không chính xác.
- **4E:** E2 (Tài khoản không tồn tại): Hệ thống thông báo chưa tìm thấy tài khoản tương ứng.
- **4E:** E3 (Mất kết nối): Hệ thống thông báo không thể đăng nhập và cho phép thử lại.

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

**Ràng buộc thông tin nhập:** Không có trường nhập liệu. Người dùng chỉ chọn xác nhận đăng xuất hoặc ở lại ứng dụng.

**Luồng thay thế:**
- **4A:** Tại bước 4, nếu người dùng chọn “Ở lại” hoặc “Hủy”, hệ thống đóng thông báo và giữ nguyên màn hình đang sử dụng.

**Ngoại lệ:**
- **4E:** E1 (Không thể đăng xuất): Hệ thống thông báo lỗi; người dùng có thể thử lại.

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

**Ràng buộc thông tin nhập:**
- Họ và tên: bắt buộc, tối thiểu 2 ký tự sau khi bỏ khoảng trắng ở đầu và cuối; chưa quy định độ dài tối đa.
- Giới tính: bắt buộc chọn một trong ba lựa chọn: Nam, Nữ hoặc Khác.
- Chỉ cho phép chỉnh sửa họ tên và giới tính; không có trường sửa email hoặc số điện thoại.

**Luồng thay thế:**
- **5A:** Tại bước 5, người dùng chọn “Hủy” để đóng biểu mẫu và giữ nguyên thông tin cũ.

**Ngoại lệ:**
- **5E:** E1 (Họ tên bị bỏ trống hoặc quá ngắn): Hệ thống yêu cầu nhập lại họ tên.
- **6E:** E2 (Không lưu được thông tin): Hệ thống thông báo lỗi và giữ lại nội dung người dùng vừa nhập.

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

**Ràng buộc thông tin nhập:** Không có trường nhập liệu. Người cao tuổi gửi cảnh báo bằng nút SOS hoặc xác nhận/không phản hồi với thông báo hỏi khi ứng dụng phát hiện dấu hiệu té ngã. Vị trí là thông tin thiết bị tự lấy, không phải nội dung người dùng nhập.

**Luồng thay thế:**
- **3A:** Nếu người cao tuổi chọn “Tôi vẫn ổn” trong thời gian đếm ngược, ứng dụng đóng thông báo té ngã và không gửi cảnh báo.

**Ngoại lệ:**
- **5E:** E1 (Không lấy được vị trí): Hệ thống vẫn gửi cảnh báo và thông báo rằng chưa có thông tin vị trí.
- **6E:** E2 (Không có kết nối Internet): Hệ thống thông báo chưa gửi được cảnh báo và hiển thị lựa chọn gọi cấp cứu 115.
- **6E:** E3 (Không có người thân đã liên kết): Hệ thống vẫn ghi nhận cảnh báo nhưng không có người thân để nhận thông báo.

## 3.3.6. Usecase tiếp nhận và xử lý cảnh báo

**UsecaseID:** UC06

**Tên usecase:** Tiếp nhận và xử lý cảnh báo

**Tác nhân:** Con cái / Người thân đã liên kết với người cao tuổi.

**Tiền điều kiện:** Có cảnh báo SOS đang chờ xử lý từ người cao tuổi đã liên kết.

**Luồng sự kiện chính:**
1. Người thân nhận thông báo có cảnh báo SOS.
2. Người thân mở thông báo để xem cảnh báo.
3. Hệ thống hiển thị tên người cao tuổi, thời điểm gửi cảnh báo, nguyên nhân cảnh báo, số điện thoại và vị trí nếu có.
4. Người thân chọn “Tiếp nhận” để xác nhận mình sẽ xử lý cảnh báo.
5. Hệ thống ghi nhận người đầu tiên tiếp nhận và thông báo cho những người thân liên quan để tránh nhiều người cùng xử lý một cảnh báo.
6. Người thân thực hiện ngay hành động cần thiết: gọi cho người cao tuổi, gọi cấp cứu 115 hoặc mở bản đồ để đến vị trí được gửi kèm.
7. Sau khi đã liên hệ hoặc hỗ trợ người cao tuổi, người thân chọn “Kết thúc cảnh báo”.
8. Người thân chọn kết quả hỗ trợ và có thể nhập ghi chú ngắn.
9. Hệ thống lưu kết quả, kết thúc cảnh báo và thông báo cho những người thân liên quan.

**Ràng buộc thông tin nhập:**
- Kết quả hỗ trợ: bắt buộc chọn một trong ba lựa chọn: Đã an toàn, Đã đưa đến cơ sở y tế hoặc Báo động nhầm.
- Ghi chú: không bắt buộc, tối đa 300 ký tự; có thể để trống.

**Luồng thay thế:**
- **3A1:** Nếu cảnh báo không có vị trí, người thân vẫn có thể gọi cho người cao tuổi hoặc gọi cấp cứu 115.
- **6A1:** Nếu người thân không liên lạc được với người cao tuổi, người thân có thể gọi cấp cứu 115 hoặc nhờ người ở gần hỗ trợ.
- **6A2:** Người thân có thể mở bản đồ để tìm đường đến vị trí người cao tuổi mà không cần cập nhật tiến trình di chuyển trên ứng dụng.
- **8A1:** Nếu chưa thể xác định đầy đủ kết quả hỗ trợ, người thân nhập ghi chú ngắn về tình hình đã biết trước khi kết thúc cảnh báo.

**Ngoại lệ:**
- **4E1:** Cảnh báo đã được người thân khác tiếp nhận; hệ thống hiển thị người đang xử lý và thông tin cảnh báo mới nhất.
- **2E1:** Cảnh báo đã được kết thúc hoặc hủy; hệ thống chỉ hiển thị thông tin mới nhất và không cho xử lý tiếp.
- **2E2:** Người dùng không có quyền xem cảnh báo; hệ thống từ chối truy cập.
- **9E1:** Không lưu được kết quả hỗ trợ; hệ thống thông báo lỗi và giữ cảnh báo ở trạng thái đang chờ kết thúc để người thân thử lại.

**Ghi chú:** Không yêu cầu người thân cập nhật các trạng thái như “đang trên đường” hoặc “đã đến nơi”. Khi đã tiếp nhận, người thân có thể gọi điện, gọi cấp cứu hoặc mở bản đồ ngay; chỉ cần cập nhật kết quả sau khi đã hỗ trợ.
## 3.3.7. Usecase ghi chỉ số và theo dõi cảnh báo huyết áp

**UsecaseID:** UC07

**Tên usecase:** Ghi chỉ số và theo dõi cảnh báo huyết áp

**Tác nhân:** Người cao tuổi.

**Tiền điều kiện:** Người cao tuổi đã đăng nhập vào ứng dụng.

**Luồng sự kiện chính:**
1. Người cao tuổi mở mục “Nhật ký sức khỏe”.
2. Người dùng chọn “Ghi chỉ số”.
3. Hệ thống hiển thị màn hình nhập kết quả đo.
4. Người dùng nhập chỉ số huyết áp trên và huyết áp dưới.
5. Người dùng chọn “Lưu kết quả đo”.
6. Hệ thống kiểm tra hai chỉ số, trong đó chỉ số trên phải lớn hơn chỉ số dưới.
7. Hệ thống lưu kết quả đo, đánh giá mức độ và hiển thị hướng dẫn phù hợp.
8. Người dùng có thể xem lại các lần đo đã lưu trong lịch sử.

**Ràng buộc thông tin nhập:**
- Huyết áp trên: số nguyên từ 70 đến 250.
- Huyết áp dưới: số nguyên từ 40 đến 150.
- Huyết áp trên phải lớn hơn huyết áp dưới.
- Hai giá trị được chọn bằng nút tăng/giảm, không nhập chữ.

**Luồng thay thế:**
- **7A1:** Nếu chỉ số ở mức bình thường hoặc tốt, hệ thống hiển thị lời khuyên tiếp tục theo dõi định kỳ.
- **7A2:** Nếu chỉ số ở mức cần chú ý, hệ thống hiển thị hướng dẫn nghỉ ngơi và đo lại.
- **7A3:** Nếu chỉ số ở mức rất cao, hệ thống hiển thị hướng dẫn khẩn cấp.

**Ngoại lệ:**
- **4E1:** Người dùng chưa nhập đủ hai chỉ số; hệ thống yêu cầu nhập bổ sung.
- **4E2:** Chỉ số nằm ngoài khoảng cho phép hoặc chỉ số trên không lớn hơn chỉ số dưới; hệ thống yêu cầu kiểm tra và nhập lại.
- **6E1:** Không thể lưu kết quả; hệ thống thông báo lỗi và cho phép thử lại.

**Ghi chú:** Phần cảnh báo huyết áp được gộp vào chức năng ghi chỉ số vì đây là kết quả xử lý ngay sau khi người dùng nhập số đo, không phải mục đích sử dụng độc lập.

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

**Ràng buộc thông tin nhập:** Không có trường nhập liệu. Hệ thống tự hiển thị tối đa 7 lần đo gần nhất; người dùng chỉ chọn một lần đo để xem chi tiết.

**Luồng thay thế:** Không có.

**Ngoại lệ:**
- **2E:** E1 (Chưa có dữ liệu): Hệ thống hiển thị thông báo chưa có kết quả đo và hướng dẫn người dùng ghi chỉ số lần đầu.
- **2E:** E2 (Không tải được dữ liệu): Hệ thống thông báo lỗi và cho phép tải lại.

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

**Ràng buộc thông tin nhập:**
- Tên thuốc: bắt buộc; chưa quy định giới hạn độ dài trong màn hình hiện tại.
- Liều lượng: bắt buộc chọn số nguyên từ 1 đến 20 viên.
- Hướng dẫn uống: không bắt buộc; mặc định là “Uống sau ăn”; chưa quy định giới hạn độ dài.
- Ngày bắt đầu: bắt buộc chọn từ ngày hiện tại đến tối đa 10 năm sau.
- Giờ uống: bắt buộc chọn một giờ trong ngày; mỗi lịch thuốc hiện chỉ lưu một khung giờ.
- Màn hình hiện tại không có trường nhập ngày kết thúc.

**Luồng thay thế:**
- **2A:** Người dùng có thể mở một lịch thuốc đã có để thay đổi thông tin hoặc chọn “Dừng thuốc” khi không còn sử dụng lịch đó.

**Ngoại lệ:**
- **3E:** E1 (Thiếu tên thuốc hoặc giờ uống): Hệ thống yêu cầu bổ sung thông tin còn thiếu.
- **4E:** E2 (Ngày kết thúc trước ngày bắt đầu): Hệ thống yêu cầu chọn lại ngày.
- **7E:** E3 (Không lưu được lịch): Hệ thống thông báo lỗi và giữ lại thông tin đã nhập.

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

**Ràng buộc thông tin nhập:** Không có trường nhập liệu. Thời điểm nhắc được lấy từ lịch uống thuốc đã tạo; người thân chỉ xem thông tin lịch.

**Luồng thay thế:**
- **2A:** Người dùng có thể mở thông báo để chuyển thẳng đến phần lịch uống thuốc.

**Ngoại lệ:**
- **2E:** E1 (Chưa cho phép thông báo): Ứng dụng hiển thị hướng dẫn bật quyền thông báo trên thiết bị.
- **1E:** E2 (Lịch thuốc đã dừng hoặc chưa đến ngày bắt đầu): Ứng dụng không tạo lời nhắc cho lịch đó.
- **2E:** E3 (Thiết bị không hỗ trợ lời nhắc): Người dùng vẫn có thể xem lịch uống thuốc trong ứng dụng.

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

**Ràng buộc thông tin nhập:** Không có trường nhập liệu. Người dùng chỉ chọn “Đã uống” tại lần uống tương ứng; hệ thống tự ghi thời điểm xác nhận.

**Luồng thay thế:**
- **3A:** Người dùng có thể xem lại các lần uống đã hoàn thành hoặc bị bỏ lỡ trong phần lịch sử.

**Ngoại lệ:**
- **3E:** E1 (Lần uống đã được ghi nhận): Hệ thống không tạo thêm bản ghi trùng cho cùng một lần uống.
- **4E:** E2 (Không lưu được): Hệ thống thông báo lỗi và cho phép người dùng thử lại.

## 3.3.13. Usecase liên kết và quản lý người thân

**UsecaseID:** UC13

**Tên usecase:** Liên kết và quản lý người thân

**Tác nhân:** Con cái / Người thân, Người cao tuổi.

**Tiền điều kiện:** Hai người đã có tài khoản trong hệ thống.

**Luồng sự kiện chính:**
1. Người thân mở mục “Người thân của tôi”.
2. Người thân nhập số điện thoại của người cao tuổi và chọn gửi yêu cầu.
3. Hệ thống kiểm tra tài khoản theo số điện thoại đã nhập.
4. Hệ thống gửi yêu cầu đến tài khoản người cao tuổi.
5. Người cao tuổi mở mục “Liên hệ khẩn cấp” để xem yêu cầu đang chờ.
6. Người cao tuổi chọn “Chấp nhận” hoặc “Từ chối”.
7. Nếu người cao tuổi chấp nhận, hệ thống ghi nhận hai tài khoản đã liên kết.
8. Hệ thống hiển thị danh sách người thân đã liên kết cho người cao tuổi và danh sách người cao tuổi đã liên kết cho người thân.
9. Người dùng chọn một người trong danh sách để xem thông tin liên hệ được hiển thị.

**Ràng buộc thông tin nhập:**
- Số điện thoại người cao tuổi: bắt buộc, đúng 10 chữ số và bắt đầu bằng số 0.
- Có thể nhập khoảng trắng để dễ đọc; hệ thống bỏ khoảng trắng trước khi kiểm tra.
- Không tìm người dùng bằng họ tên hoặc email trong màn hình này.

**Luồng thay thế:**
- **6A1:** Người cao tuổi chọn “Từ chối”; hệ thống không tạo liên kết.
- **4A1:** Khi yêu cầu còn đang chờ phản hồi, người gửi có thể hủy yêu cầu.
- **8A1:** Nếu chưa có người thân liên kết, hệ thống hiển thị hướng dẫn gửi hoặc xác nhận yêu cầu.

**Ngoại lệ:**
- **3E1:** Không tìm thấy số điện thoại; hệ thống thông báo chưa có tài khoản phù hợp.
- **3E2:** Tài khoản được chọn không phải tài khoản người cao tuổi; hệ thống không cho gửi yêu cầu.
- **3E3:** Hai tài khoản đã liên kết hoặc đang có yêu cầu chờ; hệ thống không tạo yêu cầu trùng.
- **6E1:** Yêu cầu không còn hiệu lực; hệ thống thông báo và tải lại danh sách yêu cầu.
- **8E1:** Không tải được danh sách người thân; hệ thống thông báo lỗi và cho phép tải lại.

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

**Ràng buộc thông tin nhập:** Không có trường nhập liệu. Người dùng chọn nút gọi 115 và xác nhận trước khi thiết bị mở chức năng gọi điện.

**Luồng thay thế:**
- **5A:** Người dùng chọn “Hủy” để đóng thông báo và không thực hiện cuộc gọi.

**Ngoại lệ:**
- **5E:** E1 (Thiết bị không thể gọi điện): Hệ thống thông báo không thể thực hiện cuộc gọi trên thiết bị hiện tại.

**Ghi chú:** Mã nguồn hiện có nút gọi cấp cứu 115 và hiển thị người thân đã liên kết. Chưa thấy chức năng thêm, sửa, xóa danh bạ khẩn cấp riêng; vì vậy đặc tả không mô tả các thao tác này.

## 3.3.14. Usecase quản lý lịch khám gia đình

**UsecaseID:** UC14

**Tên usecase:** Quản lý lịch khám gia đình

**Tác nhân:** Con cái / Người thân đã liên kết với người cao tuổi.

**Tiền điều kiện:** Người thân đã liên kết với tài khoản người cao tuổi.

**Luồng sự kiện chính:**
1. Người thân mở mục “Lịch khám”.
2. Người thân chọn “Thêm lịch”.
3. Người thân nhập nội dung khám, tên bệnh viện hoặc cơ sở y tế, khoa khám, ngày giờ và ghi chú cần thiết.
4. Người thân có thể chọn người dự kiến đưa người cao tuổi đi khám.
5. Người thân chọn “Lưu”.
6. Hệ thống kiểm tra thông tin và tạo lịch khám.
7. Lịch khám được hiển thị trong danh sách để các thành viên liên quan theo dõi.
8. Với lịch chưa có người phụ trách, một thành viên chọn “Tôi sẽ đưa đi”.
9. Hệ thống kiểm tra lịch vẫn chưa có người nhận và ghi nhận người vừa chọn là người phụ trách.
10. Nếu người phụ trách không thể tiếp tục, họ chọn “Nhờ người khác”; hệ thống bỏ tên người phụ trách và đưa lịch về tình trạng chưa có người nhận.
11. Người phụ trách mở lịch khám và chọn “Hoàn thành” sau khi đã đến hoặc qua thời gian hẹn.
12. Hệ thống kiểm tra người thao tác có phải người phụ trách và cập nhật lịch thành đã hoàn thành.
13. Ứng dụng mở phần thêm hồ sơ khám và điền sẵn tên cơ sở y tế cùng ngày khám nếu có thông tin.

**Ràng buộc thông tin nhập:**
- Nội dung khám: bắt buộc, không được để trống; chưa quy định độ dài tối đa.
- Bệnh viện/Cơ sở khám: bắt buộc, không được để trống; chưa quy định độ dài tối đa.
- Khoa khám: không bắt buộc; chưa quy định độ dài tối đa.
- Người đưa đi khám: phải chọn một người thân đã liên kết; màn hình hiện tại không cho lưu nếu chưa chọn.
- Thời gian khám: bắt buộc chọn thời điểm sau thời điểm hiện tại; ngày được chọn trong phạm vi tối đa 10 năm kể từ hiện tại.
- Ghi chú chuẩn bị: không bắt buộc, hiển thị tối đa 3 dòng; chưa đặt giới hạn số ký tự.

**Luồng thay thế:**
- **4A1:** Nếu chưa xác định người đưa đi khám, lịch được lưu ở tình trạng chưa có người phụ trách.
- **10A1:** Sau khi lịch được trả lại, một thành viên khác có thể nhận lịch.
- **13A1:** Người dùng có thể bỏ qua việc thêm hồ sơ khám và thực hiện sau.

**Ngoại lệ:**
- **3E1:** Thiếu nội dung khám hoặc thời gian khám; hệ thống yêu cầu bổ sung.
- **4E1:** Thời gian khám đã qua; hệ thống yêu cầu chọn thời gian trong tương lai.
- **4E2:** Người được chọn không thuộc nhóm người thân đã liên kết; hệ thống không chấp nhận người phụ trách đó.
- **8E1:** Lịch đã có người nhận; hệ thống thông báo lịch đã được thành viên khác đảm nhận.
- **10E1:** Người dùng không phải người đang phụ trách; hệ thống không cho phép trả lại lịch.
- **11E1:** Chưa đến thời gian hẹn; hệ thống chưa cho phép hoàn thành lịch.
- **12E1:** Lịch đã được hoàn thành hoặc không còn tồn tại; hệ thống tải lại thông tin mới nhất.
- **6E1:** Không lưu được lịch; hệ thống thông báo lỗi và giữ lại thông tin đã nhập.

**Ghi chú:** Việc nhận lịch chỉ thể hiện thành viên trong gia đình nhận trách nhiệm đưa người cao tuổi đi khám, không có nghĩa là hệ thống đã đặt lịch với bệnh viện.

## 3.3.15. Usecase quản lý hồ sơ khám và tài liệu

**UsecaseID:** UC15

**Tên usecase:** Quản lý hồ sơ khám và tài liệu

**Tác nhân:** Người cao tuổi, Con cái / Người thân đã liên kết.

**Tiền điều kiện:** Người dùng đã đăng nhập và có quyền xem hoặc thêm hồ sơ cho tài khoản người cao tuổi được chọn.

**Luồng sự kiện chính:**
1. Người dùng mở mục “Hồ sơ khám”.
2. Hệ thống hiển thị các lần khám đã lưu, sắp xếp từ gần nhất đến cũ nhất.
3. Người dùng chọn “Thêm hồ sơ”.
4. Người dùng nhập ngày khám, tên bệnh viện, khoa khám, tên bác sĩ, chẩn đoán, kết luận và ghi chú nếu có.
5. Người dùng có thể nhập ngày tái khám.
6. Người dùng chọn “Lưu”.
7. Hệ thống kiểm tra thông tin và lưu hồ sơ khám.
8. Người dùng mở một hồ sơ khám và chọn chức năng thêm tài liệu.
9. Người dùng chọn hình ảnh hoặc tệp PDF từ thiết bị.
10. Hệ thống kiểm tra loại tệp và dung lượng, sau đó lưu tài liệu vào hồ sơ khám đã chọn.
11. Người dùng chọn một hồ sơ trong danh sách để xem thông tin chi tiết và các tài liệu đính kèm.

**Ràng buộc thông tin nhập:**
- Ngày khám: bắt buộc chọn từ ngày 01/01/2000 đến ngày hiện tại.
- Bệnh viện: bắt buộc, không được để trống.
- Chẩn đoán: bắt buộc, không được để trống.
- Kết luận/Ghi chú: không bắt buộc, hiển thị tối đa 3 dòng; chưa đặt giới hạn số ký tự.
- Khoa khám và tên bác sĩ: hiện không có ô nhập trong biểu mẫu đang triển khai.
- Tài liệu đính kèm: chỉ nhận ảnh hoặc PDF; dung lượng tệp phải nhỏ hơn 15 MB. Tên tệp không được để trống.
- Ngày tái khám: hiện chưa có ô nhập trong biểu mẫu đang triển khai.

**Luồng thay thế:**
- **3A1:** Người dùng có thể mở chức năng thêm hồ sơ từ màn hình hoàn tất lịch khám; tên cơ sở y tế và ngày khám được điền sẵn nếu có.
- **9A1:** Người dùng có thể chọn mở tài liệu PDF bằng chức năng xem tài liệu trên thiết bị.

**Ngoại lệ:**
- **4E1:** Thiếu ngày khám, cơ sở y tế hoặc chẩn đoán; hệ thống yêu cầu bổ sung.
- **4E2:** Ngày khám ở tương lai; hệ thống yêu cầu kiểm tra lại ngày khám.
- **7E1:** Không có quyền thêm hồ sơ cho tài khoản đã chọn; hệ thống từ chối thao tác.
- **7E2:** Không lưu được hồ sơ; hệ thống thông báo lỗi và giữ lại nội dung đã nhập.
- **9E1:** Loại tệp không được hỗ trợ; hệ thống chỉ chấp nhận hình ảnh hoặc PDF.
- **9E2:** Tệp lớn hơn 15 MB; hệ thống thông báo tệp vượt quá dung lượng cho phép.
- **10E1:** Không có quyền truy cập hoặc không tải được tệp; hệ thống thông báo lỗi.
- **2E1:** Chưa có hồ sơ khám; hệ thống hiển thị hướng dẫn thêm hồ sơ mới.
- **11E1:** Tài liệu không còn hoặc không mở được; hệ thống thông báo tài liệu hiện không thể xem.

**Ghi chú:** Tạo hồ sơ, xem lịch sử khám và thêm tài liệu được gộp vì đều là các bước quản lý cùng một hồ sơ khám.

## 3.3.16. Usecase ghi âm lời nhắc

**UsecaseID:** UC16

**Tên usecase:** Ghi âm lời nhắc

**Tác nhân:** Người dùng đã đăng nhập.

**Tiền điều kiện:** Người dùng đã đăng nhập; thiết bị có chức năng ghi âm.

**Luồng sự kiện chính:**
1. Người dùng mở mục “Cài đặt”.
2. Người dùng chọn chức năng ghi âm lời nhắc.
3. Hệ thống hiển thị màn hình ghi âm.
4. Người dùng nhập tên cho lời nhắc nếu muốn.
5. Người dùng chọn bắt đầu ghi âm.
6. Hệ thống kiểm tra quyền sử dụng micro và bắt đầu ghi âm.
7. Người dùng chọn dừng ghi âm hoặc hệ thống tự dừng khi đạt giới hạn thời gian.
8. Người dùng nghe lại bản ghi để kiểm tra.
9. Người dùng chọn lưu bản ghi.
10. Hệ thống lưu bản ghi vào tài khoản; trên thiết bị Android, người dùng có thể chọn dùng bản ghi làm âm thanh nhắc uống thuốc.

**Ràng buộc thông tin nhập:**
- Tên lời nhắc: không bắt buộc; nếu để trống hệ thống tự dùng tên mặc định; chưa quy định độ dài tối đa.
- Thời lượng ghi âm: phải lớn hơn 0 và tối đa 29 giây.
- Chỉ lưu được khi đã có bản ghi âm hợp lệ.

**Luồng thay thế:**
- **8A1:** Người dùng nghe lại bản ghi và có thể ghi âm lại nếu chưa hài lòng.
- **10A1:** Người dùng không chọn dùng bản ghi làm âm thanh nhắc thuốc; hệ thống chỉ lưu bản ghi vào tài khoản.

**Ngoại lệ:**
- **6E1:** Người dùng chưa cấp quyền sử dụng micro; hệ thống thông báo cần cấp quyền trước khi ghi âm.
- **6E2:** Không thể bắt đầu ghi âm; hệ thống thông báo lỗi.
- **9E1:** Không có bản ghi hợp lệ hoặc thời lượng bằng 0; hệ thống yêu cầu ghi âm lại.
- **10E1:** Không lưu được bản ghi; hệ thống thông báo lỗi.
- **10E2:** Không đặt được bản ghi làm âm thanh nhắc thuốc; nếu bản ghi đã được lưu, hệ thống thông báo riêng rằng phần đặt âm thanh chưa thành công.

## 3.3.17. Usecase xem vị trí người cao tuổi

**UsecaseID:** UC17

**Tên usecase:** Xem vị trí người cao tuổi

**Tác nhân:** Con cái / Người thân đã liên kết; Người cao tuổi; Hệ thống.

**Tiền điều kiện:** Người thân đã liên kết với tài khoản người cao tuổi; thiết bị người cao tuổi có kết nối và cho phép lấy vị trí.

**Luồng sự kiện chính:**
1. Người cao tuổi đăng nhập và mở ứng dụng.
2. Ứng dụng lấy vị trí hiện tại của thiết bị theo chu kỳ khoảng 5 phút.
3. Hệ thống lưu vị trí và thời điểm cập nhật.
4. Người thân mở màn hình chính của tài khoản gia đình đã liên kết.
5. Hệ thống hiển thị vị trí gần nhất của người cao tuổi nếu có dữ liệu.
6. Người thân xem thời điểm cập nhật để biết vị trí đang hiển thị có mới hay không.

**Ràng buộc thông tin nhập:** Không có trường nhập liệu. Vị trí và thời điểm cập nhật do thiết bị tự gửi; người thân chỉ xem thông tin được hiển thị.

**Luồng thay thế:**
- **5A1:** Nếu chưa có vị trí được lưu, hệ thống hiển thị thông báo chưa có thông tin vị trí.

**Ngoại lệ:**
- **2E1:** Người dùng chưa cho phép truy cập vị trí; ứng dụng không thể lấy vị trí.
- **2E2:** Thiết bị mất kết nối hoặc không lấy được vị trí; hệ thống không cập nhật vị trí mới.
- **5E1:** Chưa có dữ liệu vị trí; hệ thống thông báo không thể hiển thị vị trí hiện tại.


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
