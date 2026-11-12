# TRƯỜNG ĐẠI HỌC THỦY LỢI

## KHOA CÔNG NGHỆ THÔNG TIN

# BẢN TÓM TẮT ĐỀ CƯƠNG ĐỒ ÁN TỐT NGHIỆP

**Tên đề tài:** Xây dựng ứng dụng hỗ trợ chăm sóc sức khỏe người cao tuổi GeriatricCare

- **Sinh viên thực hiện:** [Điền họ và tên]
- **Lớp:** [Điền lớp]
- **Mã sinh viên:** [Điền mã sinh viên]
- **Số điện thoại:** [Điền số điện thoại]
- **Email:** [Điền email]
- **Giáo viên hướng dẫn:** [Điền họ và tên giảng viên]

## 1. Tóm tắt đề tài

Quá trình già hóa dân số đang làm gia tăng nhu cầu chăm sóc và theo dõi sức khỏe người cao tuổi. Tuy nhiên, việc chăm sóc hiện nay vẫn gặp nhiều khó khăn do người thân không phải lúc nào cũng có thể ở bên, đặc biệt khi phải làm việc hoặc sống xa. Trong gia đình có nhiều người con, thông tin chăm sóc thường được trao đổi rời rạc qua điện thoại hoặc tin nhắn, dẫn đến khó thống nhất ai sẽ đưa bố mẹ đi khám, khó theo dõi lịch tái khám và dễ bỏ sót hồ sơ y tế. Người cao tuổi cũng có thể quên lịch uống thuốc, chưa duy trì việc ghi nhận chỉ số sức khỏe hoặc gặp khó khăn khi sử dụng ứng dụng có giao diện phức tạp. Khi xảy ra tình huống khẩn cấp, việc thông báo chậm hoặc không xác định được vị trí kịp thời có thể làm giảm khả năng hỗ trợ.

Từ những vấn đề trên, đề tài xây dựng GeriatricCare — ứng dụng đa nền tảng tạo không gian chăm sóc chung cho gia đình. Một gia đình có thể gồm nhiều người cao tuổi và nhiều người thân cùng tham gia chăm sóc. Hệ thống hỗ trợ quản lý thành viên và quyền truy cập; theo dõi lịch sử khám bệnh; tạo lịch khám và phân công người đưa bố mẹ đi khám; lưu hồ sơ bằng cách nhập thủ công, tải tệp hoặc chụp ảnh; đồng thời hỗ trợ ghi nhận huyết áp, quản lý thuốc, nhắc bằng giọng nói, chia sẻ vị trí và gửi cảnh báo SOS.

Ứng dụng được phát triển bằng Flutter/Dart theo Clean Architecture và tích hợp Firebase để xác thực, lưu trữ, đồng bộ dữ liệu, quản lý tệp và gửi thông báo. Tài liệu ảnh hoặc PDF được lưu cùng hồ sơ gốc; dữ liệu trích xuất từ ảnh phải được người dùng kiểm tra trước khi trở thành thông tin chính thức. Sản phẩm hướng tới giao diện đơn giản cho người cao tuổi và khả năng phối hợp minh bạch, an toàn giữa các thành viên trong gia đình.

## 2. Các mục tiêu chính

1. Tìm hiểu và vận dụng các kiến thức, công nghệ và công cụ phục vụ phát triển hệ thống: lập trình hướng đối tượng, lập trình bất đồng bộ, quản lý trạng thái, cơ sở dữ liệu NoSQL, xác thực và phân quyền, điện toán đám mây, bảo mật dữ liệu, kiểm thử phần mềm; Flutter/Dart, Riverpod, Firebase Authentication, Cloud Firestore, Firebase Storage, Cloud Functions, Firebase Cloud Messaging, Clean Architecture, Git và các công cụ hỗ trợ phát triển ứng dụng.
2. Khảo sát bài toán chăm sóc người cao tuổi từ xa và xác định yêu cầu của hai nhóm người dùng: người cao tuổi và người thân/người chăm sóc.
3. Phân tích, thiết kế hệ thống theo Clean Architecture hướng tính năng, bảo đảm tách biệt lớp trình bày, nghiệp vụ và dữ liệu.
4. Xây dựng xác thực số điện thoại, hồ sơ người dùng và không gian gia đình gồm nhiều người được chăm sóc, nhiều người chăm sóc với quyền truy cập phù hợp.
5. Xây dựng lịch khám dùng chung; hỗ trợ phân công, nhận, từ chối, chuyển người phụ trách và lưu lịch sử thay đổi nhiệm vụ.
6. Xây dựng hồ sơ khám bệnh theo dòng thời gian, gồm thông tin lần khám, chẩn đoán, kết luận, đơn thuốc, kết quả xét nghiệm và lịch tái khám.
7. Hỗ trợ nhập hồ sơ thủ công, tải ảnh/PDF hoặc chụp ảnh; lưu tệp gốc và cho phép người dùng kiểm tra dữ liệu được trích xuất trước khi xác nhận.
8. Xây dựng chức năng ghi nhận huyết áp, quản lý lịch và lịch sử uống thuốc, thông báo cục bộ và lời nhắc bằng giọng nói.
9. Xây dựng chức năng SOS có đếm ngược, lấy vị trí và gửi thông báo đẩy đến các thành viên được cấp quyền.
10. Thiết lập quy tắc bảo mật Firebase, nhật ký thao tác và kiểm thử các nghiệp vụ cốt lõi, đặc biệt đối với dữ liệu y tế nhạy cảm.

## 3. Kết quả dự kiến

Kết quả dự kiến gồm một ứng dụng GeriatricCare chạy được trên Android và có thể mở rộng sang iOS, Web hoặc Desktop nhờ Flutter. Mã nguồn được tổ chức theo Clean Architecture và quản lý theo từng tính năng.

Hệ thống hoàn thiện các luồng chính:

- Đăng ký bằng email, xác thực email và đăng nhập bằng số điện thoại, mật khẩu.
- Tạo và quản lý không gian gia đình có nhiều người cao tuổi, nhiều người thân.
- Lựa chọn nhanh bố hoặc mẹ cần theo dõi.
- Tạo lịch khám, phân công người đưa đi, nhận hoặc chuyển nhiệm vụ.
- Theo dõi lịch sử khám bệnh theo dòng thời gian.
- Nhập hồ sơ bằng biểu mẫu, tải ảnh/PDF hoặc chụp ảnh trực tiếp.
- Lưu tài liệu gốc và xác nhận dữ liệu trích xuất trước khi sử dụng.
- Ghi nhận và theo dõi huyết áp.
- Quản lý lịch uống thuốc và lịch sử sử dụng thuốc.
- Gửi thông báo nhắc thuốc và phát lời nhắc bằng giọng nói.
- Gửi cảnh báo SOS kèm vị trí và thông báo đẩy.
- Chia sẻ, theo dõi vị trí người cao tuổi.
- Quản lý hồ sơ và cài đặt ứng dụng.

Sản phẩm bàn giao gồm mã nguồn ứng dụng, mô hình dữ liệu Cloud Firestore, kho tài liệu Firebase Storage, Cloud Functions, quy tắc bảo mật, bộ kiểm thử nghiệp vụ và tài liệu phân tích, thiết kế, hướng dẫn sử dụng. Phạm vi cốt lõi ưu tiên việc lưu và kiểm tra hồ sơ; nhận dạng ký tự hoặc trích xuất thông tin tự động được triển khai ở mức hỗ trợ, không thay thế xác nhận của người dùng.

## 4. Tiến độ thực hiện

| TT | Thời gian | Nội dung công việc | Kết quả dự kiến đạt được |
|---:|---|---|---|
| 1 | Tuần 1 | Tìm hiểu bài toán chăm sóc sức khỏe người cao tuổi và các kiến thức, công nghệ, công cụ sử dụng trong dự án như Flutter/Dart, Riverpod, Firebase, Clean Architecture, Git, bảo mật và kiểm thử phần mềm. | Hiểu được bài toán, nhu cầu thực tế và nắm được vai trò, cách sử dụng các công nghệ, công cụ phục vụ phát triển hệ thống. |
| 2 | Tuần 2 | Xác định phạm vi; phân tích tác nhân, yêu cầu nghiệp vụ và các luồng sử dụng chính. | Đặc tả yêu cầu, phạm vi chức năng và sơ đồ nghiệp vụ. |
| 3 | Tuần 3 | Thiết kế kiến trúc, mô hình Family–Member–Patient, dữ liệu Firestore và giao diện tổng thể. | Tài liệu thiết kế kiến trúc, dữ liệu và nguyên mẫu giao diện. |
| 4 | Tuần 4–11 | Xây dựng các chức năng của hệ thống: đăng ký và xác thực bằng email, đăng nhập bằng số điện thoại và mật khẩu; hồ sơ người dùng; không gian gia đình và phân quyền thành viên; lựa chọn người được chăm sóc; lịch khám và phân công người phụ trách; lịch sử khám bệnh; nhập hồ sơ thủ công, từ ảnh hoặc PDF; theo dõi huyết áp và thuốc; lời nhắc bằng giọng nói; SOS, vị trí và thông báo cho thành viên gia đình. | Hoàn thành các chức năng chính và luồng phối hợp chăm sóc giữa nhiều thành viên trong gia đình. |
| 5 | Tuần 12 | Hoàn thiện phân quyền, Storage Rules, nhật ký thao tác và xử lý lỗi. | Dữ liệu gia đình và hồ sơ được bảo vệ. |
| 6 | Tuần 13 | Viết và chạy kiểm thử nghiệp vụ; sửa lỗi và tối ưu trải nghiệm. | Báo cáo kiểm thử và phiên bản ứng dụng hoàn thiện. |
| 7 | Tuần 14 | Hoàn thiện báo cáo, hướng dẫn sử dụng, đóng gói và chuẩn bị bảo vệ. | Bộ mã nguồn, ứng dụng, báo cáo và slide trình bày. |

## 5. Tài liệu tham khảo

1. Flutter, *Flutter Documentation*, <https://docs.flutter.dev/>.
2. Dart, *Dart Documentation*, <https://dart.dev/guides>.
3. Firebase, *Firebase Documentation*, <https://firebase.google.com/docs>.
4. Riverpod, *Riverpod Documentation*, <https://riverpod.dev/docs/introduction/getting_started>.
5. Martin, R. C. (2017), *Clean Architecture: A Craftsman's Guide to Software Structure and Design*, Pearson.
6. Dennis, A., Wixom, B. H. và Roth, R. M. (2019), *Systems Analysis and Design*, 7th Edition, John Wiley & Sons.
