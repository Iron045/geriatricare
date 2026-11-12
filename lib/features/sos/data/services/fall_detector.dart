import 'dart:math' as math;

/// Detects the common fall sequence: short free fall followed by a strong
/// impact. Thresholds are intentionally conservative; the confirmation dialog
/// remains the final guard against false alarms.
final class FallDetector {
  FallDetector({
    this.freeFallThresholdG = .45,
    this.impactThresholdG = 2.5,
    this.maximumSequence = const Duration(milliseconds: 1600),
    this.cooldown = const Duration(seconds: 30),
  });

  final double freeFallThresholdG;
  final double impactThresholdG;
  final Duration maximumSequence;
  final Duration cooldown;

  DateTime? _freeFallAt;
  DateTime? _lastDetectionAt;

  bool addSample({
    required double x,
    required double y,
    required double z,
    required DateTime measuredAt,
  }) {
    final magnitudeG = math.sqrt(x * x + y * y + z * z) / 9.80665;
    final lastDetectionAt = _lastDetectionAt;
    if (lastDetectionAt != null &&
        measuredAt.difference(lastDetectionAt) < cooldown) {
      return false;
    }

    if (magnitudeG < freeFallThresholdG) {
      _freeFallAt = measuredAt;
      return false;
    }

    final freeFallAt = _freeFallAt;
    if (freeFallAt == null) return false;
    final elapsed = measuredAt.difference(freeFallAt);
    if (elapsed > maximumSequence) {
      _freeFallAt = null;
      return false;
    }
    if (magnitudeG < impactThresholdG) return false;

    _freeFallAt = null;
    _lastDetectionAt = measuredAt;
    return true;
  }

  void reset() => _freeFallAt = null;
}
