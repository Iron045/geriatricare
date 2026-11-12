import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_error_dialog.dart';
import '../../domain/entities/app_user.dart';
import '../providers/auth_providers.dart';
import 'email_otp_page.dart';

class PhoneAuthPage extends ConsumerStatefulWidget {
  const PhoneAuthPage({super.key});

  @override
  ConsumerState<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends ConsumerState<PhoneAuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  UserRole _role = UserRole.elder;
  UserGender _gender = UserGender.male;
  bool _isRegister = false;
  bool _loading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      await showAppErrorDialog(
        context,
        message: 'Thông tin không hợp lệ. Vui lòng kiểm tra các trường được đánh dấu.',
      );
      return;
    }
    setState(() => _loading = true);
    try {
      final repository = ref.read(authRepositoryProvider);
      if (_isRegister) {
        await repository.requestRegistrationCode(
          email: _emailController.text,
          phoneNumber: _phoneController.text,
        );
        if (!mounted) return;
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => EmailOtpPage(
              email: _emailController.text.trim().toLowerCase(),
              phoneNumber: _phoneController.text,
              password: _passwordController.text,
              fullName: _nameController.text.trim(),
              role: _role,
              gender: _gender,
            ),
          ),
        );
      } else {
        await repository.signInWithPhoneAndPassword(
          phoneNumber: _phoneController.text,
          password: _passwordController.text,
        );
        ref.invalidate(authUserIdProvider);
      }
    } catch (error) {
      if (mounted) {
        await showAppErrorDialog(context, message: error);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.monitor_heart_rounded,
                        size: 68,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        _isRegister ? 'Đăng ký tài khoản' : 'Đăng nhập',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isRegister
                            ? 'Xác thực tài khoản qua email'
                            : 'Đăng nhập bằng số điện thoại và mật khẩu',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 28),
                      if (_isRegister) ...[
                        TextFormField(
                          controller: _nameController,
                          textInputAction: TextInputAction.next,
                          decoration: _decoration('Họ và tên', Icons.person),
                          validator: (value) =>
                              value == null || value.trim().length < 2
                              ? 'Vui lòng nhập họ và tên'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: _decoration('Email', Icons.email),
                          validator: (value) =>
                              value == null ||
                                  !RegExp(
                                    r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                                  ).hasMatch(value.trim())
                              ? 'Email chưa hợp lệ'
                              : null,
                        ),
                        const SizedBox(height: 16),
                      ],
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        decoration: _decoration('Số điện thoại', Icons.phone),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        maxLength: 10,
                        validator: (value) =>
                            value == null ||
                                !RegExp(r'^0\d{9}$').hasMatch(value)
                            ? 'Số điện thoại phải có 10 số và bắt đầu bằng 0'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        maxLength: 6,
                        onFieldSubmitted: (_) => _loading ? null : _submit(),
                        decoration:
                            _decoration(
                              'Mật khẩu gồm 6 chữ số',
                              Icons.lock,
                            ).copyWith(
                              counterText: '',
                              suffixIcon: IconButton(
                                onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                        validator: (value) =>
                            value == null || !RegExp(r'^\d{6}$').hasMatch(value)
                            ? 'Mật khẩu phải gồm đúng 6 chữ số'
                            : null,
                      ),
                      if (_isRegister) ...[
                        const SizedBox(height: 16),
                        DropdownButtonFormField<UserRole>(
                          initialValue: _role,
                          decoration: _decoration('Vai trò', Icons.badge),
                          items: const [
                            DropdownMenuItem(
                              value: UserRole.elder,
                              child: Text('Người cao tuổi'),
                            ),
                            DropdownMenuItem(
                              value: UserRole.child,
                              child: Text('Con cái'),
                            ),
                            DropdownMenuItem(
                              value: UserRole.caregiver,
                              child: Text('Người chăm sóc'),
                            ),
                          ],
                          onChanged: (value) =>
                              setState(() => _role = value ?? UserRole.elder),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<UserGender>(
                          initialValue: _gender,
                          decoration: _decoration('Giới tính', Icons.wc),
                          items: const [
                            DropdownMenuItem(
                              value: UserGender.male,
                              child: Text('Nam'),
                            ),
                            DropdownMenuItem(
                              value: UserGender.female,
                              child: Text('Nữ'),
                            ),
                            DropdownMenuItem(
                              value: UserGender.other,
                              child: Text('Khác'),
                            ),
                          ],
                          onChanged: (value) => setState(
                            () => _gender = value ?? UserGender.male,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Sau khi đăng ký, hệ thống sẽ gửi mã xác thực gồm 6 chữ số đến email của bạn.',
                          style: TextStyle(color: AppColors.textMuted),
                        ),
                      ],
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: _loading ? null : _submit,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: _loading
                              ? const SizedBox.square(
                                  dimension: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(_isRegister ? 'Đăng ký' : 'Đăng nhập'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: _loading
                            ? null
                            : () => setState(() {
                                _isRegister = !_isRegister;
                                _formKey.currentState?.reset();
                              }),
                        child: Text(
                          _isRegister
                              ? 'Đã có tài khoản? Đăng nhập'
                              : 'Chưa có tài khoản? Đăng ký',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  InputDecoration _decoration(String label, IconData icon) => InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon),
    filled: true,
    fillColor: AppColors.background,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
  );
}
