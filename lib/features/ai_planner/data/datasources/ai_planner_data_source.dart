import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';

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

  static const String _apiKey =
      'AQ.Ab8RN6LMlccq9zKfCksq39stPTghe4mIxXiTqavQvzJNCw0k9A';

  static const String _model = 'gemini-3.5-flash';

  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';
  Future<String> _generateContent(String prompt) async {
    final uri = Uri.parse('$_baseUrl/$_model:generateContent');

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': _apiKey,
        },
        body: jsonEncode({
          'contents': [
            {
              'role': 'user',
              'parts': [
                {'text': prompt},
              ],
            },
          ],
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);

        final candidates = decoded['candidates'];

        if (candidates is! List || candidates.isEmpty) {
          throw Exception(AppLocale.aiEmptyResponse);
        }

        final firstCandidate = candidates.first;

        final content = firstCandidate['content'];

        if (content is! Map) {
          throw Exception(AppLocale.aiInvalidResponseFormat);
        }

        final parts = content['parts'];

        if (parts is! List || parts.isEmpty) {
          throw Exception(AppLocale.aiEmptyResponse);
        }

        final text = parts
            .whereType<Map>()
            .map((part) => part['text'])
            .whereType<String>()
            .join();

        if (text.trim().isEmpty) {
          throw Exception(AppLocale.aiEmptyResponse);
        }

        return text;
      }

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception(
          AppLocale.aiAuthError,
        );
      }

      if (response.statusCode == 429) {
        throw Exception(
          AppLocale.aiRateLimitError
        );
      }

      String message = AppLocale.aiServerError;

      try {
        final errorBody = jsonDecode(response.body);

        final error = errorBody['error'];

        if (error is Map) {
          final apiMessage = error['message'];

          if (apiMessage is String && apiMessage.trim().isNotEmpty) {
            message = apiMessage;
          }
        }
      } catch (_) {
      }

      throw Exception(AppLocale.aiServerError);
    } on http.ClientException catch (e) {
      throw Exception(AppLocale.aiNetworkConnectionError);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }

      throw Exception(AppLocale.aiErrorGeneric);
    }
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
    final prompt =
        '''
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
3. مثال:
   "عايز مكان هادي أذاكر فيه وبعدها آكل"
   معناها:
   activities = ["study", "food"]
   requirements = ["quiet"]

4. مثال:
   "عايزة خروجة رومانسية"
   معناها:
   mood = "romantic"
   requirements = ["romantic", "comfortable"]

5. مثال:
   "عايز أقعد أشرب قهوة وأشتغل شوية"
   معناها:
   activities = ["coffee", "work"]
   requirements = ["wifi", "quiet"]

6. استخرج أهم المتطلبات من كلام المستخدم.
7. لا تخترع أسماء أماكن.
8. لا تقترح أماكن في هذه المرحلة.
9. المطلوب فقط فهم طلب المستخدم وتحويله إلى بيانات منظمة.
10. يجب أن يكون الـ JSON صالحًا تمامًا.
11. لا تكتب أي كلام خارج الـ JSON.

Return ONLY valid JSON.

{
  "mood": "وصف مختصر للمود",
  "durationHours": 2,
  "budget": 500,
  "activities": [
    "coffee",
    "study"
  ],
  "requirements": [
    "quiet",
    "wifi"
  ],
  "weatherPreference": "indoor"
}

قيم weatherPreference المسموحة فقط:

"indoor"
"outdoor"
"either"
''';

    final rawText = await _generateContent(prompt);

    return AIPlanIntentDTO.fromJson(_decodeObject(rawText));
  }


  @override
  Future<AIPlanFinalDTO> rankCandidates({
    required AIPlanIntentDTO intent,
    required List<Map<String, dynamic>> candidates,
    required String weatherSummary,
  }) async {
    final compactCandidates = jsonEncode(candidates);

    final userData = jsonEncode({
      'mood': intent.mood,
      'durationHours': intent.durationHours,
      'budget': intent.budget,
      'activities': intent.activities,
      'requirements': intent.requirements,
      'weatherPreference': intent.weatherPreference,
    });

    final prompt =
        '''
أنت Madinaty AI.

مهمتك بناء أفضل خطة يومية للمستخدم باستخدام الأماكن الحقيقية الموجودة في قائمة Candidates فقط.

المستخدم يتوقع إجابة باللغة العربية المصرية البسيطة والطبيعية.

ممنوع تمامًا اختراع أي مكان أو Place ID.

قواعد مهمة:

1. استخدم الأماكن الموجودة في Candidates فقط.
2. لا تخترع اسم مكان.
3. لا تخترع placeId.
4. كل placeId في النتيجة يجب أن يكون مطابقًا تمامًا لـ placeId موجود في Candidates.
5. اختار الأماكن الأقرب لاحتياجات المستخدم.
6. اهتم بالتقييم Rating.
7. اهتم بالمسافة Distance.
8. اهتم إذا كان المكان مفتوحًا أم لا.
9. اهتم بالـ Attributes الخاصة بالمكان.
10. اهتم بالتكلفة المتوقعة.
11. حاول ألا تتجاوز ميزانية المستخدم.
12. لا تكرر نفس المكان أكثر من مرة إلا لو كان ذلك ضروريًا.
13. خلي الخطة منطقية حسب الوقت المتاح.
14. إذا المستخدم طلب مكان هادي، أعطِ أولوية للأماكن التي تحتوي على quiet أو attributes مشابهة.
15. إذا طلب WiFi، أعطِ أولوية للأماكن التي تحتوي على wifi.
16. إذا طلب أكل، لا تختار مكانًا لا يناسب الأكل إذا كان هناك بديل مناسب.
17. إذا طلب قهوة، أعطِ أولوية للكافيهات المناسبة للقهوة.
18. إذا كان الطقس غير مناسب للخروج، راعي weatherPreference.
19. reason يجب أن يكون باللغة العربية.
20. headline و summary يجب أن يكونا باللغة العربية.
21. title و purpose يمكن أن يكونا بالعربي الطبيعي.
22. لا تكتب أي نص خارج الـ JSON.

بيانات المستخدم:

$userData

حالة الطقس الحالية:

$weatherSummary

الأماكن الحقيقية المتاحة:

$compactCandidates

Return ONLY valid JSON.

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

    final rawText = await _generateContent(prompt);

    return AIPlanFinalDTO.fromJson(_decodeObject(rawText));
  }

  Map<String, dynamic> _decodeObject(String? rawText) {
    if (rawText == null || rawText.trim().isEmpty) {
      throw Exception(AppLocale.aiEmptyResponse);
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
      throw Exception(AppLocale.aiInvalidResponseFormat);
    }
  }
}
