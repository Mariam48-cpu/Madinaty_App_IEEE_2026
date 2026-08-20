import 'package:flutter/material.dart';
import 'seating_table.dart';

class SeatingMap extends StatelessWidget {
  final String? selectedTable;
  final String filterCategory;
  final ValueChanged<String> onTableSelected;

  const SeatingMap({
    super.key,
    required this.selectedTable,
    required this.onTableSelected,
    required this.filterCategory,
  });

  bool isTableMatchingFilter(String? category) {
    if (category == null) return false;
    if (filterCategory == 'الكل') return true;
    return filterCategory == category;
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> tableCategories = {
      'T1': 'إطلالة النيل',
      'T2': 'إطلالة النيل',
      'T3': 'بجوار النافذة',
      'T4': 'ركن هادئ',
      'T5': 'ركن هادئ',
      'T6': 'بجوار النافذة',
      'T7': 'إطلالة النيل',
      'BAR': 'البار',
    };

    return Container(
      height: 320,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Color(0xFFE0EDF4)),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 12,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                filterCategory == 'الكل' ? 'خريطة الجلسات' : filterCategory,
                style: TextStyle(
                  color: Color(0xFF6C9BB8),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          if (isTableMatchingFilter(tableCategories['T1']))
            Positioned(
              top: 42,
              right: 28,
              child: SeatingTable(
                id: 'T1',
                selected: selectedTable == 'T1',
                booked: false,
                onTap: () => onTableSelected('T1'),
              ),
            ),
          if (isTableMatchingFilter(tableCategories['T2']))
            Positioned(
              top: 42,
              left: 105,
              child: SeatingTable(
                id: 'T2',
                selected: selectedTable == 'T2',
                booked: false,
                rectangle: true,
                onTap: () => onTableSelected('T2'),
              ),
            ),
          if (isTableMatchingFilter(tableCategories['T3']))
            Positioned(
              top: 42,
              left: 25,
              child: SeatingTable(
                id: 'T3',
                selected: selectedTable == 'T3',
                booked: false,
                onTap: () => onTableSelected('T3'),
              ),
            ),
          if (isTableMatchingFilter(tableCategories['T4']))
            Positioned(
              top: 125,
              right: 60,
              child: SeatingTable(
                id: 'T4',
                selected: selectedTable == 'T4',
                booked: false,
                onTap: () => onTableSelected('T4'),
              ),
            ),

          if (isTableMatchingFilter(tableCategories['T5']))
            Positioned(
              top: 115,
              left: 65,
              child: SeatingTable(
                id: 'T5',
                selected: selectedTable == 'T5',
                booked: false,
                size: 68,
                onTap: () => onTableSelected('T5'),
              ),
            ),
          if (isTableMatchingFilter(tableCategories['T6']))
            Positioned(
              top: 215,
              left: 120,
              child: SeatingTable(
                id: 'T6',
                selected: selectedTable == 'T6',
                booked: true,
                onTap: () {},
              ),
            ),
          if (isTableMatchingFilter(tableCategories['T7']))
            Positioned(
              top: 215,
              right: 110,
              child: SeatingTable(
                id: 'T7',
                selected: selectedTable == 'T7',
                booked: false,
                onTap: () => onTableSelected('T7'),
              ),
            ),
          if (isTableMatchingFilter(tableCategories['BAR']))
            Positioned(
              bottom: 18,
              right: 20,
              child: GestureDetector(
                onTap: () => onTableSelected('BAR'),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  decoration: BoxDecoration(
                    color: selectedTable == 'BAR'
                        ? Color(0xFF6E4027)
                        : Color(0xFFECE5DF),
                    borderRadius: BorderRadius.circular(10),
                    border: selectedTable == 'BAR'
                        ? Border.all(color: Colors.brown, width: 1.5)
                        : null,
                  ),
                  child: Text(
                    'البار',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: selectedTable == 'BAR'
                          ? Colors.white
                          : Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
