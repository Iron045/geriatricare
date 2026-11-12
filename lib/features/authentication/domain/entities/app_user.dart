enum UserRole { elder, child, caregiver }

enum UserGender { male, female, other }

extension UserGenderLabel on UserGender? {
  String get elderHonorific => switch (this) {
    UserGender.male => 'Ông',
    UserGender.female => 'Bà',
    _ => 'Người cao tuổi',
  };

  String get parentRelationship => switch (this) {
    UserGender.male => 'Bố',
    UserGender.female => 'Mẹ',
    _ => 'Người thân',
  };
}

UserGender? userGenderFromName(String? value) {
  for (final gender in UserGender.values) {
    if (gender.name == value) return gender;
  }
  return null;
}

class AppUser {
  const AppUser({
    required this.id,
    required this.phoneNumber,
    required this.fullName,
    required this.role,
    required this.createdAt,
    this.email = '',
    this.gender,
  });

  final String id;
  final String phoneNumber;
  final String fullName;
  final UserRole role;
  final DateTime createdAt;
  final String email;
  final UserGender? gender;
}
