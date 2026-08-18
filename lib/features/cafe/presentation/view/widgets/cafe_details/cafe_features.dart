import 'package:flutter/material.dart';

import 'feature_card.dart';

class CafeFeatures extends StatelessWidget {
  final List<String> attributes;

  const CafeFeatures({super.key, required this.attributes});

  @override
  Widget build(BuildContext context) {
    final features = buildFeatures();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'المرافق والخدمات',
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D2521),
          ),
        ),

        SizedBox(height: 10),

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

  List<FeatureDataModel> buildFeatures() {
    final result = <FeatureDataModel>[];

    if (attributes.isNotEmpty) {
      for (final attribute in attributes.take(4)) {
        result.add(
          FeatureDataModel(
            icon: getIcon(attribute),
            title: attribute,
            subtitle: 'متاح',
          ),
        );
      }
    }

    if (result.isEmpty) {
      result.addAll([
        const FeatureDataModel(
          icon: Icons.wifi,
          title: 'واي فاي',
          subtitle: 'متوفر مجانًا',
        ),
        const FeatureDataModel(
          icon: Icons.home_work_outlined,
          title: 'جلسات داخلية',
          subtitle: 'متاحة',
        ),
        const FeatureDataModel(
          icon: Icons.pets_outlined,
          title: 'يسمح بالحيوانات',
          subtitle: 'الخدمة متاحة',
        ),
        const FeatureDataModel(
          icon: Icons.accessible_forward,
          title: 'مناسب للجميع',
          subtitle: 'سهولة الوصول',
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
