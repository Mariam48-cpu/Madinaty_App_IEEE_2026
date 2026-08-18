import 'package:flutter/material.dart';

class ProductOptionSelectorWidget extends StatelessWidget {
  final String title;
  final List<String> options;
  final String selectedOption;
  final ValueChanged<String> onOptionSelected;

  const ProductOptionSelectorWidget({
    super.key,
    required this.title,
    required this.options,
    required this.selectedOption,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style:  TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D2521),
          ),
        ),
         SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: options.map((option) {
            final isSelected = selectedOption == option;
            return Padding(
              padding:  EdgeInsets.only(left: 8.0),
              child: InkWell(
                onTap: () => onOptionSelected(option),
                child: Container(
                  padding:  EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ?  Color(0xFF8D6654) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ?  Color(0xFF8D6654)
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color:
                          isSelected ? Colors.white :  Color(0xFF2D2521),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}