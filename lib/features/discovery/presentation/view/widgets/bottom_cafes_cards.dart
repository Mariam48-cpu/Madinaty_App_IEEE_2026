import 'package:flutter/material.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/widgets/cafe_placeholder.dart';
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
        padding:  EdgeInsets.symmetric(horizontal: 12),
        itemCount: state.cafes.length,
        itemBuilder: (context, index) {
          final cafe = state.cafes[index];
          return CafeCardItem(cafe: cafe);
        },
      ),
    );
  }
}

class CafeCardItem extends StatelessWidget {
  final CafeEntity cafe;

  const CafeCardItem({super.key, required this.cafe});

  Widget buildCafePlaceholder() {
    return Container(
      height: 95,
      width: double.infinity,
      color: Colors.grey[300],
      child:  Icon(Icons.local_cafe, size: 40, color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      margin:  EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow:  [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:  BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: cafe.photos.isNotEmpty
                    ? Image.network(
                        cafe.photos.first,
                        height: 95,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return CafePlaceholder();
                        },
                      )
                    : CafePlaceholder(),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding:  EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${cafe.rating}',
                        style:  TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                       SizedBox(width: 2),
                       Icon(Icons.star, color: Colors.amber, size: 14),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                       Icon(
                        Icons.bookmark_border,
                        size: 20,
                        color: Colors.black54,
                      ),
                       SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          cafe.name,
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style:  TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    cafe.address,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style:  TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'هادئ',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'سريع',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
