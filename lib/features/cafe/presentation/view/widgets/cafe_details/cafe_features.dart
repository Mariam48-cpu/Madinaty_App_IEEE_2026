import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';

import 'feature_card.dart';

class CafeFeatures extends StatelessWidget {
  final List<String> attributes;

  const CafeFeatures({super.key, required this.attributes});

  @override
  Widget build(BuildContext context) {
    final features = buildFeatures(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocale.facilitiesAndServices.getString(context),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D2521),
          ),
        ),

        const SizedBox(height: 10),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: features.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 2.5,
          ),
          itemBuilder: (context, index) {
            final feature = features[index];
            return FeatureCard(
              icon: feature.icon,
              title: feature.title,
              subtitle: feature.subtitle,
            );
          },
        ),
      ],
    );
  }

  List<FeatureDataModel> buildFeatures(BuildContext context) {
    final result = <FeatureDataModel>[];

    if (attributes.isNotEmpty) {
      for (final attribute in attributes.take(4)) {
        result.add(
          FeatureDataModel(
            icon: getIcon(attribute),
            title: attribute,
            subtitle: AppLocale.available.getString(context),
          ),
        );
      }
    }

    if (result.isEmpty) {
      result.addAll([
        FeatureDataModel(
          icon: Icons.wifi,
          title: AppLocale.wifi.getString(context),
          subtitle: AppLocale.available.getString(context),
        ),
        FeatureDataModel(
          icon: Icons.home_work_outlined,
          title: AppLocale.indoorSeating.getString(context),
          subtitle: AppLocale.available.getString(context),
        ),
        FeatureDataModel(
          icon: Icons.pets_outlined,
          title: AppLocale.petFriendly.getString(context),
          subtitle: AppLocale.available.getString(context),
        ),
        FeatureDataModel(
          icon: Icons.accessible_forward,
          title: AppLocale.wheelchairAccessible.getString(context),
          subtitle: AppLocale.available.getString(context),
        ),
      ]);
    }

    return result;
  }

  IconData getIcon(String value) {
    final text = value.toLowerCase();

    if (text.contains('wifi') || text.contains('واي')) {
      return Icons.wifi;
    }

    if (text.contains('جلس')) {
      return Icons.home_work_outlined;
    }

    if (text.contains('parking') || text.contains('ركن')) {
      return Icons.local_parking;
    }

    if (text.contains('pet') || text.contains('حيوان')) {
      return Icons.pets_outlined;
    }

    if (text.contains('delivery') || text.contains('توصيل')) {
      return Icons.delivery_dining;
    }

    return Icons.check_circle_outline;
  }
}

class FeatureDataModel {
  final IconData icon;
  final String title;
  final String subtitle;

  const FeatureDataModel({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
