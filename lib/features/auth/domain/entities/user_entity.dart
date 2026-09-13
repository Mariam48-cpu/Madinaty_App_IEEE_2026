enum UserRole {
  customer,
  cafeOwner;

  static UserRole fromString(String? role) {
    if (role == null) return UserRole.customer;
    final r = role.trim().toLowerCase();
    if (r == 'cafe_owner' || r == 'cafeowner') {
      return UserRole.cafeOwner;
    }
    return UserRole.customer;
  }

  String toMapValue() {
    switch (this) {
      case UserRole.cafeOwner:
        return 'cafe_owner';
      case UserRole.customer:
        return 'customer';
    }
  }
}

class UserEntity {
  final String uid;
  final String? name;
  final String? email;
  final String? phone;
  final String? profileImageUrl;
  final DateTime? birthDate;
  final UserRole role;
  final String? cafeId;
  final int points;

  const UserEntity({
    required this.uid,
    this.name,
    this.email,
    this.phone,
    this.profileImageUrl,
    this.birthDate,
    this.role = UserRole.customer,
    this.cafeId,
    this.points = 0,
  });

  bool get isCafeOwner => role == UserRole.cafeOwner;
}