import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';

import 'package:madinaty_app_ieee_2026/core/di/injection_container.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/screens/location_permission_gate.dart';
import 'package:madinaty_app_ieee_2026/features/favorites/presentation/view/screens/favorites_screen.dart';
import 'package:madinaty_app_ieee_2026/features/favorites/presentation/view_model/cubit/favorites_cubit.dart';
import 'package:madinaty_app_ieee_2026/features/notifications/presentation/view/screens/notifications_screen.dart';
import 'package:madinaty_app_ieee_2026/features/notifications/presentation/view_model/notification_cubit.dart';
import 'package:madinaty_app_ieee_2026/features/profile/presentation/view/screens/profile_screen.dart';
import 'package:madinaty_app_ieee_2026/features/profile/presentation/view_model/profile_cubit.dart';

import '../../view_model/home_cubit.dart';
import '../../view_model/home_state.dart';
import '../widgets/home_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavIndex = 0;

  String _userName = '';
  bool _isLoadingUser = true;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUserName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        if (mounted) {
          setState(() {
            _userName = '';
            _isLoadingUser = false;
          });
        }
        return;
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      String name = '';

      if (userDoc.exists && userDoc.data() != null) {
        final data = userDoc.data()!;

        name = (data['username'] ?? '').toString().trim();

        if (name.isEmpty) {
          name = (data['name'] ?? '').toString().trim();
        }
      }

      if (name.isEmpty) {
        name = user.displayName?.trim() ?? '';
      }

      if (mounted) {
        setState(() {
          _userName = name;
          _isLoadingUser = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _userName = '';
          _isLoadingUser = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: _buildCurrentPage()),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildCurrentPage() {
    switch (_selectedNavIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return const LocationPermissionGate();
      case 2:
        return const FavoritesScreen();
      case 3:
        return _buildProfilePage();
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return BlocProvider<FavoritesCubit>(
      create: (_) => sl<FavoritesCubit>()..initFavoritesWatcher(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading || state is HomeInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is HomeError) {
            return ErrorStateWidget(state: state);
          }

          if (state is HomeEmpty) {
            return const EmptyStateWidget();
          }

          if (state is HomeLoaded) {
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {
                _searchController.clear();
                await context.read<HomeCubit>().fetchHomeData();
                await _loadUserName();
              },
              child: _buildHomeContent(context, state),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildProfilePage() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(
        child: Text(
          AppLocale.loginRequiredToProceed.getString(context),
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return BlocProvider(
      create: (_) => sl<ProfileCubit>()..fetchUserProfile(user.uid),
      child: ProfileScreen(uid: user.uid),
    );
  }

  Widget _buildHomeContent(BuildContext context, HomeLoaded state) {
    final effectiveUserName = _userName.isNotEmpty
        ? _userName
        : AppLocale.defaultUser.getString(context);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocProvider(
                create: (_) {
                  final cubit = sl<NotificationCubit>();
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    cubit.watchNotifications(user.uid);
                  }
                  return cubit;
                },
                child: BlocBuilder<NotificationCubit, NotificationState>(
                  builder: (context, notificationState) {
                    int unreadCount = 0;
                    if (notificationState is NotificationLoaded) {
                      unreadCount = notificationState.unreadCount;
                    }
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.border),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.notifications_none_rounded,
                              size: 22,
                              color: AppColors.textSecondary,
                            ),
                            onPressed: () {
                              final user = FirebaseAuth.instance.currentUser;

                              if (user == null) {
                                return;
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider(
                                    create: (_) {
                                      final cubit = sl<NotificationCubit>();
                                      cubit.fetchNotifications(user.uid);
                                      return cubit;
                                    },
                                    child: NotificationsScreen(uid: user.uid),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        if (unreadCount > 0)
                          PositionedDirectional(
                            top: -5,
                            end: -5,
                            child: Container(
                              constraints: const BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              decoration: const BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  unreadCount > 99
                                      ? '99+'
                                      : unreadCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _isLoadingUser
                          ? AppLocale.goodMorningLoading.getString(context)
                          : '${AppLocale.goodMorningPrefix.getString(context)} $effectiveUserName',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          AppLocale.madinatyCairo.getString(context),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(17),
              border: Border.all(color: AppColors.border),
            ),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (query) {
                context.read<HomeCubit>().searchCafes(query);
              },
              decoration: InputDecoration(
                hintText: AppLocale.homeSearchBarHint.getString(context),
                hintStyle: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.textSecondary,
                  size: 22,
                ),
                suffixIcon: state.isSearchActive
                    ? IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    context.read<HomeCubit>().clearSearch();
                  },
                )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
              ),
            ),
          ),
          if (state.isSearchActive) ...[
            const SizedBox(height: 18),
            Text(
              AppLocale.searchResultsTitle.getString(context),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 11),
            if (state.isSearching)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              )
            else if (state.searchError != null)
              SearchErrorWidget(message: state.searchError!)
            else if (state.searchResults.isEmpty)
                const NoSearchResults()
              else
                ...state.searchResults.map(
                      (cafe) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: CafeCard(cafe: cafe),
                  ),
                ),
          ] else ...[
            const SizedBox(height: 16),
            if (state.activeMoodOrOccasion != null) MoodCard(state: state),
            const SizedBox(height: 18),
            Text(
              AppLocale.whatsYourMoodToday.getString(context),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 11),
            const HomeFilters(),
            const SizedBox(height: 18),
            Text(
              AppLocale.selectedCafesForYou.getString(context),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 11),
            if (state.filteredCafes.isEmpty)
              const NoFilteredResults()
            else
              ...state.filteredCafes.map(
                    (cafe) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: CafeCard(cafe: cafe),
                ),
              ),
            const SizedBox(height: 2),
            const QuickCategories(),
            const SizedBox(height: 15),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: AppLocale.navHome.getString(context),
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.explore_outlined,
                activeIcon: Icons.explore,
                label: AppLocale.navExplore.getString(context),
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.favorite_border_rounded,
                activeIcon: Icons.favorite_rounded,
                label: AppLocale.navFavorites.getString(context),
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: AppLocale.navMyAccount.getString(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isSelected = _selectedNavIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedNavIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceVariant : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              size: 21,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}