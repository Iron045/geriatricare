import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/sos_alert.dart';
import '../../domain/repositories/sos_repository.dart';
import '../models/sos_alert_model.dart';

final class SosRepositoryImpl implements SosRepository {
  SosRepositoryImpl(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _alerts =>
      _firestore.collection('sos_alerts');

  @override
  Future<String> sendAlert(SosAlert alert) async {
    final existingSnapshot = await _alerts
        .where('elderUserId', isEqualTo: alert.elderUserId)
        .get();
    final existing =
        existingSnapshot.docs
            .map(SosAlertModel.fromFirestore)
            .where((item) => item.status.isOngoing)
            .toList()
          ..sort((a, b) => b.triggeredAt.compareTo(a.triggeredAt));
    if (existing.isNotEmpty) return existing.first.id;
    final document = alert.id.isEmpty ? _alerts.doc() : _alerts.doc(alert.id);
    await document.set(SosAlertModel.toFirestore(alert));
    return document.id;
  }

  @override
  Stream<List<SosAlert>> watchActiveAlerts(String elderId) => _alerts
      .where('elderUserId', isEqualTo: elderId)
      .snapshots()
      .map((snapshot) {
        final alerts = snapshot.docs
            .map(SosAlertModel.fromFirestore)
            .where((alert) => alert.status.isOngoing)
            .toList();
        alerts.sort((a, b) => b.triggeredAt.compareTo(a.triggeredAt));
        return alerts;
      });

  @override
  Stream<SosAlert?> watchAlert(String alertId) => _alerts
      .doc(alertId)
      .snapshots()
      .map(
        (snapshot) =>
            snapshot.exists ? SosAlertModel.fromFirestore(snapshot) : null,
      );

  @override
  Future<void> acknowledgeAlert({
    required String alertId,
    required String childId,
  }) => _transition(
    alertId: alertId,
    actorId: childId,
    allowedFrom: const {SosStatus.active},
    to: SosStatus.acknowledged,
    values: {
      'acknowledgedAt': FieldValue.serverTimestamp(),
      'acknowledgedById': childId,
    },
  );

  @override
  Future<void> updateLocation({
    required String alertId,
    required double latitude,
    required double longitude,
    required double accuracy,
    required DateTime capturedAt,
  }) => _alerts.doc(alertId).update({
    'latitude': latitude,
    'longitude': longitude,
    'locationAccuracy': accuracy,
    'locationCapturedAt': Timestamp.fromDate(capturedAt),
  });

  @override
  Future<void> markEnRoute({
    required String alertId,
    required String childId,
  }) => _transition(
    alertId: alertId,
    actorId: childId,
    allowedFrom: const {SosStatus.acknowledged},
    to: SosStatus.enRoute,
    values: {'enRouteAt': FieldValue.serverTimestamp()},
    requiredResponderId: childId,
  );

  @override
  Future<void> markArrived({
    required String alertId,
    required String childId,
  }) => _transition(
    alertId: alertId,
    actorId: childId,
    allowedFrom: const {SosStatus.enRoute},
    to: SosStatus.arrived,
    values: {'arrivedAt': FieldValue.serverTimestamp()},
    requiredResponderId: childId,
  );

  @override
  Future<void> cancelAlert({
    required String alertId,
    required String userId,
    required String reason,
  }) async {
    final allowedStatuses = <SosStatus>{
      SosStatus.active,
      SosStatus.acknowledged,
      SosStatus.enRoute,
      SosStatus.arrived,
    };
    try {
      await _transition(
        alertId: alertId,
        actorId: userId,
        allowedFrom: allowedStatuses,
        to: SosStatus.cancelled,
        values: {
          'resolvedAt': FieldValue.serverTimestamp(),
          'cancelledById': userId,
          'cancellationReason': reason.trim(),
        },
      );
    } on FirebaseException catch (error) {
      if (error.code != 'permission-denied') rethrow;
      // Tương thích rules cũ chỉ cho cập nhật trạng thái và thời gian.
      await _transition(
        alertId: alertId,
        actorId: userId,
        allowedFrom: allowedStatuses,
        to: SosStatus.cancelled,
        values: {'resolvedAt': FieldValue.serverTimestamp()},
      );
    }
  }

  @override
  Future<void> resolveAlert({
    required String alertId,
    required String userId,
    required String resolutionType,
    String? note,
    bool includeResolutionDetails = true,
  }) {
    final values = <String, Object?>{
      'resolvedAt': FieldValue.serverTimestamp(),
    };
    if (includeResolutionDetails) {
      values.addAll({
        'resolvedById': userId,
        'resolutionType': resolutionType,
        'resolutionNote': note?.trim(),
      });
    }
    return _transition(
      alertId: alertId,
      actorId: userId,
      allowedFrom: const {
        SosStatus.acknowledged,
        SosStatus.enRoute,
        SosStatus.arrived,
      },
      to: SosStatus.resolved,
      values: values,
    );
  }

  Future<void> _transition({
    required String alertId,
    required String actorId,
    required Set<SosStatus> allowedFrom,
    required SosStatus to,
    required Map<String, Object?> values,
    String? requiredResponderId,
  }) async {
    final alertRef = _alerts.doc(alertId);
    SosStatus? previousStatus;
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(alertRef);
      if (!snapshot.exists) throw StateError('Cảnh báo SOS không còn tồn tại.');
      final alert = SosAlertModel.fromFirestore(snapshot);
      if (!allowedFrom.contains(alert.status)) {
        throw StateError('Cảnh báo đã được người khác cập nhật.');
      }
      if (requiredResponderId != null &&
          alert.acknowledgedById != requiredResponderId) {
        throw StateError('Cảnh báo đã được một người thân khác tiếp nhận.');
      }
      previousStatus = alert.status;
      transaction.update(alertRef, {'status': to.name, ...values});
    });

    // Nhật ký là dữ liệu bổ sung: không được phép làm thất bại thao tác SOS
    // chính khi rules cũ chưa hỗ trợ subcollection `events`.
    try {
      await alertRef.collection('events').add({
        'fromStatus': previousStatus?.name ?? 'unknown',
        'toStatus': to.name,
        'actorId': actorId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException {
      // Trạng thái SOS đã được cập nhật thành công; có thể ghi nhật ký lại sau.
    }
  }
}
