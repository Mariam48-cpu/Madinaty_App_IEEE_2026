import 'package:flutter/material.dart';
import 'skeleton_primitives.dart';
import '../../theme/app_colors.dart';

class CartSkeleton extends StatelessWidget {
  const CartSkeleton({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(18),
    physics: const NeverScrollableScrollPhysics(),
    children: const [
      SkeletonText(widthFactor: .45, height: 24, radius: 8),
      SizedBox(height: 20),
      CartItemSkeleton(),
      CartItemSkeleton(),
      CartItemSkeleton(),
      SizedBox(height: 18),
      AppSkeleton(height: 145, radius: 22),
    ],
  );
}

class CartItemSkeleton extends StatelessWidget {
  const CartItemSkeleton({super.key});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(11),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: AppColors.border),
    ),
    child: const Row(
      children: [
        AppSkeleton(width: 86, height: 86, radius: 14),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonText(widthFactor: .72, height: 15),
              SizedBox(height: 10),
              SkeletonText(widthFactor: .4, height: 12),
              SizedBox(height: 12),
              SkeletonChip(width: 100, height: 28),
            ],
          ),
        ),
      ],
    ),
  );
}

class CheckoutSkeleton extends StatelessWidget {
  const CheckoutSkeleton({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(18),
    physics: const NeverScrollableScrollPhysics(),
    children: const [
      SkeletonText(widthFactor: .5, height: 24),
      SizedBox(height: 20),
      AppSkeleton(height: 82, radius: 18),
      SizedBox(height: 14),
      AppSkeleton(height: 150, radius: 20),
      SizedBox(height: 14),
      AppSkeleton(height: 110, radius: 20),
      SizedBox(height: 22),
      AppSkeleton(height: 56, radius: 18),
    ],
  );
}
