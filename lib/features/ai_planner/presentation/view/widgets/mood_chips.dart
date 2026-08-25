import 'package:flutter/material.dart';

class MoodChips extends StatelessWidget {
  final String? selectedMood;
  final Function(String?) onMoodSelected;

  const MoodChips({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    final moods = [
      'هادي',
      'فرفوش',
      'رومانسي',
      'اجتماعي',
      'منتج',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: Row(
        children: moods.map((mood) {
          final selected = selectedMood == mood;

          return Padding(
            padding: const EdgeInsets.only(left: 8),
            child: GestureDetector(
              onTap: () {
                onMoodSelected(
                  selected ? null : mood,
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF8B5E3C)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: selected
                        ? const Color(0xFF8B5E3C)
                        : const Color(0xFFE7DDD4),
                  ),
                ),
                child: Text(
                  mood,
                  style: TextStyle(
                    color: selected
                        ? Colors.white
                        : const Color(0xFF2E241F),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}