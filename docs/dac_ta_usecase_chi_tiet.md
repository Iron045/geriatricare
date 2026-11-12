# BẢNG ĐẶC TẢ CHI TIẾT 21 USE CASE HỆ THỐNG GERIATRICCARE
## Mẫu chuẩn bảng 2 cột (Đã gộp ràng buộc dữ liệu vào Luồng sự kiện chính và Ngoại lệ)

---

## PHÂN HỆ 1: QUẢN LÝ TÀI KHOẢN

### Bảng đặc tả Use Case: UC01 - Đăng ký

| Trường thông tin | Nội dung chi tiết |
| :--- | :--- |
| **UsecaseID** | **UC01** |
| **Tên usecase** | **Đăng ký** |
| **Tác nhân** | Người cao tuổi, Con cái / Người thân |
| **Tiền điều kiện** | Thiết bị có kết nối Internet; Số điện thoại và Email chưa từng được đăng ký trong hệ thống. |
| **Luồng sự kiện chính** | **1.** Người dùng mở ứng dụng và chọn chức năng "Đăng ký tài khoản".<br>**2.** Nhập **Họ và tên** (Bắt buộc, từ 2 đến 50 chữ cái, không chứa ký tự đặc biệt).<br>**3.** Nhập **Số điện thoại** (Bắt buộc, đúng 10 chữ số, bắt đầu bằng số 0) và **Email** (Bắt buộc, đúng định dạng thư điện tử).<br>**4.** Nhập **Mật khẩu bảo mật** (Bắt buộc, mã số gồm đúng 6 chữ số).<br>**5.** Chọn **Giới tính** (Bắt buộc chọn 1 trong: `Nam`, `Nữ`, `Khác`) và Chọn **Vai trò tài khoản** (Bắt buộc chọn 1 trong: `Người cao tuổi` hoặc `Con cái / Người thân`).<br>**6.** Người dùng nhấn nút "Gửi mã xác thực". Hệ thống kiểm tra dữ liệu hợp lệ, sinh mã số xác nhận gồm 6 chữ số (hiệu lực trong 5 phút) và gửi đến địa chỉ Email vừa nhập.<br>**7.** Người dùng kiểm tra email, nhập **Mã xác nhận** vào ô trên màn hình và nhấn "Hoàn tất đăng ký".<br>**8.** Hệ thống kiểm tra mã xác nhận chính xác, khởi tạo tài khoản và lưu thông tin người dùng vào hệ thống.<br>**9.** Hệ thống tự động gửi thư kích hoạt tài khoản qua email và chuyển người dùng sang màn hình thông báo hoàn tất. |
| **Ngoại lệ** | **E1 (Dữ liệu nhập không hợp lệ):**<br>- Họ tên dưới 2 chữ cái: Báo lỗi *"Vui lòng nhập họ và tên hợp lệ (tối thiểu 2 ký tự)"*.<br>- Số điện thoại không đủ 10 chữ số hoặc không bắt đầu bằng số 0: Báo lỗi *"Số điện thoại phải có đúng 10 chữ số và bắt đầu bằng số 0"*.<br>- Email sai định dạng: Báo lỗi *"Địa chỉ email không đúng định dạng"*.<br>- Mật khẩu không đủ 6 chữ số: Báo lỗi *"Mật khẩu phải gồm đúng 6 chữ số"*.<br>**E2 (Trùng lặp dữ liệu):** Số điện thoại hoặc Email đã được đăng ký trước đó -> Hệ thống báo lỗi *"Số điện thoại hoặc email này đã được sử dụng. Vui lòng đăng nhập hoặc dùng thông tin khác!"*.<br>**E3 (Mã xác thực không chính xác hoặc hết hạn):** Người dùng nhập sai mã hoặc nhập sau 5 phút -> Hệ thống báo lỗi *"Mã xác thực không đúng hoặc đã hết hạn"*, cho phép bấm gửi lại mã sau 60 giây.<br>**E4 (Lỗi kết nối mạng):** Mất kết nối Internet -> Hệ thống hiển thị thông báo *"Không thể kết nối máy chủ, vui lòng kiểm tra lại đường truyền mạng"*. |

---

### Bảng đặc tả Use Case: UC02 - Đăng nhập

| Trường thông tin | Nội dung chi tiết |
| :--- | :--- |
| **UsecaseID** | **UC02** |
| **Tên usecase** | **Đăng nhập** |
| **Tác nhân** | Người cao tuổi, Con cái / Người thân |
| **Tiền điều kiện** | Người dùng đã có tài khoản trên hệ thống và đã kích hoạt qua email; Thiết bị có kết nối mạng Internet. |
| **Luồng sự kiện chính** | **1.** Người dùng mở ứng dụng và truy cập màn hình Đăng nhập.<br>**2.** Nhập **Số điện thoại** (Bắt buộc, đúng 10 chữ số, bắt đầu bằng số 0).<br>**3.** Nhập **Mật khẩu** (Bắt buộc, mã số gồm đúng 6 chữ số).<br>**4.** Người dùng nhấn nút "Đăng nhập".<br>**5.** Hệ thống kiểm tra thông tin không để trống và đúng quy chuẩn số điện thoại, mật khẩu.<br>**6.** Hệ thống kiểm tra số điện thoại và đối soát mật khẩu đã lưu trong hệ thống.<br>**7.** Hệ thống kiểm tra trạng thái tài khoản: tài khoản đang hoạt động bình thường và đã hoàn thành kích hoạt qua email.<br>**8.** Hệ thống nhận diện vai trò người dùng, ghi nhớ trạng thái đăng nhập và mở màn hình chính phù hợp (Giao diện chữ to, nút bấm lớn cho Người cao tuổi; Giao diện theo dõi cho Con cái). |
| **Ngoại lệ** | **E1 (Dữ liệu rỗng hoặc sai độ dài):** Báo lỗi *"Vui lòng nhập đầy đủ số điện thoại 10 số và mật khẩu 6 số"*.<br>**E2 (Sai số điện thoại hoặc mật khẩu):** Báo lỗi *"Số điện thoại hoặc mật khẩu không chính xác. Vui lòng kiểm tra lại!"*.<br>**E3 (Tài khoản chưa kích hoạt email):** Tự động chuyển sang màn hình nhắc nhở kích hoạt email kèm nút "Gửi lại link kích hoạt".<br>**E4 (Tài khoản bị khóa):** Báo lỗi *"Tài khoản của bạn đã bị tạm khóa. Vui lòng liên hệ quản trị viên!"*.<br>**E5 (Lỗi kết nối mạng):** Báo lỗi *"Lỗi kết nối mạng, vui lòng thử lại sau"*. |

---

### Bảng đặc tả Use Case: UC03 - Đăng xuất

| Trường thông tin | Nội dung chi tiết |
| :--- | :--- |
| **UsecaseID** | **UC03** |
| **Tên usecase** | **Đăng xuất** |
| **Tác nhân** | Người cao tuổi, Con cái / Người thân |
| **Tiền điều kiện** | Người dùng hiện đang trong trạng thái đăng nhập vào ứng dụng. |
| **Luồng sự kiện chính** | **1.** Người dùng mở mục Cài đặt hoặc Hồ sơ cá nhân, chọn nút "Đăng xuất".<br>**2.** Hệ thống hiển thị hộp thoại xác nhận: "Bạn có chắc chắn muốn đăng xuất khỏi tài khoản này?".<br>**3.** Người dùng nhấn nút xác nhận "Đăng xuất".<br>**4.** Hệ thống ngắt các kết nối cập nhật dữ liệu tự động đang hoạt động.<br>**5.** Hệ thống hủy đăng ký nhận thông báo của thiết bị này để tránh gửi nhầm thông báo khi có tài khoản khác đăng nhập.<br>**6.** Hệ thống xóa dữ liệu phiên làm việc lưu tạm trên máy.<br>**7.** Hệ thống chuyển người dùng trở về màn hình Đăng nhập ban đầu. |
| **Ngoại lệ** | **E1 (Người dùng hủy thao tác):** Người dùng bấm nút "Hủy" hoặc bấm ra ngoài hộp thoại -> Hệ thống đóng hộp thoại và giữ nguyên trạng thái làm việc bình thường.<br>**E2 (Mất kết nối mạng):** Hệ thống vẫn tiến hành xóa thông tin đăng nhập trên máy và đưa người dùng ra màn hình đăng nhập để đảm bảo an toàn. |

---

### Bảng đặc tả Use Case: UC03b - Chỉnh sửa thông tin

| Trường thông tin | Nội dung chi tiết |
| :--- | :--- |
| **UsecaseID** | **UC03b** |
| **Tên usecase** | **Chỉnh sửa thông tin** |
| **Tác nhân** | Người cao tuổi, Con cái / Người thân (Người dùng đã đăng nhập) |
| **Tiền điều kiện** | Người dùng đang đăng nhập trong ứng dụng; Thiết bị có kết nối mạng Internet. |
| **Luồng sự kiện chính** | **1.** Người dùng mở mục **Cài đặt** hoặc **Hồ sơ cá nhân**.<br>**2.** Hệ thống hiển thị các thông tin hiện tại gồm: Ảnh đại diện, Họ và tên, Số điện thoại, Giới tính và Vai trò tài khoản.<br>**3.** Người dùng nhấn vào nút **"Chỉnh sửa hồ sơ"**.<br>**4.** Hệ thống mở biểu mẫu chỉnh sửa thông tin:<br>- **Họ và tên:** Bắt buộc nhập, độ dài từ 2 đến 50 chữ cái, tự động viết hoa chữ cái đầu mỗi từ.<br>- **Giới tính:** Bắt buộc chọn 1 trong 3 lựa chọn: `Nam`, `Nữ`, hoặc `Khác`.<br>- *Các thông tin cố định:* Số điện thoại, Vai trò tài khoản và Email xác thực không được phép sửa đổi để đảm bảo an toàn tài khoản.<br>**5.** Người dùng nhập các thông tin cần sửa và nhấn nút **"Lưu thay đổi"**.<br>**6.** Hệ thống kiểm tra tính hợp lệ: Họ và tên không được để trống và phải có ít nhất 2 chữ cái; Giới tính đã được chọn.<br>**7.** Hệ thống lưu các thông tin mới vào hệ thống, đồng thời tự động cập nhật tên mới đến danh sách gia đình của tất cả người thân liên kết.<br>**8.** Hệ thống đóng biểu mẫu chỉnh sửa, cập nhật thông tin mới ngay trên màn hình và thông báo: *"Cập nhật hồ sơ thành công"*. |
| **Ngoại lệ** | **E1 (Họ và tên không hợp lệ):** Người dùng để trống hoặc nhập ít hơn 2 chữ cái -> Hệ thống hiển thị thông báo lỗi màu đỏ: *"Vui lòng nhập họ và tên (tối thiểu 2 ký tự)"* và không cho phép lưu.<br>**E2 (Chưa chọn giới tính):** Để trống mục giới tính -> Hệ thống báo lỗi *"Vui lòng chọn giới tính"**.<br>**E3 (Người dùng hủy thao tác):** Người dùng nhấn nút "Hủy" hoặc bấm ra ngoài biểu mẫu -> Hệ thống đóng biểu mẫu và giữ nguyên thông tin ban đầu.<br>**E4 (Lỗi kết nối mạng):** Thiết bị mất mạng khi đang lưu -> Hệ thống thông báo: *"Không thể cập nhật hồ sơ do lỗi kết nối mạng. Vui lòng kiểm tra lại đường truyền!"*, dữ liệu vừa nhập được giữ nguyên để không phải gõ lại. |

---

## PHÂN HỆ 2: QUẢN LÝ TÌNH HUỐNG KHẨN CẤP (SOS)

### Bảng đặc tả Use Case: UC04 - Gửi cảnh báo SOS

| Trường thông tin | Nội dung chi tiết |
| :--- | :--- |
| **UsecaseID** | **UC04** |
| **Tên usecase** | **Gửi cảnh báo SOS** |
| **Tác nhân** | Người cao tuổi, Cảm biến phát hiện ngã |
| **Tiền điều kiện** | Người cao tuổi đã đăng nhập vào ứng dụng; Thiết bị đã bật định vị vị trí và có kết nối mạng Internet. |
| **Luồng sự kiện chính** | **1.** Tình huống khẩn cấp được kích hoạt theo 1 trong 2 cách:<br>- *Cách 1 (Thủ công):* Người cao tuổi nhấn và giữ nút "SOS Khẩn cấp" màu đỏ trên màn hình chính trong 1 giây.<br>- *Cách 2 (Tự động):* Cảm biến trên điện thoại tự động phát hiện cú ngã mạnh đột ngột, hệ thống phát màn hình đếm ngược 15 giây.<br>**2.** Điện thoại của người cao tuổi tự động hú còi báo động với âm lượng tối đa và rung liên tục.<br>**3.** Hệ thống tự động xác định vị trí tọa độ địa lý hiện tại của người cao tuổi với độ chính xác cao.<br>**4.** Hệ thống khởi tạo bản ghi sự cố khẩn cấp, ghi nhận thời gian xảy ra và trạng thái chờ hỗ trợ.<br>**5.** Hệ thống lập tức gửi thông báo khẩn cấp và chuông báo động đỏ đến toàn bộ điện thoại của con cái và người thân trong nhóm gia đình. |
| **Ngoại lệ** | **E1 (Bấm nhầm hoặc ngã nhẹ):** Trong 15 giây đếm ngược, người cao tuổi nhấn nút "Tôi ổn, bấm nhầm" -> Hệ thống dừng đếm ngược và tắt còi hú, không phát cảnh báo đến người thân.<br>**E2 (Mất tín hiệu định vị vị trí):** Không lấy được vị trí tức thời -> Hệ thống tự động gửi vị trí được ghi nhận lần gần nhất kèm thông báo *"Vị trí không khả dụng"**.<br>**E3 (Mất kết nối mạng Internet):** Điện thoại không có kết nối mạng -> Hệ thống tự động mở trình nhắn tin soạn sẵn tọa độ vị trí và gọi điện trực tiếp đến số khẩn cấp của người thân. |

---

### Bảng đặc tả Use Case: UC05 - Xử lý cảnh báo

| Trường thông tin | Nội dung chi tiết |
| :--- | :--- |
| **UsecaseID** | **UC05** *(Tích hợp tiếp nhận và xử lý sự cố)* |
| **Tên usecase** | **Xử lý cảnh báo** |
| **Tác nhân** | Con cái / Người thân |
| **Tiền điều kiện** | Con cái đã cài ứng dụng và kết nối với tài khoản của cha mẹ; Thiết bị bật mạng và cho phép thông báo; Cảnh báo khẩn cấp đang ở trạng thái chờ xử lý. |
| **Luồng sự kiện chính** | **1.** Điện thoại của con cái nhận thông báo khẩn cấp kèm chuông báo động âm lượng lớn khi người cao tuổi gặp nạn (hoặc do cảm biến phát hiện ngã).<br>**2.** Con cái chạm vào thông báo để mở màn hình chi tiết tình huống khẩn cấp.<br>**3.** Màn hình hiển thị đầy đủ thông tin: Họ tên người cao tuổi, Loại sự cố (`SOS khẩn cấp` hoặc `Phát hiện ngã`), Thời gian xảy ra chính xác đến từng giây.<br>**4.** Bản đồ định vị chính xác vị trí gặp nạn và địa chỉ ước tính của người cao tuổi.<br>**5.** Con cái thực hiện các biện pháp hỗ trợ tức thì: Nhấn nút **"Gọi điện thoại ngay"** để đàm thoại trực tiếp với cha mẹ, hoặc nhấn **"Chỉ đường"** trên bản đồ để nhanh chóng di chuyển tiếp cận vị trí.<br>**6.** Ngay khi con cái nhấn một trong hai thao tác hỗ trợ trên, hệ thống tự động ghi nhận và chuyển trạng thái sự cố sang **"Đã có người tiếp nhận"**, đồng thời hiển thị tên người thân đang tiếp nhận hỗ trợ lên điện thoại của các thành viên khác trong gia đình để mọi người an tâm và nắm bắt được tình hình.<br>**7.** Sau khi đã liên hệ hoặc tiếp cận hỗ trợ thực tế cha mẹ an toàn, người thân nhấn nút **"Cập nhật xử lý tình huống"**.<br>**8.** Hệ thống hiển thị biểu mẫu ghi nhận kết quả xử lý:<br>- Chọn **Kết quả xử lý:** Bắt buộc chọn 1 trong 3 trạng thái: `Đã an toàn tại nhà`, `Đã đưa đi cấp cứu / nhập viện`, hoặc `Cảnh báo giả / Bấm nhầm`.<br>- Nhập **Ghi chú xử lý:** Tùy chọn, mô tả tình hình thực tế (tối đa 300 chữ, ví dụ: "Cha bị trượt chân nhẹ, đã bôi dầu và nghỉ ngơi ổn định").<br>**9.** Người dùng nhấn nút **"Xác nhận hoàn tất xử lý"**.<br>**10.** Hệ thống lưu kết quả xử lý, ghi nhận người hoàn tất, thời gian xử lý và đánh dấu ca hỗ trợ đã được giải quyết an toàn.<br>**11.** Hệ thống tự động tắt còi hú báo động trên điện thoại của người cao tuổi và cập nhật trạng thái an toàn đến toàn bộ các thành viên khác trong gia đình. |
| **Ngoại lệ** | **E1 (Cảnh báo đang có người thân khác tiếp nhận):** Nếu thành viên khác trong gia đình đã nhấn gọi điện hoặc chỉ đường trước -> Màn hình hiển thị thông tin: *"[Tên người thân] đang tiếp nhận hỗ trợ tình huống này"* để tránh gọi trùng lặp.<br>**E2 (Cảnh báo đã được người thân khác xử lý hoàn tất):** Nếu sự cố đã được một thành viên khác trong gia đình hoàn tất trước đó -> Màn hình hiển thị thông báo: *"Cảnh báo này đã được [Tên người thân] hỗ trợ an toàn vào lúc [Giờ:phút]"*.<br>**E3 (Chưa chọn kết quả xử lý):** Người dùng để trống lựa chọn kết quả -> Hệ thống thông báo lỗi: *"Vui lòng chọn kết quả xử lý tình huống!"*.<br>**E4 (Ghi chú quá dài):** Nhập quá 300 ký tự -> Hệ thống báo lỗi: *"Ghi chú không được vượt quá 300 ký tự"*.<br>**E5 (Lỗi kết nối mạng khi hoàn tất):** Điện thoại mất kết nối khi đang lưu -> Hệ thống thông báo: *"Không thể hoàn tất xử lý do lỗi mạng. Vui lòng kiểm tra lại đường truyền!"*. |

---

## PHÂN HỆ 3: QUẢN LÝ CHỈ SỐ HUYẾT ÁP

### Bảng đặc tả Use Case: UC07 - Ghi chỉ số huyết áp

| Trường thông tin | Nội dung chi tiết |
| :--- | :--- |
| **UsecaseID** | **UC07** |
| **Tên usecase** | **Ghi chỉ số huyết áp** |
| **Tác nhân** | Người cao tuổi, Con cái / Người thân |
| **Tiền điều kiện** | Người dùng đã đăng nhập; Mở màn hình "Ghi nhận huyết áp". |
| **Luồng sự kiện chính** | **1.** Người dùng mở màn hình thêm kết quả đo huyết áp .<br>**2.** Nhập **Huyết áp tâm thu** : Bắt buộc, số nguyên dương, giá trị từ 70 đến 250 mmHg.<br>**3.** Nhập **Huyết áp tâm trương** : Bắt buộc, số nguyên dương, giá trị từ 40 đến 150 mmHg. (Hệ thống kiểm tra ràng buộc logic y tế: Huyết áp tâm thu phải lớn hơn huyết áp tâm trương ít nhất 10 mmHg: chỉ số tâm thu lớn hơn tâm trương).<br>**4.** Nhập **Nhịp tim** : Bắt buộc, số nguyên dương, giá trị từ 30 đến 220 nhịp/phút (bpm).<br>**5.** Chọn **Thời điểm đo** : Mặc định là thời gian hiện tại, có thể chọn lại nhưng không được chọn thời điểm trong tương lai (thời gian đo không ở tương lai).<br>**6.** Nhập **Ghi chú bổ sung** : Tùy chọn, chuỗi ký tự tối đa 200 ký tự (ví dụ: "đo sau khi tập thể dục", "hơi nhức đầu").<br>**7.** Người dùng nhấn nút "Lưu kết quả".<br>**8.** Hệ thống tự động phân loại mức độ nguy cơ theo tiêu chuẩn WHO/AHA (`Bình thường`, `Tiền tăng huyết áp`, `Tăng huyết áp độ 1`, `Tăng huyết áp độ 2`, `Huyết áp thấp`), lưu bản ghi vào dữ liệu đo huyết áp và cập nhật thông số gần nhất vào hồ sơ người cao tuổi. |
| **Ngoại lệ** | **E1 (Chỉ số ngoài dải đo cho phép):**<br>- Tâm thu ngoài dải [70, 250] mmHg -> Báo lỗi *"Huyết áp tâm thu phải nằm trong khoảng 70 - 250 mmHg"*.<br>- Tâm trương ngoài dải [40, 150] mmHg -> Báo lỗi *"Huyết áp tâm trương phải nằm trong khoảng 40 - 150 mmHg"*.<br>- Nhịp tim ngoài dải [30, 220] bpm -> Báo lỗi *"Nhịp tim phải nằm trong khoảng 30 - 220 bpm"*.<br>**E2 (Tâm thu nhỏ hơn hoặc bằng Tâm trương):** tâm thu nhỏ hơn hoặc bằng tâm trương -> Hệ thống báo lỗi logic *"Huyết áp tâm thu (chỉ số trên) phải lớn hơn huyết áp tâm trương (chỉ số dưới)"*.<br>**E3 (Thời điểm đo trong tương lai):** thời gian đo ở tương lai -> Báo lỗi *"Thời điểm đo không được lớn hơn thời điểm hiện tại"*.<br>**E4 (Ghi chú quá dài):** Vượt quá 200 ký tự -> Hệ thống báo *"Ghi chú không được vượt quá 200 ký tự"*. |

---

### Bảng đặc tả Use Case: UC08 - Theo dõi lịch sử huyết áp

| Trường thông tin | Nội dung chi tiết |
| :--- | :--- |
| **UsecaseID** | **UC08** |
| **Tên usecase** | **Theo dõi lịch sử huyết áp** |
| **Tác nhân** | Người cao tuổi, Con cái / Người thân |
| **Tiền điều kiện** | Người dùng đã đăng nhập; Đã có dữ liệu đo huyết áp được lưu trong hệ thống. |
| **Luồng sự kiện chính** | **1.** Người dùng truy cập chức năng "Lịch sử huyết áp" .<br>**2.** Chọn **Khoảng thời gian thống kê**: Chọn 1 trong các bộ lọc: `7 ngày qua`, `30 ngày qua`, `90 ngày qua`, hoặc `Tùy chọn khoảng ngày` (Ràng buộc: Ngày bắt đầu phải nhỏ hơn hoặc bằng Ngày kết thúc: ngày bắt đầu trước ngày kết thúc).<br>**3.** Hệ thống truy vấn cơ sở dữ liệu theo người cao tuổi và khoảng thời gian đã chọn, sắp xếp giảm dần theo thời gian đo (mới nhất lên đầu).<br>**4.** Hệ thống tính toán và hiển thị các chỉ số tổng hợp: Huyết áp tâm thu/tâm trương trung bình, Nhịp tim trung bình, Tổng số lần đo, Tỷ lệ các lần đo bất thường.<br>**5.** Hệ thống vẽ biểu đồ đường trực quan thể hiện xu hướng biến thiên huyết áp theo thời gian, có đường kẻ ranh giới cảnh báo nguy cơ cao (140/90 mmHg).<br>**6.** Hiển thị danh sách chi tiết các lần đo với màu sắc mã hóa cảnh báo (Xanh: Bình thường, Vàng: Chú ý, Đỏ: Nguy hiểm). |
| **Ngoại lệ** | **E1 (Khoảng ngày tùy chọn không hợp lệ):** Người dùng chọn ngày bắt đầu sau ngày kết thúc -> Hệ thống hiển thị thông báo lỗi *"Ngày bắt đầu không được lớn hơn ngày kết thúc"*.<br>**E2 (Chưa có dữ liệu đo trong khoảng thời gian chọn):** Hệ thống hiển thị hình ảnh minh họa cùng thông báo *"Chưa có dữ liệu đo huyết áp trong khoảng thời gian này. Hãy thực hiện đo và lưu kết quả mới!"*. |

---

### Bảng đặc tả Use Case: UC09 - Cảnh báo chỉ số bất thường

| Trường thông tin | Nội dung chi tiết |
| :--- | :--- |
| **UsecaseID** | **UC09** |
| **Tên usecase** | **Cảnh báo chỉ số bất thường** |
| **Tác nhân** | Hệ thống (Tự động kích hoạt khi có bản ghi huyết áp mới từ UC07) |
| **Tiền điều kiện** | Một bản ghi chỉ số đo huyết áp vừa được lưu thành công vào cơ sở dữ liệu. |
| **Luồng sự kiện chính** | **1.** Hệ thống tự động phân tích các giá trị huyết áp tâm thu, huyết áp tâm trương và nhịp tim vừa được tạo.<br>**2.** Hệ thống kiểm tra điều kiện ngưỡng bất thường nguy hiểm y tế:<br>- *Tăng huyết áp khẩn cấp:* tâm thu từ 160 trở lên hoặc tâm trương từ 100 trở lên.<br>- *Tụt huyết áp nguy hiểm:* tâm thu dưới 90 hoặc tâm trương dưới 60.<br>- *Rối loạn nhịp tim:* nhịp tim dưới 50 hoặc trên 120 nhịp/phút.<br>**3.** Nếu vi phạm các ngưỡng trên, hệ thống đánh dấu cờ chỉ số bất thường và xác định mức độ nghiêm trọng (mức độ chú ý hoặc nguy hiểm).<br>**4.** Hệ thống khởi tạo tài liệu thông báo trong cơ sở dữ liệu.<br>**5.** Hệ thống kích hoạt hệ thống thông báo gửi thông báo đẩy cảnh báo y tế lập tức đến toàn bộ thiết bị của Con cái/Người thân liên kết với nội dung: *"[CẢNH BÁO SỨC KHỎE] Chỉ số huyết áp của Cha/Mẹ đang ở mức báo động: [Tâm thu]/[Tâm trương] mmHg, nhịp tim: [Nhịp tim] bpm. Vui lòng liên hệ kiểm tra ngay!"*.<br>**6.** Trên màn hình của người cao tuổi, hệ thống hiển thị hướng dẫn y tế khẩn cấp: Ngồi nghỉ ngơi tại chỗ, uống nước ấm, hít thở đều và đo lại sau 15 phút. |
| **Ngoại lệ** | **E1 (Chỉ số nằm trong ngưỡng bình thường):** tâm thu dưới 140 và tâm trương dưới 90 -> Hệ thống chỉ lưu trữ và hiển thị nhãn trạng thái xanh (Bình thường), không phát sinh thông báo đẩy cảnh báo đến người thân. |

---

## PHÂN HỆ 4: QUẢN LÝ LỊCH UỐNG THUỐC

### Bảng đặc tả Use Case: UC10 - Thiết lập lịch uống thuốc

| Trường thông tin | Nội dung chi tiết |
| :--- | :--- |
| **UsecaseID** | **UC10** |
| **Tên usecase** | **Thiết lập lịch uống thuốc** |
| **Tác nhân** | Con cái / Người thân, Người cao tuổi |
| **Tiền điều kiện** | Người dùng đã đăng nhập; Truy cập chức năng "Tạo đơn thuốc / Lịch uống thuốc". |
| **Luồng sự kiện chính** | **1.** Người dùng mở màn hình thêm lịch thuốc mới .<br>**2.** Nhập **Tên thuốc** : Bắt buộc, chuỗi ký tự từ 2 đến 100 ký tự.<br>**3.** Nhập **Liều lượng mỗi lần** : Bắt buộc, chuỗi mô tả từ 1 đến 50 ký tự (ví dụ: "1 viên", "2 muỗng canh", "1 gói").<br>**4.** Nhập **Số lượng đơn vị số học** : Bắt buộc, số nguyên dương từ 1 đến 20.<br>**5.** Chọn **Thời điểm uống so với bữa ăn** : Bắt buộc chọn 1 trong: `Trước khi ăn` , `Sau khi ăn` , `Trong khi ăn` , `Uống lúc đói` .<br>**6.** Thiết lập **Các mốc giờ nhắc uống trong ngày** : Bắt buộc chọn ít nhất 1 mốc giờ (từ 00:00 đến 23:59), tối đa không quá 6 mốc giờ/ngày.<br>**7.** Thiết lập thời gian điều trị:<br>- **Ngày bắt đầu** : Bắt buộc, ngày tháng năm, không được trước ngày hôm nay quá 7 ngày.<br>- **Ngày kết thúc** : Tùy chọn, nếu có thì ngày kết thúc phải lớn hơn hoặc bằng ngày bắt đầu (ngày kết thúc sau ngày bắt đầu).<br>**8.** Nhập **Hướng dẫn bổ sung** : Tùy chọn, tối đa 200 ký tự (ví dụ: "uống nhiều nước ấm").<br>**9.** Người dùng nhấn "Lưu lịch uống thuốc". Hệ thống kiểm tra hợp lệ, lưu vào dữ liệu lịch uống thuốc và đăng ký lịch báo thức trên thiết bị (chuông báo thức trên thiết bị). |
| **Ngoại lệ** | **E1 (Tên thuốc để trống hoặc quá dài):** Báo lỗi *\"Tên thuốc không được để trống và có độ dài từ 2 đến 100 ký tự\"*.<br>**E2 (Liều lượng không hợp lệ):** Liều lượng để trống hoặc số lượng < 1 hoặc > 20 -> Báo lỗi *\"Số lượng liều uống phải từ 1 đến 20 đơn vị\"*.<br>**E3 (Chưa chọn giờ nhắc):** Danh sách các mốc giờ nhắc rỗng -> Báo lỗi *\"Vui lòng chọn ít nhất một khung giờ uống thuốc trong ngày\"*.<br>**E4 (Ngày kết thúc trước ngày bắt đầu):** ngày kết thúc trước ngày bắt đầu -> Báo lỗi *\"Ngày kết thúc uống thuốc phải sau hoặc trùng với ngày bắt đầu\"*. |

---

### Bảng đặc tả Use Case: UC11 - Nhắc nhở và theo dõi theo ngày

| Trường thông tin | Nội dung chi tiết |
| :--- | :--- |
| **UsecaseID** | **UC11** |
| **Tên usecase** | **Nhắc nhở và theo dõi theo ngày** |
| **Tác nhân** | Người cao tuổi, Con cái / Người thân, Hệ thống tự động |
| **Tiền điều kiện** | Đã có lịch uống thuốc có hiệu lực trong ngày hôm nay (trong khoảng thời gian dùng thuốc). |
| **Luồng sự kiện chính** | **1.** Khi đến mốc giờ uống thuốc đã cài đặt, Hệ thống tự động phát chuông báo thức, rung thiết bị và hiển thị thông báo toàn màn hình nhắc uống thuốc trên máy người cao tuổi.<br>**2.** Người cao tuổi mở ứng dụng, màn hình chính hiển thị danh sách các cữ thuốc trong ngày được phân nhóm theo buổi (Sáng, Trưa, Chiều, Tối).<br>**3.** Mỗi mục thuốc hiển thị rõ ràng: Tên thuốc, số lượng/liều lượng, hình thức uống (trước/sau ăn) cùng trạng thái hiện tại: `Chờ uống` , `Đã uống` , hoặc `Đã bỏ qua` .<br>**4.** Trên ứng dụng của Con cái, màn hình theo dõi cũng cập nhật đồng bộ tiến độ uống thuốc của cha mẹ theo thời gian thực để con cái có thể nhắc nhở từ xa nếu thấy quá giờ mà cha mẹ chưa uống. |
| **Ngoại lệ** | **E1 (Thiết bị bật chế độ im lặng / Không làm phiền):** Thông báo sử dụng kênh báo động ưu tiên cao (kênh báo động ưu tiên) để phát chuông nhắc nhở người cao tuổi không bị lỡ giờ thuốc.<br>**E2 (Hết hạn đợt thuốc):** Sau ngày ngày kết thúc, lịch thuốc tự động chuyển vào mục "Đơn thuốc đã hoàn thành", không phát thông báo nhắc nhở mỗi ngày nữa. |

---

### Bảng đặc tả Use Case: UC12 - Ghi nhận nhật ký uống thuốc

| Trường thông tin | Nội dung chi tiết |
| :--- | :--- |
| **UsecaseID** | **UC12** |
| **Tên usecase** | **Ghi nhận nhật ký uống thuốc** |
| **Tác nhân** | Người cao tuổi, Con cái / Người thân |
| **Tiền điều kiện** | Có cữ thuốc đang ở trạng thái chờ duyệt trong ngày hôm nay. |
| **Luồng sự kiện chính** | **1.** Tại thẻ cữ thuốc tương ứng trên màn hình, người dùng nhấn nút xác nhận "Đã uống" (hoặc chọn "Bỏ qua").<br>**2.** Nếu chọn **"Đã uống"**:<br>- Hệ thống tự động lấy thời gian ghi nhận thực tế .<br>- Chuyển trạng thái cữ thuốc thành trạng thái đã uống.<br>**3.** Nếu chọn **"Bỏ qua"**:<br>- Hệ thống hiển thị hộp thoại yêu cầu chọn hoặc nhập **Lý do bỏ qua** : Bắt buộc chọn hoặc nhập, tối đa 150 ký tự (ví dụ: "bị nôn ói", "quên mang thuốc", "hết thuốc").<br>- Chuyển trạng thái thành trạng thái bỏ qua.<br>**4.** Hệ thống ghi nhận bản ghi nhật ký vào cơ sở dữ liệu.<br>**5.** Hệ thống tính toán lại tỷ lệ tuân thủ điều trị trong ngày/tuần của người cao tuổi và gửi thông báo cập nhật về máy con cái. |
| **Ngoại lệ** | **E1 (Lý do bỏ qua để trống khi chọn Bỏ qua):** Báo lỗi *\"Vui lòng nhập hoặc chọn lý do bỏ qua cữ thuốc này\"*.<br>**E2 (Cữ thuốc đã được xác nhận trước đó):** Trạng thái đã là đã hoàn thành -> Hệ thống thông báo cữ thuốc đã được hoàn thành lúc [Giờ:phút], yêu cầu xác nhận nếu muốn thay đổi lại trạng thái.<br>**E3 (Lỗi kết nối mạng):** Bản ghi được lưu tạm vào bộ nhớ cục bộ (bộ nhớ tạm của máy) và tự động đồng bộ lên máy chủ ngay khi có mạng trở lại. |

---

## PHÂN HỆ 5: QUẢN LÝ LIÊN KẾT TÀI KHOẢN

### Bảng đặc tả Use Case: UC13 - Gửi và phản hồi yêu cầu liên kết

| Trường thông tin | Nội dung chi tiết |
| :--- | :--- |
| **UsecaseID** | **UC13** |
| **Tên usecase** | **Gửi và phản hồi yêu cầu liên kết** |
| **Tác nhân** | Con cái / Người thân (người gửi), Người cao tuổi (người nhận duyệt) |
| **Tiền điều kiện** | Cả hai tài khoản đã được đăng ký và kích hoạt trong hệ thống; Con cái biết số điện thoại của người cao tuổi. |
| **Luồng sự kiện chính** | **1.** Con cái truy cập mục "Thêm liên kết người thân" .<br>**2.** Nhập **Số điện thoại người cao tuổi** : Bắt buộc, đúng 10 chữ số, bắt đầu bằng số 0, định dạng quy chuẩn `10 số bắt đầu bằng số 0`.<br>**3.** Chọn **Mối quan hệ gia đình** : Bắt buộc chọn 1 trong: `Cha/Mẹ` , `Ông/Bà` , `Vợ/Chồng` , hoặc `Người thân khác` .<br>**4.** Con cái nhấn nút "Gửi yêu cầu liên kết".<br>**5.** Hệ thống kiểm tra các ràng buộc nghiệp vụ: Số điện thoại phải tồn tại trong danh bạ tài khoản, tài khoản đích phải có vai trò Người cao tuổi, không được tự nhập số điện thoại của chính mình, và giữa 2 người chưa có liên kết nào đang chờ hoặc đã kết nối (đã chấp thuận).<br>**6.** Hệ thống tạo bản ghi liên kết mới trong dữ liệu liên kết gia đình với trạng thái chờ duyệt, đồng thời gửi thông báo đẩy đến điện thoại của người cao tuổi.<br>**7.** Người cao tuổi mở ứng dụng, nhận hộp thoại thông báo: "[Tên con cái] gửi yêu cầu liên kết chăm sóc với bạn. Bạn có đồng ý không?".<br>**8.** Người cao tuổi chọn "Đồng ý" (hoặc "Từ chối").<br>**9.** Hệ thống cập nhật bản ghi liên kết: Nếu đồng ý, cập nhật trạng thái đã chấp nhận, bổ sung ID con cái vào mảng danh sách người thân liên kết của cha mẹ và ngược lại; Nếu từ chối, cập nhật trạng thái đã từ chối. |
| **Ngoại lệ** | **E1 (Số điện thoại không đúng định dạng):** Nhập sai regex -> Báo lỗi *\"Số điện thoại phải có 10 chữ số và bắt đầu bằng số 0\"*.<br>**E2 (Số điện thoại không tồn tại hoặc sai vai trò):** Số không có trong hệ thống hoặc là tài khoản con cái -> Báo lỗi *\"Không tìm thấy tài khoản Người cao tuổi nào tương ứng với số điện thoại này!\"*.<br>**E3 (Tự liên kết chính mình):** Nhập số điện thoại của tài khoản đang đăng nhập -> Báo lỗi *\"Bạn không thể tự gửi yêu cầu liên kết cho chính mình!\"*.<br>**E4 (Yêu cầu đã tồn tại):** Giữa 2 tài khoản đã có yêu cầu chờ duyệt hoặc đã đã chấp thuận -> Báo lỗi *\"Yêu cầu liên kết giữa hai tài khoản đã tồn tại hoặc đang chờ xử lý!\"*. |

---

### Bảng đặc tả Use Case: UC14 - Quản lý danh sách người thân

| Trường thông tin | Nội dung chi tiết |
| :--- | :--- |
| **UsecaseID** | **UC14** |
| **Tên usecase** | **Quản lý danh sách người thân** |
| **Tác nhân** | Con cái / Người thân, Người cao tuổi |
| **Tiền điều kiện** | Người dùng đã đăng nhập; Có ít nhất một liên kết gia đình đã được chấp thuận (đã được đồng ý). |
| **Luồng sự kiện chính** | **1.** Người dùng mở mục "Danh sách người thân / Gia đình" .<br>**2.** Hệ thống truy xuất và hiển thị danh sách các thành viên liên kết kèm thông tin: Ảnh đại diện, Họ và tên, Số điện thoại, Vai trò và Mối quan hệ.<br>**3.** Người dùng có thể chọn một thành viên để cập nhật danh xưng gợi nhớ : Tùy chọn, tối đa 50 ký tự (ví dụ: "Mẹ yêu", "Con trai cả").<br>**4.** Khi cần chấm dứt liên kết, người dùng nhấn nút "Hủy liên kết thành viên".<br>**5.** Hệ thống hiển thị cảnh báo bảo mật: "Khi hủy liên kết, bạn sẽ không thể tiếp tục theo dõi vị trí, hồ sơ sức khỏe và nhận cảnh báo khẩn cấp từ người này. Bạn có chắc chắn muốn hủy?".<br>**6.** Người dùng xác nhận "Hủy liên kết". Hệ thống cập nhật trạng thái liên kết trạng thái đã hủy, xóa quyền truy cập dữ liệu chéo giữa 2 tài khoản. |
| **Ngoại lệ** | **E1 (Người dùng hủy thao tác):** Nhấn "Không" tại hộp thoại cảnh báo -> Hệ thống đóng hộp thoại và giữ nguyên danh sách liên kết.<br>**E2 (Lỗi kết nối mạng):** Mất mạng Internet khi hủy liên kết -> Hệ thống báo lỗi *\"Không thể cập nhật trạng thái liên kết. Vui lòng kiểm tra lại kết nối mạng!\"*. |

---

### Bảng đặc tả Use Case: UC15 - Liên hệ khẩn cấp

| Trường thông tin | Nội dung chi tiết |
| :--- | :--- |
| **UsecaseID** | **UC15** |
| **Tên usecase** | **Liên hệ khẩn cấp** |
| **Tác nhân** | Người cao tuổi, Con cái / Người thân |
| **Tiền điều kiện** | Ứng dụng đã được cài đặt và cấp quyền thực hiện cuộc gọi; Đã có danh bạ người thân liên kết hoặc số cấp cứu mặc định. |
| **Luồng sự kiện chính** | **1.** Người cao tuổi truy cập mục "Danh bạ khẩn cấp" trên giao diện chính (Hiển thị các thẻ danh bạ to rõ, có ảnh đại diện và tên người thân).<br>**2.** Người cao tuổi chạm vào nút gọi nhanh của người thân mong muốn (hoặc nút gọi số cấp cứu y tế `115`).<br>**3.** Hệ thống kiểm tra số điện thoại đích (Bắt buộc chuỗi từ 3 đến 12 chữ số hợp lệ).<br>**4.** Hệ thống gọi thư viện tính năng gọi điện mở trình quay số cuộc gọi hệ thống (cuộc gọi).<br>**5.** Người cao tuổi thực hiện đàm thoại trực tiếp với người thân để trao đổi tình hình. |
| **Ngoại lệ** | **E1 (Thiết bị không hỗ trợ tính năng gọi điện):** Sử dụng máy tính bảng không gắn SIM -> Hệ thống thông báo *\"Thiết bị không hỗ trợ tính năng cuộc gọi viễn thông. Vui lòng sử dụng điện thoại khác!\"*.<br>**E2 (Số điện thoại liên hệ bị trống hoặc không hợp lệ):** Hệ thống báo lỗi *\"Số điện thoại liên hệ khẩn cấp chưa được thiết lập hoặc không đúng định dạng!\"*. |

---

## PHÂN HỆ 6: QUẢN LÝ LỊCH KHÁM SỨC KHỎE

### Bảng đặc tả Use Case: UC16 - Tạo lịch khám sức khỏe

| Trường thông tin | Nội dung chi tiết |
| :--- | :--- |
| **UsecaseID** | **UC16** |
| **Tên usecase** | **Tạo lịch khám sức khỏe** |
| **Tác nhân** | Con cái / Người thân, Người cao tuổi |
| **Tiền điều kiện** | Người dùng đã đăng nhập; Truy cập mục "Lịch khám sức khỏe". |
| **Luồng sự kiện chính** | **1.** Người dùng mở màn hình tạo lịch khám bệnh .<br>**2.** Nhập **Tiêu đề lịch khám** : Bắt buộc, chuỗi ký tự từ 3 đến 100 ký tự (ví dụ: "Khám định kỳ tim mạch", "Tái khám mắt").<br>**3.** Nhập **Tên Bệnh viện / Phòng khám** : Bắt buộc, chuỗi từ 3 đến 150 ký tự.<br>**4.** Nhập **Địa chỉ bệnh viện** : Tùy chọn, chuỗi tối đa 250 ký tự.<br>**5.** Nhập **Bác sĩ phụ trách / Chuyên khoa** : Tùy chọn, tối đa 100 ký tự.<br>**6.** Chọn **Thời gian khám** : Bắt buộc, ngày và giờ cụ thể (Ràng buộc: Thời gian hẹn khám phải sau thời điểm hiện tại ít nhất 30 phút: sau thời điểm tạo lịch ít nhất 30 phút).<br>**7.** Nhập **Ghi chú dặn dò** : Tùy chọn, tối đa 300 ký tự (ví dụ: "Nhịn ăn sáng trước khi xét nghiệm máu", "Mang theo sổ BHYT").<br>**8.** Người dùng nhấn "Lưu lịch khám". Hệ thống kiểm tra hợp lệ, lưu vào dữ liệu lịch khám với trạng thái ban đầu trạng thái đã lên lịch và gửi thông báo nhắc hẹn cho các thành viên gia đình. |
| **Ngoại lệ** | **E1 (Tiêu đề hoặc Bệnh viện để trống):** Báo lỗi *\"Vui lòng nhập đầy đủ tiêu đề lịch khám và tên cơ sở y tế!\"*.<br>**E2 (Thời gian khám trong quá khứ):** đã đến hoặc qua giờ hẹn khám -> Báo lỗi *\"Thời gian khám bệnh phải diễn ra trong tương lai (sau thời điểm hiện tại ít nhất 30 phút)\"*.<br>**E3 (Ghi chú quá dài):** Vượt quá 300 ký tự -> Báo lỗi *\"Ghi chú dặn dò không được vượt quá 300 ký tự\"*. |

---

### Bảng đặc tả Use Case: UC17 - Điều phối người đưa đi khám

| Trường thông tin | Nội dung chi tiết |
| :--- | :--- |
| **UsecaseID** | **UC17** |
| **Tên usecase** | **Điều phối người đưa đi khám** |
| **Tác nhân** | Con cái / Người thân trong gia đình |
| **Tiền điều kiện** | Đã có lịch khám bệnh với trạng thái đang chờ diễn ra; Có nhiều thành viên liên kết trong nhóm gia đình. |
| **Luồng sự kiện chính** | **1.** Con cái mở màn hình chi tiết lịch khám bệnh của cha mẹ.<br>**2.** Nhấn nút "Nhận đưa đi khám" (tự nhận) hoặc "Phân công người thân đưa đi".<br>**3.** Nếu phân công: Chọn một thành viên từ danh sách con cái/người thân liên kết (`assignedCaregiverId`: bắt buộc chọn 1 người).<br>**4.** Nhập **Ghi chú di chuyển / Phương tiện** : Tùy chọn, tối đa 150 ký tự (ví dụ: "Đi ô tô gia đình", "Đã gọi taxi đón lúc 7h00\").<br>**5.** Nhấn nút "Xác nhận điều phối".<br>**6.** Hệ thống kiểm tra dữ liệu, cập nhật bản ghi lịch khám: `assignedCaregiverId`, `assignedCaregiverName`, cờ có người đưa đi đã có người đưa đi.<br>**7.** Hệ thống gửi thông báo cho người được phân công và hiển thị rõ tên người đưa đi trên ứng dụng của người cao tuổi để cha mẹ an tâm. |
| **Ngoại lệ** | **E1 (Chưa chọn người phụ trách đưa đi):** Báo lỗi *\"Vui lòng chọn một người thân trong gia đình phụ trách đưa đi khám!\"*.<br>**E2 (Người được phân công đã bị hủy liên kết):** Báo lỗi *\"Thành viên này hiện không còn liên kết trong nhóm gia đình\"*.<br>**E3 (Lỗi kết nối):** Báo lỗi *\"Không thể cập nhật điều phối, vui lòng kiểm tra kết nối mạng!\"*. |

---

### Bảng đặc tả Use Case: UC18 - Xác nhận hoàn tất lịch khám

| Trường thông tin | Nội dung chi tiết |
| :--- | :--- |
| **UsecaseID** | **UC18** |
| **Tên usecase** | **Xác nhận hoàn tất lịch khám** |
| **Tác nhân** | Con cái / Người thân, Người cao tuổi |
| **Tiền điều kiện** | Lịch khám đang ở trạng thái đang chờ diễn ra và thời gian hiện tại đã đến hoặc qua giờ hẹn khám (đã đến hoặc qua giờ hẹn khám). |
| **Luồng sự kiện chính** | **1.** Sau khi hoàn thành buổi khám bệnh, người dùng mở chi tiết lịch khám.<br>**2.** Nhấn nút "Xác nhận hoàn tất buổi khám".<br>**3.** Nhập **Kết luận của bác sĩ** : Tùy chọn, tối đa 500 ký tự (ví dụ: "Sức khỏe ổn định, huyết áp duy trì tốt, tiếp tục dùng thuốc theo đơn").<br>**4.** Chọn **Ngày hẹn tái khám** : Tùy chọn, ngày tháng năm (Ràng buộc: Nếu có chọn thì ngày tái khám phải lớn hơn ngày khám hiện tại: sau ngày khám bệnh).<br>**5.** Người dùng nhấn "Hoàn tất".<br>**6.** Hệ thống kiểm tra dữ liệu, cập nhật lịch khám: trạng thái đã hoàn tất, `completedAt = now`, kết luận của bác sĩ.<br>**7.** Nếu có thiết lập ngày hẹn tái khám, hệ thống tự động gợi ý tạo một lịch khám bệnh mới tương ứng cho đợt tái khám. |
| **Ngoại lệ** | **E1 (Xác nhận khi chưa đến thời gian khám):** chưa đến giờ hẹn khám -> Hệ thống hiển thị hộp thoại cảnh báo *\"Lịch khám này chưa đến thời gian diễn ra. Bạn có chắc chắn muốn xác nhận kết thúc sớm không?\"*.<br>**E2 (Ngày tái khám trước hoặc trùng ngày khám):** trước hoặc trùng ngày khám -> Báo lỗi *\"Ngày hẹn tái khám phải sau ngày khám bệnh hiện tại\"*. |

---

## PHÂN HỆ 7: QUẢN LÝ HỒ SƠ Y TẾ

### Bảng đặc tả Use Case: UC19 - Lưu hồ sơ y tế

| Trường thông tin | Nội dung chi tiết |
| :--- | :--- |
| **UsecaseID** | **UC19** |
| **Tên usecase** | **Lưu hồ sơ y tế** |
| **Tác nhân** | Con cái / Người thân, Người cao tuổi |
| **Tiền điều kiện** | Người dùng đã đăng nhập; Mở mục "Sổ hồ sơ bệnh án y tế". |
| **Luồng sự kiện chính** | **1.** Người dùng mở màn hình tạo hồ sơ y tế mới .<br>**2.** Nhập **Tên Bệnh viện / Phòng khám** : Bắt buộc, chuỗi ký tự từ 3 đến 150 ký tự.<br>**3.** Nhập **Kết quả Chẩn đoán bệnh** : Bắt buộc, chuỗi ký tự từ 3 đến 250 ký tự (ví dụ: "Thoái hóa khớp gối độ 2", "Viêm phế quản mạn tính").<br>**4.** Chọn **Ngày khám bệnh** : Bắt buộc, ngày tháng năm (Ràng buộc logic: Từ năm 2000 đến hiện tại, không được chọn ngày trong tương lai: từ năm 2000 đến hiện tại).<br>**5.** Nhập **Bác sĩ điều trị** : Tùy chọn, chuỗi từ 2 đến 100 ký tự.<br>**6.** Nhập **Chỉ định / Tóm tắt đơn thuốc** : Tùy chọn, tối đa 500 ký tự.<br>**7.** Người dùng nhấn nút "Lưu hồ sơ bệnh án".<br>**8.** Hệ thống kiểm tra hợp lệ toàn bộ dữ liệu, tạo tài liệu trong hồ sơ bệnh án theo đúng người cao tuổi và điều hướng sang màn hình xem hồ sơ chi tiết (gợi ý đính kèm ảnh tài liệu). |
| **Ngoại lệ** | **E1 (Bệnh viện hoặc Chẩn đoán để trống):** Báo lỗi *\"Vui lòng nhập đầy đủ tên bệnh viện và kết quả chẩn đoán bệnh!\"*.<br>**E2 (Ngày khám trong tương lai):** ngày khám ở tương lai -> Báo lỗi *\"Ngày khám bệnh không được lớn hơn ngày hiện tại!\"*.<br>**E3 (Ngày khám quá cũ trước năm 2000):** ngày khám trước năm 2000 -> Báo lỗi *\"Năm khám bệnh phải từ năm 2000 trở lại đây!\"*. |

---

### Bảng đặc tả Use Case: UC20 - Quản lý tài liệu đính kèm

| Trường thông tin | Nội dung chi tiết |
| :--- | :--- |
| **UsecaseID** | **UC20** |
| **Tên usecase** | **Quản lý tài liệu đính kèm** |
| **Tác nhân** | Con cái / Người thân, Người cao tuổi |
| **Tiền điều kiện** | Đang mở một hồ sơ y tế cụ thể trong hệ thống (từ UC19). |
| **Luồng sự kiện chính** | **1.** Người dùng nhấn nút "Đính kèm tài liệu / Hình ảnh xét nghiệm" .<br>**2.** Chọn nguồn tệp: "Chụp ảnh mới bằng Camera" hoặc "Chọn tệp ảnh/PDF từ Thư viện máy".<br>**3.** Hệ thống kiểm tra các ràng buộc kỹ thuật của tệp:<br>- Định dạng tệp cho phép: `image/jpeg`, `image/png`, `application/pdf`.<br>- Dung lượng tệp tối đa: $\le 10$ MB/tệp.<br>**4.** Nhập **Tên / Chú thích tài liệu** : Tùy chọn, tối đa 100 ký tự (ví dụ: "Ảnh chụp X-Quang khớp gối", "Hóa đơn xét nghiệm máu").<br>**5.** Người dùng nhấn nút "Tải lên".<br>**6.** Hệ thống tự động nén tối ưu hóa hình ảnh và tải tệp lên hệ thống lưu trữ đám mây theo đường dẫn hệ thống lưu trữ tệp đính kèm.<br>**7.** Hệ thống nhận đường link URL tải an toàn và ghi thông tin tệp vào mảng danh sách `attachments` trong tài liệu hồ sơ bệnh án.<br>**8.** Hiển thị hình ảnh xem trước (ảnh thu nhỏ) trên giao diện; cho phép người dùng bấm vào xem phóng to toàn màn hình hoặc bấm nút Xóa tài liệu khi cần. |
| **Ngoại lệ** | **E1 (Định dạng tệp không được hỗ trợ):** Chọn tệp `.doc`, `.zip`, `.exe`... -> Báo lỗi *\"Định dạng tệp không được hỗ trợ. Ứng dụng chỉ chấp nhận tệp ảnh JPG, PNG hoặc tài liệu PDF!\"*.<br>**E2 (Dung lượng tệp vượt quá 10MB):** Báo lỗi *\"Dung lượng tệp vượt quá giới hạn 10MB. Vui lòng chọn tệp nhỏ hơn hoặc giảm kích thước ảnh!\"*.<br>**E3 (Lỗi tải lên do mất kết nối mạng):** Báo lỗi *\"Tải tài liệu thất bại do gián đoạn kết nối mạng. Vui lòng thử lại!\"*. |

---

### Bảng đặc tả Use Case: UC21 - Tra cứu lịch sử khám bệnh

| Trường thông tin | Nội dung chi tiết |
| :--- | :--- |
| **UsecaseID** | **UC21** |
| **Tên usecase** | **Tra cứu lịch sử khám bệnh** |
| **Tác nhân** | Người cao tuổi, Con cái / Người thân |
| **Tiền điều kiện** | Người dùng đã đăng nhập; Hồ sơ người cao tuổi đã có dữ liệu bệnh án trong hệ thống. |
| **Luồng sự kiện chính** | **1.** Người dùng truy cập chức năng "Sổ theo dõi khám bệnh" .<br>**2.** Nhập **Từ khóa tìm kiếm** : Tùy chọn, chuỗi ký tự từ 1 đến 50 ký tự (tìm kiếm tương đối theo tên bệnh viện, tên bác sĩ, hoặc tên chẩn đoán bệnh).<br>**3.** Chọn **Bộ lọc theo năm khám** : Chọn "Tất cả các năm" hoặc chọn một năm cụ thể (từ năm 2020 đến nay).<br>**4.** Hệ thống thực hiện truy vấn và lọc các bản ghi hồ sơ bệnh án tương ứng theo người cao tuổi, sắp xếp giảm dần theo ngày khám bệnh (mới nhất lên đầu).<br>**5.** Hệ thống hiển thị danh sách kết quả trực quan dạng thẻ tóm tắt: Ngày khám, Tên bệnh viện, Chẩn đoán bệnh, Tên bác sĩ và số lượng hình ảnh/tài liệu đính kèm.<br>**6.** Người dùng chạm vào một thẻ hồ sơ bất kỳ để mở xem toàn bộ chi tiết bệnh án và đơn thuốc đính kèm. |
| **Ngoại lệ** | **E1 (Từ khóa tìm kiếm chứa ký tự đặc biệt nguy hiểm):** Hệ thống tự động lọc bỏ các ký tự đặc biệt để ngăn chặn lỗi tìm kiếm.<br>**E2 (Không có kết quả phù hợp):** Hệ thống hiển thị thông báo *\"Không tìm thấy hồ sơ y tế nào phù hợp với từ khóa '[searchQuery]'. Vui lòng thử lại với từ khóa khác!\"* kèm nút xóa bộ lọc. |
