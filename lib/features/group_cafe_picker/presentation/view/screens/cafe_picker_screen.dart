import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/core/widgets/cafe_card.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view_model/cubit/discovery_cubit.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view_model/cubit/discovery_state.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/domain/entities/group_cafe_entity.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/presentation/view_model/group_cafe_picker_cubit.dart';

class CafePickerScreen extends StatefulWidget {
  final String groupId;
  final GroupMemberEntity currentUser;

  const CafePickerScreen({
    super.key,
    required this.groupId,
    required this.currentUser,
  });

  @override
  State<CafePickerScreen> createState() => _CafePickerScreenState();
}

class _CafePickerScreenState extends State<CafePickerScreen> {
  final List<CafeEntity> selectedCafes = [];

  @override
  void initState() {
    super.initState();

    final discoveryCubit = context.read<DiscoveryCubit>();

    if (discoveryCubit.state is DiscoveryInitial) {
      discoveryCubit.loadNearbyCafes();
    }
  }

  void toggleCafe(CafeEntity cafe) {
    setState(() {
      final exists = selectedCafes.any((element) => element.id == cafe.id);

      if (exists) {
        selectedCafes.removeWhere((element) => element.id == cafe.id);
        return;
      }

      if (selectedCafes.length >= 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ممكن تختاري لحد 3 كافيهات بس')),
        );

        return;
      }

      selectedCafes.add(cafe);
    });
  }

  Future<void> submit() async {
    if (selectedCafes.length < 2) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('اختاري كافيهين على الأقل')));

      return;
    }

    final picks = selectedCafes.map((cafe) {
      return GroupCafePickEntity(
        cafeId: cafe.id,
        cafeName: cafe.name,
        imageUrl: cafe.photos.isNotEmpty ? cafe.photos.first : '',
        rating: cafe.rating,
        address: cafe.address,
      );
    }).toList();

    await context.read<GroupCafeCubit>().submitPicks(
      groupId: widget.groupId,
      userId: widget.currentUser.userId,
      picks: picks,
    );

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'اختار كافيهاتك',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: BlocBuilder<DiscoveryCubit, DiscoveryState>(
        builder: (context, state) {
          if (state is DiscoveryLoading || state is DiscoveryInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DiscoveryError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(state.message, textAlign: TextAlign.center),
              ),
            );
          }

          if (state is! DiscoverySuccess) {
            return const Center(child: Text('مفيش كافيهات متاحة حاليًا'));
          }

          final cafes = state.cafes;

          return Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.local_cafe_rounded,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'اختاري من 2 لـ 3 كافيهات',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            '${selectedCafes.length}/3 تم اختيارهم',
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: cafes.length,
                  itemBuilder: (context, index) {
                    final cafe = cafes[index];

                    final isSelected = selectedCafes.any(
                      (element) => element.id == cafe.id,
                    );

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Stack(
                        children: [
                          CafeCard(
                            title: cafe.name,
                            subtitle: cafe.address,
                            imageUrl: cafe.photos.isNotEmpty
                                ? cafe.photos.first
                                : null,
                            rating: cafe.rating,
                            reviewCount: cafe.reviewsCount,
                            tagText: isSelected ? 'تم الاختيار ✓' : null,
                            onTap: () {
                              toggleCafe(cafe);
                            },
                          ),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: GestureDetector(
                              onTap: () {
                                toggleCafe(cafe);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.12,
                                      ),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  isSelected
                                      ? Icons.check_rounded
                                      : Icons.add_rounded,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.primary,
                                  size: 21,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: selectedCafes.length >= 2 ? submit : null,
                    icon: const Icon(Icons.check_rounded),
                    label: const Text(
                      'أنا خلصت اختياري',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
