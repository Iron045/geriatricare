import '../entities/sos_alert.dart';

abstract interface class SosRepository {
  Future<String> sendAlert(SosAlert alert);
  Stream<List<SosAlert>> watchActiveAlerts(String elderId);
  Stream<SosAlert?> watchAlert(String alertId);
  Future<void> acknowledgeAlert({
    required String alertId,
    required String childId,
  });
  Future<void> updateLocation({
    required String alertId,
    required double latitude,
    required double longitude,
    required double accuracy,
    required DateTime capturedAt,
  });
  Future<void> markEnRoute({required String alertId, required String childId});
  Future<void> markArrived({required String alertId, required String childId});
  Future<void> cancelAlert({
    required String alertId,
    required String userId,
    required String reason,
  });
  Future<void> resolveAlert({
    required String alertId,
    required String userId,
    required String resolutionType,
    String? note,
    bool includeResolutionDetails = true,
  });
}
