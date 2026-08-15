import 'package:flutter/material.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/widgets/Icon_Button.dart';

class CategoryResultsHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  final VoidCallback onSearch;

  const CategoryResultsHeader({
    super.key,
    required this.title,
    required this.onBack,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          IconButtonWidget(icon: Icons.arrow_back_ios_new, onTap: onBack),

          SizedBox(width: 8),

          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D2521),
              ),
            ),
          ),

          SizedBox(width: 8),

          IconButtonWidget(icon: Icons.search, onTap: onSearch),
        ],
      ),
    );
  }
}
