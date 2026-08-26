import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

import 'package:madinaty_app_ieee_2026/core/di/injection_container.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/routes/app_routes.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/core/widgets/skeletons/home_skeleton.dart';
import 'package:madinaty_app_ieee_2026/core/widgets/skeletons/skeleton_primitives.dart';

import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/screens/location_permission_gate.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view_model/cubit/discovery_cubit.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view_model/cubit/discovery_state.dart';

import 'package:madinaty_app_ieee_2026/features/favorites/presentation/view/screens/favorites_screen.dart';
import 'package:madinaty_app_ieee_2026/features/favorites/presentation/view_model/cubit/favorites_cubit.dart';

import 'package:madinaty_app_ieee_2026/features/notifications/presentation/view/screens/notifications_screen.dart';
import 'package:madinaty_app_ieee_2026/features/notifications/presentation/view_model/notification_cubit.dart';

import 'package:madinaty_app_ieee_2026/features/profile/presentation/view/screens/profile_screen.dart';
import 'package:madinaty_app_ieee_2026/features/profile/presentation/view_model/profile_cubit.dart';

import 'package:madinaty_app_ieee_2026/features/cart/presentation/view/screens/cart_screen.dart';
import 'package:madinaty_app_ieee_2026/features/cart/presentation/view_model/cubit/cart_cubit.dart';

import '../../view_model/home_cubit.dart';
import '../../view_model/home_state.dart';
import '../widgets/home_widgets.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;

  const HomeScreen({super.key, this.initialIndex = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedNavIndex;

  String _userName = '';
  bool _isLoadingUser = true;

  String _locationName = '';
  bool _isLoadingLocation = true;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _selectedNavIndex = widget.initialIndex.clamp(0, 4);

    _loadUserName();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final discoveryCubit = context.read<DiscoveryCubit>();

      final location = discoveryCubit.currentLocation;

      if (location != null) {
        _resolveLocationName(location);
      }
    });
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
        if (!mounted) return;

        setState(() {
          _userName = '';
          _isLoadingUser = false;
        });

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

      if (!mounted) return;

      setState(() {
        _userName = name;
        _isLoadingUser = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _userName = '';
        _isLoadingUser = false;
      });
    }
  }
  Future<void> _resolveLocationName(LatLng location) async {
    try {
      if (mounted) {
        setState(() {
          _isLoadingLocation = true;
        });
      }

      final placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (!mounted) return;

      if (placemarks.isEmpty) {
        setState(() {
          _locationName = '';
          _isLoadingLocation = false;
        });

        return;
      }

      final place = placemarks.first;

      String locationName = '';

      final possibleNames = <String?>[
        place.subLocality,
        place.locality,
        place.subAdministrativeArea,
        place.administrativeArea,
      ];

      for (final value in possibleNames) {
        if (value != null && value.trim().isNotEmpty) {
          locationName = value.trim();
          break;
        }
      }

      setState(() {
        _locationName = locationName;
        _isLoadingLocation = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _locationName = '';
        _isLoadingLocation = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _buildCurrentPage(),
      ),
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
        return _buildCartPage();

      case 3:
        return const FavoritesScreen();

      case 4:
        return _buildProfilePage();

      default:
        return _buildHomePage();
    }
  }
  Widget _buildHomePage() {
    return BlocListener<DiscoveryCubit, DiscoveryState>(
      listenWhen: (previous, current) {
        return current is DiscoverySuccess;
      },

      listener: (context, state) async {
        if (state is DiscoverySuccess) {
          final location = state.currentLocation;

          if (location != null) {
            await _resolveLocationName(location);
          }
        }
      },

      child: BlocProvider<FavoritesCubit>(
        create: (_) => sl<FavoritesCubit>()..initFavoritesWatcher(),

        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {

            if (state is HomeLoading || state is HomeInitial) {
              return const HomeSkeleton();
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

                  final discoveryCubit = context.read<DiscoveryCubit>();

                  final location = discoveryCubit.currentLocation;

                  if (location != null) {
                    await _resolveLocationName(location);
                  }
                },

                child: _buildHomeContent(context, state),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
  Widget _buildCartPage() {
    return BlocProvider(
      create: (_) => sl<CartCubit>()..initCartWatcher(),
      child: const CartScreen(),
    );
  }
  Widget _buildProfilePage() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(
        child: Text(
          AppLocale.loginRequiredToProceed.getString(context),
          style: const TextStyle(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return BlocProvider(
      create: (_) => sl<ProfileCubit>()..fetchUserProfile(user.uid),
      child: ProfileScreen(uid: user.uid),
    );
  }
  Widget _buildHomeContent(
      BuildContext context,
      HomeLoaded state,
      ) {
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
                            border: Border.all(
                              color: AppColors.border,
                            ),
                          ),

                          child: IconButton(
                            padding: EdgeInsets.zero,

                            icon: const Icon(
                              Icons.notifications_none_rounded,
                              size: 22,
                              color: AppColors.textSecondary,
                            ),

                            onPressed: () {
                              final user =
                                  FirebaseAuth.instance.currentUser;

                              if (user == null) {
                                return;
                              }

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider(
                                    create: (_) {
                                      final cubit =
                                      sl<NotificationCubit>();

                                      cubit.fetchNotifications(user.uid);

                                      return cubit;
                                    },

                                    child: NotificationsScreen(
                                      uid: user.uid,
                                    ),
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
                          ? AppLocale.goodMorningLoading
                          .getString(context)
                          : '${AppLocale.goodMorningPrefix.getString(context)} $effectiveUserName',

                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,

                      textAlign: TextAlign.right,

                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 5),
                    Row(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 15,
                          color: AppColors.primary,
                        ),

                        const SizedBox(width: 3),

                        Flexible(
                          child: Text(
                            _isLoadingLocation
                                ? 'جاري تحديد موقعك...'
                                : _locationName.isNotEmpty
                                ? _locationName
                                : 'الموقع غير متاح',

                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,

                            textAlign: TextAlign.right,

                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
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
              border: Border.all(
                color: AppColors.border,
              ),
            ),

            child: TextField(
              controller: _searchController,

              textInputAction: TextInputAction.search,

              onSubmitted: (query) {
                context.read<HomeCubit>().searchCafes(query);
              },

              decoration: InputDecoration(
                hintText:
                AppLocale.homeSearchBarHint.getString(context),

                hintStyle: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),

                prefixIcon: AnimatedSwitcher(
                  duration: const Duration(
                    milliseconds: 220,
                  ),

                  transitionBuilder: (
                      child,
                      animation,
                      ) {
                    return ScaleTransition(
                      scale: animation,
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    );
                  },

                  child: Icon(
                    state.isSearchActive
                        ? Icons.manage_search_rounded
                        : Icons.search_rounded,

                    key: ValueKey(
                      state.isSearchActive,
                    ),

                    color: AppColors.textSecondary,

                    size: 22,
                  ),
                ),

                suffixIcon: AnimatedSwitcher(
                  duration: const Duration(
                    milliseconds: 220,
                  ),

                  transitionBuilder: (
                      child,
                      animation,
                      ) {
                    return ScaleTransition(
                      scale: animation,
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    );
                  },

                  child: state.isSearchActive
                      ? IconButton(
                    key: const ValueKey(
                      'clear-search',
                    ),

                    icon: const Icon(
                      Icons.close_rounded,
                      color:
                      AppColors.textSecondary,
                      size: 20,
                    ),

                    onPressed: () {
                      _searchController.clear();

                      context
                          .read<HomeCubit>()
                          .clearSearch();
                    },
                  )
                      : const SizedBox.shrink(
                    key: ValueKey(
                      'no-clear',
                    ),
                  ),
                ),

                border: InputBorder.none,

                contentPadding:
                const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
              ),
            ),
          ),
          if (state.isSearchActive) ...[
            const SizedBox(height: 18),

            Text(
              AppLocale.searchResultsTitle
                  .getString(context),

              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 11),

            AnimatedSwitcher(
              duration: const Duration(
                milliseconds: 320,
              ),

              switchInCurve:
              Curves.easeOutCubic,

              switchOutCurve:
              Curves.easeInCubic,

              transitionBuilder: (
                  child,
                  animation,
                  ) {
                return FadeTransition(
                  opacity: animation,

                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, .04),
                      end: Offset.zero,
                    ).animate(animation),

                    child: child,
                  ),
                );
              },

              child: state.isSearching
                  ? const Padding(
                key: ValueKey(
                  'search-loading',
                ),

                padding:
                EdgeInsets.symmetric(
                  vertical: 8,
                ),

                child: _SearchSkeleton(),
              )
                  : state.searchError != null
                  ? SearchErrorWidget(
                key: const ValueKey(
                  'search-error',
                ),
                message:
                state.searchError!,
              )
                  : state.searchResults.isEmpty
                  ? const NoSearchResults(
                key: ValueKey(
                  'search-empty',
                ),
              )
                  : Column(
                key: const ValueKey(
                  'search-results',
                ),

                children: state
                    .searchResults
                    .map(
                      (cafe) => Padding(
                    padding:
                    const EdgeInsets
                        .only(
                      bottom: 16,
                    ),

                    child: CafeCard(
                      cafe: cafe,
                    ),
                  ),
                ).toList(),
              ),
            ),
          ]
          else ...[
            const SizedBox(height: 16),

            const _AiPlannerEntryCard(),

            const SizedBox(height: 18),

            if (state.activeMoodOrOccasion != null) ...[
              MoodCard(state: state),

              const SizedBox(height: 18),
            ],

            Text(
              AppLocale.whatsYourMoodToday
                  .getString(context),

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
              AppLocale.selectedCafesForYou
                  .getString(context),

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
                  padding: const EdgeInsets.only(
                    bottom: 16,
                  ),

                  child: CafeCard(
                    cafe: cafe,
                  ),
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

        border: Border(
          top: BorderSide(
            color: AppColors.border,
          ),
        ),
      ),

      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 6,
          ),

          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceAround,

            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: AppLocale.navHome
                    .getString(context),
              ),

              _buildNavItem(
                index: 1,
                icon: Icons.explore_outlined,
                activeIcon: Icons.explore,
                label: AppLocale.navExplore
                    .getString(context),
              ),

              _buildNavItem(
                index: 2,
                icon:
                Icons.shopping_cart_outlined,
                activeIcon:
                Icons.shopping_cart_rounded,
                label: 'السلة',
              ),

              _buildNavItem(
                index: 3,
                icon:
                Icons.favorite_border_rounded,
                activeIcon:
                Icons.favorite_rounded,
                label: AppLocale.navFavorites
                    .getString(context),
              ),

              _buildNavItem(
                index: 4,
                icon:
                Icons.person_outline_rounded,
                activeIcon:
                Icons.person_rounded,
                label: AppLocale.navMyAccount
                    .getString(context),
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
    final isSelected =
        _selectedNavIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedNavIndex = index;
        });
      },

      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 200,
        ),

        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 7,
        ),

        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.surfaceVariant
              : Colors.transparent,

          borderRadius:
          BorderRadius.circular(18),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Icon(
              isSelected
                  ? activeIcon
                  : icon,

              size: 21,

              color: isSelected
                  ? AppColors.primary
                  : AppColors.textSecondary,
            ),

            const SizedBox(height: 3),

            Text(
              label,

              style: TextStyle(
                fontSize: 9,
                fontWeight: isSelected
                    ? FontWeight.bold
                    : FontWeight.normal,

                color: isSelected
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _AiPlannerEntryCard extends StatelessWidget {
  const _AiPlannerEntryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,

          colors: [
            Color(0xFFFFEBDD),
            Color(0xFFFFF5EF),
          ],
        ),

        borderRadius:
        BorderRadius.circular(22),

        border: Border.all(
          color: AppColors.primary
              .withValues(alpha: 0.10),
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,

            decoration: BoxDecoration(
              color: AppColors.primary
                  .withValues(alpha: 0.10),

              borderRadius:
              BorderRadius.circular(15),
            ),

            child: const Icon(
              Icons.auto_awesome_rounded,

              color: AppColors.primary,

              size: 23,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.end,

              children: [
                Text(
                  'خطط لي يومي بالذكاء الاصطناعي',

                  textAlign:
                  TextAlign.right,

                  maxLines: 1,

                  overflow:
                  TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight:
                    FontWeight.bold,
                    color:
                    AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  'تجربة مميزة تناسب مزاجك، وقتك ومكانك.',

                  textAlign:
                  TextAlign.right,

                  maxLines: 2,

                  overflow:
                  TextOverflow.ellipsis,

                  style: TextStyle(
                    fontSize: 10.5,
                    height: 1.35,
                    color:
                    AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 9),

                Align(
                  alignment:
                  AlignmentDirectional
                      .centerEnd,

                  child: SizedBox(
                    height: 33,

                    child:
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.aiPlanner,
                        );
                      },

                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        size: 14,
                      ),

                      label: const Text(
                        'ابدأ الآن',

                        style: TextStyle(
                          fontSize: 11,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      style:
                      ElevatedButton.styleFrom(
                        backgroundColor:
                        AppColors.primary,

                        foregroundColor:
                        Colors.white,

                        elevation: 0,

                        padding:
                        const EdgeInsets
                            .symmetric(
                          horizontal: 13,
                        ),

                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius
                              .circular(11),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              color: Colors.white
                  .withValues(alpha: 0.72),

              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.auto_awesome_rounded,

              color: AppColors.primary,

              size: 21,
            ),
          ),
        ],
      ),
    );
  }
}
class _SearchSkeleton extends StatelessWidget {
  const _SearchSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _SearchResultSkeleton(),

        SizedBox(height: 10),

        _SearchResultSkeleton(),
      ],
    );
  }
}

class _SearchResultSkeleton
    extends StatelessWidget {
  const _SearchResultSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: AppColors.surface,

        borderRadius:
        BorderRadius.circular(18),

        border: Border.all(
          color: AppColors.border,
        ),
      ),

      child: const Row(
        children: [
          AppSkeleton(
            width: 70,
            height: 70,
            radius: 14,
          ),

          SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                AppSkeleton(
                  width: 125,
                  height: 14,
                  radius: 6,
                ),

                SizedBox(height: 9),

                AppSkeleton(
                  width: 90,
                  height: 10,
                  radius: 5,
                ),

                SizedBox(height: 9),

                AppSkeleton(
                  width: 65,
                  height: 22,
                  radius: 11,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
