import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  final DateTime? createdAt;

  const UserModel({
    required super.uid,
    super.name,
    super.email,
    super.phone,
    super.profileImageUrl,
    super.birthDate,
    super.points,
    this.createdAt,
  });

  factory UserModel.fromMap(
    Map<String, dynamic> map,
    String uid,
  ) {
    int parsedPoints = 0;
    if (map['points'] != null) {
      parsedPoints = (map['points'] as num).toInt();
    } else if (map['loyaltyPoints'] != null) {
      parsedPoints = (map['loyaltyPoints'] as num).toInt();
    }

    return UserModel(
      uid: uid,
      name: map['name'] as String?,
      email: map['email'] as String?,
      phone: map['phone'] as String?,
      profileImageUrl: map['profileImageUrl'] as String?,
      birthDate: map['birthDate'] != null
          ? DateTime.tryParse(map['birthDate'].toString())
          : null,
      points: parsedPoints,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
      'points': points,
    };

    if (birthDate != null) {
      data['birthDate'] = birthDate!.toIso8601String();
    }

    if (createdAt != null) {
      data['createdAt'] = createdAt!.toIso8601String();
    }

    return data;
  }
}