import 'package:flutter/material.dart';

import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';

void showCafeDetailsBottomSheet({
  required BuildContext context,
  required CafeEntity cafe,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return CafeDetailsBottomSheet(cafe: cafe);
    },
  );
}

class CafeDetailsBottomSheet extends StatelessWidget {
  final CafeEntity cafe;

  const CafeDetailsBottomSheet({super.key, required this.cafe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Center(
              child: Container(
                width: 45,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            SizedBox(height: 20),

            Row(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.coffee, color: Colors.white, size: 28),
                ),

                SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        cafe.name,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 5),

                      Text(
                        cafe.address,
                        textAlign: TextAlign.right,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, size: 18),
                    SizedBox(width: 5),
                    Text(
                      cafe.rating > 0 ? cafe.rating.toString() : 'No rating',
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      cafe.isOpen ? Icons.check_circle : Icons.cancel,
                      size: 18,
                    ),
                    SizedBox(width: 5),
                    Text(cafe.isOpen ? 'Open' : 'Closed'),
                  ],
                ),
              ],
            ),

            SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
