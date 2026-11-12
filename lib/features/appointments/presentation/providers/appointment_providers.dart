import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../authentication/presentation/providers/auth_providers.dart';
import '../../data/repositories/appointment_repository_impl.dart';
import '../../domain/entities/medical_appointment.dart';
import '../../domain/repositories/appointment_repository.dart';

final appointmentRepositoryProvider = Provider<AppointmentRepository>(
  (ref) => AppointmentRepositoryImpl(ref.watch(firestoreProvider)),
);

final appointmentsForElderProvider =
    StreamProvider.family<List<MedicalAppointment>, String>(
      (ref, elderId) =>
          ref.watch(appointmentRepositoryProvider).watchAppointments(elderId),
    );
