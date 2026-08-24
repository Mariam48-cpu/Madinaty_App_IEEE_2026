import '../../../../../core/localization/app_locale.dart';

class AIPlanIntentDTO {
  final String mood;
  final int durationHours;
  final double budget;
  final List<String> activities;
  final List<String> requirements;
  final String weatherPreference;

  const AIPlanIntentDTO({
    required this.mood,
    required this.durationHours,
    required this.budget,
    required this.activities,
    required this.requirements,
    required this.weatherPreference,
  });

  factory AIPlanIntentDTO.fromJson(Map<String, dynamic> json) {
    List<String> strings(dynamic value) => value is List
        ? value
        .map((e) => e.toString().trim())
        .where((e) => e.isNotEmpty)
        .toList()
        : const [];

    return AIPlanIntentDTO(
      mood: (json['mood'] ?? '').toString(),
      durationHours: (json['durationHours'] as num?)?.toInt() ?? 2,
      budget: (json['budget'] as num?)?.toDouble() ?? 0,
      activities: strings(json['activities']),
      requirements: strings(json['requirements']),
      weatherPreference: (json['weatherPreference'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'mood': mood,
    'durationHours': durationHours,
    'budget': budget,
    'activities': activities,
    'requirements': requirements,
    'weatherPreference': weatherPreference,
  };
}

class AIPlanFinalDTO {
  final String headline;
  final String summary;
  final double estimatedTotal;
  final List<AIPlanActivityDTO> activities;

  const AIPlanFinalDTO({
    required this.headline,
    required this.summary,
    required this.estimatedTotal,
    required this.activities,
  });

  factory AIPlanFinalDTO.fromJson(Map<String, dynamic> json) {
    final raw = json['activities'];
    final activities = raw is List
        ? raw
        .whereType<Map>()
        .map((e) =>
        AIPlanActivityDTO.fromJson(Map<String, dynamic>.from(e)))
        .toList()
        : <AIPlanActivityDTO>[];

    return AIPlanFinalDTO(
      headline: (json['headline'] ?? AppLocale.aiDefaultHeadline).toString(),
      summary: (json['summary'] ?? '').toString(),
      estimatedTotal: (json['estimatedTotal'] as num?)?.toDouble() ?? 0,
      activities: activities,
    );
  }

  Map<String, dynamic> toJson() => {
    'headline': headline,
    'summary': summary,
    'estimatedTotal': estimatedTotal,
    'activities': activities.map((e) => e.toJson()).toList(),
  };
}

class AIPlanActivityDTO {
  final String title;
  final String purpose;
  final String category;
  final int durationMinutes;
  final String placeId;
  final int matchScore;
  final String reason;

  const AIPlanActivityDTO({
    required this.title,
    required this.purpose,
    required this.category,
    required this.durationMinutes,
    required this.placeId,
    required this.matchScore,
    required this.reason,
  });

  factory AIPlanActivityDTO.fromJson(Map<String, dynamic> json) {
    return AIPlanActivityDTO(
      title: (json['title'] ?? AppLocale.aiDefaultActivityTitle).toString(),
      purpose: (json['purpose'] ?? '').toString(),
      category: (json['category'] ?? 'cafe').toString(),
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 60,
      placeId: (json['placeId'] ?? '').toString(),
      matchScore: ((json['matchScore'] as num?)?.toInt() ?? 80).clamp(0, 100),
      reason: (json['reason'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'purpose': purpose,
    'category': category,
    'durationMinutes': durationMinutes,
    'placeId': placeId,
    'matchScore': matchScore,
    'reason': reason,
  };
}