# ĐẶC TẢ USE CASE VÀ QUY TẮC NGHIỆP VỤ – GERIATRICCARE

> Bản chuẩn hóa theo mã nguồn Flutter/Firebase hiện tại. Các nội dung ghi “Cần đồng bộ” là khoảng cách giữa tài liệu và implementation, không mặc định là chức năng đã hoàn thiện.

## 1. Tác nhân và nguyên tắc phân quyền

| Tác nhân | Phạm vi nghiệp vụ |
|---|---|
| Người cao tuổi (elder) | Quản lý hồ sơ của mình; ghi huyết áp; xem và xác nhận liều thuốc; gửi/hủy SOS; phản hồi yêu cầu liên kết; xem hồ sơ sức khỏe. |
| Người thân (child) | Chỉ truy cập hồ sơ elder đã chấp nhận liên kết; theo dõi sức khỏe/thuốc/vị trí, nhận và xử lý SOS, tạo lịch khám, lưu hồ sơ và tài liệu. |
| Người chăm sóc (caregiver) | Chỉ được truy cập dữ liệu khi có quan hệ chăm sóc hợp lệ và quyền tương ứng; không mặc định có toàn bộ quyền của child. |
| Hệ thống | Xác thực, kiểm tra quyền, đồng bộ Firestore, gửi FCM, tạo nhắc thuốc và ghi nhật ký. |

UID Firebase Authentication là định danh chuẩn. Dữ liệu sức khỏe, thuốc, SOS, lịch khám và hồ sơ y tế phải gắn với elderUserId. Quan hệ care_relationships chỉ cấp quyền sau khi elder chấp nhận. Không dùng dữ liệu do client tự gửi làm bằng chứng phân quyền.

## 2. Đặc tả 21 Use Case

### Phân hệ A – Tài khoản

#### UC01 – Đăng ký tài khoản
| Trường | Đặc tả |
|---|---|
| Mục tiêu / Tác nhân | Tạo tài khoản mới. Tác nhân: người dùng mới (elder/child). |
| Tiền điều kiện / Kích hoạt | Chưa có tài khoản; thiết bị có Internet. Người dùng chọn Đăng ký. |
| Luồng chính | 1. Nhập họ tên, email, số điện thoại, mật khẩu, giới tính và vai trò. 2. Hệ thống chuẩn hóa và kiểm tra dữ liệu bắt buộc/định dạng. 3. Gửi OTP đến email. 4. Người dùng nhập OTP. 5. Hệ thống xác minh OTP còn hạn, chưa sử dụng. 6. Tạo Firebase Auth account và hồ sơ users/{uid}; đồng bộ các chỉ mục tra cứu. 7. Điều hướng theo trạng thái xác thực thực tế. |
| Ngoại lệ / Hậu điều kiện | Sai định dạng/trùng email hoặc số điện thoại → từ chối và chỉ rõ trường lỗi. OTP sai/hết hạn/đã dùng → không tạo tài khoản, cho nhập lại hoặc yêu cầu mã mới. Ghi hồ sơ thất bại sau khi tạo Auth → xử lý bù/rollback, không báo thành công giả. Thành công: một tài khoản và hồ sơ nhất quán. |

#### UC02 – Đăng nhập
| Trường | Đặc tả |
|---|---|
| Mục tiêu / Tác nhân | Xác thực người dùng và mở giao diện theo vai trò. Tác nhân: người dùng đã đăng ký. |
| Tiền điều kiện / Kích hoạt | Tài khoản tồn tại, không bị vô hiệu hóa. Người dùng gửi thông tin đăng nhập. |
| Luồng chính | 1. Nhập thông tin định danh và mật khẩu theo phương thức cấu hình. 2. Firebase Authentication xác thực; không đối chiếu mật khẩu dạng rõ trong Firestore. 3. Tải hồ sơ theo UID, kiểm tra trạng thái và role. 4. Khởi tạo phiên, đăng ký/cập nhật FCM token phù hợp. 5. Mở giao diện elder hoặc child/caregiver. |
| Ngoại lệ / Hậu điều kiện | Thiếu/sai định dạng → yêu cầu nhập lại; sai thông tin → thông báo chung; hồ sơ thiếu/role không hợp lệ/tài khoản khóa → không vào màn hình chính; mất mạng → không tạo phiên giả. Thành công: phiên hợp lệ với quyền được xác định từ hồ sơ. |

#### UC03 – Đăng xuất
| Trường | Đặc tả |
|---|---|
| Mục tiêu / Tác nhân | Kết thúc phiên trên thiết bị. Tác nhân: người dùng đã đăng nhập. |
| Tiền điều kiện / Kích hoạt | Có phiên xác thực; chọn Đăng xuất. |
| Luồng chính | 1. Hiển thị xác nhận. 2. Dừng subscription/listener. 3. Xóa FCM token gắn với thiết bị nếu có thể. 4. Xóa dữ liệu nhạy cảm lưu tạm và đăng xuất Firebase Auth. 5. Quay về màn hình đăng nhập. |
| Ngoại lệ / Hậu điều kiện | Hủy → giữ phiên. Không xóa được token do mất mạng → vẫn đăng xuất cục bộ và dọn token khi có thể. Thành công: phiên trên thiết bị đã kết thúc. |

#### UC03B – Cập nhật hồ sơ cá nhân
| Trường | Đặc tả |
|---|---|
| Mục tiêu / Tác nhân | Cập nhật thông tin hồ sơ. Tác nhân: người dùng đã đăng nhập. |
| Tiền điều kiện / Kích hoạt | Hồ sơ tồn tại; người dùng mở Chỉnh sửa hồ sơ. |
| Luồng chính | 1. Tải hồ sơ hiện tại. 2. Cho sửa họ tên, giới tính, ảnh đại diện và trường được phép. 3. Kiểm tra dữ liệu. 4. Lưu hồ sơ và đồng bộ tên hiển thị ở các quan hệ liên quan. |
| Ngoại lệ / Hậu điều kiện | Email/số điện thoại định danh thay đổi phải qua quy trình xác minh riêng. Dữ liệu sai hoặc mất mạng → giữ biểu mẫu, không ghi đè. Thành công: hồ sơ được cập nhật. |

### Phân hệ B – SOS và an toàn

#### UC04 – Gửi cảnh báo SOS
| Trường | Đặc tả |
|---|---|
| Mục tiêu / Tác nhân | Phát tín hiệu cần trợ giúp. Tác nhân: elder; cảm biến ngã là tác nhân phụ nếu thiết bị hỗ trợ. |
| Tiền điều kiện / Kích hoạt | Elder đã đăng nhập. Nhấn SOS hoặc xác nhận cảnh báo ngã sau đếm ngược. |
| Luồng chính | 1. Nhấn giữ SOS hoặc xác nhận cảnh báo ngã. 2. Hệ thống kiểm tra cảnh báo đang mở; nếu có thì mở lại, không tạo trùng. 3. Thu thập tọa độ/độ chính xác nếu được cấp quyền. 4. Lưu SOS với elderUserId, triggerMethod, triggeredAt và status=active. 5. Cloud Function gửi FCM đến child có quan hệ accepted. 6. Hiển thị trạng thái gửi và hướng dẫn gọi trợ giúp. |
| Ngoại lệ / Hậu điều kiện | Hủy đếm ngược → không tạo SOS. GPS không khả dụng → vẫn gửi, vị trí để trống hoặc dùng vị trí gần nhất có gắn thời điểm. Mất mạng → báo rõ chưa gửi được và cung cấp gọi điện; không báo SOS đã gửi. Không có token → SOS vẫn được lưu và notificationStatus phản ánh thất bại. |

#### UC05 – Tiếp nhận cảnh báo SOS
| Trường | Đặc tả |
|---|---|
| Mục tiêu / Tác nhân | Một người thân nhận trách nhiệm xử lý. Tác nhân: child đã liên kết. |
| Tiền điều kiện / Kích hoạt | SOS của elder liên kết đang active; child mở cảnh báo và chọn Tiếp nhận. |
| Luồng chính | 1. Tải trạng thái mới nhất. 2. Gửi yêu cầu tiếp nhận. 3. Transaction chỉ cho phép active → acknowledged, ghi acknowledgedById và acknowledgedAt. 4. Đồng bộ người tiếp nhận cho thành viên liên quan. |
| Ngoại lệ / Hậu điều kiện | Không có quyền/quan hệ → từ chối. Người khác đã nhận hoặc SOS đã kết thúc → tải trạng thái mới, không ghi đè. Lỗi transaction → giữ trạng thái cũ. Thành công: tối đa một responder đầu tiên. |

#### UC06 – Cập nhật tiến độ và kết thúc SOS
| Trường | Đặc tả |
|---|---|
| Mục tiêu / Tác nhân | Theo dõi ứng cứu và lưu kết quả. Tác nhân: child đang tiếp nhận; elder được hủy SOS của mình. |
| Tiền điều kiện / Kích hoạt | SOS chưa kết thúc; responder hiện tại chọn cập nhật tiến độ/hoàn tất. |
| Luồng chính | 1. Chuyển acknowledged → enRoute → arrived theo thứ tự. 2. Sau hỗ trợ thực tế, nhập resolutionType và ghi chú tùy chọn. 3. Hệ thống kiểm tra responder và trạng thái. 4. Chuyển resolved, lưu resolvedById/resolvedAt/kết quả. 5. Thông báo các bên. |
| Ngoại lệ / Hậu điều kiện | Sai thứ tự hoặc sai người → từ chối. Thiếu kết quả → yêu cầu chọn. SOS đã resolved/cancelled → không cập nhật lần hai. Elder chỉ hủy khi SOS chưa kết thúc. Thành công: trạng thái kết thúc và kết quả được lưu. |

### Phân hệ C – Sức khỏe

#### UC07 – Ghi nhận chỉ số huyết áp
| Trường | Đặc tả |
|---|---|
| Mục tiêu / Tác nhân | Lưu kết quả đo cho elder. Tác nhân: elder; child nếu được cấp quyền ghi. |
| Tiền điều kiện / Kích hoạt | Đã xác thực, có quyền ghi cho hồ sơ đích; mở Ghi huyết áp. |
| Luồng chính | 1. Chọn hồ sơ elder. 2. Nhập tâm thu, tâm trương và trường bổ sung được hỗ trợ. 3. Chọn thời điểm đo, mặc định hiện tại. 4. Kiểm tra kiểu số, miền hợp lệ và tâm thu > tâm trương. 5. Phân loại bằng hàm domain thống nhất. 6. Lưu bản ghi, người ghi, thời điểm đo và ghi chú. |
| Ngoại lệ / Hậu điều kiện | Thiếu/sai kiểu, ngoài miền hoặc tâm thu ≤ tâm trương, thời điểm tương lai, không có quyền hoặc lỗi Firestore → không lưu và giữ dữ liệu nhập. Thành công: một bản ghi hợp lệ gắn đúng elder. |

#### UC08 – Xem phân loại và hướng dẫn huyết áp
| Trường | Đặc tả |
|---|---|
| Mục tiêu / Tác nhân | Giải thích kết quả, không thay thế chẩn đoán. Tác nhân: elder/child có quyền đọc. |
| Tiền điều kiện / Kích hoạt | Có bản ghi hợp lệ; người dùng mở chi tiết. |
| Luồng chính | 1. Tải chỉ số và thời điểm. 2. Tính/đọc phân loại theo cùng quy tắc domain. 3. Hiển thị mức độ và hướng dẫn. 4. Với dấu hiệu nguy cấp, hiển thị hướng dẫn liên hệ cấp cứu. |
| Ngoại lệ / Hậu điều kiện | Không có bản ghi/dữ liệu thiếu → thông báo không đủ dữ liệu. Không tự kết luận bệnh. Thành công: chỉ xem, không sửa bản ghi gốc. |

#### UC09 – Tra cứu lịch sử huyết áp
| Trường | Đặc tả |
|---|---|
| Mục tiêu / Tác nhân | Theo dõi xu hướng các lần đo. Tác nhân: elder/child có quyền đọc. |
| Tiền điều kiện / Kích hoạt | Có quyền đọc; mở Lịch sử huyết áp. |
| Luồng chính | 1. Chọn hồ sơ và khoảng thời gian. 2. Tải bản ghi theo measuredAt giảm dần. 3. Hiển thị danh sách và biểu đồ tâm thu/tâm trương. 4. Mở chi tiết để xem người ghi, ghi chú, phân loại. |
| Ngoại lệ / Hậu điều kiện | Chưa có dữ liệu → trạng thái trống. Tải lỗi → giữ bộ lọc và cho tải lại. Thành công: lịch sử hiển thị đúng thời gian. |

### Phân hệ D – Thuốc

#### UC10 – Thiết lập và quản lý lịch thuốc
| Trường | Đặc tả |
|---|---|
| Mục tiêu / Tác nhân | Quản lý lịch dùng thuốc. Tác nhân: elder hoặc child có quyền quản lý. |
| Tiền điều kiện / Kích hoạt | Có quyền ghi; chọn Thêm thuốc/Sửa lịch/Dừng thuốc. |
| Luồng chính | 1. Chọn elder. 2. Nhập tên thuốc, liều, hướng dẫn, ngày bắt đầu/kết thúc và các giờ uống. 3. Kiểm tra trường bắt buộc, giờ hợp lệ và ngày kết thúc không trước ngày bắt đầu. 4. Lưu lịch hoạt động. 5. Đồng bộ nhắc trên thiết bị elder. 6. Khi dừng, ngừng các nhắc tương lai nhưng giữ lịch sử liều đã phát sinh. |
| Ngoại lệ / Hậu điều kiện | Dữ liệu thiếu/sai → không lưu. Quyền thông báo tắt → lịch vẫn lưu nhưng phải báo nhắc chưa được cấu hình. Không có quyền ghi → từ chối. Thành công: lịch có hiệu lực đúng khoảng ngày. |

#### UC11 – Xem lịch và nhận nhắc thuốc
| Trường | Đặc tả |
|---|---|
| Mục tiêu / Tác nhân | Hiển thị liều đến hạn và phát nhắc. Tác nhân: elder, hệ thống, child có quyền theo dõi. |
| Tiền điều kiện / Kích hoạt | Có lịch hoạt động; mở lịch hoặc đến giờ uống. |
| Luồng chính | 1. Tạo danh sách liều theo ngày từ lịch còn hiệu lực. 2. Sắp xếp theo giờ. 3. Đến giờ, phát local notification trên thiết bị đã cấu hình. 4. Mở thông báo đến đúng liều. 5. Child xem trạng thái đồng bộ. |
| Ngoại lệ / Hậu điều kiện | Lịch dừng/ngoài ngày hiệu lực → không tạo liều. Quyền thông báo tắt → lịch vẫn xem được và hiển thị cảnh báo. Offline → thể hiện rõ trạng thái đồng bộ. Nhắc không tự đổi trạng thái liều thành đã uống. |

#### UC12 – Ghi nhận liều đã uống hoặc bỏ lỡ
| Trường | Đặc tả |
|---|---|
| Mục tiêu / Tác nhân | Lưu trạng thái thực tế từng liều. Tác nhân: elder; hệ thống tạo trạng thái missed. |
| Tiền điều kiện / Kích hoạt | Liều thuộc lịch hợp lệ; người thao tác có quyền ghi; người dùng chọn Đã uống hoặc job đồng bộ chạy. |
| Luồng chính | 1. Định danh liều duy nhất bằng elder + schedule + scheduledAt. 2. Khi xác nhận, lưu takenAt và trạng thái taken. 3. Job rà soát liều quá hạn theo grace period; nếu chưa xác nhận thì ghi missed. 4. Child xem lịch sử. |
| Ngoại lệ / Hậu điều kiện | Liều đã có trạng thái cuối → không tạo trùng/ghi đè. Xác nhận muộn → lưu thời điểm thực tế, không giả mạo giờ dự kiến. Job và xác nhận đồng thời → transaction/idempotency bảo đảm một kết quả cuối. |

### Phân hệ E – Liên kết và liên hệ

#### UC13 – Gửi, chấp nhận hoặc từ chối yêu cầu liên kết
| Trường | Đặc tả |
|---|---|
| Mục tiêu / Tác nhân | Tạo quan hệ chăm sóc có sự đồng ý của elder. Tác nhân: child gửi; elder phản hồi. |
| Tiền điều kiện / Kích hoạt | Hai tài khoản tồn tại; child đã đăng nhập; nhập số điện thoại elder. |
| Luồng chính | 1. Chuẩn hóa số và tra user_directory. 2. Kiểm tra role đích là elder và không phải chính mình. 3. Chống trùng pending/accepted. 4. Tạo account_links pending. 5. Elder chọn chấp nhận/từ chối. 6. Khi chấp nhận, transaction cập nhật accepted và tạo care_relationships/{elderId}_{childId}. 7. Child được hủy yêu cầu khi còn pending. |
| Ngoại lệ / Hậu điều kiện | Không tìm thấy/role sai → từ chối. Đã pending/accepted → không tạo trùng. Người không phải elder đích phản hồi → từ chối. Transaction lỗi → không để invitation và relationship lệch nhau. Chỉ accepted mới cấp quyền. |

#### UC14 – Quản lý danh sách người thân đã liên kết
| Trường | Đặc tả |
|---|---|
| Mục tiêu / Tác nhân | Xem quan hệ và trạng thái kết nối. Tác nhân: elder/child. |
| Tiền điều kiện / Kích hoạt | Đã xác thực; mở mục Người thân/Liên kết. |
| Luồng chính | 1. Tải yêu cầu và quan hệ thuộc UID hiện tại. 2. Phân biệt pending, accepted, rejected, cancelled. 3. Hiển thị danh sách accepted cùng thông tin cần thiết. 4. Cho hủy pending; thu hồi accepted phải qua quy trình xác nhận riêng. |
| Ngoại lệ / Hậu điều kiện | Chưa có liên kết → hướng dẫn kết nối. Không có quyền đọc → không hiển thị. Danh sách phản ánh trạng thái mới nhất. |

#### UC15 – Quản lý và sử dụng liên hệ khẩn cấp
| Trường | Đặc tả |
|---|---|
| Mục tiêu / Tác nhân | Cung cấp số hỗ trợ khi cần. Tác nhân: elder/child có quyền quản lý. |
| Tiền điều kiện / Kích hoạt | Đã đăng nhập và có quyền với hồ sơ; mở Liên hệ khẩn cấp. |
| Luồng chính | 1. Tải danh sách theo elder. 2. Thêm/sửa/xóa tên, số điện thoại, quan hệ và thứ tự ưu tiên. 3. Chuẩn hóa và kiểm tra số. 4. Lưu theo owner elder. 5. Khi gọi, mở trình gọi hệ điều hành để người dùng xác nhận. |
| Ngoại lệ / Hậu điều kiện | Số sai/trùng → yêu cầu sửa. Không có quyền → từ chối. Không có ứng dụng gọi → hiển thị số để sao chép. |

### Phân hệ F – Lịch khám và hồ sơ y tế

#### UC16 – Tạo lịch khám sức khỏe
| Trường | Đặc tả |
|---|---|
| Mục tiêu / Tác nhân | Tạo lịch khám cho elder. Tác nhân: child đã liên kết hoặc elder theo quyền. |
| Tiền điều kiện / Kích hoạt | Có quyền tạo lịch; chọn Thêm lịch khám. |
| Luồng chính | 1. Chọn elder. 2. Nhập nội dung khám, cơ sở y tế, khoa, ngày giờ, ghi chú. 3. Chọn người dự kiến phụ trách hoặc để chưa phân công. 4. Kiểm tra ngày giờ không quá khứ và assignee thuộc quan hệ hợp lệ. 5. Lưu unassigned nếu chưa có người nhận hoặc accepted nếu đã gán hợp lệ. |
| Ngoại lệ / Hậu điều kiện | Thiếu trường/ngày quá khứ/người nhận không có quyền → không lưu. Lỗi mạng → giữ biểu mẫu. Thành công: lịch tồn tại với trạng thái và người phụ trách nhất quán. |

#### UC17 – Điều phối người đưa đi khám
| Trường | Đặc tả |
|---|---|
| Mục tiêu / Tác nhân | Chỉ một thành viên nhận trách nhiệm. Tác nhân: child đã liên kết. |
| Tiền điều kiện / Kích hoạt | Lịch unassigned hoặc accepted; chọn Tôi sẽ đưa đi/Nhờ người khác. |
| Luồng chính | 1. Thành viên nhận lịch. 2. Transaction kiểm tra unassigned, gán assigneeId/assigneeName/acceptedAt và chuyển accepted. 3. Người phụ trách hiện tại có thể nhả lịch; kiểm tra assigneeId là chính mình, chuyển unassigned và xóa assignee. 4. Thành viên khác có thể nhận sau đó. |
| Ngoại lệ / Hậu điều kiện | Nhận đồng thời → chỉ một transaction thành công. Người không phụ trách nhả → từ chối. Lịch completed/cancelled → không nhận/nhả. Tối đa một người phụ trách. |

#### UC18 – Xác nhận hoàn tất lịch khám
| Trường | Đặc tả |
|---|---|
| Mục tiêu / Tác nhân | Đánh dấu lịch đã diễn ra và chuyển tiếp lưu hồ sơ. Tác nhân: người phụ trách. |
| Tiền điều kiện / Kích hoạt | Lịch accepted; current user là assignee; đã đến thời điểm hẹn. |
| Luồng chính | 1. Tải lịch mới nhất. 2. Kiểm tra quyền và thời gian. 3. Chuyển accepted → completed, lưu completedById/completedAt. 4. Gợi ý tạo hồ sơ khám và điền sẵn cơ sở/ngày/khoa. |
| Ngoại lệ / Hậu điều kiện | Chưa đến giờ → không cho hoàn thành, trừ khi có quy tắc hoàn thành sớm riêng. Sai assignee hoặc lịch đã kết thúc → từ chối. Lỗi lưu → giữ trạng thái cũ. Hồ sơ khám chỉ tạo khi người dùng xác nhận ở UC19. |

#### UC19 – Lưu hồ sơ khám bệnh
| Trường | Đặc tả |
|---|---|
| Mục tiêu / Tác nhân | Lưu kết quả khám của elder. Tác nhân: elder hoặc child có quyền ghi. |
| Tiền điều kiện / Kích hoạt | Có quyền ghi; chọn Thêm hồ sơ khám. |
| Luồng chính | 1. Chọn elder. 2. Nhập ngày khám, cơ sở, khoa, bác sĩ, chẩn đoán, kết luận, ghi chú, ngày tái khám nếu có. 3. Kiểm tra ngày không ở tương lai và trường bắt buộc. 4. Lưu medical_visits cùng createdById/createdAt. 5. Cập nhật danh sách lịch sử. |
| Ngoại lệ / Hậu điều kiện | Thiếu dữ liệu/sai ngày/không có quyền/lỗi lưu → không tạo hồ sơ, giữ biểu mẫu. Thành công: hồ sơ gắn đúng elder. |

#### UC20 – Quản lý tài liệu đính kèm hồ sơ y tế
| Trường | Đặc tả |
|---|---|
| Mục tiêu / Tác nhân | Tải lên và đọc tài liệu thuộc lần khám. Tác nhân: elder/child có quyền. |
| Tiền điều kiện / Kích hoạt | Hồ sơ khám tồn tại; người dùng xác thực; chọn Đính kèm/Mở tài liệu. |
| Luồng chính | 1. Chọn visit và tệp. 2. Kiểm tra MIME, dung lượng, tên và quyền ở client/server. 3. Server xác minh Firebase ID token và quan hệ; lưu tệp riêng tư cùng metadata elderId/visitId/uploadedById. 4. Khi đọc, server xác minh quyền lại và trả nội dung hoặc URL ngắn hạn. |
| Ngoại lệ / Hậu điều kiện | Tệp sai định dạng/quá dung lượng → từ chối. Token hết hạn/không có quyền → 401/403. Upload lỗi → không để metadata mồ côi. Không truy cập tài liệu chỉ bằng URL công khai. |

#### UC21 – Tra cứu lịch sử khám bệnh
| Trường | Đặc tả |
|---|---|
| Mục tiêu / Tác nhân | Tra cứu hồ sơ khám theo thời gian. Tác nhân: elder/child có quyền đọc. |
| Tiền điều kiện / Kích hoạt | Có quyền đọc; mở Lịch sử khám. |
| Luồng chính | 1. Chọn elder và bộ lọc. 2. Tải medical_visits theo visitDate giảm dần. 3. Hiển thị ngày, cơ sở, khoa, chẩn đoán, kết luận và số tài liệu. 4. Mở chi tiết/tài liệu; kiểm tra quyền lại. |
| Ngoại lệ / Hậu điều kiện | Chưa có hồ sơ → trạng thái trống. Tải lỗi → cho tải lại. Hồ sơ/tài liệu không còn hoặc mất quyền → không hiển thị nội dung. |

## 3. Quy tắc nghiệp vụ dùng chung

### 3.1 Tài khoản và quyền
- UID Firebase Auth là khóa chính; không dùng email/số điện thoại làm khóa quan hệ.
- Role hợp lệ hiện gồm elder, child, caregiver. Không cho client tự nâng role hoặc đổi role tùy ý.
- Quyền đọc và quyền ghi là hai quyền riêng. Child chỉ được truy cập elder có relationship accepted.
- Mọi thao tác nhạy cảm phải được kiểm tra ở Firestore Rules hoặc server, không chỉ ẩn nút trên UI.

### 3.2 Trạng thái liên kết
- Vòng đời: pending → accepted | rejected | cancelled; không chuyển ngược trạng thái kết thúc về pending.
- Chỉ accepted mới tạo quyền chăm sóc.
- Mỗi cặp elder-child chỉ có tối đa một quan hệ accepted và một yêu cầu pending có hiệu lực.
- Cần có use case thu hồi quan hệ accepted để thu hồi quyền ngay lập tức.

### 3.3 Trạng thái SOS
- Vòng đời chuẩn: active → acknowledged → enRoute → arrived → resolved; nhánh hủy: trạng thái chưa kết thúc → cancelled.
- Chỉ elder sở hữu SOS được cập nhật vị trí/hủy; chỉ child đã liên kết được tiếp nhận; chỉ responder hiện tại được cập nhật tiến độ/kết thúc.
- Tạo SOS phải idempotent; retry/chạm lặp không tạo nhiều cảnh báo đang mở.
- Gửi FCM bất đồng bộ, độc lập với việc tạo SOS. Lưu notificationStatus, số thành công/thất bại và thời điểm xử lý.
- GPS không bắt buộc để gửi SOS. Phân biệt tọa độ hiện tại với tọa độ gần nhất và thời điểm cập nhật.

### 3.4 Huyết áp
- Firestore hiện kiểm tra tâm thu 70–250 mmHg, tâm trương 40–150 mmHg và tâm thu > tâm trương.
- Phân loại phải dùng cùng một hàm domain; không gán nhãn chẩn đoán. Ngưỡng và thông điệp cần chuyên gia y tế rà soát trước khi sử dụng thực tế.
- Không mô tả nhịp tim là bắt buộc nếu schema và UI không lưu trường này.

### 3.5 Thuốc
- Lịch có ngày bắt đầu, ngày kết thúc tùy chọn và nhiều giờ uống trong ngày.
- Khóa liều duy nhất: elder + schedule + scheduledAt; xác nhận phải idempotent.
- takenAt là thời điểm xác nhận thực tế, không phải giờ dự kiến.
- Logic đồng bộ hiện tại tạo missed khi đã quá giờ dự kiến 5 giờ. Cần thống nhất grace period này và múi giờ.
- Dừng lịch không xóa lịch sử; không sinh liều sau ngày kết thúc.

### 3.6 Lịch khám
- Trạng thái đề xuất: unassigned → accepted → completed; có nhánh cancelled.
- accepted nghĩa là đã có người phụ trách, không đồng nghĩa đã đặt chỗ tại bệnh viện.
- Nhận/nhả/hoàn tất phải kiểm tra assignee và trạng thái trong transaction.
- scheduledAt là giờ hẹn; completedAt là giờ hoàn tất thực tế.

### 3.7 Hồ sơ và tài liệu
- Hồ sơ khám thuộc một elder; createdById lưu người tạo.
- Tài liệu phải thuộc visitId tồn tại và cùng elderId; không dùng URL cố định công khai.
- Server xác minh token và quyền cho cả upload, open, download. Kiểm tra MIME/dung lượng/tên tệp phía server.
- Không xóa hồ sơ/tài liệu bằng thao tác thường nếu chưa có chính sách lưu trữ/kiểm toán.

### 3.8 Thời gian và thông báo
- Lưu timestamp chuẩn UTC; hiển thị theo múi giờ địa phương.
- FCM là kênh thông báo, không phải nguồn dữ liệu chính; khi mở chi tiết phải tải trạng thái mới nhất từ Firestore.
- Tắt quyền thông báo không được làm mất dữ liệu lịch thuốc/SOS.

## 4. Các điểm lệch cần xử lý trong mã nguồn

| Hạng mục | Quan sát từ repository | Việc cần làm |
|---|---|---|
| Đăng ký/đăng nhập | Có Firebase Auth, OTP email và các directory tra cứu. | Đặc tả phải khớp luồng OTP thực tế; nếu mật khẩu 6 số chỉ là PIN thì không gọi là mật khẩu bảo mật mạnh. |
| SOS | Có chống tạo cảnh báo mở trùng, transaction chuyển trạng thái và Cloud Function gửi FCM. | Không cam kết còi hú âm lượng tối đa hoặc push chắc chắn đến mọi thiết bị; xử lý notificationStatus độc lập. |
| Huyết áp | Rules kiểm tra miền tâm thu/tâm trương; domain có low/optimal/normal/rising/high/crisis. | Không mô tả “WHO/AHA”, “tiền tăng huyết áp/độ 1/độ 2” nếu thuật toán không triển khai đúng bộ ngưỡng đó; bổ sung test biên. |
| Thuốc | Có tạo liều theo ngày, khóa liều ổn định, xác nhận và đồng bộ missed sau 5 giờ. | Chốt grace period 5 giờ; rà soát rules để child/caregiver chỉ ghi trong phạm vi được cấp. |
| Liên kết | Có kiểm tra role elder, chống trùng và transaction chấp nhận tạo relationship. | Bổ sung thu hồi quan hệ accepted; bảo đảm chỉ người gửi hủy pending. |
| Lịch khám | Model có unassigned/assigned/accepted/completed/cancelled; repository nhận lịch bằng transaction nhưng nhả/hoàn tất đang update trực tiếp. Rules hiện chỉ cho tạo accepted có assignee. | **Cần đồng bộ:** thống nhất assigned hay accepted; nếu cần unassigned thì sửa rules và create flow; chuyển nhả/hoàn tất sang transaction kiểm tra assigneeId và trạng thái. |
| Hồ sơ khám | Có medical_visits và API tài liệu riêng. | Ràng buộc ngày khám/trường bắt buộc và kiểm tra quyền server-side nhất quán. |
| Tài liệu | API server dùng Firebase ID token cho upload/read/open. | Kiểm tra MIME, dung lượng, path traversal, URL ngắn hạn và cleanup khi upload lỗi. |
| Liên hệ khẩn cấp | Có entity emergency_contact; cần rà soát UI/repository/rules cho đủ thao tác. | Không mô tả thêm/sửa/xóa là đã hoàn thiện trước khi cả ba lớp hỗ trợ. |
| Vị trí | Có location repository và SOS location service. | Chỉ cam kết cập nhật theo luồng thực sự triển khai; không khẳng định theo dõi nền liên tục nếu chưa xử lý quyền nền, pin và riêng tư. |

## 5. Tiêu chí nghiệm thu nghiệp vụ
1. Người dùng không thể đọc/sửa dữ liệu elder chưa chấp nhận liên kết.
2. Một cặp elder-child không tạo được nhiều quan hệ accepted hoặc nhiều yêu cầu pending trùng.
3. Retry gửi SOS không tạo cảnh báo đang mở trùng; chỉ một responder được tiếp nhận.
4. Chuyển trạng thái SOS sai thứ tự/sai người bị chặn ở rules/transaction.
5. Huyết áp sai miền hoặc tâm thu ≤ tâm trương bị chặn cả client và server.
6. Xác nhận một liều nhiều lần không tạo lịch sử trùng; job missed không ghi đè liều taken.
7. Hai thành viên nhận cùng lịch khám đồng thời chỉ một người thành công; người không phụ trách không thể nhả/hoàn tất.
8. Tài liệu y tế không truy cập được nếu thiếu token/quyền hợp lệ.
9. Khi lỗi mạng, giao diện phải nói rõ dữ liệu đã lưu hay chưa; không báo thành công trước khi server xác nhận.
10. Timestamp được xử lý nhất quán UTC và hiển thị theo múi giờ địa phương.

## 6. Quy ước đồng bộ tài liệu
- UC01–UC21 là bộ use case nghiệp vụ chính; UC03B là use case phụ về hồ sơ cá nhân.
- Activity/sequence diagram phải dùng cùng ID, tên, tác nhân, trạng thái và ngoại lệ.
- Chức năng chưa có UI/repository/rules/server tương ứng phải ghi “đề xuất” hoặc “cần triển khai”, không mô tả là đã hoàn thành.
