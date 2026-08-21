import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import '../../../domain/entities/review_entity.dart';

class ReviewCard extends StatefulWidget {
  final ReviewEntity review;

  const ReviewCard({
    super.key,
    required this.review,
  });

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  bool _isHelpful = false;
  void _toggleHelpful() {
    setState(() {
      _isHelpful = !_isHelpful;
    });
  }

  String _formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) return 'منذ قليل';
      return 'قبل ${diff.inHours} ساعة';
    } else if (diff.inDays == 1) {
      return 'أمس';
    } else if (diff.inDays == 2) {
      return 'قبل يومين';
    } else if (diff.inDays < 7) {
      return 'قبل ${diff.inDays} أيام';
    } else if (diff.inDays < 14) {
      return 'قبل أسبوع';
    } else if (diff.inDays < 30) {
      return 'قبل ${(diff.inDays / 7).floor()} أسابيع';
    } else {
      return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final review = widget.review;
    final initials = review.userName.isNotEmpty
        ? review.userName.trim().split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join()
        : 'م';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFF1E9E2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Header: Stars (Start/Left) & User Info (End/Right in RTL) ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stars
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  final isFilled = index < review.rating.round();
                  return Icon(
                    isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 16,
                    color: isFilled
                        ? const Color(0xFF8A5A36)
                        : const Color(0xFFD6CDC5),
                  );
                }),
              ),

              // User Info & Avatar
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        review.userName.isNotEmpty
                            ? review.userName
                            : 'مستخدم مدينتي',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D2521),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatRelativeDate(review.createdAt),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF9E948C),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  _buildAvatar(review.userAvatar, initials),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // --- Review Text ---
          Text(
            review.text,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 13,
              height: 1.55,
              color: Color(0xFF4A413C),
            ),
          ),

          // --- Optional Attached Images ---
          if (review.images.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 75,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: review.images.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final imageUrl = review.images[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      width: 75,
                      height: 75,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 75,
                        height: 75,
                        color: const Color(0xFFF3EBE1),
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          size: 24,
                          color: Color(0xFF8A5A36),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],

          const SizedBox(height: 12),

          // --- Footer: Helpful Button ---
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: _toggleHelpful,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isHelpful
                            ? Icons.thumb_up_rounded
                            : Icons.thumb_up_outlined,
                        size: 15,
                        color: _isHelpful
                            ? const Color(0xFF8A5A36)
                            : const Color(0xFF8C827A),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        AppLocale.helpful.getString(context),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              _isHelpful ? FontWeight.bold : FontWeight.w500,
                          color: _isHelpful
                              ? const Color(0xFF8A5A36)
                              : const Color(0xFF8C827A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String? avatarUrl, String initials) {
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          avatarUrl,
          width: 38,
          height: 38,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _buildInitialsAvatar(initials),
        ),
      );
    }
    return _buildInitialsAvatar(initials);
  }

  Widget _buildInitialsAvatar(String initials) {
    return Container(
      width: 38,
      height: 38,
      decoration: const BoxDecoration(
        color: Color(0xFFEDE3D9),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Color(0xFF684124),
        ),
      ),
    );
  }
}
