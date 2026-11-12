import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/app_user.dart';

class AppUserModel {
  const AppUserModel({
    required this.id,
    required this.phoneNumber,
    required this.fullName,
    required this.role,
    required this.createdAt,
    this.email = '',
    this.gender,
  });

  factory AppUserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? const <String, dynamic>{};
    return AppUserModel(
      id: document.id,
      phoneNumber: data['phoneNumber'] as String? ?? '',
      fullName: data['fullName'] as String? ?? '',
      email: data['email'] as String? ?? '',
      role: switch (data['role']) {
        'child' => UserRole.child,
        'caregiver' => UserRole.caregiver,
        'elder' => UserRole.elder,
        _ => throw FormatException('Vai trò tài khoản không được hỗ trợ.'),
      },
      createdAt:
          (data['createdAt'] as Timestamp?)?.toDate() ??
          DateTime.fromMillisecondsSinceEpoch(0),
      gender: _genderFromFirestore(data['gender']),
    );
  }

  factory AppUserModel.fromEntity(AppUser user) => AppUserModel(
    id: user.id,
    phoneNumber: user.phoneNumber,
    fullName: user.fullName,
    role: user.role,
    createdAt: user.createdAt,
    email: user.email,
    gender: user.gender,
  );

  final String id;
  final String phoneNumber;
  final String fullName;
  final UserRole role;
  final DateTime createdAt;
  final String email;
  final UserGender? gender;

  AppUser toEntity() => AppUser(
    id: id,
    phoneNumber: phoneNumber,
    fullName: fullName,
    role: role,
    createdAt: createdAt,
    email: email,
    gender: gender,
  );

  Map<String, Object?> toFirestore() => {
    'phoneNumber': phoneNumber,
    'email': email,
    'fullName': fullName,
    'role': role.name,
    'createdAt': Timestamp.fromDate(createdAt),
    'gender': gender?.name,
    'updatedAt': FieldValue.serverTimestamp(),
  };

  static UserGender? _genderFromFirestore(Object? value) {
    for (final gender in UserGender.values) {
      if (gender.name == value) return gender;
    }
    return null;
  }
}
