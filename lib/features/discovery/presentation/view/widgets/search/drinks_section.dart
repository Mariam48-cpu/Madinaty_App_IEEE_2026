import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'المشروبات اللي ممكن تلاقيها',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),

        SizedBox(height: 14),

        SizedBox(
          height: 115,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            reverse: true,
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
