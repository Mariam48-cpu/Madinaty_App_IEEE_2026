import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/core/widgets/skeletons/profile_skeleton.dart';
import 'package:toastification/toastification.dart';

import '../../../../../core/utils/app_toast.dart';
import '../../view_model/profile_cubit.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().fetchUserProfile(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLoggedOut) {
              Navigator.pushReplacementNamed(context, '/auth');
            } else if (state is ProfileError) {
              AppToast.showToast(
                context: context,
                title: AppLocale.toastError.getString(context),
                description: state.message,
                type: ToastificationType.error,
              );
            }
          },
          builder: (context, state) {
            if (state is ProfileInitial || state is ProfileLoading) {
              return const ProfileSkeleton();
            }

            String name = AppLocale.defaultUser.getString(context);
            String email = "";
            String phone = "";
            String? profileImageUrl;
            String birthDateStr = "";

            const int loyaltyPoints = 1250;

            if (state is ProfileLoaded) {
              name = state.user.name ?? name;
              email = state.user.email ?? email;
              phone = state.user.phone ?? "";
              profileImageUrl = state.user.profileImageUrl;
              birthDateStr = state.user.birthDate?.toString() ?? "";
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Bar / Header
                  Row(
                    children: [
                      // Profile Title on start
                      Text(
                        AppLocale.navMyAccount.getString(context),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      // Language Switcher
                      const _HeaderLanguageSwitch(),
                      const SizedBox(width: 8),
                      // Settings Icon
                      IconButton(
                        icon: const Icon(
                          Icons.settings_outlined,
                          color: AppColors.primary,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 45,
                              backgroundColor: AppColors.surfaceVariant,
                              backgroundImage:
                                  profileImageUrl != null &&
                                      profileImageUrl!.isNotEmpty
                                  ? NetworkImage(profileImageUrl!)
                                  : null,
                              child:
                                  profileImageUrl == null ||
                                      profileImageUrl!.isEmpty
                                  ? const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: AppColors.primary,
                                    )
                                  : null,
                            ),

                            // Edit Button
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: context.read<ProfileCubit>(),
                                      child: EditProfileScreen(
                                        uid: widget.uid,
                                        currentName: name,
                                        currentPhone: phone,
                                        currentImageUrl: profileImageUrl,
                                        currentEmail: email,
                                        currentBirthDate: birthDateStr,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: AppColors.darkButton,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 14,
                                  color: AppColors.onDarkButton,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          email,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),

                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Divider(color: AppColors.border),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _ProfileStatItem(
                              title: AppLocale.bookingsTitle.getString(context),
                              value: "12",
                            ),
                            const _VerticalDivider(),
                            _ProfileStatItem(
                              title: AppLocale.navFavorites.getString(context),
                              value: "8",
                            ),
                            const _VerticalDivider(),
                            _ProfileStatItem(
                              title: AppLocale.ordersTitle.getString(context),
                              value: "45",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.4,
                    children: [
                      _buildMenuCard(
                        context,
                        AppLocale.bookingsTitle.getString(context),
                        AppLocale.bookingsSubtitle.getString(context),
                        Icons.calendar_today_outlined,
                        AppColors.surfaceVariant,
                        AppColors.primary,
                      ),
                      _buildMenuCard(
                        context,
                        AppLocale.navFavorites.getString(context),
                        AppLocale.favoritePlacesSubtitle.getString(context),
                        Icons.favorite_border,
                        AppColors.error.withValues(alpha: 0.1),
                        AppColors.error,
                      ),
                      _buildMenuCard(
                        context,
                        AppLocale.favoriteProducts.getString(context),
                        AppLocale.favoriteProductsSubtitle.getString(context),
                        Icons.coffee_outlined,
                        AppColors.surfaceVariant,
                        AppColors.primary,
                      ),
                      _buildMenuCard(
                        context,
                        AppLocale.loyaltyPoints.getString(context),
                        "$loyaltyPoints ${AppLocale.pointsUnit.getString(context)}",
                        Icons.workspace_premium_outlined,
                        Colors.amber.shade50,
                        Colors.amber.shade800,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Material(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        _buildListTile(
                          AppLocale.paymentMethods.getString(context),
                          Icons.credit_card_outlined,
                        ),
                        const Divider(
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                          color: AppColors.border,
                        ),
                        _buildListTile(
                          AppLocale.savedAddresses.getString(context),
                          Icons.location_on_outlined,
                        ),
                        const Divider(
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                          color: AppColors.border,
                        ),
                        _buildListTile(
                          AppLocale.helpAndSupport.getString(context),
                          Icons.help_outline,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.error),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        context.read<ProfileCubit>().logout();
                      },
                      icon: const Icon(Icons.logout, color: AppColors.error),
                      label: Text(
                        AppLocale.logoutBtn.getString(context),
                        style: const TextStyle(
                          color: AppColors.error,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color bgColor,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textPrimary),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: AppColors.textSecondary,
      ),
      onTap: () {},
    );
  }
}

class _HeaderLanguageSwitch extends StatelessWidget {
  const _HeaderLanguageSwitch();

  @override
  Widget build(BuildContext context) {
    final localization = FlutterLocalization.instance;
    final currentCode = localization.currentLocale?.languageCode ?? 'ar';
    final isArabic = currentCode == 'ar';

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLangBtn(
              title: 'AR',
              isSelected: isArabic,
              onTap: () {
                if (!isArabic) {
                  localization.translate('ar');
                }
              },
            ),
            _buildLangBtn(
              title: 'EN',
              isSelected: !isArabic,
              onTap: () {
                if (isArabic) {
                  localization.translate('en');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLangBtn({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _ProfileStatItem extends StatelessWidget {
  final String title;
  final String value;

  const _ProfileStatItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(height: 24, width: 1, color: AppColors.border);
  }
}
