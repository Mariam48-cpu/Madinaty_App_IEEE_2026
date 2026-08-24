import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/screens/location_permission_gate.dart';
import 'package:madinaty_app_ieee_2026/features/favorites/presentation/view/screens/favorites_screen.dart';
import '../../../../../features/favorites/presentation/view_model/cubit/favorites_cubit.dart';
import 'package:madinaty_app_ieee_2026/features/profile/presentation/view/screens/profile_screen.dart';
import 'package:madinaty_app_ieee_2026/features/profile/presentation/view_model/profile_cubit.dart';

import '../../view_model/home_cubit.dart';
import '../../view_model/home_state.dart';
import '../widgets/home_widgets.dart';

import '../../../../../core/di/injection_container.dart';
import '../../../../../features/notifications/presentation/view/screens/notifications_screen.dart';
import '../../../../../features/notifications/presentation/view_model/notification_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavIndex = 0;

  String _userName = 'مستخدم';
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
            _userName = 'مستخدم';
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

      if (name.isEmpty) {
        name = 'مستخدم';
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
          _userName = 'مستخدم';
          _isLoadingUser = false;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFAF8F4),
        body: SafeArea(child: _buildCurrentPage()),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
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
              child: CircularProgressIndicator(color: Color(0xFF8B6B4A)),
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
              color: const Color(0xFF8B6B4A),
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
      return const Center(child: Text('يجب تسجيل الدخول أولاً'));
    }

    return BlocProvider(
      create: (_) => sl<ProfileCubit>()..fetchUserProfile(user.uid),
      child: ProfileScreen(uid: user.uid),
    );
  }

  Widget _buildHomeContent(BuildContext context, HomeLoaded state) {
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
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFE8E1D8)),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.notifications_none_rounded,
                              size: 22,
                              color: Color(0xFF5E5146),
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
                          Positioned(
                            top: -5,
                            right: -5,
                            child: Container(
                              constraints: const BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              decoration: const BoxDecoration(
                                color: Colors.red,
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
                          ? 'صباح الخير...'
                          : 'صباح الخير، $_userName',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3F3934),
                      ),
                    ),

                    const SizedBox(height: 3),

                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Color(0xFF7A7068),
                        ),
                        SizedBox(width: 3),
                        Text(
                          'مدينتي، القاهرة',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF81776E),
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(17),
              border: Border.all(color: const Color(0xFFEDE7DF)),
            ),
            child: TextField(
              controller: _searchController,
              textDirection: TextDirection.rtl,
              textInputAction: TextInputAction.search,
              onSubmitted: (query) {
                context.read<HomeCubit>().searchCafes(query);
              },
              decoration: InputDecoration(
                hintText: 'ابحث بالاسم، المنطقة، أو نوع القهوة',
                hintStyle: const TextStyle(
                  color: Color(0xFF9A9189),
                  fontSize: 12,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Color(0xFF70675F),
                  size: 22,
                ),
                suffixIcon: state.isSearchActive
                    ? IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Color(0xFF70675F),
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

            const Text(
              'نتائج البحث',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF443D38),
              ),
            ),

            const SizedBox(height: 11),

            if (state.isSearching)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: CircularProgressIndicator(color: Color(0xFF8B6B4A)),
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
          ]
          else ...[
            const SizedBox(height: 16),

            if (state.activeMoodOrOccasion != null) MoodCard(state: state),

            const SizedBox(height: 18),

            const Text(
              'على مزاجك إيه النهارده؟',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF443D38),
              ),
            ),

            const SizedBox(height: 11),

            const HomeFilters(),

            const SizedBox(height: 18),

            const Text(
              'المقاهي المختارة لك',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF443D38),
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
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEDE7DF))),
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
                label: 'الرئيسية',
              ),

              _buildNavItem(
                index: 1,
                icon: Icons.explore_outlined,
                activeIcon: Icons.explore,
                label: 'استكشف',
              ),

              _buildNavItem(
                index: 2,
                icon: Icons.favorite_border_rounded,
                activeIcon: Icons.favorite_rounded,
                label: 'المفضلة',
              ),

              _buildNavItem(
                index: 3,
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: 'حسابي',
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
          color: isSelected ? const Color(0xFFF0D9BC) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              size: 21,
              color: isSelected
                  ? const Color(0xFF8B6545)
                  : const Color(0xFF81776E),
            ),

            const SizedBox(height: 3),

            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? const Color(0xFF8B6545)
                    : const Color(0xFF81776E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
