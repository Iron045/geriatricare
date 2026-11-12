enum SosTriggerMethod { button, shake }

enum SosStatus { active, acknowledged, enRoute, arrived, resolved, cancelled }

extension SosStatusX on SosStatus {
  bool get isOngoing =>
      this == SosStatus.active ||
      this == SosStatus.acknowledged ||
      this == SosStatus.enRoute ||
      this == SosStatus.arrived;

  bool get isClosed =>
      this == SosStatus.resolved || this == SosStatus.cancelled;
}

class SosAlert {
  const SosAlert({
    required this.id,
    required this.elderUserId,
    required this.triggerMethod,
    required this.status,
    required this.triggeredAt,
    this.latitude,
    this.longitude,
    this.locationAccuracy,
    this.locationCapturedAt,
    this.acknowledgedAt,
    this.acknowledgedById,
    this.enRouteAt,
    this.arrivedAt,
    this.resolvedAt,
    this.resolvedById,
    this.resolutionType,
    this.resolutionNote,
    this.cancelledById,
    this.cancellationReason,
  });

  final String id;
  final String elderUserId;
  final SosTriggerMethod triggerMethod;
  final double? latitude;
  final double? longitude;
  final double? locationAccuracy;
  final DateTime? locationCapturedAt;
  final SosStatus status;
  final DateTime triggeredAt;
  final DateTime? acknowledgedAt;
  final String? acknowledgedById;
  final DateTime? enRouteAt;
  final DateTime? arrivedAt;
  final DateTime? resolvedAt;
  final String? resolvedById;
  final String? resolutionType;
  final String? resolutionNote;
  final String? cancelledById;
  final String? cancellationReason;
}
