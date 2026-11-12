import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FallConfirmationDialog extends StatefulWidget {
  const FallConfirmationDialog({super.key, this.seconds = 15});

  final int seconds;

  @override
  State<FallConfirmationDialog> createState() =>
      _FallConfirmationDialogState();
}

class _FallConfirmationDialogState extends State<FallConfirmationDialog> {
  late int _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remaining = widget.seconds;
    HapticFeedback.heavyImpact();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_remaining <= 1) {
        _timer?.cancel();
        Navigator.of(context).pop(true);
      } else {
        setState(() => _remaining--);
        HapticFeedback.mediumImpact();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    child: AlertDialog(
      icon: const Icon(Icons.personal_injury_rounded, size: 58),
      title: const Text(
        'Phát hiện có thể bị ngã',
        textAlign: TextAlign.center,
      ),
      content: Text(
        'Hệ thống sẽ tự động gửi SOS sau $_remaining giây nếu bạn không phản hồi.',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        FilledButton.icon(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(58),
            backgroundColor: Colors.green,
          ),
          onPressed: () => Navigator.of(context).pop(false),
          icon: const Icon(Icons.check_circle_rounded),
          label: const Text('TÔI VẪN ỔN'),
        ),
        const SizedBox(height: 8),
        FilledButton.icon(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(58),
            backgroundColor: Colors.red,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          icon: const Icon(Icons.sos_rounded),
          label: const Text('GỬI SOS NGAY'),
        ),
      ],
    ),
  );
}
