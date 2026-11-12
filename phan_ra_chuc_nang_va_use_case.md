# Phân rã chức năng và danh sách Use Case

> Tài liệu phác thảo cho ứng dụng **Geriatriccare**. Nội dung dựa trên tên dự án và ngữ cảnh file `health_remote_data_source.dart`; cần đối chiếu với các màn hình và luồng thực tế trong mã nguồn.

## 1. Biểu đồ phân rã chức năng

```mermaid
flowchart TD
    A[Ứng dụng chăm sóc người cao tuổi]
    A --> B[Tài khoản]
    A --> C[Hồ sơ người cao tuổi]
    A --> D[Theo dõi sức khỏe]
    A --> E[Nhắc nhở chăm sóc]
    A --> F[Báo cáo và thông báo]

    B --> B1[Đăng ký]
    B --> B2[Đăng nhập / Đăng xuất]
    B --> B3[Quản lý thông tin tài khoản]

    C --> C1[Xem hồ sơ]
    C --> C2[Cập nhật thông tin]
    C --> C3[Quản lý người chăm sóc]

    D --> D1[Ghi nhận chỉ số sức khỏe]
    D --> D2[Xem lịch sử chỉ số]
    D --> D3[Theo dõi tình trạng sức khỏe]

    E --> E1[Tạo lịch nhắc]
    E --> E2[Cập nhật / Xóa lịch nhắc]
    E --> E3[Nhận nhắc uống thuốc / chăm sóc]

    F --> F1[Xem báo cáo sức khỏe]
    F --> F2[Nhận cảnh báo bất thường]
    F --> F3[Xem thông báo]
```

## 2. Danh sách Use Case

| Mã | Use Case | Tác nhân chính | Mô tả |
|---|---|---|---|
| UC01 | Đăng ký tài khoản | Người dùng | Tạo tài khoản mới để sử dụng ứng dụng. |
| UC02 | Đăng nhập | Người dùng | Truy cập ứng dụng bằng thông tin xác thực. |
| UC03 | Quản lý hồ sơ người cao tuổi | Người chăm sóc | Xem và cập nhật thông tin của người được chăm sóc. |
| UC04 | Ghi nhận chỉ số sức khỏe | Người chăm sóc | Nhập chỉ số sức khỏe cần theo dõi. |
| UC05 | Xem lịch sử sức khỏe | Người chăm sóc | Xem các chỉ số đã ghi nhận theo thời gian. |
| UC06 | Tạo lịch nhắc chăm sóc | Người chăm sóc | Thiết lập lịch uống thuốc hoặc hoạt động chăm sóc. |
| UC07 | Quản lý lịch nhắc | Người chăm sóc | Sửa hoặc xóa lịch nhắc đã tạo. |
| UC08 | Nhận nhắc nhở | Người dùng | Nhận thông báo khi đến lịch chăm sóc. |
| UC09 | Xem báo cáo sức khỏe | Người chăm sóc | Theo dõi tổng quan hoặc xu hướng sức khỏe. |
| UC10 | Nhận cảnh báo sức khỏe | Người chăm sóc | Nhận cảnh báo khi chỉ số cần chú ý, nếu ứng dụng hỗ trợ. |

## 4. Ghi chú

Các chức năng ngoài theo dõi sức khỏe hiện là giả định ban đầu. Nên rà soát mã nguồn và giao diện để xác nhận tác nhân, chức năng, cùng các quy tắc nghiệp vụ trước khi dùng làm tài liệu đặc tả chính thức.

## 3. Biểu đồ Use Case

```mermaid
flowchart LR
    User([Người dùng])
    Caregiver([Người chăm sóc])
    Elder([Người cao tuổi])

    subgraph System[Ứng dụng Geriatriccare]
        UC01((Đăng ký tài khoản))
        UC02((Đăng nhập))
        UC03((Quản lý hồ sơ người cao tuổi))
        UC04((Ghi nhận chỉ số sức khỏe))
        UC05((Xem lịch sử sức khỏe))
        UC06((Tạo lịch nhắc chăm sóc))
        UC07((Quản lý lịch nhắc))
        UC08((Nhận nhắc nhở))
        UC09((Xem báo cáo sức khỏe))
        UC10((Nhận cảnh báo sức khỏe))
    end

    User --- UC01
    User --- UC02
    User --- UC08
    Caregiver --- UC02
    Caregiver --- UC03
    Caregiver --- UC04
    Caregiver --- UC05
    Caregiver --- UC06
    Caregiver --- UC07
    Caregiver --- UC09
    Caregiver --- UC10
    Elder --- UC08
```

> Biểu đồ thể hiện các Use Case ở mức tổng quan. Tác nhân “Người cao tuổi” chỉ áp dụng nếu người cao tuổi trực tiếp dùng ứng dụng để nhận nhắc nhở; có thể bỏ tác nhân này nếu nhắc nhở chỉ gửi cho người chăm sóc.

