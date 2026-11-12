import 'dart:typed_data';

import '../entities/medical_visit.dart';

abstract interface class MedicalRecordRepository {
  Stream<List<MedicalVisit>> watchVisits(String elderId);
  Future<String> createVisit(MedicalVisit visit);
  Future<void> attachDocument({
    required String elderId,
    required String visitId,
    required String fileName,
    required String contentType,
    required Uint8List bytes,
    required String uploadedById,
  });
  Future<Uint8List> readDocument({
    required String visitId,
    required String documentId,
  });
  Future<Uri> createDocumentOpenUrl({
    required String visitId,
    required String documentId,
  });
}
