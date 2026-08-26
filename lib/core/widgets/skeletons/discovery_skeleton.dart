import 'package:flutter/material.dart';
import 'skeleton_primitives.dart';
import '../../theme/app_colors.dart';

class DiscoverySkeleton extends StatelessWidget {
  const DiscoverySkeleton({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
    children: const [
      AppSkeleton(height: 52, radius: 18),
      SizedBox(height: 16),
      _CategoryChipsSkeleton(),
      SizedBox(height: 22),
      SkeletonSectionTitle(widthFactor: .48),
      SizedBox(height: 14),
      _FeaturedRow(),
      SizedBox(height: 24),
      SkeletonSectionTitle(widthFactor: .4),
      SizedBox(height: 14),
      _DiscoveryResult(),
      _DiscoveryResult(),
      _DiscoveryResult(),
      _DiscoveryResult(),
    ],
  );
}

class _CategoryChipsSkeleton extends StatelessWidget {
  const _CategoryChipsSkeleton();
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 40,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(width: 9),
      itemBuilder: (_, i) => SkeletonChip(width: 70 + i * 8),
    ),
  );
}

class _FeaturedRow extends StatelessWidget {
  const _FeaturedRow();
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 190,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (_, __) => const _FeaturedCard(),
    ),
  );
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard();
  @override
  Widget build(BuildContext context) => Container(
    width: 225,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(21),
      border: Border.all(color: AppColors.border),
    ),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSkeleton(height: 100, radius: 16),
        SizedBox(height: 9),
        SkeletonText(widthFactor: .72, height: 15),
        SizedBox(height: 7),
        SkeletonText(widthFactor: .5, height: 10),
        Spacer(),
        Row(
          children: [
            SkeletonChip(width: 52, height: 20),
            SizedBox(width: 7),
            SkeletonChip(width: 62, height: 20),
          ],
        ),
      ],
    ),
  );
}

class _DiscoveryResult extends StatelessWidget {
  const _DiscoveryResult();
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 13),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(21),
      border: Border.all(color: AppColors.border),
    ),
    child: const Row(
      children: [
        AppSkeleton(width: 105, height: 105, radius: 16),
        SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonText(widthFactor: .75, height: 16),
              SizedBox(height: 9),
              SkeletonText(widthFactor: .5, height: 10),
              SizedBox(height: 10),
              SkeletonText(widthFactor: .95, height: 10),
              SizedBox(height: 7),
              SkeletonText(widthFactor: .7, height: 10),
              SizedBox(height: 12),
              Row(
                children: [
                  SkeletonChip(width: 48, height: 20),
                  SizedBox(width: 7),
                  SkeletonChip(width: 58, height: 20),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class ExploreMapSkeleton extends StatelessWidget {
  const ExploreMapSkeleton({super.key});
  @override
  Widget build(BuildContext context) => Stack(
    children: [
      const Positioned.fill(child: AppSkeleton(radius: 0)),
      Positioned(
        top: 12,
        left: 16,
        right: 16,
        child: Row(
          children: const [
            AppSkeleton(width: 44, height: 44, radius: 15),
            SizedBox(width: 10),
            Expanded(child: AppSkeleton(height: 48, radius: 17)),
            SizedBox(width: 10),
            AppSkeleton(width: 44, height: 44, radius: 15),
          ],
        ),
      ),
      const Positioned(
        top: 70,
        left: 16,
        right: 16,
        child: SizedBox(height: 40, child: _CategoryChipsSkeleton()),
      ),
      const Positioned(
        right: 16,
        bottom: 190,
        child: AppSkeleton(width: 46, height: 46, radius: 15),
      ),
      Positioned(
        left: 0,
        right: 0,
        bottom: 14,
        child: SizedBox(
          height: 155,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, __) => const _MapBottomCard(),
          ),
        ),
      ),
    ],
  );
}

class _MapBottomCard extends StatelessWidget {
  const _MapBottomCard();
  @override
  Widget build(BuildContext context) => Container(
    width: 265,
    padding: const EdgeInsets.all(9),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.border),
    ),
    child: const Row(
      children: [
        AppSkeleton(width: 86, height: 86, radius: 15),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonText(widthFactor: .8, height: 14),
              SizedBox(height: 8),
              SkeletonText(widthFactor: .55, height: 10),
              SizedBox(height: 8),
              SkeletonChip(width: 55, height: 18),
            ],
          ),
        ),
      ],
    ),
  );
}
