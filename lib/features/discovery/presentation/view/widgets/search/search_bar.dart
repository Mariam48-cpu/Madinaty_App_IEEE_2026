import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onClear;
  final VoidCallback onBack;
  final VoidCallback onChanged;
  final ValueChanged<String> onSearch;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onClear,
    required this.onBack,
    required this.onChanged,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Color(0xFFD7B8A4)),
              ),
              child: TextField(
                controller: controller,
                textAlign: TextAlign.right,
                textInputAction: TextInputAction.search,
                onSubmitted: onSearch,
                onChanged: (_) => onChanged(),
                decoration: InputDecoration(
                  hintText: 'ابحث بالاسم، المنطقة أو النوع',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                  border: InputBorder.none,

                  prefixIcon: Icon(
                    Icons.tune,
                    size: 20,
                    color: Color(0xFF8D6654),
                  ),

                  suffixIcon: controller.text.isNotEmpty
                      ? IconButton(
                          onPressed: onClear,
                          icon: Icon(Icons.close, color: Colors.grey),
                        )
                      : IconButton(
                          onPressed: () {
                            onSearch(controller.text);
                          },
                          icon: Icon(Icons.search, color: Colors.grey),
                        ),

                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 13,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: 10),

          IconButton(
            onPressed: onBack,
            icon: Icon(Icons.arrow_forward, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
