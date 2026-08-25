import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/widgets/search/drink_card.dart';

class DrinksSection extends StatelessWidget {
  const DrinksSection({super.key});

  static const drinks = [
    ('Cappuccino', Icons.coffee),
    ('Latte', Icons.local_cafe),
    ('Americano', Icons.coffee_outlined),
    ('Iced Coffee', Icons.icecream),
    ('Hot Chocolate', Icons.local_drink),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocale.drinksYouMightFind.getString(context),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 115,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: drinks.length,
            itemBuilder: (_, index) {
              final drink = drinks[index];
              return DrinkCard(name: drink.$1, icon: drink.$2);
            },
          ),
        ),
      ],
    );
  }
}