import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_error_dialog.dart';
import '../providers/auth_providers.dart';

class EmailVerificationPage extends ConsumerStatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  ConsumerState<EmailVerificationPage> createState() =>
      _EmailVerificationPageState();
}

class _EmailVerificationPageState extends ConsumerState<EmailVerificationPage> {
  bool _checking = false;
  bool _sending = false;

  Future<void> _checkStatus() async {
    setState(() => _checking = true);
    try {
      final verified = await ref
          .read(authRepositoryProvider)
          .reloadEmailVerificationStatus();
      if (verified) {
        ref.invalidate(authUserIdProvider);
      } else if (mounted) {
        await showAppErrorDialog(
          context,
          message: 'Email chưa được xác thực. Hãy kiểm tra lại hộp thư.',
        );
      }
    } catch (error) {
      if (mounted) await showAppErrorDialog(context, message: error);
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  Future<void> _resend() async {
    setState(() => _sending = true);
    try {
      await ref.read(authRepositoryProvider).sendEmailVerification();
      if (mounted) {
        await showAppMessageDialog(
          context,
          message: 'Đã gửi lại email xác thực.',
          type: AppMessageType.success,
        );
      }
    } catch (error) {
      if (mounted) {
        await showAppErrorDialog(context, message: error);
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              children: [
                const Icon(
                  Icons.mark_email_unread_rounded,
                  size: 82,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 20),
                Text(
                  'Xác thực email',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Chúng tôi đã gửi email xác thực cho bạn. Hãy mở email, chọn liên kết xác thực rồi quay lại ứng dụng.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: AppColors.textMuted),
                ),
                const SizedBox(height: 28),
                FilledButton.icon(
                  onPressed: _checking ? null : _checkStatus,
                  icon: _checking
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.verified),
                  label: const Text('Tôi đã xác thực email'),
                ),
                TextButton(
                  onPressed: _sending ? null : _resend,
                  child: Text(_sending ? 'Đang gửi...' : 'Gửi lại email'),
                ),
                TextButton(
                  onPressed: () => performSignOut(ref),
                  child: const Text('Đăng xuất'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
