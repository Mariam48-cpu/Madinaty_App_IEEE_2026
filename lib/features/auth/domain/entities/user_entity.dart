class UserEntity {
  final String uid;
  final String? name;
  final String? email;
  final String? phone;
  final String? profileImageUrl;
  final DateTime? birthDate;
  final int points;

  const UserEntity({
    required this.uid,
    this.name,
    this.email,
    this.phone,
    this.profileImageUrl,
    this.birthDate,
    this.points = 0,
  });
}