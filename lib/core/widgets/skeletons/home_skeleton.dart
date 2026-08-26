import 'package:flutter/material.dart';
import 'skeleton_primitives.dart';
import '../../theme/app_colors.dart';

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});
  @override
  Widget build(BuildContext context) => ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 20),
        children: const [
          _HomeHeaderSkeleton(),
          SizedBox(height: 18),
          AppSkeleton(height: 52, radius: 17),
          SizedBox(height: 18),
          _AiPlannerEntrySkeleton(),
          SizedBox(height: 16),
          _MoodSkeleton(),
          SizedBox(height: 20),
          SkeletonSectionTitle(widthFactor: .42),
          SizedBox(height: 12),
          _HomeFilterSkeleton(),
          SizedBox(height: 22),
          SkeletonSectionTitle(widthFactor: .55),
          SizedBox(height: 14),
          _HomeCafeCardSkeleton(),
          SizedBox(height: 14),
          _HomeCafeCardSkeleton(),
          SizedBox(height: 22),
          SkeletonSectionTitle(widthFactor: .38),
          SizedBox(height: 12),
          _QuickCategoriesSkeleton(),
        ],
      );
}

class _HomeHeaderSkeleton extends StatelessWidget {
  const _HomeHeaderSkeleton();
  @override
  Widget build(BuildContext context) => Row(children: [
        const AppSkeleton(width: 40, height: 40, radius: 20),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: const [
          SkeletonText(widthFactor: .55, height: 18, radius: 7),
          SizedBox(height: 5),
          SkeletonText(widthFactor: .42, height: 11, radius: 6),
        ])),
      ]);
}

class _AiPlannerEntrySkeleton extends StatelessWidget {
  const _AiPlannerEntrySkeleton();
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)),
        child: const Row(children: [
          AppSkeleton(width: 46, height: 46, radius: 15),
          SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            SkeletonText(widthFactor: .55, height: 15),
            SizedBox(height: 8),
            SkeletonText(widthFactor: .9, height: 11),
          ])),
          SizedBox(width: 10),
          AppSkeleton(width: 28, height: 28, radius: 14),
        ]),
      );
}

class _MoodSkeleton extends StatelessWidget {
  const _MoodSkeleton();
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(17), border: Border.all(color: AppColors.border)),
        child: const Row(children: [
          AppSkeleton(width: 38, height: 38, radius: 19),
          SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [SkeletonText(widthFactor: .55, height: 13), SizedBox(height: 5), SkeletonText(widthFactor: .8, height: 10)])),
          SizedBox(width: 8),
          AppSkeleton(width: 18, height: 18, radius: 9),
        ]),
      );
}

class _HomeFilterSkeleton extends StatelessWidget {
  const _HomeFilterSkeleton();
  @override
  Widget build(BuildContext context) => SizedBox(height: 40, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: 4, separatorBuilder: (_, __) => const SizedBox(width: 8), itemBuilder: (_, i) => SkeletonChip(width: [66.0, 82.0, 74.0, 94.0][i], height: 40.0)));
}

class _HomeCafeCardSkeleton extends StatelessWidget {
  const _HomeCafeCardSkeleton();
  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)),
        clipBehavior: Clip.antiAlias,
        child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AppSkeleton(height: 175, radius: 0),
          Padding(padding: EdgeInsets.fromLTRB(14, 12, 14, 14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Expanded(child: SkeletonText(widthFactor: .72, height: 17)), SizedBox(width: 10), AppSkeleton(width: 55, height: 11, radius: 5)]),
            SizedBox(height: 7),
            SkeletonText(widthFactor: .62, height: 11),
            SizedBox(height: 9),
            SkeletonText(widthFactor: .94, height: 10),
            SizedBox(height: 7),
            SkeletonText(widthFactor: .72, height: 10),
            SizedBox(height: 11),
            Row(children: [SkeletonChip(width: 56, height: 24), SizedBox(width: 6), SkeletonChip(width: 72, height: 24), SizedBox(width: 6), SkeletonChip(width: 68, height: 24)]),
          ])),
        ]),
      );
}

class _QuickCategoriesSkeleton extends StatelessWidget {
  const _QuickCategoriesSkeleton();
  @override
  Widget build(BuildContext context) => Row(children: const [Expanded(child: _CategorySkeleton()), SizedBox(width: 10), Expanded(child: _CategorySkeleton())]);
}
class _CategorySkeleton extends StatelessWidget {
  const _CategorySkeleton();
  @override
  Widget build(BuildContext context) => Container(height: 96, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(18)), child: const Row(children: [AppSkeleton(width: 40, height: 40, radius: 14), SizedBox(width: 10), Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [SkeletonText(widthFactor: .8, height: 13), SizedBox(height: 7), SkeletonText(widthFactor: .55, height: 10)]))]));
}
