import 'package:flutter/material.dart';

import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';

class CafeInfoSection extends StatelessWidget {
  final CafeEntity cafe;

  const CafeInfoSection({super.key, required this.cafe});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Address
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                cafe.address.isNotEmpty ? cafe.address : 'العنوان غير متوفر',
                textAlign: TextAlign.right,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(width: 5),
            const Icon(
              Icons.location_on_outlined,
              size: 16,
              color: Color(0xFF8D6654),
            ),
          ],
        ),

        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (cafe.openingHours.isNotEmpty)
              Expanded(
                child: Text(
                  cafe.openingHours,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 9, color: Colors.grey.shade600),
                ),
              ),

            const SizedBox(width: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: cafe.isOpen
                    ? const Color(0xFFE8F7EC)
                    : const Color(0xFFF1E9E5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                cafe.isOpen ? 'مفتوح الآن' : 'مغلق الآن',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: cafe.isOpen
                      ? const Color(0xFF38965A)
                      : Colors.grey.shade700,
                ),
              ),
            ),
          ],
        ),

        if (cafe.attributes.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: 6,
            runSpacing: 6,
            children: cafe.attributes.take(4).map((attribute) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7EEEA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  attribute,
                  style: const TextStyle(fontSize: 8, color: Color(0xFF6D5143)),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
