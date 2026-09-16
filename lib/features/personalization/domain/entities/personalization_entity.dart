class PersonalizationEntity {
  final String userId;
  final List<String> interests;
  final String? selectedMood;
  final String? selectedOccasion;
  final DateTime? outingReasonDate;
  final DateTime? updatedAt;

  const PersonalizationEntity({
    required this.userId,
    this.interests = const [],
    this.selectedMood,
    this.selectedOccasion,
    this.outingReasonDate,
    this.updatedAt,
  });

  PersonalizationEntity copyWith({
    String? userId,
    List<String>? interests,
    String? selectedMood,
    String? selectedOccasion,
    DateTime? outingReasonDate,
    DateTime? updatedAt,
  }) {
    return PersonalizationEntity(
      userId: userId ?? this.userId,
      interests: interests ?? this.interests,
      selectedMood: selectedMood ?? this.selectedMood,
      selectedOccasion: selectedOccasion ?? this.selectedOccasion,
      outingReasonDate: outingReasonDate ?? this.outingReasonDate,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonalizationEntity &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          _listEquals(interests, other.interests) &&
          selectedMood == other.selectedMood &&
          selectedOccasion == other.selectedOccasion &&
          outingReasonDate == other.outingReasonDate &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode => Object.hash(
        userId,
        Object.hashAll(interests),
        selectedMood,
        selectedOccasion,
        outingReasonDate,
        updatedAt,
      );

  static bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
