import 'package:flutter/material.dart';

class SearchErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const SearchErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 50, color: Colors.redAccent),

            SizedBox(height: 12),

            Text(message, textAlign: TextAlign.center),

            SizedBox(height: 16),

            ElevatedButton(onPressed: onRetry, child: Text('إعادة المحاولة')),
          ],
        ),
      ),
    );
  }
}
