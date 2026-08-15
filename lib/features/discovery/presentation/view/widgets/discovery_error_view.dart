import 'package:flutter/material.dart';

class DiscoveryErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const DiscoveryErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 55, color: Colors.redAccent),
            SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            SizedBox(height: 18),
            ElevatedButton(onPressed: onRetry, child: Text('إعادة المحاولة')),
          ],
        ),
      ),
    );
  }
}
