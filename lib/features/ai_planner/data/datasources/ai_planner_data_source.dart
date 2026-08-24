import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:injectable/injectable.dart';

import '../models/ai_plan_dto.dart';

abstract class AIPlannerDataSource {
  Future<AIPlanIntentDTO> understandRequest({
    required String message,
    required double budget,
    required int durationHours,
    required List<String> interests,
    String? mood,
    String? occasion,
  });

  Future<AIPlanFinalDTO> rankCandidates({
    required AIPlanIntentDTO intent,
    required List<Map<String, dynamic>> candidates,
    required String weatherSummary,
  });
}

@LazySingleton(as: AIPlannerDataSource)
class AIPlannerDataSourceImpl implements AIPlannerDataSource {
  late final GenerativeModel _generativeModel;

  AIPlannerDataSourceImpl() {
    _generativeModel = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: const String.fromEnvironment(
        'GEMINI_API_KEY',
        defaultValue: 'AQ.Ab8RN6K67YKmhD1pCCIJh8-TDNhC6B0w0qLA4kBAlar4rhl22w',
      ),
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        temperature: 0.2,
      ),
    );
  }

  @override
  Future<AIPlanIntentDTO> understandRequest({
    required String message,
    required double budget,
    required int durationHours,
    required List<String> interests,
    String? mood,
    String? occasion,
  }) async {
    final prompt = '''
أنت Madinaty AI، مساعد ذكي متخصص في اقتراح أماكن وتجارب مناسبة للمستخدم.

المستخدم ممكن يكتب طلبه بالعربي أو بالإنجليزي أو يخلط بينهم.

حلل كلام المستخدم وافهم بالضبط هو عايز يعمل إيه.

رسالة المستخدم:
$message

الميزانية القصوى بالجنيه المصري:
$budget

الوقت المتاح بالساعات:
$durationHours

اهتمامات المستخدم:
${interests.join(', ')}

المود:
${mood ?? ''}

المناسبة:
${occasion ?? ''}

قواعد مهمة جدًا:
1. افهم اللغة الطبيعية للمستخدم، حتى لو كتب بالمصري العامية.
2. لا تحتاج أن تكون الكلمات المستخدمة مطابقة للكلمات الموجودة في البيانات.
3. استخرج أهم المتطلبات من كلام المستخدم.
4. لا تخترع أسماء أماكن أو تقترح أماكن في هذه المرحلة.
5. المطلوب فقط فهم طلب المستخدم وتحويله إلى بيانات منظمة بصيغة JSON.

Return ONLY valid JSON with this schema:
{
  "mood": "وصف مختصر للمود",
  "durationHours": 2,
  "budget": 500,
  "activities": ["coffee", "study"],
  "requirements": ["quiet", "wifi"],
  "weatherPreference": "indoor"
}

قيم weatherPreference المسموحة فقط: "indoor", "outdoor", "either"
''';

    final response = await _generativeModel.generateContent([
      Content.text(prompt),
    ]);

    return AIPlanIntentDTO.fromJson(_decodeObject(response.text));
  }

  @override
  Future<AIPlanFinalDTO> rankCandidates({
    required AIPlanIntentDTO intent,
    required List<Map<String, dynamic>> candidates,
    required String weatherSummary,
  }) async {
    final compactCandidates = jsonEncode(candidates);

    final prompt = '''
أنت Madinaty AI.

مهمتك بناء أفضل خطة يومية للمستخدم باستخدام الأماكن الحقيقية الموجودة في قائمة Candidates فقط.
المستخدم يتوقع إجابة باللغة العربية المصرية البسيطة والطبيعية.
ممنوع تمامًا اختراع أي مكان أو Place ID.

قواعد مهمة:
1. استخدم الأماكن الموجودة في Candidates فقط.
2. كل placeId في النتيجة يجب أن يكون مطابقًا تمامًا لـ placeId موجود في Candidates.
3. اختار الأماكن الأقرب لاحتياجات المستخدم.
4. اهتم بالتقييم، المسافة، وحالة الفتح.
5. حاول ألا تتجاوز ميزانية المستخدم.
6. خلي الخطة منطقية حسب الوقت المتاح وحالة الطقس.
7. headline و summary و reason و title و purpose يجب أن تكون باللغة العربية.

بيانات المستخدم:
${jsonEncode({'mood': intent.mood, 'durationHours': intent.durationHours, 'budget': intent.budget, 'activities': intent.activities, 'requirements': intent.requirements, 'weatherPreference': intent.weatherPreference})}

حالة الطقس الحالية:
$weatherSummary

الأماكن الحقيقية المتاحة:
$compactCandidates

Return ONLY valid JSON with this schema:
{
  "headline": "خروجة هادية ومناسبة لميزانيتك",
  "summary": "اختارت لك أفضل الأماكن القريبة بناءً على طلبك ووقتك وميزانيتك.",
  "estimatedTotal": 500,
  "activities": [
    {
      "title": "قهوة ومذاكرة",
      "purpose": "مذاكرة في مكان هادي",
      "category": "cafe",
      "durationMinutes": 90,
      "placeId": "EXACT_CANDIDATE_PLACE_ID",
      "matchScore": 94,
      "reason": "المكان مناسب لأنه هادي وقريب وبه واي فاي ويناسب ميزانيتك."
    }
  ]
}
''';

    final response = await _generativeModel.generateContent([
      Content.text(prompt),
    ]);

    return AIPlanFinalDTO.fromJson(_decodeObject(response.text));
  }

  Map<String, dynamic> _decodeObject(String? rawText) {
    if (rawText == null || rawText.trim().isEmpty) {
      throw Exception('لم يرجع الذكاء الاصطناعي أي نتيجة.');
    }

    var clean = rawText.trim();
    clean = clean
        .replaceAll('```json', '')
        .replaceAll('```JSON', '')
        .replaceAll('```', '')
        .trim();

    final first = clean.indexOf('{');
    final last = clean.lastIndexOf('}');

    if (first >= 0 && last > first) {
      clean = clean.substring(first, last + 1);
    }

    try {
      final decoded = jsonDecode(clean);
      if (decoded is! Map) {
        throw const FormatException('Gemini response is not a JSON object.');
      }
      return Map<String, dynamic>.from(decoded);
    } catch (_) {
      throw Exception('تعذر قراءة رد الذكاء الاصطناعي. حاول مرة أخرى.');
    }
  }
}