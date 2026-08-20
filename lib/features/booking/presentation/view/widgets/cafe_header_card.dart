import 'package:flutter/material.dart';

class CafeHeaderCard extends StatelessWidget {
  final String cafeName;
  final String? cafeAddress;
  final String? cafeImageUrl;

  const CafeHeaderCard({
    super.key,
    required this.cafeName,
    this.cafeAddress,
    this.cafeImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFFFAEFE7),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 56,
              height: 56,
              child: cafeImageUrl != null && cafeImageUrl!.isNotEmpty
                  ? Image.network(
                      cafeImageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Color(0xFFE4D2C3),
                        child: Icon(Icons.coffee, color: Color(0xFF6E4027)),
                      ),
                    )
                  : Container(
                      color: Color(0xFFE4D2C3),
                      child: Icon(Icons.coffee, color: Color(0xFF6E4027)),
                    ),
            ),
          ),

          SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cafeName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                if (cafeAddress != null && cafeAddress!.isNotEmpty) ...[
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          cafeAddress!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          Icon(Icons.arrow_forward_ios, size: 13, color: Colors.grey),
        ],
      ),
    );
  }
}
