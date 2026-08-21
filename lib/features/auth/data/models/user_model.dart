import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  final DateTime? createdAt;

  const UserModel({
    required super.uid,
    super.name,
    super.email,
    super.phone,
    this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      name: map['name'] as String?,
      email: map['email'] as String?,
      phone: map['phone'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
    };
    if (createdAt != null) {
      data['createdAt'] = createdAt!.toIso8601String();
    }
    return data;
  }
}
