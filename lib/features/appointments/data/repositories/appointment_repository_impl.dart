import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/medical_appointment.dart';
import '../../domain/repositories/appointment_repository.dart';

final class AppointmentRepositoryImpl implements AppointmentRepository {
  AppointmentRepositoryImpl(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _appointments =>
      _firestore.collection('medical_appointments');

  @override
  Stream<List<MedicalAppointment>> watchAppointments(String elderId) =>
      _appointments.where('elderUserId', isEqualTo: elderId).snapshots().map((
        snapshot,
      ) {
        final items = snapshot.docs.map(_fromFirestore).toList();
        items.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
        return List.unmodifiable(items);
      });

  MedicalAppointment _fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? const <String, dynamic>{};
    return MedicalAppointment(
      id: document.id,
      elderUserId: data['elderUserId'] as String? ?? '',
      title: data['title'] as String? ?? '',
      hospitalName: data['hospitalName'] as String? ?? '',
      department: data['department'] as String? ?? '',
      scheduledAt:
          (data['scheduledAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: AppointmentStatus.values.firstWhere(
        (status) => status.name == data['status'],
        orElse: () => AppointmentStatus.unassigned,
      ),
      createdById: data['createdById'] as String? ?? '',
      note: data['note'] as String? ?? '',
      assigneeId: data['assigneeId'] as String?,
      assigneeName: data['assigneeName'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  @override
  Future<void> createAppointment(MedicalAppointment appointment) =>
      _appointments.add({
        'elderUserId': appointment.elderUserId,
        'title': appointment.title,
        'hospitalName': appointment.hospitalName,
        'department': appointment.department,
        'scheduledAt': Timestamp.fromDate(appointment.scheduledAt),
        'status': appointment.status.name,
        'createdById': appointment.createdById,
        'note': appointment.note,
        'assigneeId': appointment.assigneeId,
        'assigneeName': appointment.assigneeName,
        'acceptedAt': appointment.assigneeId == null
            ? null
            : FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

  @override
  Future<void> acceptAppointment({
    required String appointmentId,
    required String userId,
    required String userName,
  }) => _firestore.runTransaction((transaction) async {
    final reference = _appointments.doc(appointmentId);
    final snapshot = await transaction.get(reference);
    final data = snapshot.data();
    if (data == null) throw StateError('Lịch khám không còn tồn tại.');
    if (data['status'] != AppointmentStatus.unassigned.name) {
      throw StateError('Lịch khám đã có người nhận.');
    }
    transaction.update(reference, {
      'status': AppointmentStatus.accepted.name,
      'assigneeId': userId,
      'assigneeName': userName,
      'acceptedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  });

  @override
  Future<void> releaseAppointment({
    required String appointmentId,
    required String userId,
  }) => _appointments.doc(appointmentId).update({
    'status': AppointmentStatus.unassigned.name,
    'assigneeId': null,
    'assigneeName': null,
    'releasedById': userId,
    'updatedAt': FieldValue.serverTimestamp(),
  });

  @override
  Future<void> completeAppointment({
    required String appointmentId,
    required String userId,
  }) => _appointments.doc(appointmentId).update({
    'status': AppointmentStatus.completed.name,
    'completedById': userId,
    'completedAt': FieldValue.serverTimestamp(),
    'updatedAt': FieldValue.serverTimestamp(),
  });
}
