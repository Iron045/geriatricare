# Sequence – Liên kết tài khoản

> Trích từ [tài liệu Chương 3](../chuong3_bieu_do.md).

```mermaid
sequenceDiagram
    actor Elder as 👴 Người cao tuổi
    participant ElderApp as 📱 App (Elder)
    participant LinkRepo as AccountLinkRepository
    participant Firestore as 🗃️ Firestore
    participant FCM as 🔔 Firebase FCM
    actor Child as 👨‍👧 Con cái

    Elder->>ElderApp: Nhập SĐT con cái\nvà mối quan hệ
    ElderApp->>LinkRepo: createRequest(AccountLinkRequest)
    LinkRepo->>Firestore: link_requests/{id}
    Firestore-->>LinkRepo: OK
    Firestore->>FCM: Cloud Function trigger
    FCM->>Child: Push: "Yêu cầu liên kết từ [Tên]"

    Child->>Firestore: watchChildLinks(childPhone)
    Firestore-->>Child: Danh sách yêu cầu pending

    Child->>LinkRepo: respondToRequest(requestId, accept=true, elderId)
    LinkRepo->>Firestore: status = accepted, childId = ...
    Firestore-->>Elder: Liên kết thành công
```

---
