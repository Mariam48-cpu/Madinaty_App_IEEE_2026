import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';


class CafeBottomButtons extends StatelessWidget {
  final VoidCallback? onDirections;
  final VoidCallback? onDirectionPreOrder;

  final VoidCallback? onCall;

  const CafeBottomButtons({
    super.key,
    this.onDirections,
    this.onCall,
    required this.onDirectionPreOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 9, 12, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: onDirectionPreOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF17120F),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  AppLocale.preOrder.getString(context),
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: onDirections,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF17120F),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  AppLocale.bookTable.getString(context),
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
