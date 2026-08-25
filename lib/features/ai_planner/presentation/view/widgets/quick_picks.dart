import 'package:flutter/material.dart';

class QuickPicks extends StatelessWidget {
  final List<String> interests;
  final Function(String) onToggle;
  final TextEditingController controller;

  const QuickPicks({
    super.key,
    required this.interests,
    required this.onToggle,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      ('قهوة', 'Coffee', Icons.coffee_rounded),
      ('مذاكرة', 'Study', Icons.menu_book_rounded),
      ('أكل', 'Food', Icons.restaurant_rounded),
      ('دِيت', 'Date', Icons.favorite_rounded),
      ('خروجة', 'Hangout', Icons.groups_rounded),
    ];

    return Wrap(
      spacing: 9,
      runSpacing: 9,
      children: items.map((item) {
        final selected = interests.contains(item.$2);

        return GestureDetector(
          onTap: () {
            onToggle(item.$2);

            if (controller.text.trim().isEmpty) {
              controller.text =
                  'عايز ${item.$1.toLowerCase()}';

              controller.selection =
                  TextSelection.fromPosition(
                TextPosition(
                  offset: controller.text.length,
                ),
              );
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 11,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? const Color(0xFF8B5E3C)
                  : Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: selected
                    ? const Color(0xFF8B5E3C)
                    : const Color(0xFFE7DDD4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  item.$3,
                  size: 17,
                  color: selected
                      ? Colors.white
                      : const Color(0xFF8B5E3C),
                ),
                const SizedBox(width: 7),
                Text(
                  item.$1,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selected
                        ? Colors.white
                        : const Color(0xFF2E241F),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}