import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../authentication/presentation/providers/auth_providers.dart';
import '../../data/repositories/medical_record_repository_impl.dart';
import '../../domain/entities/medical_visit.dart';
import '../../domain/repositories/medical_record_repository.dart';

final medicalRecordHttpClientProvider = Provider<http.Client>(
  (ref) {
    final client = http.Client();
    ref.onDispose(client.close);
    return client;
  },
);

final medicalRecordRepositoryProvider = Provider<MedicalRecordRepository>(
  (ref) => MedicalRecordRepositoryImpl(
    ref.watch(firestoreProvider),
    ref.watch(firebaseAuthProvider),
    ref.watch(medicalRecordHttpClientProvider),
  ),
);

final medicalVisitsForElderProvider =
    StreamProvider.family<List<MedicalVisit>, String>(
      (ref, elderId) =>
          ref.watch(medicalRecordRepositoryProvider).watchVisits(elderId),
    );
