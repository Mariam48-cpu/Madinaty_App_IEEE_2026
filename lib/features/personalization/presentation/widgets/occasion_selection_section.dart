import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/localization/app_locale.dart';
import 'personalization_section_header.dart';
import 'selectable_option_card.dart';

class OccasionItem {
  final String id;
  final String labelKey;
  final String svgAsset;

  const OccasionItem({
    required this.id,
    required this.labelKey,
    required this.svgAsset,
  });
}

class OccasionSelectionSection extends StatelessWidget {
  final String? selectedOccasion;
  final ValueChanged<String> onOccasionSelected;

  const OccasionSelectionSection({
    super.key,
    required this.selectedOccasion,
    required this.onOccasionSelected,
  });

  static const List<OccasionItem> occasionsList = [
    OccasionItem(
      id: 'friends_outing',
      labelKey: AppLocale.friendsOuting,
      svgAsset: AppAssets.friendsIcon,
    ),
    OccasionItem(
      id: 'work_meeting',
      labelKey: AppLocale.work,
      svgAsset: AppAssets.workIcon,
    ),
    OccasionItem(
      id: 'special_date',
      labelKey: AppLocale.date,
      svgAsset: AppAssets.dateIcon,
    ),
    OccasionItem(
      id: 'celebration',
      labelKey: AppLocale.birthday,
      svgAsset: AppAssets.birthdayIcon,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PersonalizationSectionHeader(
          title: AppLocale.whatIsYourOccasion.getString(context),
          subtitle: AppLocale.selectOccasionType.getString(context),
          badgeText: AppLocale.singleSelect.getString(context),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: occasionsList.map((item) {
            final isSelected = selectedOccasion == item.id;
            return SelectableOptionCard(
              title: item.labelKey.getString(context),
              svgAsset: item.svgAsset,
              isSelected: isSelected,
              onTap: () => onOccasionSelected(item.id),
            );
          }).toList(),
        ),
      ],
    );
  }
}
