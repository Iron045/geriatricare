import '../entities/app_user.dart';

abstract interface class AuthRepository {
  Stream<String?> watchUserId();
  String? get currentUserId;
  bool get currentUserEmailVerified;
  Future<void> requestRegistrationCode({
    required String email,
    required String phoneNumber,
  });
  Future<void> completeRegistration({
    required String email,
    required String phoneNumber,
    required String password,
    required String fullName,
    required UserRole role,
    required UserGender gender,
    required String code,
  });
  Future<void> signInWithPhoneAndPassword({
    required String phoneNumber,
    required String password,
  });
  Future<void> sendEmailVerification();
  Future<bool> reloadEmailVerificationStatus();
  Future<AppUser?> getProfile(String userId);
  Future<void> saveProfile(AppUser user);
  Future<void> signOut();
}
