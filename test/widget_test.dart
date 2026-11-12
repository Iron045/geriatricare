import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geriatriccare/app/app.dart';
import 'package:geriatriccare/features/navigation/presentation/pages/elder_navigation_page.dart';
import 'package:geriatriccare/features/health/presentation/providers/health_providers.dart';
import 'package:geriatriccare/features/medication/presentation/providers/medication_providers.dart';
import 'package:geriatriccare/features/authentication/domain/entities/app_user.dart';
import 'package:geriatriccare/features/authentication/domain/repositories/auth_repository.dart';
import 'package:geriatriccare/features/authentication/presentation/providers/auth_providers.dart';

void main() {
  testWidgets('Elder home renders the primary emergency action', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(_TestAuthRepository()),
          medicationSchedulesProvider.overrideWith(
            (ref) => Stream.value(const []),
          ),
          todayMedicationIntakesProvider.overrideWith(
            (ref) => Stream.value(const []),
          ),
          healthRecordsProvider.overrideWith((ref) => Stream.value(const [])),
        ],
        child: const GeriatricCareApp(home: ElderNavigationPage()),
      ),
    );
    expect(find.text('GỌI KHẨN\nCẤP'), findsOneWidget);
    expect(find.text('Trang chủ'), findsOneWidget);
    expect(find.text('Sức khỏe'), findsOneWidget);
    expect(find.text('Liên hệ'), findsOneWidget);
  });
}

final class _TestAuthRepository implements AuthRepository {
  @override
  String? get currentUserId => null;

  @override
  bool get currentUserEmailVerified => true;

  @override
  Future<AppUser?> getProfile(String userId) async => null;

  @override
  Future<bool> reloadEmailVerificationStatus() async => true;

  @override
  Future<void> completeRegistration({
    required String email,
    required String phoneNumber,
    required String password,
    required String fullName,
    required UserRole role,
    required UserGender gender,
    required String code,
  }) async {}

  @override
  Future<void> requestRegistrationCode({
    required String email,
    required String phoneNumber,
  }) async {}

  @override
  Future<void> saveProfile(AppUser user) async {}

  @override
  Future<void> sendEmailVerification() async {}

  @override
  Future<void> signInWithPhoneAndPassword({
    required String phoneNumber,
    required String password,
  }) async {}

  @override
  Future<void> signOut() async {}

  @override
  Stream<String?> watchUserId() => Stream.value(null);
}
