import 'package:flutter_test/flutter_test.dart';
import 'package:geriatriccare/features/sos/data/services/fall_detector.dart';

void main() {
  test('detects free fall followed by a strong impact', () {
    final detector = FallDetector();
    final start = DateTime(2026);

    expect(
      detector.addSample(x: 0, y: 0, z: 1, measuredAt: start),
      isFalse,
    );
    expect(
      detector.addSample(
        x: 0,
        y: 0,
        z: 30,
        measuredAt: start.add(const Duration(milliseconds: 500)),
      ),
      isTrue,
    );
  });

  test('does not treat an isolated impact as a fall', () {
    final detector = FallDetector();

    expect(
      detector.addSample(x: 0, y: 0, z: 30, measuredAt: DateTime(2026)),
      isFalse,
    );
  });

  test('rejects an impact arriving too late', () {
    final detector = FallDetector();
    final start = DateTime(2026);
    detector.addSample(x: 0, y: 0, z: 1, measuredAt: start);

    expect(
      detector.addSample(
        x: 0,
        y: 0,
        z: 30,
        measuredAt: start.add(const Duration(seconds: 2)),
      ),
      isFalse,
    );
  });
}
