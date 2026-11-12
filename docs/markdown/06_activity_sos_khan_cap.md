# Activity – SOS khẩn cấp

> Trích từ [tài liệu Chương 3](../chuong3_bieu_do.md).

```mermaid
flowchart TD
    Start([🟢 Bắt đầu])
    Start --> TriggerMethod{Phương thức\nkích hoạt}
    TriggerMethod -->|Nhấn nút| ButtonPress[Nhấn nút SOS]
    TriggerMethod -->|Lắc điện thoại| ShakeDetect[Phát hiện\nlắc mạnh]

    ButtonPress --> CreateAlert[Tạo SosAlert\ntrạng thái: active]
    ShakeDetect --> CreateAlert

    CreateAlert --> GetGPS[Thu thập\nvị trí GPS]
    GetGPS --> GPSOk{GPS khả dụng?}
    GPSOk -->|Có| SaveGPS[Lưu tọa độ\nvào cảnh báo]
    GPSOk -->|Không| SkipGPS[Bỏ qua GPS]
    SaveGPS --> NotifyFamily[Gửi Push Notification\ntới người thân]
    SkipGPS --> NotifyFamily

    NotifyFamily --> FamilyAction{Người thân\nphản hồi}
    FamilyAction -->|Xác nhận| Acknowledge[Cập nhật:\nacknowledged]
    FamilyAction -->|Bỏ qua| WaitMore[Tiếp tục chờ]
    WaitMore --> FamilyAction

    Acknowledge --> OnRoute[Nhấn Đang đến]
    OnRoute --> UpdateEnRoute[Cập nhật:\nenRoute]
    UpdateEnRoute --> Arrived[Nhấn Đã đến]
    Arrived --> UpdateArrived[Cập nhật:\narrived]

    UpdateArrived --> Resolution{Kết quả}
    Resolution -->|Giải quyết xong| Resolve[Cập nhật:\nresolved]
    Resolution -->|Báo động nhầm| Cancel[Cập nhật:\ncancelled]

    Resolve --> End([🔴 Kết thúc])
    Cancel --> End
```

---
