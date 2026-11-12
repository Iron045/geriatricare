import '../entities/medical_appointment.dart';

abstract interface class AppointmentRepository {
  Stream<List<MedicalAppointment>> watchAppointments(String elderId);
  Future<void> createAppointment(MedicalAppointment appointment);
  Future<void> acceptAppointment({
    required String appointmentId,
    required String userId,
    required String userName,
  });
  Future<void> releaseAppointment({
    required String appointmentId,
    required String userId,
  });
  Future<void> completeAppointment({
    required String appointmentId,
    required String userId,
  });
}
