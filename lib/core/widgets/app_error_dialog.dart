import 'package:flutter/material.dart';

enum AppMessageType { info, success, warning, error }

Future<void> showAppMessageDialog(
  BuildContext context, {
  required Object message,
  String? title,
  AppMessageType type = AppMessageType.info,
}) {
  final (defaultTitle, icon, color) = switch (type) {
    AppMessageType.success => (
      'Thành công',
      Icons.check_circle_outline_rounded,
      Colors.green,
    ),
    AppMessageType.warning => (
      'Thông báo',
      Icons.warning_amber_rounded,
      Colors.orange,
    ),
    AppMessageType.error => (
      'Thông báo lỗi',
      Icons.error_outline_rounded,
      Colors.red,
    ),
    AppMessageType.info => (
      'Thông báo',
      Icons.info_outline_rounded,
      Colors.blue,
    ),
  };
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) => AlertDialog(
      icon: Icon(icon, color: color, size: 52),
      title: Text(title ?? defaultTitle, textAlign: TextAlign.center),
      content: Text(_friendlyErrorMessage(message), textAlign: TextAlign.center),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: color),
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Xác nhận'),
        ),
      ],
    ),
  );
}

Future<void> showAppErrorDialog(
  BuildContext context, {
  required Object message,
  String title = 'Thông báo lỗi',
}) {
  return showAppMessageDialog(
    context,
    message: message,
    title: title,
    type: AppMessageType.error,
  );
}

String _friendlyErrorMessage(Object error) {
  var message = error.toString().trim();
  for (final prefix in const [
    'Exception: ',
    'ValidationException: ',
    'StateError: ',
  ]) {
    if (message.startsWith(prefix)) message = message.substring(prefix.length);
  }
  return message.isEmpty ? 'Đã xảy ra lỗi. Vui lòng thử lại.' : message;
}
