import 'package:flutter/material.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';

class CafeCard extends StatelessWidget {
  final CafeEntity cafe;

  const CafeCard({super.key, required this.cafe});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 235,
      margin: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildImage(),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildName(),

                  Text(
                    cafe.address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),

                  _buildRating(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (cafe.photos.isEmpty) {
      return _placeholderImage();
    }

    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      child: Image.network(
        cafe.photos.first,
        height: 125,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return _placeholderImage();
        },
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      height: 125,
      width: double.infinity,
      color: Color(0xFFE8E0DC),
      child: Icon(Icons.local_cafe, size: 50, color: Color(0xFF8D6654)),
    );
  }

  Widget _buildName() {
    return Row(
      children: [
        Icon(Icons.bookmark_border, size: 19, color: Colors.grey),

        SizedBox(width: 6),

        Expanded(
          child: Text(
            cafe.name,
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '${cafe.rating}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        ),

        SizedBox(width: 3),

        Icon(Icons.star, color: Colors.amber, size: 14),
      ],
    );
  }
}
