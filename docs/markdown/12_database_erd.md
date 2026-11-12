# Thiết kế cơ sở dữ liệu và ERD

> Trích từ [tài liệu Chương 3](../chuong3_bieu_do.md).

### Cấu trúc Firestore Collections

```
Firestore Database
│
├── users/                              # Collection: AppUser
│   └── {userId}/
│       ├── id: String
│       ├── phoneNumber: String
│       ├── fullName: String
│       ├── email: String
│       ├── role: String               # "elder" | "child" | "caregiver"
│       ├── gender: String?            # "male" | "female" | "other"
│       ├── createdAt: Timestamp
│       │
│       ├── health_records/            # Sub-collection: HealthRecord
│       │   └── {recordId}/
│       │       ├── id: String
│       │       ├── elderUserId: String
│       │       ├── systolic: Number
│       │       ├── diastolic: Number
│       │       ├── recordedAt: Timestamp
│       │       ├── contactedAt: Timestamp?
│       │       └── contactedById: String?
│       │
│       ├── pill_schedules/            # Sub-collection: PillSchedule
│       │   └── {scheduleId}/
│       │       ├── id: String
│       │       ├── elderUserId: String
│       │       ├── medicationName: String
│       │       ├── dosage: String
│       │       ├── instruction: String
│       │       ├── timesInMinutes: Array[Number]
│       │       ├── startDate: Timestamp
│       │       ├── endDate: Timestamp?
│       │       └── isActive: Boolean
│       │
│       ├── medication_intakes/        # Sub-collection: MedicationIntake
│       │   └── {intakeId}/
│       │       ├── id: String
│       │       ├── elderUserId: String
│       │       ├── scheduleId: String
│       │       ├── scheduledAt: Timestamp
│       │       └── takenAt: Timestamp
│       │
│       ├── medication_history/        # Sub-collection: MedicationHistoryEntry
│       │   └── {historyId}/
│       │       ├── id: String
│       │       ├── elderUserId: String
│       │       ├── scheduleId: String
│       │       ├── medicationName: String
│       │       ├── dosage: String
│       │       ├── scheduledAt: Timestamp
│       │       ├── takenAt: Timestamp?
│       │       └── status: String     # "taken" | "missed"
│       │
│       ├── appointments/              # Sub-collection: MedicalAppointment
│       │   └── {appointmentId}/
│       │       ├── id: String
│       │       ├── elderUserId: String
│       │       ├── title: String
│       │       ├── hospitalName: String
│       │       ├── department: String
│       │       ├── scheduledAt: Timestamp
│       │       ├── status: String     # AppointmentStatus enum
│       │       ├── createdById: String
│       │       ├── note: String
│       │       ├── assigneeId: String?
│       │       ├── assigneeName: String?
│       │       └── createdAt: Timestamp?
│       │
│       ├── medical_visits/            # Sub-collection: MedicalVisit
│       │   └── {visitId}/
│       │       ├── id: String
│       │       ├── elderUserId: String
│       │       ├── visitDate: Timestamp
│       │       ├── hospitalName: String
│       │       ├── department: String
│       │       ├── doctorName: String
│       │       ├── diagnosis: String
│       │       ├── conclusion: String
│       │       ├── notes: String
│       │       ├── followUpDate: Timestamp?
│       │       ├── createdById: String
│       │       └── documents/         # Sub-collection: MedicalDocument
│       │           └── {docId}/
│       │               ├── id: String
│       │               ├── fileName: String
│       │               ├── storagePath: String
│       │               ├── contentType: String
│       │               ├── uploadedById: String
│       │               └── createdAt: Timestamp
│       │
│       └── location/                  # Document: ElderLocation
│           ├── elderId: String
│           ├── latitude: Number
│           ├── longitude: Number
│           ├── accuracyMeters: Number
│           └── updatedAt: Timestamp
│
├── sos_alerts/                        # Collection: SosAlert
│   └── {alertId}/
│       ├── id: String
│       ├── elderUserId: String
│       ├── triggerMethod: String      # "button" | "shake"
│       ├── latitude: Number?
│       ├── longitude: Number?
│       ├── locationAccuracy: Number?
│       ├── locationCapturedAt: Timestamp?
│       ├── status: String             # SosStatus enum
│       ├── triggeredAt: Timestamp
│       ├── acknowledgedAt: Timestamp?
│       ├── acknowledgedById: String?
│       ├── enRouteAt: Timestamp?
│       ├── arrivedAt: Timestamp?
│       ├── resolvedAt: Timestamp?
│       ├── resolvedById: String?
│       ├── resolutionType: String?
│       ├── resolutionNote: String?
│       ├── cancelledById: String?
│       └── cancellationReason: String?
│
└── link_requests/                     # Collection: AccountLinkRequest
    └── {requestId}/
        ├── id: String
        ├── elderId: String
        ├── elderName: String
        ├── elderPhone: String
        ├── childPhone: String
        ├── relationship: String
        ├── status: String             # "pending" | "accepted" | "rejected" | "cancelled"
        ├── createdAt: Timestamp
        ├── elderGender: String?
        ├── childId: String?
        ├── childName: String?
        └── updatedAt: Timestamp?
```

### Sơ đồ quan hệ CSDL (ERD dạng bảng)

```mermaid
erDiagram
    USERS {
        string id PK
        string phoneNumber
        string fullName
        string email
        string role
        string gender
        timestamp createdAt
    }

    HEALTH_RECORDS {
        string id PK
        string elderUserId FK
        int systolic
        int diastolic
        timestamp recordedAt
        timestamp contactedAt
        string contactedById FK
    }

    PILL_SCHEDULES {
        string id PK
        string elderUserId FK
        string medicationName
        string dosage
        string instruction
        array timesInMinutes
        timestamp startDate
        timestamp endDate
    }

    MEDICATION_INTAKES {
        string id PK
        string elderUserId FK
        string scheduleId FK
        timestamp scheduledAt
        timestamp takenAt
    }

    MEDICATION_HISTORY {
        string id PK
        string elderUserId FK
        string scheduleId FK
        string medicationName
        string dosage
        timestamp scheduledAt
        timestamp takenAt
        string status
    }

    APPOINTMENTS {
        string id PK
        string elderUserId FK
        string title
        string hospitalName
        string department
        timestamp scheduledAt
        string status
        string createdById FK
        string assigneeId FK
    }

    MEDICAL_VISITS {
        string id PK
        string elderUserId FK
        timestamp visitDate
        string hospitalName
        string diagnosis
        string createdById FK
    }

    MEDICAL_DOCUMENTS {
        string id PK
        string visitId FK
        string fileName
        string storagePath
        string contentType
        string uploadedById FK
        timestamp createdAt
    }

    SOS_ALERTS {
        string id PK
        string elderUserId FK
        string triggerMethod
        float latitude
        float longitude
        string status
        timestamp triggeredAt
        string acknowledgedById FK
        string resolvedById FK
    }

    LINK_REQUESTS {
        string id PK
        string elderId FK
        string elderPhone
        string childPhone
        string childId FK
        string relationship
        string status
        timestamp createdAt
    }

    ELDER_LOCATION {
        string elderId PK_FK
        float latitude
        float longitude
        float accuracyMeters
        timestamp updatedAt
    }

    USERS ||--o{ HEALTH_RECORDS : "ghi nhận sức khỏe"
    USERS ||--o{ PILL_SCHEDULES : "có lịch thuốc"
    USERS ||--o{ MEDICATION_INTAKES : "xác nhận uống"
    USERS ||--o{ MEDICATION_HISTORY : "lịch sử thuốc"
    USERS ||--o{ APPOINTMENTS : "có lịch hẹn"
    USERS ||--o{ MEDICAL_VISITS : "có hồ sơ khám"
    USERS ||--o{ SOS_ALERTS : "kích hoạt SOS"
    USERS ||--o| ELDER_LOCATION : "vị trí"
    USERS ||--o{ LINK_REQUESTS : "gửi yêu cầu liên kết"
    PILL_SCHEDULES ||--o{ MEDICATION_INTAKES : "theo lịch"
    PILL_SCHEDULES ||--o{ MEDICATION_HISTORY : "theo lịch"
    MEDICAL_VISITS ||--o{ MEDICAL_DOCUMENTS : "đính kèm"
```
