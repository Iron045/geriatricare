import 'dart:async';

import 'package:sensors_plus/sensors_plus.dart';

import 'fall_detector.dart';

final class FallDetectionService {
  FallDetectionService({FallDetector? detector})
    : _detector = detector ?? FallDetector();

  final FallDetector _detector;
  StreamSubscription<AccelerometerEvent>? _subscription;

  bool get isRunning => _subscription != null;

  void start({required void Function() onFallDetected}) {
    if (_subscription != null) return;
    _subscription = accelerometerEventStream(
      samplingPeriod: SensorInterval.gameInterval,
    ).listen(
      (event) {
        final detected = _detector.addSample(
          x: event.x,
          y: event.y,
          z: event.z,
          measuredAt: DateTime.now(),
        );
        if (detected) onFallDetected();
      },
      onError: (_) => stop(),
      cancelOnError: false,
    );
  }

  void stop() {
    _subscription?.cancel();
    _subscription = null;
    _detector.reset();
  }

  void dispose() => stop();
}
