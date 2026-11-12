import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/app_exception.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/app_user_model.dart';

final class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._auth, this._firestore, this._httpClient);

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final http.Client _httpClient;

  static const _otpServerUrl = String.fromEnvironment(
    'OTP_SERVER_URL',
    defaultValue: 'http://192.168.1.12:3000',
  );

  @override
  String? get currentUserId => _auth.currentUser?.uid;
  @override
  bool get currentUserEmailVerified =>
      _auth.currentUser?.emailVerified ?? false;
  @override
  Stream<String?> watchUserId() => _auth.authStateChanges().map((u) => u?.uid);

  @override
  Future<void> requestRegistrationCode({
    required String email,
    required String phoneNumber,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final normalizedPhone = _normalizePhone(phoneNumber);
    try {
      final phoneDirectory = await _firestore
          .collection('login_directory')
          .doc(normalizedPhone)
          .get();
      if (phoneDirectory.exists) {
        throw const ValidationException('Số điện thoại đã được sử dụng.');
      }
      await _postOtp('/otp/send', {'email': normalizedEmail});
    } on AppException {
      rethrow;
    } catch (error) {
      throw NetworkException('Không thể kết nối máy chủ gửi OTP.', error);
    }
  }

  @override
  Future<void> completeRegistration({
    required String email,
    required String phoneNumber,
    required String password,
    required String fullName,
    required UserRole role,
    required UserGender gender,
    required String code,
  }) async {
    _validatePassword(password);
    final normalizedEmail = email.trim().toLowerCase();
    final normalizedPhone = _normalizePhone(phoneNumber);
    UserCredential? credential;
    try {
      await _postOtp('/otp/verify', {'email': normalizedEmail, 'code': code});
      credential = await _auth.createUserWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );
      await saveProfile(
        AppUser(
          id: credential.user!.uid,
          email: normalizedEmail,
          phoneNumber: normalizedPhone,
          fullName: fullName.trim(),
          role: role,
          gender: gender,
          createdAt: DateTime.now(),
        ),
      );
    } on AppException {
      rethrow;
    } on FirebaseAuthException catch (error) {
      throw ValidationException(
        _firebaseAuthMessage(error, 'Không thể hoàn tất đăng ký.'),
        error,
      );
    } on FirebaseException catch (error) {
      if (credential?.user != null) {
        await credential!.user!.delete().catchError((_) {});
      }
      final message = switch (error.code) {
        'permission-denied' =>
          'Firestore từ chối lưu hồ sơ. Hãy triển khai Firestore Rules mới.',
        'unavailable' => 'Không thể kết nối Firestore. Hãy kiểm tra Internet.',
        _ => 'Không thể lưu hồ sơ người dùng (${error.code}).',
      };
      throw DatabaseException(message, error);
    } catch (error) {
      if (credential?.user != null) {
        await credential!.user!.delete().catchError((_) {});
      }
      throw NetworkException('Không thể hoàn tất đăng ký.', error);
    }
  }

  Future<Map<String, dynamic>> _postOtp(
    String path,
    Map<String, String> body,
  ) async {
    final response = await _httpClient
        .post(
          Uri.parse('$_otpServerUrl$path'),
          headers: const {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 20));
    final decoded = jsonDecode(response.body);
    final data = decoded is Map<String, dynamic>
        ? decoded
        : <String, dynamic>{};
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ValidationException(
        data['message'] as String? ?? 'Máy chủ OTP trả về lỗi.',
      );
    }
    return data;
  }

  @override
  Future<void> signInWithPhoneAndPassword({
    required String phoneNumber,
    required String password,
  }) async {
    _validatePassword(password);
    final phone = _normalizePhone(phoneNumber);
    final directory = await _firestore
        .collection('login_directory')
        .doc(phone)
        .get();
    final email = directory.data()?['email'] as String?;
    if (email == null || email.isEmpty) {
      throw const ValidationException(
        'Số điện thoại hoặc mật khẩu không chính xác.',
      );
    }
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (error) {
      throw ValidationException(
        _firebaseAuthMessage(
          error,
          'Số điện thoại hoặc mật khẩu không chính xác.',
        ),
        error,
      );
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user == null) throw const ValidationException('Bạn chưa đăng nhập.');
    if (!user.emailVerified) await user.sendEmailVerification();
  }

  @override
  Future<bool> reloadEmailVerificationStatus() async {
    final user = _auth.currentUser;
    if (user == null) return false;
    await user.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }

  @override
  Future<AppUser?> getProfile(String userId) async {
    final document = await _firestore.collection('users').doc(userId).get();
    return document.exists
        ? AppUserModel.fromFirestore(document).toEntity()
        : null;
  }

  @override
  Future<void> saveProfile(AppUser user) async {
    final data = AppUserModel.fromEntity(user).toFirestore();
    data['dateOfBirth'] = FieldValue.delete();
    QuerySnapshot<Map<String, dynamic>>? relatedLinks;
    if (user.role == UserRole.elder) {
      relatedLinks = await _firestore
          .collection('account_links')
          .where('elderId', isEqualTo: user.id)
          .get();
    } else if (
        user.role == UserRole.child || user.role == UserRole.caregiver) {
      relatedLinks = await _firestore
          .collection('account_links')
          .where('childId', isEqualTo: user.id)
          .get();
    }
    final batch = _firestore.batch();
    batch.set(
      _firestore.collection('users').doc(user.id),
      data,
      SetOptions(merge: true),
    );
    batch.set(
      _firestore.collection('user_directory').doc(user.phoneNumber),
      {
        'uid': user.id,
        'email': user.email,
        'phoneNumber': user.phoneNumber,
        'role': user.role.name,
        'fullName': user.fullName,
        'gender': user.gender?.name,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
    batch.set(
      _firestore.collection('login_directory').doc(user.phoneNumber),
      {
        'uid': user.id,
        'email': user.email,
        'phoneNumber': user.phoneNumber,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
    batch.set(
      _firestore
          .collection('email_directory')
          .doc(_emailDirectoryKey(user.email)),
      {
        'uid': user.id,
        'email': user.email,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
    if (relatedLinks != null) {
      final nameField = user.role == UserRole.elder ? 'elderName' : 'childName';
      for (final document in relatedLinks.docs) {
        batch.update(document.reference, {
          nameField: user.fullName,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    }
    await batch.commit();
  }

  @override
  Future<void> signOut() => _auth.signOut();
}

void _validatePassword(String password) {
  if (!RegExp(r'^\d{6}$').hasMatch(password)) {
    throw const ValidationException('Mật khẩu phải gồm đúng 6 chữ số.');
  }
}

String _normalizePhone(String value) {
  final compact = value.replaceAll(RegExp(r'\D'), '');
  if (!RegExp(r'^0\d{9}$').hasMatch(compact)) {
    throw const ValidationException(
      'Số điện thoại phải gồm 10 chữ số và bắt đầu bằng số 0.',
    );
  }
  return '+84${compact.substring(1)}';
}

String _emailDirectoryKey(String email) => base64Url
    .encode(utf8.encode(email.trim().toLowerCase()))
    .replaceAll('=', '');

String _firebaseAuthMessage(FirebaseAuthException error, String fallback) =>
    switch (error.code) {
      'email-already-in-use' => 'Email đã được sử dụng.',
      'invalid-email' => 'Email không hợp lệ.',
      'weak-password' => 'Mật khẩu chưa đáp ứng yêu cầu bảo mật.',
      'operation-not-allowed' =>
        'Firebase chưa bật phương thức đăng nhập Email/Password.',
      'invalid-credential' ||
      'wrong-password' ||
      'user-not-found' => 'Số điện thoại hoặc mật khẩu không chính xác.',
      'too-many-requests' => 'Bạn đã thử quá nhiều lần. Vui lòng thử lại sau.',
      'network-request-failed' =>
        'Không thể kết nối mạng. Vui lòng kiểm tra Internet.',
      _ => fallback,
    };
