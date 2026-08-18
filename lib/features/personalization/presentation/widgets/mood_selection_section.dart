import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/localization/app_locale.dart';
import 'personalization_section_header.dart';
import 'selectable_option_card.dart';

class MoodItem {
  final String id;
  final String labelKey;
  final String svgAsset;

  const MoodItem({
    required this.id,
    required this.labelKey,
    required this.svgAsset,
  });
}

class MoodSelectionSection extends StatelessWidget {
  final String? selectedMood;
  final ValueChanged<String> onMoodSelected;

  const MoodSelectionSection({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
  });

  static const List<MoodItem> moodsList = [
    MoodItem(
      id: 'quiet_chill',
      labelKey: AppLocale.chillSitting,
      svgAsset: AppAssets.quietIcon,
    ),
    MoodItem(
      id: 'work_focus',
      labelKey: AppLocale.work,
      svgAsset: AppAssets.workIcon,
    ),
    MoodItem(
      id: 'social_energetic',
      labelKey: AppLocale.friendsOuting,
      svgAsset: AppAssets.friendsIcon,
    ),
    MoodItem(
      id: 'fun_celebrate',
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
          title: AppLocale.whatsYourMoodToday.getString(context),
          subtitle: AppLocale.chooseGeneralVibe.getString(context),
          badgeText: AppLocale.singleSelect.getString(context),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: moodsList.map((item) {
            final isSelected = selectedMood == item.id;
            return SelectableOptionCard(
              title: item.labelKey.getString(context),
              svgAsset: item.svgAsset,
              isSelected: isSelected,
              onTap: () => onMoodSelected(item.id),
            );
          }).toList(),
        ),
      ],
    );
  }
}
