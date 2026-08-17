import 'package:flutter/material.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/screens/cafe_details_screen.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/widgets/cafe_card_item.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view_model/cubit/discovery_state.dart';

class BottomCafesCards extends StatelessWidget {
  final DiscoverySuccess state;

  const BottomCafesCards({
    super.key,
    required this.state,
    required List<CafeEntity> cafeList,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12),
        itemCount: state.cafes.length,
        itemBuilder: (context, index) {
          final cafe = state.cafes[index];

          return CafeCardItem(
            cafe: cafe,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CafeDetailsScreen(cafe: cafe),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
