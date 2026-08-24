import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import '../../../../../core/localization/app_locale.dart';

class WeatherSnapshot {
  final double temperature;
  final double precipitationProbability;
  final String summaryKey;

  const WeatherSnapshot({
    required this.temperature,
    required this.precipitationProbability,
    required this.summaryKey,
  });

  String get summary => summaryKey;
}

abstract class WeatherDataSource {
  Future<WeatherSnapshot> getCurrentWeather({
    required double latitude,
    required double longitude,
  });
}

@LazySingleton(as: WeatherDataSource)
class WeatherDataSourceImpl implements WeatherDataSource {
  @override
  Future<WeatherSnapshot> getCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final uri = Uri.parse(
        'https://api.open-meteo.com/v1/forecast'
            '?latitude=$latitude&longitude=$longitude'
            '&current=temperature_2m,precipitation'
            '&hourly=precipitation_probability'
            '&forecast_days=1',
      );

      final response = await http.get(uri);
      if (response.statusCode != 200) {
        return const WeatherSnapshot(
          temperature: 0,
          precipitationProbability: 0,
          summaryKey: AppLocale.weatherUnavailable,
        );
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final current = data['current'] as Map<String, dynamic>? ?? {};
      final hourly = data['hourly'] as Map<String, dynamic>? ?? {};
      final probabilities = hourly['precipitation_probability'];

      final temperature = (current['temperature_2m'] as num?)?.toDouble() ?? 0.0;
      final precipitation = (current['precipitation'] as num?)?.toDouble() ?? 0.0;
      final double probability = probabilities is List && probabilities.isNotEmpty
          ? (probabilities.first as num?)?.toDouble() ?? 0.0
          : 0.0;

      final summaryKey = precipitation > 0 || probability >= 50
          ? AppLocale.weatherRainyIndoorPreferred
          : AppLocale.weatherSuitableOutdoor;

      return WeatherSnapshot(
        temperature: temperature,
        precipitationProbability: probability,
        summaryKey: summaryKey,
      );
    } catch (_) {
      return const WeatherSnapshot(
        temperature: 0,
        precipitationProbability: 0,
        summaryKey: AppLocale.weatherUnavailable,
      );
    }
  }
}