# Đặc tả chi tiết các Use Case

Mỗi Use Case có một bảng duy nhất. Các nhánh ngoại lệ được đánh dấu theo bước phát sinh, ví dụ 2.a, 2.b, kèm điều kiện và cách xử lý.


### UC01 – Kích hoạt SOS

| Thành phần | Nội dung |
|---|---|
| Mục tiêu | Gửi cảnh báo khẩn cấp để người thân biết người cao tuổi cần hỗ trợ. |
| Tác nhân | Người cao tuổi |
| Tiền điều kiện | Đã đăng nhập |
| Sự kiện kích hoạt | Người cao tuổi nhấn SOS hoặc xác nhận SOS sau khi ứng dụng phát hiện rung lắc/té ngã. |
| Luồng sự kiện chính | 1. Nhấn SOS hoặc kích hoạt thao tác SOS.<br>2. Xác nhận gửi nếu ứng dụng yêu cầu.<br>3. Hệ thống tạo cảnh báo, lấy GPS nếu khả dụng, lưu dữ liệu và gửi thông báo đến các tài khoản liên kết. |
| Hậu điều kiện | SOS được lưu ở trạng thái đang hoạt động và các tài khoản liên kết được thông báo; vị trí được gắn kèm nếu lấy được. |
| Ngoại lệ / luồng thay thế | 2.a Người dùng không xác nhận → hủy thao tác, kết thúc luồng và không tạo SOS.<br>3.a Không có quyền GPS/không lấy được tọa độ → tiếp tục gửi SOS nhưng không đính kèm vị trí. |


### UC02 – Nhận và xử lý cảnh báo SOS

| Thành phần | Nội dung |
|---|---|
| Mục tiêu | Giúp người thân nhận biết, tiếp nhận và xem thông tin của cảnh báo SOS. |
| Tác nhân | Con cái / người chăm sóc |
| Tiền điều kiện | Có SOS đang hoạt động từ người cao tuổi đã liên kết |
| Sự kiện kích hoạt | Người thân nhận thông báo hoặc mở một cảnh báo SOS đang hoạt động. |
| Luồng sự kiện chính | 1. Nhận thông báo và mở cảnh báo.<br>2. Xem người gửi, thời điểm, vị trí và trạng thái.<br>3. Chọn tiếp nhận; hệ thống ghi nhận người xử lý và cập nhật trạng thái.<br>4. Liên hệ người cao tuổi hoặc mở bản đồ. |
| Hậu điều kiện | Cảnh báo được hiển thị cho người thân; nếu tiếp nhận thành công thì người xử lý và trạng thái tiếp nhận được lưu. |
| Ngoại lệ / luồng thay thế | 1.a Không tải được thông báo/cảnh báo → báo lỗi, cho phép mở lại.<br>3.a SOS đã kết thúc hoặc người khác đã tiếp nhận → tải trạng thái mới nhất, không tiếp nhận trùng. |


### UC03 – Cập nhật trạng thái ứng cứu

| Thành phần | Nội dung |
|---|---|
| Mục tiêu | Theo dõi tiến độ người thân đang ứng cứu. |
| Tác nhân | Người đang xử lý SOS |
| Tiền điều kiện | SOS đang hoạt động và đã tiếp nhận |
| Sự kiện kích hoạt | Người đang xử lý SOS chọn cập nhật tiến độ ứng cứu. |
| Luồng sự kiện chính | 1. Chọn “Đang đến”.<br>2. Khi đến nơi, chọn “Đã đến”.<br>3. Hệ thống lưu và đồng bộ trạng thái. |
| Hậu điều kiện | Trạng thái ứng cứu mới được lưu và hiển thị cho các bên liên quan. |
| Ngoại lệ / luồng thay thế | 1.a SOS đã bị hủy/kết thúc trước khi cập nhật → hiển thị trạng thái hiện tại và kết thúc luồng.<br>2.a Không lưu được trạng thái mới → báo lỗi, giữ trạng thái cũ và cho phép thử lại. |


### UC04 – Hủy / kết thúc SOS

| Thành phần | Nội dung |
|---|---|
| Mục tiêu | Đóng cảnh báo khi đã xử lý hoặc khi người cao tuổi hủy yêu cầu. |
| Tác nhân | Người cao tuổi hoặc người xử lý SOS |
| Tiền điều kiện | Có SOS chưa kết thúc |
| Sự kiện kích hoạt | Người cao tuổi hoặc người xử lý chọn hủy/kết thúc cảnh báo. |
| Luồng sự kiện chính | 1. Chọn hủy hoặc kết thúc xử lý.<br>2. Xác nhận thao tác.<br>3. Hệ thống lưu trạng thái, thời điểm, người thực hiện và đồng bộ cho các bên. |
| Hậu điều kiện | Cảnh báo được lưu ở trạng thái đã hủy hoặc đã xử lý; nếu thao tác bị hủy thì trạng thái không đổi. |
| Ngoại lệ / luồng thay thế | 1.a SOS đã kết thúc → thông báo trạng thái hiện tại, không thực hiện cập nhật.<br>2.a Người dùng không xác nhận → giữ nguyên SOS và kết thúc thao tác. |


### UC05 – Chia sẻ vị trí GPS

| Thành phần | Nội dung |
|---|---|
| Mục tiêu | Cập nhật vị trí của người cao tuổi để phục vụ theo dõi và ứng cứu. |
| Tác nhân | Người cao tuổi |
| Tiền điều kiện | Đã đăng nhập; quyền và dịch vụ vị trí khả dụng |
| Sự kiện kích hoạt | Ứng dụng cần lấy/cập nhật vị trí trong phiên sử dụng hoặc khi có yêu cầu an toàn. |
| Luồng sự kiện chính | 1. Cấp quyền truy cập vị trí.<br>2. Ứng dụng lấy tọa độ và độ chính xác.<br>3. Cập nhật vị trí định kỳ/khi cần và chia sẻ với tài khoản liên kết được phép. |
| Hậu điều kiện | Vị trí và thời điểm cập nhật gần nhất được lưu/chia sẻ khi thiết bị có quyền và GPS khả dụng. |
| Ngoại lệ / luồng thay thế | 1.a Người dùng từ chối quyền vị trí → thông báo cần cấp quyền, không bật chia sẻ vị trí.<br>2.a GPS không khả dụng → giữ vị trí gần nhất nếu có và thông báo chưa cập nhật được. |


### UC06 – Xem vị trí người cao tuổi

| Thành phần | Nội dung |
|---|---|
| Mục tiêu | Cho phép người thân xem vị trí hiện tại hoặc gần nhất của người cao tuổi đã liên kết. |
| Tác nhân | Con cái / người chăm sóc đã liên kết |
| Tiền điều kiện | Có quyền xem vị trí |
| Sự kiện kích hoạt | Người thân mở thông tin vị trí của người cao tuổi đã liên kết. |
| Luồng sự kiện chính | 1. Mở thông tin người cao tuổi.<br>2. Hệ thống tải vị trí gần nhất và thời điểm cập nhật.<br>3. Chọn bản đồ để mở tọa độ. |
| Hậu điều kiện | Vị trí gần nhất được hiển thị; bản đồ ngoài ứng dụng được mở nếu người dùng yêu cầu và có tọa độ. |
| Ngoại lệ / luồng thay thế | 2.a Không có tọa độ → thông báo chưa có dữ liệu vị trí và kết thúc luồng xem bản đồ.<br>3.a Không mở được ứng dụng bản đồ → báo lỗi; vẫn hiển thị tọa độ/thời điểm trên ứng dụng nếu có. |


### UC07 – Ghi nhận huyết áp

| Thành phần | Nội dung |
|---|---|
| Mục tiêu | Lưu chỉ số huyết áp của người cao tuổi để theo dõi theo thời gian. |
| Tác nhân | Người cao tuổi |
| Tiền điều kiện | Đã đăng nhập |
| Sự kiện kích hoạt | Người cao tuổi mở chức năng sức khỏe và bắt đầu nhập huyết áp. |
| Luồng sự kiện chính | 1. Mở chức năng sức khỏe.<br>2. Nhập huyết áp tâm thu và tâm trương.<br>3. Chọn lưu.<br>4. Hệ thống kiểm tra dữ liệu, phân loại, lưu bản ghi và hiển thị hướng dẫn. |
| Hậu điều kiện | Bản ghi huyết áp hợp lệ được lưu kèm thời điểm, mức phân loại và hướng dẫn. |
| Ngoại lệ / luồng thay thế | 2.a Thiếu dữ liệu/sai định dạng → báo lỗi tại trường tương ứng, quay lại bước 2.<br>2.b Chỉ số ngoài khoảng cho phép → báo lỗi, yêu cầu nhập lại tại bước 2.<br>3.a Tâm thu nhỏ hơn hoặc bằng tâm trương → báo lỗi logic, quay lại bước 2.<br>4.a Lưu thất bại → báo lỗi, giữ dữ liệu và cho phép thử lại bước 3. |


### UC08 – Xem phân loại và hướng dẫn

| Thành phần | Nội dung |
|---|---|
| Mục tiêu | Giúp người dùng hiểu mức phân loại và hướng dẫn tương ứng của bản ghi huyết áp. |
| Tác nhân | Người cao tuổi / người thân đã liên kết |
| Tiền điều kiện | Có bản ghi huyết áp |
| Sự kiện kích hoạt | Người dùng mở một bản ghi huyết áp để xem kết quả phân loại. |
| Luồng sự kiện chính | 1. Mở bản ghi huyết áp.<br>2. Hệ thống tải chỉ số và mức phân loại.<br>3. Hiển thị phân loại cùng hướng dẫn tương ứng. |
| Hậu điều kiện | Người dùng xem được mức phân loại và hướng dẫn của bản ghi; dữ liệu không bị thay đổi. |
| Ngoại lệ / luồng thay thế | 1.a Không tìm thấy bản ghi huyết áp → thông báo chưa có dữ liệu và kết thúc luồng.<br>2.a Bản ghi thiếu chỉ số → thông báo dữ liệu không đầy đủ, không hiển thị phân loại. |


### UC09 – Xem lịch sử / biểu đồ huyết áp

| Thành phần | Nội dung |
|---|---|
| Mục tiêu | Theo dõi diễn biến huyết áp qua danh sách và biểu đồ lịch sử. |
| Tác nhân | Người cao tuổi / người thân đã liên kết |
| Tiền điều kiện | Có quyền xem dữ liệu sức khỏe |
| Sự kiện kích hoạt | Người dùng mở mục lịch sử hoặc biểu đồ huyết áp. |
| Luồng sự kiện chính | 1. Mở lịch sử sức khỏe.<br>2. Hệ thống tải các bản ghi theo thời gian.<br>3. Hiển thị danh sách và biểu đồ. |
| Hậu điều kiện | Danh sách/biểu đồ huyết áp được hiển thị từ các bản ghi đã lưu; dữ liệu không bị thay đổi. |
| Ngoại lệ / luồng thay thế | 2.a Không có bản ghi → hiển thị danh sách/biểu đồ trống và kết thúc luồng.<br>2.b Tải dữ liệu thất bại → báo lỗi và cho phép tải lại ở bước 1. |


### UC10 – Đánh dấu đã liên hệ

| Thành phần | Nội dung |
|---|---|
| Mục tiêu | Ghi nhận việc người thân đã liên hệ để theo dõi một bản ghi huyết áp. |
| Tác nhân | Con cái / người chăm sóc đã liên kết |
| Tiền điều kiện | Có bản ghi cần theo dõi |
| Sự kiện kích hoạt | Người thân mở bản ghi huyết áp cần theo dõi và chọn đánh dấu đã liên hệ. |
| Luồng sự kiện chính | 1. Mở bản ghi huyết áp.<br>2. Chọn “Đã liên hệ”.<br>3. Hệ thống lưu người thực hiện và cập nhật trạng thái theo dõi. |
| Hậu điều kiện | Bản ghi được đánh dấu đã liên hệ và lưu người thực hiện khi cập nhật thành công. |
| Ngoại lệ / luồng thay thế | 1.a Bản ghi không còn tồn tại/không có quyền xem → báo lỗi, tải lại danh sách và kết thúc luồng.<br>3.a Lưu trạng thái liên hệ thất bại → giữ trạng thái cũ, báo lỗi và cho phép thử lại bước 2. |


### UC11 – Tạo / quản lý lịch thuốc

| Thành phần | Nội dung |
|---|---|
| Mục tiêu | Lập và duy trì lịch dùng thuốc của người cao tuổi. |
| Tác nhân | Người cao tuổi / con cái / người chăm sóc có liên kết |
| Tiền điều kiện | Đã đăng nhập; chọn đúng người cao tuổi |
| Sự kiện kích hoạt | Người dùng có quyền chăm sóc chọn thêm hoặc quản lý một lịch thuốc. |
| Luồng sự kiện chính | 1. Mở chức năng thuốc và chọn thêm lịch.<br>2. Nhập tên thuốc, liều lượng, hướng dẫn, ngày và giờ uống.<br>3. Lưu lịch.<br>4. Hệ thống lưu lịch, cập nhật nhắc thuốc và danh sách.<br>5. Khi cần, sửa hoặc dừng/xóa lịch. |
| Hậu điều kiện | Lịch thuốc được tạo/cập nhật/dừng theo thao tác; nhắc thuốc tương ứng được cập nhật khi khả dụng. |
| Ngoại lệ / luồng thay thế | 2.a Thiếu thông tin/thời gian không hợp lệ → báo lỗi tại trường tương ứng, quay lại bước 2.<br>3.a Lưu lịch thất bại → báo lỗi, giữ biểu mẫu và cho phép thử lại bước 3.<br>4.a Tạo nhắc thuốc thất bại → thông báo lỗi cấu hình nhắc; giữ lịch thuốc đã lưu. |


### UC12 – Xem lịch thuốc theo ngày

| Thành phần | Nội dung |
|---|---|
| Mục tiêu | Tra cứu các thuốc và liều cần dùng theo ngày. |
| Tác nhân | Người cao tuổi / người thân đã liên kết |
| Tiền điều kiện | Có quyền xem lịch thuốc |
| Sự kiện kích hoạt | Người dùng mở lịch thuốc hoặc chọn ngày muốn tra cứu. |
| Luồng sự kiện chính | 1. Mở lịch thuốc.<br>2. Hệ thống tải các liều trong ngày.<br>3. Có thể chọn ngày khác để xem lịch tương ứng. |
| Hậu điều kiện | Lịch thuốc của ngày được chọn được hiển thị; dữ liệu không bị thay đổi. |
| Ngoại lệ / luồng thay thế | 2.a Ngày được chọn không có lịch → hiển thị trạng thái trống và kết thúc luồng.<br>2.b Tải lịch thất bại → báo lỗi và cho phép tải lại ở bước 1. |


### UC13 – Xác nhận đã uống thuốc

| Thành phần | Nội dung |
|---|---|
| Mục tiêu | Ghi nhận người cao tuổi đã dùng một liều thuốc. |
| Tác nhân | Người cao tuổi |
| Tiền điều kiện | Có liều thuốc trong lịch |
| Sự kiện kích hoạt | Người cao tuổi chọn một liều trong lịch thuốc để xác nhận. |
| Luồng sự kiện chính | 1. Mở liều thuốc cần xác nhận.<br>2. Chọn “Đã uống”.<br>3. Hệ thống lưu thời điểm, cập nhật trạng thái và lịch sử. |
| Hậu điều kiện | Liều thuốc được ghi nhận đã uống với thời điểm xác nhận và xuất hiện trong lịch sử. |
| Ngoại lệ / luồng thay thế | 1.a Liều không tồn tại/lịch đã dừng → thông báo không thể xác nhận và kết thúc luồng.<br>2.a Liều đã xác nhận → hiển thị trạng thái hiện tại, không tạo bản ghi trùng.<br>3.a Lưu xác nhận thất bại → báo lỗi và cho phép thử lại bước 2. |


### UC14 – Xem lịch sử / liều bỏ lỡ

| Thành phần | Nội dung |
|---|---|
| Mục tiêu | Theo dõi các liều thuốc đã dùng và bị bỏ lỡ. |
| Tác nhân | Người cao tuổi / người thân đã liên kết |
| Tiền điều kiện | Có quyền xem dữ liệu thuốc |
| Sự kiện kích hoạt | Người dùng mở lịch sử dùng thuốc của người cao tuổi. |
| Luồng sự kiện chính | 1. Mở lịch sử thuốc.<br>2. Hệ thống đồng bộ trạng thái liều và tải dữ liệu.<br>3. Hiển thị thuốc, thời điểm và trạng thái từng liều. |
| Hậu điều kiện | Lịch sử thuốc cùng trạng thái đã uống/bỏ lỡ được hiển thị; dữ liệu không bị thay đổi. |
| Ngoại lệ / luồng thay thế | 2.a Chưa có dữ liệu lịch sử → hiển thị trạng thái trống và kết thúc luồng.<br>2.b Đồng bộ/tải lịch sử thất bại → báo lỗi và cho phép tải lại ở bước 1. |


### UC15 – Nhận nhắc uống thuốc

| Thành phần | Nội dung |
|---|---|
| Mục tiêu | Nhắc người dùng về liều thuốc đến giờ theo lịch đang hoạt động. |
| Tác nhân | Người cao tuổi; người thân tùy cấu hình |
| Tiền điều kiện | Lịch đang hoạt động và nhắc thuốc được bật |
| Sự kiện kích hoạt | Đến giờ uống thuốc của một lịch đang hoạt động và nhắc thuốc được bật. |
| Luồng sự kiện chính | 1. Đến giờ uống theo lịch.<br>2. Hệ thống phát thông báo trên thiết bị.<br>3. Chạm thông báo để mở lịch thuốc.<br>4. Người dùng xác nhận đã uống nếu muốn. |
| Hậu điều kiện | Thông báo nhắc thuốc được phát trên thiết bị; trạng thái liều chỉ đổi nếu người dùng xác nhận. |
| Ngoại lệ / luồng thay thế | 1.a Nhắc thuốc bị tắt/lịch đã dừng → không phát thông báo, kết thúc luồng nhắc.<br>2.a Thiết bị không nhận thông báo → giữ lịch thuốc trong ứng dụng.<br>3.a Không mở được lịch từ thông báo → báo lỗi và cho phép mở lịch thủ công. |


### UC16 – Đăng ký tài khoản

| Thành phần | Nội dung |
|---|---|
| Mục tiêu | Tạo tài khoản mới sau khi xác minh email bằng OTP. |
| Tác nhân | Người dùng mới |
| Tiền điều kiện | Chưa có tài khoản sử dụng email/số điện thoại đó |
| Sự kiện kích hoạt | Người dùng mới chọn đăng ký tài khoản. |
| Luồng sự kiện chính | 1. Nhập email và số điện thoại.<br>2. Hệ thống kiểm tra dữ liệu và gửi OTP đến email.<br>3. Nhập OTP hợp lệ để xác minh email.<br>4. Nhập mật khẩu, họ tên, giới tính và vai trò.<br>5. Chọn hoàn tất đăng ký.<br>6. Hệ thống tạo tài khoản và hồ sơ người dùng, sau đó mở ứng dụng. |
| Hậu điều kiện | Tài khoản và hồ sơ người dùng được tạo sau khi OTP và dữ liệu đăng ký hợp lệ. |
| Ngoại lệ / luồng thay thế | 1.a Email/số điện thoại sai định dạng hoặc đã dùng → báo lỗi, quay lại bước 1.<br>2.a Không gửi được OTP → báo lỗi và cho phép gửi lại tại bước 2.<br>3.a OTP sai/hết hạn → báo lỗi, cho nhập lại tại bước 3 hoặc yêu cầu mã mới.<br>4.a Mật khẩu/thông tin hồ sơ không hợp lệ → báo lỗi và quay lại bước 4.<br>6.a Tạo tài khoản thất bại → báo lỗi, không mở ứng dụng và cho phép thử lại. |


### UC17 – Đăng nhập

| Thành phần | Nội dung |
|---|---|
| Mục tiêu | Xác thực người dùng và mở giao diện ứng dụng theo vai trò. |
| Tác nhân | Người dùng |
| Tiền điều kiện | Có tài khoản |
| Sự kiện kích hoạt | Người dùng mở ứng dụng và gửi thông tin đăng nhập. |
| Luồng sự kiện chính | 1. Nhập thông tin đăng nhập.<br>2. Chọn đăng nhập.<br>3. Hệ thống xác thực thông tin và tải hồ sơ/vai trò.<br>4. Hệ thống mở giao diện phù hợp với vai trò. |
| Hậu điều kiện | Phiên đăng nhập được tạo và màn hình phù hợp vai trò được mở. |
| Ngoại lệ / luồng thay thế | 1.a Thiếu thông tin đăng nhập → yêu cầu nhập đầy đủ tại bước 1.<br>3.a Sai thông tin/tài khoản chưa xác minh → báo lỗi, quay lại bước 1 để thử lại.<br>4.a Hồ sơ không tồn tại/vai trò không hỗ trợ → báo lỗi, không mở màn hình chính và kết thúc luồng. |


### UC17a – Đăng xuất

| Thành phần | Nội dung |
|---|---|
| Mục tiêu | Kết thúc phiên sử dụng an toàn và quay về màn hình đăng nhập. |
| Tác nhân | Người dùng đã đăng nhập |
| Tiền điều kiện | Có phiên đăng nhập đang hoạt động |
| Sự kiện kích hoạt | Người dùng chọn đăng xuất trong phần cài đặt. |
| Luồng sự kiện chính | 1. Mở cài đặt và chọn đăng xuất.<br>2. Xác nhận đăng xuất nếu ứng dụng yêu cầu.<br>3. Hệ thống kết thúc phiên và chuyển về màn hình đăng nhập. |
| Hậu điều kiện | Phiên đăng nhập bị kết thúc và người dùng trở về màn hình đăng nhập. |
| Ngoại lệ / luồng thay thế | 2.a Người dùng hủy xác nhận → giữ phiên đăng nhập và kết thúc thao tác.<br>3.a Kết thúc phiên thất bại → báo lỗi và cho phép thử lại bước 1. |


### UC18 – Cập nhật hồ sơ cá nhân

| Thành phần | Nội dung |
|---|---|
| Mục tiêu | Cập nhật thông tin cơ bản trên hồ sơ người dùng. |
| Tác nhân | Người dùng đã đăng nhập |
| Tiền điều kiện | Hồ sơ đã tồn tại |
| Sự kiện kích hoạt | Người dùng mở hồ sơ/cài đặt và chọn chỉnh sửa thông tin. |
| Luồng sự kiện chính | 1. Mở cài đặt hồ sơ.<br>2. Sửa họ tên hoặc giới tính.<br>3. Lưu.<br>4. Hệ thống kiểm tra và cập nhật hồ sơ cùng thông tin tên liên quan đến liên kết. |
| Hậu điều kiện | Hồ sơ và thông tin tên liên quan đến liên kết được cập nhật theo dữ liệu hợp lệ. |
| Ngoại lệ / luồng thay thế | 2.a Họ tên/giới tính không hợp lệ → báo lỗi, quay lại bước 2.<br>3.a Cập nhật hồ sơ thất bại → giữ thông tin cũ, báo lỗi và cho phép thử lại bước 3. |


### UC19 – Gửi yêu cầu liên kết

| Thành phần | Nội dung |
|---|---|
| Mục tiêu | Gửi đề nghị kết nối tài khoản với người cao tuổi. |
| Tác nhân | Con cái / người chăm sóc |
| Tiền điều kiện | Đã đăng nhập; biết số điện thoại người cao tuổi |
| Sự kiện kích hoạt | Con cái/người chăm sóc chọn liên kết người cao tuổi và nhập số điện thoại. |
| Luồng sự kiện chính | 1. Nhập số điện thoại.<br>2. Hệ thống kiểm tra định dạng, tài khoản và yêu cầu trùng.<br>3. Tạo yêu cầu chờ xác nhận.<br>4. Thông báo cho người cao tuổi và hiển thị yêu cầu đang chờ. |
| Hậu điều kiện | Yêu cầu liên kết ở trạng thái chờ được lưu và gửi thông báo cho người cao tuổi. |
| Ngoại lệ / luồng thay thế | 1.a Số điện thoại sai định dạng/không tồn tại/là số của người gửi → báo lỗi và kết thúc luồng.<br>2.a Đã có yêu cầu đang chờ/liên kết → báo trùng, không tạo mới.<br>3.a Lưu yêu cầu thất bại → báo lỗi và cho phép thử lại bước 2. |


### UC20 – Chấp nhận / từ chối / hủy liên kết

| Thành phần | Nội dung |
|---|---|
| Mục tiêu | Cho phép người cao tuổi quyết định yêu cầu liên kết hoặc người gửi hủy yêu cầu đang chờ. |
| Tác nhân | Người cao tuổi; người gửi yêu cầu |
| Tiền điều kiện | Có yêu cầu đang chờ |
| Sự kiện kích hoạt | Có yêu cầu liên kết đang chờ cần được xử lý hoặc người gửi muốn hủy yêu cầu. |
| Luồng sự kiện chính | 1. Mở yêu cầu và xem thông tin người gửi.<br>2. Người cao tuổi chọn chấp nhận hoặc từ chối; người gửi có thể hủy yêu cầu đang chờ.<br>3. Hệ thống cập nhật trạng thái; nếu chấp nhận thì tạo liên kết.<br>4. Đồng bộ danh sách và thông báo kết quả. |
| Hậu điều kiện | Yêu cầu được chấp nhận/từ chối/hủy; nếu chấp nhận, liên kết chăm sóc được tạo/cập nhật. |
| Ngoại lệ / luồng thay thế | 1.a Yêu cầu không tồn tại/đã xử lý → tải lại danh sách, thông báo và kết thúc luồng.<br>2.a Thao tác không phù hợp trạng thái → từ chối cập nhật và hiển thị trạng thái hiện tại.<br>3.a Cập nhật thất bại → giữ trạng thái cũ, báo lỗi và cho phép thử lại. |


### UC21 – Xem danh sách liên kết

| Thành phần | Nội dung |
|---|---|
| Mục tiêu | Tra cứu các tài khoản đã liên kết và chọn hồ sơ người cao tuổi cần chăm sóc. |
| Tác nhân | Người dùng đã đăng nhập |
| Tiền điều kiện | Đã đăng nhập |
| Sự kiện kích hoạt | Người dùng mở mục liên kết tài khoản. |
| Luồng sự kiện chính | 1. Mở mục liên kết.<br>2. Hệ thống tải liên kết đã chấp nhận và yêu cầu đang chờ theo tài khoản.<br>3. Chọn người cao tuổi để xem dữ liệu chăm sóc. |
| Hậu điều kiện | Danh sách liên kết/yêu cầu phù hợp với tài khoản được hiển thị và hồ sơ được chọn nếu có. |
| Ngoại lệ / luồng thay thế | 2.a Chưa có liên kết → hiển thị hướng dẫn gửi/chờ yêu cầu và kết thúc luồng.<br>2.b Tải danh sách thất bại → báo lỗi và cho phép tải lại bước 1.<br>3.a Liên kết hết hiệu lực → thông báo và tải lại danh sách. |


### UC22 – Tạo lịch hẹn khám

| Thành phần | Nội dung |
|---|---|
| Mục tiêu | Lập lịch khám cho người cao tuổi đã liên kết. |
| Tác nhân | Con cái / người chăm sóc đã liên kết |
| Tiền điều kiện | Đã chọn người cao tuổi |
| Sự kiện kích hoạt | Con cái/người chăm sóc chọn tạo lịch khám cho một người cao tuổi đã liên kết. |
| Luồng sự kiện chính | 1. Chọn tạo lịch hẹn.<br>2. Nhập cơ sở y tế, khoa/phòng, thời gian và ghi chú.<br>3. Lưu lịch.<br>4. Hệ thống lưu lịch cho người cao tuổi và cập nhật danh sách. |
| Hậu điều kiện | Lịch hẹn được lưu cho đúng người cao tuổi và xuất hiện trong danh sách lịch. |
| Ngoại lệ / luồng thay thế | 2.a Thiếu thông tin/thời gian không hợp lệ → báo lỗi tại trường tương ứng, quay lại bước 2.<br>3.a Lưu lịch hẹn thất bại → báo lỗi và cho phép thử lại bước 3. |


### UC23 – Xem danh sách lịch hẹn

| Thành phần | Nội dung |
|---|---|
| Mục tiêu | Tra cứu các lịch khám của người cao tuổi. |
| Tác nhân | Người cao tuổi / người thân đã liên kết |
| Tiền điều kiện | Có quyền xem lịch |
| Sự kiện kích hoạt | Người dùng mở mục lịch khám của người cao tuổi. |
| Luồng sự kiện chính | 1. Mở mục lịch hẹn.<br>2. Hệ thống tải lịch của người cao tuổi được chọn.<br>3. Hiển thị thời gian, địa điểm, ghi chú và người hỗ trợ nếu có. |
| Hậu điều kiện | Danh sách lịch hẹn và trạng thái được hiển thị; dữ liệu không bị thay đổi. |
| Ngoại lệ / luồng thay thế | 2.a Chưa có lịch hẹn → hiển thị trạng thái trống và kết thúc luồng.<br>2.b Tải danh sách thất bại → báo lỗi và cho phép tải lại bước 1. |


### UC24 – Nhận / bàn giao lịch hẹn

| Thành phần | Nội dung |
|---|---|
| Mục tiêu | Phân công, nhận hoặc bàn giao người hỗ trợ cho lịch khám. |
| Tác nhân | Con cái / người chăm sóc đã liên kết |
| Tiền điều kiện | Lịch hẹn có thể nhận hoặc đang do người dùng phụ trách |
| Sự kiện kích hoạt | Người thân mở lịch khám để nhận hoặc bàn giao việc hỗ trợ. |
| Luồng sự kiện chính | 1. Mở lịch hẹn.<br>2. Chọn nhận hỗ trợ hoặc bàn giao/giải phóng lịch.<br>3. Hệ thống cập nhật người phụ trách và trạng thái. |
| Hậu điều kiện | Người hỗ trợ của lịch hẹn được cập nhật theo thao tác nhận/bàn giao. |
| Ngoại lệ / luồng thay thế | 1.a Lịch không tồn tại/không ở trạng thái có thể nhận-bàn giao → thông báo và kết thúc luồng.<br>2.a Người khác vừa nhận lịch → từ chối thao tác và tải trạng thái mới.<br>3.a Lưu thay đổi thất bại → giữ người phụ trách hiện tại, báo lỗi và cho phép thử lại. |


### UC25 – Đánh dấu hoàn thành lịch hẹn

| Thành phần | Nội dung |
|---|---|
| Mục tiêu | Ghi nhận việc hỗ trợ một lịch khám đã hoàn tất. |
| Tác nhân | Người phụ trách lịch hẹn |
| Tiền điều kiện | Lịch chưa hoàn thành |
| Sự kiện kích hoạt | Người phụ trách mở một lịch khám cần đánh dấu hoàn thành. |
| Luồng sự kiện chính | 1. Mở lịch hẹn.<br>2. Chọn hoàn thành.<br>3. Hệ thống lưu trạng thái hoàn tất và làm mới danh sách. |
| Hậu điều kiện | Lịch hẹn chuyển sang trạng thái hoàn thành. |
| Ngoại lệ / luồng thay thế | 1.a Lịch đã hủy/không còn tồn tại → thông báo và kết thúc luồng.<br>2.a Lịch đã hoàn thành → giữ nguyên trạng thái, không cập nhật trùng.<br>3.a Lưu trạng thái thất bại → báo lỗi và cho phép thử lại bước 2. |


### UC26 – Ghi nhận lần khám

| Thành phần | Nội dung |
|---|---|
| Mục tiêu | Lưu thông tin một lần khám vào hồ sơ y tế. |
| Tác nhân | Con cái / người chăm sóc đã liên kết |
| Tiền điều kiện | Đã chọn người cao tuổi |
| Sự kiện kích hoạt | Người thân chọn thêm hồ sơ cho một lần khám. |
| Luồng sự kiện chính | 1. Tạo hồ sơ lần khám.<br>2. Nhập ngày khám, cơ sở y tế, khoa, bác sĩ, kết luận và ghi chú.<br>3. Nhập ngày tái khám nếu có rồi lưu.<br>4. Hệ thống lưu và hiển thị hồ sơ mới. |
| Hậu điều kiện | Hồ sơ lần khám được lưu cho đúng người cao tuổi và xuất hiện trong lịch sử khám. |
| Ngoại lệ / luồng thay thế | 2.a Thiếu/sai dữ liệu → báo lỗi tại trường tương ứng, quay lại bước 2.<br>3.a Lưu hồ sơ thất bại → báo lỗi, giữ biểu mẫu và cho phép thử lại bước 3.<br>4.a Không tải được hồ sơ vừa tạo → báo lỗi và cho phép tải lại danh sách. |


### UC27 – Xem hồ sơ và lịch sử khám

| Thành phần | Nội dung |
|---|---|
| Mục tiêu | Tra cứu các lần khám và thông tin hồ sơ y tế. |
| Tác nhân | Người cao tuổi / người thân đã liên kết |
| Tiền điều kiện | Có quyền xem hồ sơ |
| Sự kiện kích hoạt | Người dùng mở hồ sơ y tế của người cao tuổi. |
| Luồng sự kiện chính | 1. Mở hồ sơ y tế.<br>2. Hệ thống tải danh sách lần khám.<br>3. Chọn lần khám để xem cơ sở y tế, bác sĩ, kết luận, ghi chú, ngày tái khám và tệp đính kèm. |
| Hậu điều kiện | Thông tin hồ sơ và lịch sử khám được hiển thị; dữ liệu không bị thay đổi. |
| Ngoại lệ / luồng thay thế | 2.a Chưa có hồ sơ khám → hiển thị trạng thái trống và kết thúc luồng.<br>2.b Tải danh sách thất bại → báo lỗi và cho phép thử lại bước 1.<br>3.a Hồ sơ không còn tồn tại → quay lại danh sách và tải dữ liệu mới. |


### UC28 – Đính kèm / xem ảnh hoặc PDF

| Thành phần | Nội dung |
|---|---|
| Mục tiêu | Lưu và mở tài liệu ảnh/PDF gắn với hồ sơ lần khám. |
| Tác nhân | Con cái / người chăm sóc; người liên kết được phép xem |
| Tiền điều kiện | Có hồ sơ lần khám |
| Sự kiện kích hoạt | Người dùng chọn thêm tài liệu hoặc mở tệp đã đính kèm trong hồ sơ khám. |
| Luồng sự kiện chính | 1. Chọn thêm tài liệu trong hồ sơ.<br>2. Chọn ảnh hoặc PDF.<br>3. Hệ thống kiểm tra loại tệp, tải lên và lưu tham chiếu vào hồ sơ.<br>4. Chọn tệp đính kèm để mở/xem. |
| Hậu điều kiện | Tệp được gắn với hồ sơ và có thể mở/xem nếu thao tác tải lên thành công. |
| Ngoại lệ / luồng thay thế | 1.a Người dùng hủy chọn tệp → giữ nguyên hồ sơ và kết thúc thao tác đính kèm.<br>2.a Tệp không phải ảnh/PDF hỗ trợ → báo lỗi, không tải lên và cho phép chọn lại ở bước 2.<br>3.a Tải tệp/lưu tham chiếu thất bại → báo lỗi và cho phép thử lại bước 2.<br>4.a Không mở được tệp → thông báo lỗi và cho phép thử mở/tải lại. |



