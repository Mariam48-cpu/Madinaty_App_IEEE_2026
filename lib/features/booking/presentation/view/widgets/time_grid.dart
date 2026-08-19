import 'package:flutter/material.dart';

class TimeGrid extends StatelessWidget {
  final String? selectedTime;
  final ValueChanged<String> onSelected;

  const TimeGrid({required this.selectedTime, required this.onSelected});

  static const times = [
    '05:00 م',
    '05:30 م',
    '06:00 م',
    '06:30 م',
    '07:00 م',
    '07:30 م',
    '08:00 م',
    '08:30 م',
    '09:00 م',
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: times.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 2.4,
      ),
      itemBuilder: (_, index) {
        final time = times[index];
        final selected = time == selectedTime;

        return InkWell(
          onTap: () => onSelected(time),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? Color(0xFF6E4027) : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selected ? Color(0xFF6E4027) : Color(0xFFE1D8D1),
              ),
            ),
            child: Text(
              time,
              style: TextStyle(
                fontSize: 11,
                color: selected ? Colors.white : Colors.black87,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }
}
