import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:madinaty_app_ieee_2026/features/ai_planner/presentation/view/widgets/result/activity_card.dart';
import 'package:madinaty_app_ieee_2026/features/ai_planner/domain/entities/ai_plan_entity.dart';
import 'package:madinaty_app_ieee_2026/features/ai_planner/data/models/ai_plan_dto.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('AI Planner Tests', () {
    test('AIPlanIntentDTO parses numeric string values safely', () {
      final jsonWithStrings = {
        'mood': 'هادي',
        'durationHours': '3',
        'budget': '500.5',
        'activities': ['coffee', 'study'],
        'requirements': ['quiet'],
        'weatherPreference': 'indoor',
      };

      final dto = AIPlanIntentDTO.fromJson(jsonWithStrings);
      expect(dto.durationHours, equals(3));
      expect(dto.budget, equals(500.5));
    });

    testWidgets('ActivityCard renders without layout errors', (tester) async {
      const activity = AIPlanActivityEntity(
        title: 'جلسة مذاكرة وقهوة في كافيه هادي',
        purpose: 'مذاكرة وتجهيز مشاريع',
        category: 'cafe',
        requirements: ['quiet', 'wifi'],
        durationMinutes: 90,
        place: AIPlanPlaceEntity(
          id: 'cafe_1',
          name: 'ARA Cafe',
          address: 'Madinaty, Phase 1',
          rating: 4.9,
          reviewsCount: 120,
          isOpen: true,
          openingHours: '8 AM - 12 AM',
          attributes: ['wifi', 'quiet', 'outdoor'],
          photos: [],
          location: LatLng(30.08, 31.62),
          distanceMeters: 450,
          estimatedCost: 180,
          matchScore: 95,
          reason: 'المكان مناسب جداً لأنه هادي وقريب ومناسب للمذاكرة.',
        ),
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ActivityCard(
                activity: activity,
                index: 0,
                totalActivities: 2,
              ),
            ),
          ),
        ),
      );

      expect(find.text('ARA Cafe'), findsOneWidget);
    });
  });
}
