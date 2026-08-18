import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/localization/app_locale.dart';
import 'personalization_section_header.dart';
import 'selectable_option_card.dart';

class InterestItem {
  final String id;
  final String labelKey;
  final String svgAsset;

  const InterestItem({
    required this.id,
    required this.labelKey,
    required this.svgAsset,
  });
}

class InterestsSelectionSection extends StatelessWidget {
  final List<String> selectedInterests;
  final ValueChanged<String> onInterestToggled;

  const InterestsSelectionSection({
    super.key,
    required this.selectedInterests,
    required this.onInterestToggled,
  });

  static const List<InterestItem> interestsList = [
    InterestItem(
      id: 'specialty_coffee',
      labelKey: AppLocale.specialtyCoffee,
      svgAsset: AppAssets.specialtyCoffeeIcon,
    ),
    InterestItem(
      id: 'quiet',
      labelKey: AppLocale.quietChill,
      svgAsset: AppAssets.quietIcon,
    ),
    InterestItem(
      id: 'work',
      labelKey: AppLocale.work,
      svgAsset: AppAssets.workIcon,
    ),
    InterestItem(
      id: 'study',
      labelKey: AppLocale.study,
      svgAsset: AppAssets.studyIcon,
    ),
    InterestItem(
      id: 'outdoor',
      labelKey: AppLocale.placeWithView,
      svgAsset: AppAssets.outdoorIcon,
    ),
    InterestItem(
      id: 'nile_view',
      labelKey: AppLocale.nileView,
      svgAsset: AppAssets.nileViewIcon,
    ),
    InterestItem(
      id: 'parking',
      labelKey: AppLocale.placeWithView,
      svgAsset: AppAssets.parkingIcon,
    ),
    InterestItem(
      id: 'wheelchair',
      labelKey: AppLocale.placeWithView,
      svgAsset: AppAssets.wheelchairIcon,
    ),
    InterestItem(
      id: 'pets',
      labelKey: AppLocale.placeWithView,
      svgAsset: AppAssets.animalIcon,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PersonalizationSectionHeader(
          title: AppLocale.whatAreYourInterests.getString(context),
          subtitle: AppLocale.interestsSubtitle.getString(context),
          badgeText: AppLocale.multiSelect.getString(context),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: interestsList.map((item) {
            final isSelected = selectedInterests.contains(item.id);
            return SelectableOptionCard(
              title: item.labelKey.getString(context),
              svgAsset: item.svgAsset,
              isSelected: isSelected,
              isMultiSelect: true,
              onTap: () => onInterestToggled(item.id),
            );
          }).toList(),
        ),
      ],
    );
  }
}
