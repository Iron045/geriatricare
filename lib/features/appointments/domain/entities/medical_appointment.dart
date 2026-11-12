enum AppointmentStatus { unassigned, assigned, accepted, completed, cancelled }

class MedicalAppointment {
  const MedicalAppointment({
    required this.id,
    required this.elderUserId,
    required this.title,
    required this.hospitalName,
    required this.scheduledAt,
    required this.status,
    required this.createdById,
    this.department = '',
    this.note = '',
    this.assigneeId,
    this.assigneeName,
    this.createdAt,
  });

  final String id;
  final String elderUserId;
  final String title;
  final String hospitalName;
  final String department;
  final DateTime scheduledAt;
  final AppointmentStatus status;
  final String createdById;
  final String note;
  final String? assigneeId;
  final String? assigneeName;
  final DateTime? createdAt;
}
