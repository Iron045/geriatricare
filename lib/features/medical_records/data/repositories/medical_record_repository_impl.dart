import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../../domain/entities/medical_visit.dart';
import '../../domain/repositories/medical_record_repository.dart';

final class MedicalRecordRepositoryImpl implements MedicalRecordRepository {
  MedicalRecordRepositoryImpl(this._firestore, this._auth, this._httpClient);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final http.Client _httpClient;

  static const _serverUrl = String.fromEnvironment(
    'OTP_SERVER_URL',
    defaultValue: 'http://192.168.1.12:3000',
  );

  CollectionReference<Map<String, dynamic>> get _visits =>
      _firestore.collection('medical_visits');

  @override
  Stream<List<MedicalVisit>> watchVisits(String elderId) => _visits
      .where('elderUserId', isEqualTo: elderId)
      .snapshots()
      .asyncMap((snapshot) async {
        final items = <MedicalVisit>[];
        for (final document in snapshot.docs) {
          final data = document.data();
          final documentSnapshot = await document.reference
              .collection('documents')
              .get();
          final documents = documentSnapshot.docs.map((item) {
            final value = item.data();
            return MedicalDocument(
              id: item.id,
              fileName: value['fileName'] as String? ?? '',
              storagePath: value['storagePath'] as String? ?? '',
              contentType:
                  value['contentType'] as String? ?? 'application/octet-stream',
              uploadedById: value['uploadedById'] as String? ?? '',
              createdAt:
                  (value['createdAt'] as Timestamp?)?.toDate() ??
                  DateTime.now(),
            );
          }).toList();
          items.add(
            MedicalVisit(
              id: document.id,
              elderUserId: data['elderUserId'] as String? ?? '',
              visitDate:
                  (data['visitDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
              hospitalName: data['hospitalName'] as String? ?? '',
              department: data['department'] as String? ?? '',
              doctorName: data['doctorName'] as String? ?? '',
              diagnosis: data['diagnosis'] as String? ?? '',
              conclusion: data['conclusion'] as String? ?? '',
              notes: data['notes'] as String? ?? '',
              followUpDate: (data['followUpDate'] as Timestamp?)?.toDate(),
              createdById: data['createdById'] as String? ?? '',
              documents: documents,
            ),
          );
        }
        items.sort((a, b) => b.visitDate.compareTo(a.visitDate));
        return List.unmodifiable(items);
      });

  @override
  Future<String> createVisit(MedicalVisit visit) async {
    final reference = await _visits.add({
      'elderUserId': visit.elderUserId,
      'visitDate': Timestamp.fromDate(visit.visitDate),
      'hospitalName': visit.hospitalName,
      'department': visit.department,
      'doctorName': visit.doctorName,
      'diagnosis': visit.diagnosis,
      'conclusion': visit.conclusion,
      'notes': visit.notes,
      'followUpDate': visit.followUpDate == null
          ? null
          : Timestamp.fromDate(visit.followUpDate!),
      'createdById': visit.createdById,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return reference.id;
  }

  @override
  Future<void> attachDocument({
    required String elderId,
    required String visitId,
    required String fileName,
    required String contentType,
    required Uint8List bytes,
    required String uploadedById,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Bạn cần đăng nhập để tải tài liệu.');
    final token = await user.getIdToken();
    if (token == null || token.isEmpty) {
      throw StateError('Không thể xác thực với máy chủ tải tài liệu.');
    }
    final response = await _httpClient.post(
      Uri.parse('$_serverUrl/medical-documents'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'elderId': elderId,
        'visitId': visitId,
        'fileName': fileName,
        'contentType': contentType,
        'data': base64Encode(bytes),
      }),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      var message = 'Không thể tải tệp lên máy chủ.';
      try {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        message = body['message'] as String? ?? message;
      } catch (_) {
        // Keep the friendly fallback message when the response is not JSON.
      }
      throw StateError(message);
    }
  }

  @override
  Future<Uint8List> readDocument({
    required String visitId,
    required String documentId,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Bạn cần đăng nhập để xem tài liệu.');
    final token = await user.getIdToken();
    if (token == null || token.isEmpty) {
      throw StateError('Không thể xác thực với máy chủ tài liệu.');
    }
    final response = await _httpClient.get(
      Uri.parse('$_serverUrl/medical-documents/$visitId/$documentId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.bodyBytes;
    }
    var message = 'Không thể tải tài liệu từ máy chủ.';
    try {
      final body = jsonDecode(utf8.decode(response.bodyBytes))
          as Map<String, dynamic>;
      message = body['message'] as String? ?? message;
    } catch (_) {
      final responseText = utf8.decode(
        response.bodyBytes,
        allowMalformed: true,
      ).trim();
      if (responseText.isNotEmpty && responseText.length <= 300) {
        message = responseText;
      }
    }
    throw StateError('HTTP ${response.statusCode}: $message');
  }

  @override
  Future<Uri> createDocumentOpenUrl({
    required String visitId,
    required String documentId,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Bạn cần đăng nhập để xem tài liệu.');
    final token = await user.getIdToken();
    if (token == null || token.isEmpty) {
      throw StateError('Không thể xác thực với máy chủ tài liệu.');
    }
    final response = await _httpClient.post(
      Uri.parse('$_serverUrl/medical-documents/$visitId/$documentId/open'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError(
        'HTTP ${response.statusCode}: Không thể tạo liên kết PDF.',
      );
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final path = body['path'] as String?;
    if (path == null || path.isEmpty) {
      throw StateError('Máy chủ không trả về liên kết PDF.');
    }
    return Uri.parse('$_serverUrl$path');
  }
}
