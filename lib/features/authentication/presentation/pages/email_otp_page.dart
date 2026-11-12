import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_error_dialog.dart';
import '../../domain/entities/app_user.dart';
import '../providers/auth_providers.dart';

class EmailOtpPage extends ConsumerStatefulWidget {
  const EmailOtpPage({
    super.key,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.fullName,
    required this.role,
    required this.gender,
  });

  final String email;
  final String phoneNumber;
  final String password;
  final String fullName;
  final UserRole role;
  final UserGender gender;

  @override
  ConsumerState<EmailOtpPage> createState() => _EmailOtpPageState();
}

class _EmailOtpPageState extends ConsumerState<EmailOtpPage> {
  final _codeController = TextEditingController();
  Timer? _timer;
  int _resendAfter = 60;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _resendAfter = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_resendAfter <= 1) {
        timer.cancel();
        setState(() => _resendAfter = 0);
      } else {
        setState(() => _resendAfter--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final code = _codeController.text.trim();
    if (!RegExp(r'^\d{6}$').hasMatch(code)) {
      await showAppErrorDialog(
        context,
        message: 'Mã xác thực phải gồm đúng 6 chữ số.',
      );
      return;
    }
    setState(() => _loading = true);
    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.completeRegistration(
        email: widget.email,
        phoneNumber: widget.phoneNumber,
        password: widget.password,
        fullName: widget.fullName,
        role: widget.role,
        gender: widget.gender,
        code: code,
      );
      final userId = repository.currentUserId;
      if (userId != null) ref.invalidate(currentProfileProvider(userId));
      ref.invalidate(authUserIdProvider);
      if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (error) {
      if (mounted) await showAppErrorDialog(context, message: error);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _resend() async {
    setState(() => _loading = true);
    try {
      await ref
          .read(authRepositoryProvider)
          .requestRegistrationCode(
            email: widget.email,
            phoneNumber: widget.phoneNumber,
          );
      _codeController.clear();
      _startTimer();
      if (mounted) {
        await showAppMessageDialog(
          context,
          message: 'Đã gửi lại mã xác thực.',
          type: AppMessageType.success,
        );
      }
    } catch (error) {
      if (mounted) await showAppErrorDialog(context, message: error);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Xác thực email')),
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              children: [
                const Icon(
                  Icons.mark_email_read_rounded,
                  size: 82,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 20),
                Text(
                  'Nhập mã xác thực',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                Text(
                  'Mã gồm 6 chữ số đã được gửi đến\n${widget.email}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 28),
                TextField(
                  controller: _codeController,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  onSubmitted: (_) => _loading ? null : _verify(),
                  style: const TextStyle(
                    fontSize: 30,
                    letterSpacing: 12,
                    fontWeight: FontWeight.w800,
                  ),
                  decoration: const InputDecoration(
                    counterText: '',
                    hintText: '------',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 22),
                FilledButton(
                  onPressed: _loading ? null : _verify,
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      child: Center(
                        child: _loading
                            ? const SizedBox.square(
                                dimension: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Xác nhận'),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _loading || _resendAfter > 0 ? null : _resend,
                  child: Text(
                    _resendAfter > 0
                        ? 'Gửi lại mã sau $_resendAfter giây'
                        : 'Gửi lại mã',
                  ),
                ),
                const Text(
                  'Mã có hiệu lực trong 10 phút và tối đa 5 lần nhập sai.',
                  style: TextStyle(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
