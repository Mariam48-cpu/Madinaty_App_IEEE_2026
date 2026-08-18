import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/personalization_entity.dart';

class PersonalizationModel extends PersonalizationEntity {
  const PersonalizationModel({
    required super.userId,
    super.interests,
    super.selectedMood,
    super.selectedOccasion,
    super.updatedAt,
  });

  factory PersonalizationModel.fromEntity(PersonalizationEntity entity) {
    return PersonalizationModel(
      userId: entity.userId,
      interests: entity.interests,
      selectedMood: entity.selectedMood,
      selectedOccasion: entity.selectedOccasion,
      updatedAt: entity.updatedAt,
    );
  }

  factory PersonalizationModel.fromMap(
    Map<String, dynamic> map,
    String userId,
  ) {
    DateTime? parseDate(dynamic val) {
      if (val == null) return null;
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val);
      return null;
    }

    return PersonalizationModel(
      userId: userId,
      interests: (map['interests'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      selectedMood: map['selectedMood'] as String?,
      selectedOccasion: map['selectedOccasion'] as String?,
      updatedAt: parseDate(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{
      'interests': interests,
      'selectedMood': selectedMood,
      'selectedOccasion': selectedOccasion,
    };
    if (updatedAt != null) {
      data['updatedAt'] = Timestamp.fromDate(updatedAt!);
    }
    return data;
  }
}
