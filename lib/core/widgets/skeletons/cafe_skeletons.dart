import 'package:flutter/material.dart';
import 'skeleton_primitives.dart';
import '../../theme/app_colors.dart';

class CafeDetailsSkeleton extends StatelessWidget {
  const CafeDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // ============================================================
                // HERO IMAGE
                // ============================================================
                const AppSkeleton(height: 320, radius: 0),

                // ============================================================
                // MAIN INFO CARD
                // ============================================================
                Transform.translate(
                  offset: const Offset(0, -60),
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.07),
                          blurRadius: 24,
                          spreadRadius: 1,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Cafe name
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: AppSkeleton(width: 190, height: 22, radius: 8),
                        ),

                        SizedBox(height: 14),

                        // Rating + reviews
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AppSkeleton(width: 92, height: 25, radius: 13),
                            SizedBox(width: 10),
                            AppSkeleton(width: 105, height: 13, radius: 6),
                          ],
                        ),

                        SizedBox(height: 20),

                        // Address
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: AppSkeleton(width: 170, height: 14, radius: 7),
                        ),

                        SizedBox(height: 11),

                        // Info line
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: AppSkeleton(width: 250, height: 11, radius: 6),
                        ),

                        SizedBox(height: 8),

                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: AppSkeleton(width: 210, height: 11, radius: 6),
                        ),
                      ],
                    ),
                  ),
                ),

                // ============================================================
                // ABOUT SECTION
                // ============================================================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: AppSkeleton(width: 100, height: 19, radius: 7),
                      ),

                      const SizedBox(height: 12),

                      const Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: AppSkeleton(
                          width: double.infinity,
                          height: 11,
                          radius: 6,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: FractionallySizedBox(
                          widthFactor: 0.88,
                          child: const AppSkeleton(height: 11, radius: 6),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: FractionallySizedBox(
                          widthFactor: 0.62,
                          child: const AppSkeleton(height: 11, radius: 6),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // ============================================================
                // MENU SECTION
                // ============================================================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: AppSkeleton(width: 105, height: 19, radius: 7),
                      ),

                      SizedBox(height: 14),

                      _CafeDetailsMenuSkeleton(),
                      _CafeDetailsMenuSkeleton(),
                      _CafeDetailsMenuSkeleton(),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // ============================================================
                // FEATURES
                // ============================================================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: AppSkeleton(width: 115, height: 19, radius: 7),
                      ),

                      SizedBox(height: 14),

                      Row(
                        children: [
                          Expanded(child: AppSkeleton(height: 42, radius: 14)),
                          SizedBox(width: 10),
                          Expanded(child: AppSkeleton(height: 42, radius: 14)),
                        ],
                      ),

                      SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(child: AppSkeleton(height: 42, radius: 14)),
                          SizedBox(width: 10),
                          Expanded(child: AppSkeleton(height: 42, radius: 14)),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),

        // ================================================================
        // BOTTOM BUTTONS
        // ================================================================
        const _CafeDetailsBottomSkeleton(),
      ],
    );
  }
}

class _CafeDetailsMenuSkeleton extends StatelessWidget {
  const _CafeDetailsMenuSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        children: [
          // Image
          AppSkeleton(width: 72, height: 72, radius: 14),

          SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppSkeleton(width: 125, height: 14, radius: 6),

                SizedBox(height: 9),

                AppSkeleton(width: double.infinity, height: 10, radius: 5),

                SizedBox(height: 8),

                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: AppSkeleton(width: 65, height: 13, radius: 6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CafeDetailsBottomSkeleton extends StatelessWidget {
  const _CafeDetailsBottomSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: const [
            Expanded(child: AppSkeleton(height: 52, radius: 17)),

            SizedBox(width: 12),

            Expanded(child: AppSkeleton(height: 52, radius: 17)),
          ],
        ),
      ),
    );
  }
}
