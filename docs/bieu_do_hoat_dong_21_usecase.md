# TOÀN BỘ 21 BIỂU ĐỒ HOẠT ĐỘNG (UML ACTIVITY DIAGRAM)
## DỰ ÁN: ỨNG DỤNG CHĂM SÓC NGƯỜI CAO TUỔI (GERIATRICCARE)
### Chuẩn hóa theo mẫu đồ án: Phân làn 2 cột (Người dùng - Hệ thống), rẽ nhánh xác nhận/huỷ, kiểm tra true/false

---

### UC01: Đăng ký tài khoản
*File PlantUML:* [`UC01_DangKy.puml`](file:///d:/Android/Project/Geriatriccare/docs/plantuml/activity_21_usecases/UC01_DangKy.puml)

```plantuml
@startuml Activity_UC01_DangKy
skinparam backgroundColor #FFFFFF
skinparam defaultTextAlignment center
skinparam roundCorner 10
skinparam arrowColor #000000
skinparam arrowFontSize 11
skinparam activityBorderColor #000000
skinparam activityBackgroundColor #FFFFFF
skinparam activityDiamondBorderColor #000000
skinparam activityDiamondBackgroundColor #FFFFFF

title UC01: Đăng ký tài khoản

|Người dùng|
start
:Chọn đăng ký;

|Hệ thống|
label form_UC01
:Hiển thị form đăng ký;

|Người dùng|
:Điền thông tin cá nhân (SĐT, Email, PIN, Họ tên, Vai trò);

if (xác nhận?) then (huỷ)
  |Hệ thống|
  stop
else (xác nhận)
  |Hệ thống|
  if (kiểm tra) then (false)
    :Thông báo lỗi thông tin hoặc mã OTP;
    goto form_UC01
  else (true)
    :Tạo tài khoản Firebase Auth & lưu Firestore;
    :Thông báo đăng ký thành công;
    stop
  endif
endif
@enduml
```

---

### UC02: Đăng nhập
*File PlantUML:* [`UC02_DangNhap.puml`](file:///d:/Android/Project/Geriatriccare/docs/plantuml/activity_21_usecases/UC02_DangNhap.puml)

```plantuml
@startuml Activity_UC02_DangNhap
skinparam backgroundColor #FFFFFF
skinparam defaultTextAlignment center
skinparam roundCorner 10
skinparam arrowColor #000000
skinparam arrowFontSize 11
skinparam activityBorderColor #000000
skinparam activityBackgroundColor #FFFFFF
skinparam activityDiamondBorderColor #000000
skinparam activityDiamondBackgroundColor #FFFFFF

title UC02: Đăng nhập

|Người dùng|
start
:Chọn đăng nhập;

|Hệ thống|
label form_UC02
:Hiển thị form đăng nhập;

|Người dùng|
:Điền số điện thoại và mật khẩu PIN;

if (xác nhận?) then (huỷ)
  |Hệ thống|
  stop
else (xác nhận)
  |Hệ thống|
  if (kiểm tra) then (false)
    :Thông báo tài khoản hoặc mật khẩu không đúng;
    goto form_UC02
  else (true)
    :Xác thực Firebase Auth & lưu phiên làm việc;
    :Thông báo đăng nhập thành công, mở màn hình chính;
    stop
  endif
endif
@enduml
```

---

### UC03: Đăng xuất
*File PlantUML:* [`UC03_DangXuat.puml`](file:///d:/Android/Project/Geriatriccare/docs/plantuml/activity_21_usecases/UC03_DangXuat.puml)

```plantuml
@startuml Activity_UC03_DangXuat
skinparam backgroundColor #FFFFFF
skinparam defaultTextAlignment center
skinparam roundCorner 10
skinparam arrowColor #000000
skinparam arrowFontSize 11
skinparam activityBorderColor #000000
skinparam activityBackgroundColor #FFFFFF
skinparam activityDiamondBorderColor #000000
skinparam activityDiamondBackgroundColor #FFFFFF

title UC03: Đăng xuất

|Người dùng|
start
:Chọn đăng xuất;

|Hệ thống|
label form_UC03
:Hiển thị hộp thoại xác nhận đăng xuất;

|Người dùng|
:Xác nhận thao tác đăng xuất;

if (xác nhận?) then (huỷ)
  |Hệ thống|
  stop
else (xác nhận)
  |Hệ thống|
  if (kiểm tra) then (false)
    :Thông báo lỗi kết nối máy chủ;
    goto form_UC03
  else (true)
    :Hủy listeners, xóa token FCM & signOut;
    :Thông báo đăng xuất thành công, về màn hình đăng nhập;
    stop
  endif
endif
@enduml
```

---

### UC04: Gửi cảnh báo SOS
*File PlantUML:* [`UC04_GuiCanhBaoSOS.puml`](file:///d:/Android/Project/Geriatriccare/docs/plantuml/activity_21_usecases/UC04_GuiCanhBaoSOS.puml)

```plantuml
@startuml Activity_UC04_GuiCanhBaoSOS
skinparam backgroundColor #FFFFFF
skinparam defaultTextAlignment center
skinparam roundCorner 10
skinparam arrowColor #000000
skinparam arrowFontSize 11
skinparam activityBorderColor #000000
skinparam activityBackgroundColor #FFFFFF
skinparam activityDiamondBorderColor #000000
skinparam activityDiamondBackgroundColor #FFFFFF

title UC04: Gửi cảnh báo SOS

|Người cao tuổi|
start
:Chọn phát cảnh báo SOS (Bấm nút SOS / Cảm biến ngã);

|Hệ thống|
label form_UC04
:Hiển thị màn hình đếm ngược 15s và phát còi hú;

|Người cao tuổi|
:Xác nhận tình trạng khẩn cấp;

if (xác nhận?) then (huỷ)
  |Hệ thống|
  stop
else (xác nhận)
  |Hệ thống|
  if (kiểm tra) then (false)
    :Thông báo mất tín hiệu GPS, lấy vị trí gần nhất;
    goto form_UC04
  else (true)
    :Tạo EmergencyAlert Firestore & kích hoạt FCM;
    :Thông báo đã gửi cảnh báo SOS khẩn cấp tới người thân;
    stop
  endif
endif
@enduml
```

---

### UC05: Tiếp nhận cảnh báo
*File PlantUML:* [`UC05_TiepNhanCanhBao.puml`](file:///d:/Android/Project/Geriatriccare/docs/plantuml/activity_21_usecases/UC05_TiepNhanCanhBao.puml)

```plantuml
@startuml Activity_UC05_TiepNhanCanhBao
skinparam backgroundColor #FFFFFF
skinparam defaultTextAlignment center
skinparam roundCorner 10
skinparam arrowColor #000000
skinparam arrowFontSize 11
skinparam activityBorderColor #000000
skinparam activityBackgroundColor #FFFFFF
skinparam activityDiamondBorderColor #000000
skinparam activityDiamondBackgroundColor #FFFFFF

title UC05: Tiếp nhận cảnh báo

|Con cái / Người thân|
start
:Chọn tiếp nhận cảnh báo (Chạm thông báo FCM);

|Hệ thống|
label form_UC05
:Hiển thị màn hình chi tiết cảnh báo và vị trí bản đồ;

|Con cái / Người thân|
:Chọn thao tác hỗ trợ (Gọi điện thoại / Chỉ đường);

if (xác nhận?) then (huỷ)
  |Hệ thống|
  stop
else (xác nhận)
  |Hệ thống|
  if (kiểm tra) then (false)
    :Thông báo cảnh báo đã được thành viên khác xử lý;
    goto form_UC05
  else (true)
    :Cập nhật trạng thái đã tiếp nhận cảnh báo;
    :Mở bản đồ chỉ đường và kích hoạt cuộc gọi hỗ trợ;
    stop
  endif
endif
@enduml
```

---

### UC06: Xử lý cảnh báo
*File PlantUML:* [`UC06_XuLyCanhBao.puml`](file:///d:/Android/Project/Geriatriccare/docs/plantuml/activity_21_usecases/UC06_XuLyCanhBao.puml)

```plantuml
@startuml Activity_UC06_XuLyCanhBao
skinparam backgroundColor #FFFFFF
skinparam defaultTextAlignment center
skinparam roundCorner 10
skinparam arrowColor #000000
skinparam arrowFontSize 11
skinparam activityBorderColor #000000
skinparam activityBackgroundColor #FFFFFF
skinparam activityDiamondBorderColor #000000
skinparam activityDiamondBackgroundColor #FFFFFF

title UC06: Xử lý cảnh báo

|Con cái / Người thân|
start
:Chọn Cập nhật xử lý tình huống;

|Hệ thống|
label form_UC06
:Hiển thị form kết luận xử lý tình huống;

|Con cái / Người thân|
:Điền kết luận xử lý (safe/hospitalized/false_alarm) và ghi chú;

if (xác nhận?) then (huỷ)
  |Hệ thống|
  stop
else (xác nhận)
  |Hệ thống|
  if (kiểm tra) then (false)
    :Thông báo chưa chọn kết luận hoặc ghi chú quá dài;
    goto form_UC06
  else (true)
    :Cập nhật status: resolved và tắt còi hú máy cha mẹ;
    :Thông báo hoàn tất xử lý tình huống an toàn;
    stop
  endif
endif
@enduml
```

---

### UC07: Ghi chỉ số huyết áp
*File PlantUML:* [`UC07_GhiChiSoHuyetAp.puml`](file:///d:/Android/Project/Geriatriccare/docs/plantuml/activity_21_usecases/UC07_GhiChiSoHuyetAp.puml)

```plantuml
@startuml Activity_UC07_GhiChiSoHuyetAp
skinparam backgroundColor #FFFFFF
skinparam defaultTextAlignment center
skinparam roundCorner 10
skinparam arrowColor #000000
skinparam arrowFontSize 11
skinparam activityBorderColor #000000
skinparam activityBackgroundColor #FFFFFF
skinparam activityDiamondBorderColor #000000
skinparam activityDiamondBackgroundColor #FFFFFF

title UC07: Ghi chỉ số huyết áp

|Người dùng|
start
:Chọn Ghi nhận huyết áp;

|Hệ thống|
label form_UC07
:Hiển thị form đo huyết áp;

|Người dùng|
:Điền chỉ số Tâm thu, Tâm trương, Nhịp tim, Ghi chú;

if (xác nhận?) then (huỷ)
  |Hệ thống|
  stop
else (xác nhận)
  |Hệ thống|
  if (kiểm tra) then (false)
    :Thông báo chỉ số đo không hợp lệ hoặc sai logic;
    goto form_UC07
  else (true)
    :Lưu bản ghi vào Firestore & phân loại WHO/AHA;
    :Thông báo lưu kết quả thành công và hiển thị phân loại;
    stop
  endif
endif
@enduml
```

---

### UC08: Theo dõi lịch sử huyết áp
*File PlantUML:* [`UC08_TheoDoiLichSuHuyetAp.puml`](file:///d:/Android/Project/Geriatriccare/docs/plantuml/activity_21_usecases/UC08_TheoDoiLichSuHuyetAp.puml)

```plantuml
@startuml Activity_UC08_TheoDoiLichSuHuyetAp
skinparam backgroundColor #FFFFFF
skinparam defaultTextAlignment center
skinparam roundCorner 10
skinparam arrowColor #000000
skinparam arrowFontSize 11
skinparam activityBorderColor #000000
skinparam activityBackgroundColor #FFFFFF
skinparam activityDiamondBorderColor #000000
skinparam activityDiamondBackgroundColor #FFFFFF

title UC08: Theo dõi lịch sử huyết áp

|Người dùng|
start
:Chọn Xem lịch sử huyết áp;

|Hệ thống|
label form_UC08
:Hiển thị giao diện bộ lọc thời gian;

|Người dùng|
:Điền/chọn khoảng thời gian (7 ngày, 30 ngày, tùy chọn);

if (xác nhận?) then (huỷ)
  |Hệ thống|
  stop
else (xác nhận)
  |Hệ thống|
  if (kiểm tra) then (false)
    :Thông báo ngày bắt đầu lớn hơn ngày kết thúc;
    goto form_UC08
  else (true)
    :Truy vấn Firestore & tính toán chỉ số trung bình;
    :Hiển thị biểu đồ đường xu hướng và danh sách đo;
    stop
  endif
endif
@enduml
```

---

### UC09: Cảnh báo chỉ số bất thường
*File PlantUML:* [`UC09_CanhBaoChiSoBatThuong.puml`](file:///d:/Android/Project/Geriatriccare/docs/plantuml/activity_21_usecases/UC09_CanhBaoChiSoBatThuong.puml)

```plantuml
@startuml Activity_UC09_CanhBaoChiSoBatThuong
skinparam backgroundColor #FFFFFF
skinparam defaultTextAlignment center
skinparam roundCorner 10
skinparam arrowColor #000000
skinparam arrowFontSize 11
skinparam activityBorderColor #000000
skinparam activityBackgroundColor #FFFFFF
skinparam activityDiamondBorderColor #000000
skinparam activityDiamondBackgroundColor #FFFFFF

title UC09: Cảnh báo chỉ số bất thường

|Người dùng|
start
:Lưu số đo huyết áp mới vào hệ thống;

|Hệ thống|
label form_UC09
:Hiển thị màn hình đánh giá kết quả đo;

|Người dùng|
:Xác nhận xem phân tích rủi ro y tế;

if (xác nhận?) then (huỷ)
  |Hệ thống|
  stop
else (xác nhận)
  |Hệ thống|
  if (kiểm tra) then (false)
    :Thông báo chỉ số đo nằm trong ngưỡng an toàn;
    goto form_UC09
  else (true)
    :Tạo thông báo cảnh báo & gửi Push FCM tới con cái;
    :Thông báo gửi cảnh báo đỏ và hiển thị chỉ dẫn y tế tại chỗ;
    stop
  endif
endif
@enduml
```

---

### UC10: Thiết lập lịch uống thuốc
*File PlantUML:* [`UC10_ThietLapLichUongThuoc.puml`](file:///d:/Android/Project/Geriatriccare/docs/plantuml/activity_21_usecases/UC10_ThietLapLichUongThuoc.puml)

```plantuml
@startuml Activity_UC10_ThietLapLichUongThuoc
skinparam backgroundColor #FFFFFF
skinparam defaultTextAlignment center
skinparam roundCorner 10
skinparam arrowColor #000000
skinparam arrowFontSize 11
skinparam activityBorderColor #000000
skinparam activityBackgroundColor #FFFFFF
skinparam activityDiamondBorderColor #000000
skinparam activityDiamondBackgroundColor #FFFFFF

title UC10: Thiết lập lịch uống thuốc

|Người dùng|
start
:Chọn Thêm lịch uống thuốc;

|Hệ thống|
label form_UC10
:Hiển thị form thiết lập lịch thuốc;

|Người dùng|
:Điền tên thuốc, liều lượng, giờ nhắc, ngày uống;

if (xác nhận?) then (huỷ)
  |Hệ thống|
  stop
else (xác nhận)
  |Hệ thống|
  if (kiểm tra) then (false)
    :Thông báo thiếu thông tin hoặc ngày kết thúc sai;
    goto form_UC10
  else (true)
    :Lưu Firestore medication_schedules & đặt báo thức Local Alarm;
    :Thông báo thiết lập lịch uống thuốc thành công;
    stop
  endif
endif
@enduml
```

---

### UC11: Nhắc nhở và theo dõi theo ngày
*File PlantUML:* [`UC11_NhacNhoTheoDoiTheoNgay.puml`](file:///d:/Android/Project/Geriatriccare/docs/plantuml/activity_21_usecases/UC11_NhacNhoTheoDoiTheoNgay.puml)

```plantuml
@startuml Activity_UC11_NhacNhoTheoDoiTheoNgay
skinparam backgroundColor #FFFFFF
skinparam defaultTextAlignment center
skinparam roundCorner 10
skinparam arrowColor #000000
skinparam arrowFontSize 11
skinparam activityBorderColor #000000
skinparam activityBackgroundColor #FFFFFF
skinparam activityDiamondBorderColor #000000
skinparam activityDiamondBackgroundColor #FFFFFF

title UC11: Nhắc nhở và theo dõi theo ngày

|Người cao tuổi|
start
:Mở ứng dụng khi có chuông báo thuốc;

|Hệ thống|
label form_UC11
:Hiển thị danh sách cữ thuốc hôm nay;

|Người cao tuổi|
:Chọn xem chi tiết cữ thuốc cần uống;

if (xác nhận?) then (huỷ)
  |Hệ thống|
  stop
else (xác nhận)
  |Hệ thống|
  if (kiểm tra) then (false)
    :Thông báo chưa có lịch uống thuốc trong ngày;
    goto form_UC11
  else (true)
    :Tải thông tin liều lượng & hướng dẫn trước/sau ăn;
    :Hiển thị chi tiết cữ thuốc và đồng bộ máy con cái;
    stop
  endif
endif
@enduml
```

---

### UC12: Ghi nhận nhật ký uống thuốc
*File PlantUML:* [`UC12_GhiNhanNhatKyUongThuoc.puml`](file:///d:/Android/Project/Geriatriccare/docs/plantuml/activity_21_usecases/UC12_GhiNhanNhatKyUongThuoc.puml)

```plantuml
@startuml Activity_UC12_GhiNhanNhatKyUongThuoc
skinparam backgroundColor #FFFFFF
skinparam defaultTextAlignment center
skinparam roundCorner 10
skinparam arrowColor #000000
skinparam arrowFontSize 11
skinparam activityBorderColor #000000
skinparam activityBackgroundColor #FFFFFF
skinparam activityDiamondBorderColor #000000
skinparam activityDiamondBackgroundColor #FFFFFF

title UC12: Ghi nhận nhật ký uống thuốc

|Người cao tuổi|
start
:Chọn cữ thuốc đang chờ uống;

|Hệ thống|
label form_UC12
:Hiển thị popup xác nhận: Đã uống hoặc Bỏ qua;

|Người cao tuổi|
:Điền xác nhận Đã uống (hoặc Bỏ qua và nhập lý do);

if (xác nhận?) then (huỷ)
  |Hệ thống|
  stop
else (xác nhận)
  |Hệ thống|
  if (kiểm tra) then (false)
    :Thông báo chưa điền lý do khi chọn bỏ qua cữ thuốc;
    goto form_UC12
  else (true)
    :Cập nhật status taken/skipped & tính tỷ lệ tuân thủ;
    :Thông báo ghi nhận nhật ký uống thuốc thành công;
    stop
  endif
endif
@enduml
```

---

### UC13: Gửi và phản hồi yêu cầu liên kết
*File PlantUML:* [`UC13_GuiPhanHoiYeuCauLienKet.puml`](file:///d:/Android/Project/Geriatriccare/docs/plantuml/activity_21_usecases/UC13_GuiPhanHoiYeuCauLienKet.puml)

```plantuml
@startuml Activity_UC13_GuiPhanHoiYeuCauLienKet
skinparam backgroundColor #FFFFFF
skinparam defaultTextAlignment center
skinparam roundCorner 10
skinparam arrowColor #000000
skinparam arrowFontSize 11
skinparam activityBorderColor #000000
skinparam activityBackgroundColor #FFFFFF
skinparam activityDiamondBorderColor #000000
skinparam activityDiamondBackgroundColor #FFFFFF

title UC13: Gửi và phản hồi yêu cầu liên kết

|Con cái / Người thân|
start
:Chọn Thêm liên kết người thân;

|Hệ thống|
label form_UC13
:Hiển thị form nhập thông tin liên kết;

|Con cái / Người thân|
:Điền SĐT người cao tuổi và chọn mối quan hệ;

if (xác nhận?) then (huỷ)
  |Hệ thống|
  stop
else (xác nhận)
  |Hệ thống|
  if (kiểm tra) then (false)
    :Thông báo SĐT không tồn tại hoặc đã liên kết;
    goto form_UC13
  else (true)
    :Tạo yêu cầu family_links & gửi Push tới cha mẹ;
    :Thông báo gửi lời mời liên kết thành công;
    stop
  endif
endif
@enduml
```

---

### UC14: Quản lý danh sách người thân
*File PlantUML:* [`UC14_QuanLyDanhSachNguoiThan.puml`](file:///d:/Android/Project/Geriatriccare/docs/plantuml/activity_21_usecases/UC14_QuanLyDanhSachNguoiThan.puml)

```plantuml
@startuml Activity_UC14_QuanLyDanhSachNguoiThan
skinparam backgroundColor #FFFFFF
skinparam defaultTextAlignment center
skinparam roundCorner 10
skinparam arrowColor #000000
skinparam arrowFontSize 11
skinparam activityBorderColor #000000
skinparam activityBackgroundColor #FFFFFF
skinparam activityDiamondBorderColor #000000
skinparam activityDiamondBackgroundColor #FFFFFF

title UC14: Quản lý danh sách người thân

|Người dùng|
start
:Chọn Danh sách người thân đã liên kết;

|Hệ thống|
label form_UC14
:Hiển thị danh sách thành viên gia đình;

|Người dùng|
:Chọn thành viên để đổi biệt danh hoặc hủy liên kết;

if (xác nhận?) then (huỷ)
  |Hệ thống|
  stop
else (xác nhận)
  |Hệ thống|
  if (kiểm tra) then (false)
    :Thông báo lỗi không thể cập nhật liên kết;
    goto form_UC14
  else (true)
    :Cập nhật biệt danh hoặc hủy liên kết 2 chiều;
    :Thông báo cập nhật danh sách người thân thành công;
    stop
  endif
endif
@enduml
```

---

### UC15: Liên hệ khẩn cấp
*File PlantUML:* [`UC15_LienHeKhanCap.puml`](file:///d:/Android/Project/Geriatriccare/docs/plantuml/activity_21_usecases/UC15_LienHeKhanCap.puml)

```plantuml
@startuml Activity_UC15_LienHeKhanCap
skinparam backgroundColor #FFFFFF
skinparam defaultTextAlignment center
skinparam roundCorner 10
skinparam arrowColor #000000
skinparam arrowFontSize 11
skinparam activityBorderColor #000000
skinparam activityBackgroundColor #FFFFFF
skinparam activityDiamondBorderColor #000000
skinparam activityDiamondBackgroundColor #FFFFFF

title UC15: Liên hệ khẩn cấp

|Người cao tuổi|
start
:Vào mục Danh bạ khẩn cấp;

|Hệ thống|
label form_UC15
:Hiển thị danh sách nút gọi nhanh người thân và 115;

|Người cao tuổi|
:Chọn nút gọi người thân mong muốn (hoặc 115);

if (xác nhận?) then (huỷ)
  |Hệ thống|
  stop
else (xác nhận)
  |Hệ thống|
  if (kiểm tra) then (false)
    :Thông báo số điện thoại không hợp lệ hoặc chưa cài;
    goto form_UC15
  else (true)
    :Khởi chạy trình quay số hệ thống tel:09xxxxxxxx;
    :Thông báo thực hiện cuộc gọi đàm thoại trực tiếp;
    stop
  endif
endif
@enduml
```

---

### UC16: Tạo lịch khám sức khỏe
*File PlantUML:* [`UC16_TaoLichKhamSucKhoe.puml`](file:///d:/Android/Project/Geriatriccare/docs/plantuml/activity_21_usecases/UC16_TaoLichKhamSucKhoe.puml)

```plantuml
@startuml Activity_UC16_TaoLichKhamSucKhoe
skinparam backgroundColor #FFFFFF
skinparam defaultTextAlignment center
skinparam roundCorner 10
skinparam arrowColor #000000
skinparam arrowFontSize 11
skinparam activityBorderColor #000000
skinparam activityBackgroundColor #FFFFFF
skinparam activityDiamondBorderColor #000000
skinparam activityDiamondBackgroundColor #FFFFFF

title UC16: Tạo lịch khám sức khỏe

|Người dùng|
start
:Chọn Tạo lịch khám bệnh mới;

|Hệ thống|
label form_UC16
:Hiển thị form tạo lịch khám bệnh;

|Người dùng|
:Điền Tiêu đề, Bệnh viện, Bác sĩ, Thời gian khám;

if (xác nhận?) then (huỷ)
  |Hệ thống|
  stop
else (xác nhận)
  |Hệ thống|
  if (kiểm tra) then (false)
    :Thông báo thiếu thông tin hoặc thời gian quá khứ;
    goto form_UC16
  else (true)
    :Lưu Firestore medical_appointments & đồng bộ gia đình;
    :Thông báo tạo lịch khám sức khỏe thành công;
    stop
  endif
endif
@enduml
```

---

### UC17: Điều phối người đưa đi khám
*File PlantUML:* [`UC17_DieuPhoiNguoiDuaDiKham.puml`](file:///d:/Android/Project/Geriatriccare/docs/plantuml/activity_21_usecases/UC17_DieuPhoiNguoiDuaDiKham.puml)

```plantuml
@startuml Activity_UC17_DieuPhoiNguoiDuaDiKham
skinparam backgroundColor #FFFFFF
skinparam defaultTextAlignment center
skinparam roundCorner 10
skinparam arrowColor #000000
skinparam arrowFontSize 11
skinparam activityBorderColor #000000
skinparam activityBackgroundColor #FFFFFF
skinparam activityDiamondBorderColor #000000
skinparam activityDiamondBackgroundColor #FFFFFF

title UC17: Điều phối người đưa đi khám

|Con cái / Người thân|
start
:Mở chi tiết lịch khám bệnh của cha mẹ;

|Hệ thống|
label form_UC17
:Hiển thị form phân công người đưa đi khám;

|Con cái / Người thân|
:Chọn thành viên phụ trách và điền ghi chú di chuyển;

if (xác nhận?) then (huỷ)
  |Hệ thống|
  stop
else (xác nhận)
  |Hệ thống|
  if (kiểm tra) then (false)
    :Thông báo chưa chọn người đưa đi khám;
    goto form_UC17
  else (true)
    :Cập nhật assignedCaregiverId & gửi thông báo cho con;
    :Thông báo điều phối người đưa đi khám thành công;
    stop
  endif
endif
@enduml
```

---

### UC18: Xác nhận hoàn tất lịch khám
*File PlantUML:* [`UC18_XacNhanHoanTatLichKham.puml`](file:///d:/Android/Project/Geriatriccare/docs/plantuml/activity_21_usecases/UC18_XacNhanHoanTatLichKham.puml)

```plantuml
@startuml Activity_UC18_XacNhanHoanTatLichKham
skinparam backgroundColor #FFFFFF
skinparam defaultTextAlignment center
skinparam roundCorner 10
skinparam arrowColor #000000
skinparam arrowFontSize 11
skinparam activityBorderColor #000000
skinparam activityBackgroundColor #FFFFFF
skinparam activityDiamondBorderColor #000000
skinparam activityDiamondBackgroundColor #FFFFFF

title UC18: Xác nhận hoàn tất lịch khám

|Người dùng|
start
:Chọn Xác nhận hoàn tất buổi khám;

|Hệ thống|
label form_UC18
:Hiển thị form ghi nhận kết quả khám bệnh;

|Người dùng|
:Điền kết luận của bác sĩ và chọn ngày tái khám;

if (xác nhận?) then (huỷ)
  |Hệ thống|
  stop
else (xác nhận)
  |Hệ thống|
  if (kiểm tra) then (false)
    :Thông báo ngày hẹn tái khám không hợp lệ;
    goto form_UC18
  else (true)
    :Cập nhật status: completed & tạo gợi ý lịch tái khám;
    :Thông báo hoàn tất buổi khám bệnh thành công;
    stop
  endif
endif
@enduml
```

---

### UC19: Lưu hồ sơ y tế
*File PlantUML:* [`UC19_LuuHoSoYTe.puml`](file:///d:/Android/Project/Geriatriccare/docs/plantuml/activity_21_usecases/UC19_LuuHoSoYTe.puml)

```plantuml
@startuml Activity_UC19_LuuHoSoYTe
skinparam backgroundColor #FFFFFF
skinparam defaultTextAlignment center
skinparam roundCorner 10
skinparam arrowColor #000000
skinparam arrowFontSize 11
skinparam activityBorderColor #000000
skinparam activityBackgroundColor #FFFFFF
skinparam activityDiamondBorderColor #000000
skinparam activityDiamondBackgroundColor #FFFFFF

title UC19: Lưu hồ sơ y tế

|Người dùng|
start
:Chọn Tạo hồ sơ bệnh án mới;

|Hệ thống|
label form_UC19
:Hiển thị form nhập hồ sơ y tế;

|Người dùng|
:Điền Bệnh viện, Chẩn đoán, Ngày khám, Bác sĩ, Đơn thuốc;

if (xác nhận?) then (huỷ)
  |Hệ thống|
  stop
else (xác nhận)
  |Hệ thống|
  if (kiểm tra) then (false)
    :Thông báo thiếu chẩn đoán hoặc ngày khám tương lai;
    goto form_UC19
  else (true)
    :Lưu bản ghi vào Firestore medical_records/id;
    :Thông báo lưu hồ sơ bệnh án thành công;
    stop
  endif
endif
@enduml
```

---

### UC20: Quản lý tài liệu đính kèm
*File PlantUML:* [`UC20_QuanLyTaiLieuDinhKem.puml`](file:///d:/Android/Project/Geriatriccare/docs/plantuml/activity_21_usecases/UC20_QuanLyTaiLieuDinhKem.puml)

```plantuml
@startuml Activity_UC20_QuanLyTaiLieuDinhKem
skinparam backgroundColor #FFFFFF
skinparam defaultTextAlignment center
skinparam roundCorner 10
skinparam arrowColor #000000
skinparam arrowFontSize 11
skinparam activityBorderColor #000000
skinparam activityBackgroundColor #FFFFFF
skinparam activityDiamondBorderColor #000000
skinparam activityDiamondBackgroundColor #FFFFFF

title UC20: Quản lý tài liệu đính kèm

|Người dùng|
start
:Chọn Đính kèm tài liệu / Ảnh xét nghiệm;

|Hệ thống|
label form_UC20
:Hiển thị bộ chọn tệp máy ảnh / thư viện;

|Người dùng|
:Chọn tệp ảnh/PDF và điền mô tả tài liệu;

if (xác nhận?) then (huỷ)
  |Hệ thống|
  stop
else (xác nhận)
  |Hệ thống|
  if (kiểm tra) then (false)
    :Thông báo tệp không hợp lệ hoặc dung lượng quá lớn;
    goto form_UC20
  else (true)
    :Nén ảnh, tải Firebase Storage & cập nhật Firestore;
    :Thông báo tải lên tài liệu đính kèm thành công;
    stop
  endif
endif
@enduml
```

---

### UC21: Tra cứu lịch sử khám bệnh
*File PlantUML:* [`UC21_TraCuuLichSuKhamBenh.puml`](file:///d:/Android/Project/Geriatriccare/docs/plantuml/activity_21_usecases/UC21_TraCuuLichSuKhamBenh.puml)

```plantuml
@startuml Activity_UC21_TraCuuLichSuKhamBenh
skinparam backgroundColor #FFFFFF
skinparam defaultTextAlignment center
skinparam roundCorner 10
skinparam arrowColor #000000
skinparam arrowFontSize 11
skinparam activityBorderColor #000000
skinparam activityBackgroundColor #FFFFFF
skinparam activityDiamondBorderColor #000000
skinparam activityDiamondBackgroundColor #FFFFFF

title UC21: Tra cứu lịch sử khám bệnh

|Người dùng|
start
:Mở Sổ theo dõi khám bệnh / Lịch sử y tế;

|Hệ thống|
label form_UC21
:Hiển thị thanh tìm kiếm và bộ lọc năm khám;

|Người dùng|
:Điền từ khóa tìm kiếm và chọn năm khám;

if (xác nhận?) then (huỷ)
  |Hệ thống|
  stop
else (xác nhận)
  |Hệ thống|
  if (kiểm tra) then (false)
    :Thông báo không tìm thấy hồ sơ bệnh án phù hợp;
    goto form_UC21
  else (true)
    :Lọc kết quả & sắp xếp giảm dần theo ngày khám;
    :Hiển thị danh sách thẻ tóm tắt hồ sơ bệnh án;
    stop
  endif
endif
@enduml
```

---