import 'package:flutter/material.dart';

class StoreIcon extends StatelessWidget {
  const StoreIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95,
      width: double.infinity,
      color: Colors.brown.shade100,
      child: Icon(Icons.storefront, size: 45, color: Colors.brown),
    );
  }
}
