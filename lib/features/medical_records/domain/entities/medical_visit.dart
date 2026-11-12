class MedicalDocument {
  const MedicalDocument({
    required this.id,
    required this.fileName,
    required this.storagePath,
    required this.contentType,
    required this.uploadedById,
    required this.createdAt,
  });

  final String id;
  final String fileName;
  final String storagePath;
  final String contentType;
  final String uploadedById;
  final DateTime createdAt;
}

class MedicalVisit {
  const MedicalVisit({
    required this.id,
    required this.elderUserId,
    required this.visitDate,
    required this.hospitalName,
    required this.diagnosis,
    required this.createdById,
    this.department = '',
    this.doctorName = '',
    this.conclusion = '',
    this.notes = '',
    this.followUpDate,
    this.documents = const [],
  });

  final String id;
  final String elderUserId;
  final DateTime visitDate;
  final String hospitalName;
  final String department;
  final String doctorName;
  final String diagnosis;
  final String conclusion;
  final String notes;
  final DateTime? followUpDate;
  final String createdById;
  final List<MedicalDocument> documents;
}
