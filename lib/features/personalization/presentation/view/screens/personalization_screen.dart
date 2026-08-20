import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:toastification/toastification.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../../core/localization/app_locale.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/app_toast.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/error_state_widget.dart';
import '../../../../../core/widgets/loading_widget.dart';

import '../../../domain/use_cases/get_user_preferences_usecase.dart';
import '../../../domain/use_cases/save_user_preferences_usecase.dart';

import '../../view_model/personalization_cubit.dart';
import '../../view_model/personalization_state.dart';
import '../../widgets/personalization_grid_card.dart';

class PersonalizationScreen extends StatelessWidget {
  final VoidCallback? onSaved;
  final int initialStep;

  const PersonalizationScreen({
    super.key,
    this.onSaved,
    this.initialStep = 0,
  });

  @override
  Widget build(BuildContext context) {
    final currentUserId =
        sl<FirebaseAuth>().currentUser?.uid ?? '';

    return BlocProvider(
      create: (_) => PersonalizationCubit(
        getUserPreferencesUseCase:
            sl<GetUserPreferencesUseCase>(),
        saveUserPreferencesUseCase:
            sl<SaveUserPreferencesUseCase>(),
        currentUserId: currentUserId,
        initialStep: initialStep,
      )..loadPreferences(),
      child: PersonalizationView(
        onSaved: onSaved,
        initialStep: initialStep,
      ),
    );
  }
}

class PersonalizationView extends StatefulWidget {
  final VoidCallback? onSaved;
  final int initialStep;

  const PersonalizationView({
    super.key,
    this.onSaved,
    this.initialStep = 0,
  });

  @override
  State<PersonalizationView> createState() =>
      _PersonalizationViewState();
}

class _PersonalizationViewState
    extends State<PersonalizationView> {
  int _bottomNavIndex = 0;
  int? _previousStep;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocConsumer<PersonalizationCubit,
            PersonalizationState>(
          listener: (context, state) {
            if (state is PersonalizationSuccessState) {
              if (widget.onSaved != null) {
                widget.onSaved!();
              } else {
                Navigator.of(context)
                    .pushReplacementNamed(AppRoutes.home);
              }
            } else if (state is PersonalizationLoadedState) {
              if (_previousStep == 0 &&
                  state.currentStep == 1 &&
                  state.errorMessage == null) {
                AppToast.showToast(
                  context: context,
                  title: AppLocale.toastSuccess
                      .getString(context),
                  description:
                      AppLocale.preferencesSavedSuccess
                          .getString(context),
                  type: ToastificationType.success,
                );
              }

              _previousStep = state.currentStep;

              if (state.errorMessage != null) {
                AppToast.showToast(
                  context: context,
                  title:
                      AppLocale.toastError.getString(context),
                  description:
                      state.errorMessage!.getString(context),
                  type: ToastificationType.error,
                );
              }
            } else if (state is PersonalizationErrorState) {
              AppToast.showToast(
                context: context,
                title:
                    AppLocale.toastError.getString(context),
                description: state.message,
                type: ToastificationType.error,
              );
            }
          },
          builder: (context, state) {
            if (state is PersonalizationLoadingState ||
                state is PersonalizationInitialState) {
              return LoadingWidget(
                message: AppLocale.loadingPreferences
                    .getString(context),
              );
            }

            if (state is PersonalizationErrorState) {
              return ErrorStateWidget(
                errorMessage: state.message,
                onRetry: () => context
                    .read<PersonalizationCubit>()
                    .loadPreferences(),
              );
            }

            final loadedState =
                state is PersonalizationLoadedState
                    ? state
                    : const PersonalizationLoadedState();

            return SafeArea(
              child: loadedState.currentStep == 0
                  ? _buildInterestsScreen(
                      context,
                      loadedState,
                    )
                  : _buildMoodOccasionScreen(
                      context,
                      loadedState,
                    ),
            );
          },
        ),
        bottomNavigationBar: context
            .select<PersonalizationCubit, bool>(
          (cubit) =>
              cubit.state is PersonalizationLoadedState &&
              (cubit.state as PersonalizationLoadedState)
                      .currentStep ==
                  1,
        )
            ? _buildBottomNavBar()
            : null,
      ),
    );
  }

  Widget _buildInterestsScreen(
    BuildContext context,
    PersonalizationLoadedState state,
  ) {
    final theme = Theme.of(context);
    final cubit =
        context.read<PersonalizationCubit>();

    final interests = [
      {
        'id': 'specialty_coffee',
        'label': AppLocale.specialtyCoffee
            .getString(context),
        'svg': AppAssets.specialtyCoffeeIcon,
      },
      {
        'id': 'study',
        'label': AppLocale.study.getString(context),
        'svg': AppAssets.studyIcon,
      },
      {
        'id': 'work',
        'label': AppLocale.work.getString(context),
        'svg': AppAssets.workIcon,
      },
      {
        'id': 'quiet_chill',
        'label': AppLocale.quietChill
            .getString(context),
        'svg': AppAssets.quietIcon,
      },
      {
        'id': 'birthday',
        'label': AppLocale.birthday
            .getString(context),
        'svg': AppAssets.birthdayIcon,
      },
      {
        'id': 'date',
        'label': AppLocale.date.getString(context),
        'svg': AppAssets.dateIcon,
      },
      {
        'id': 'friends_outing',
        'label': AppLocale.withFriends
            .getString(context),
        'svg': AppAssets.friendsIcon,
      },
      {
        'id': 'nile_view',
        'label': AppLocale.nileView
            .getString(context),
        'svg': AppAssets.nileViewIcon,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 12.0,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Align(
            alignment:
                AlignmentDirectional.centerStart,
            child: Text(
              AppLocale.step2Of3
                  .getString(context),
              style:
                  theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Center(
            child: Column(
              children: [
                Text(
                  AppLocale.whatDoYouLikeTitle
                      .getString(context),
                  textAlign: TextAlign.center,
                  style: theme.textTheme
                      .headlineMedium
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  AppLocale.whatDoYouLikeSubtitle
                      .getString(context),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              physics:
                  const BouncingScrollPhysics(),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.22,
              ),
              itemCount: interests.length,
              itemBuilder: (context, index) {
                final item = interests[index];
                final id = item['id']!;
                final isSelected = state
                    .selectedInterests
                    .contains(id);

                return PersonalizationGridCard(
                  title: item['label']!,
                  svgAsset: item['svg']!,
                  isSelected: isSelected,
                  onTap: () =>
                      cubit.toggleInterest(id),
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          CustomButton(
            text: AppLocale.continueBtn
                .getString(context),
            backgroundColor:
                AppColors.darkButton,
            textColor:
                AppColors.onDarkButton,
            borderRadius: 18,
            height: 58,
            textStyle: theme.textTheme.titleMedium
                ?.copyWith(
              color: AppColors.onDarkButton,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            onPressed: () =>
                cubit.goToNextStep(),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildMoodOccasionScreen(
    BuildContext context,
    PersonalizationLoadedState state,
  ) {
    final theme = Theme.of(context);
    final cubit =
        context.read<PersonalizationCubit>();

    final options = [
      {
        'id': 'birthday',
        'label': AppLocale.birthday
            .getString(context),
        'svg': AppAssets.birthdayIcon,
      },
      {
        'id': 'date',
        'label': AppLocale.date.getString(context),
        'svg': AppAssets.dateIcon,
      },
      {
        'id': 'friends_outing',
        'label': AppLocale.friendsOuting
            .getString(context),
        'svg': AppAssets.friendsIcon,
      },
      {
        'id': 'study',
        'label': AppLocale.study.getString(context),
        'svg': AppAssets.studyIcon,
      },
      {
        'id': 'work',
        'label': AppLocale.work.getString(context),
        'svg': AppAssets.workIcon,
      },
      {
        'id': 'quiet_chill',
        'label': AppLocale.chillSitting
            .getString(context),
        'svg': AppAssets.quietIcon,
      },
      {
        'id': 'quick_coffee',
        'label': AppLocale.quickCoffee
            .getString(context),
        'svg': AppAssets.specialtyCoffeeIcon,
      },
      {
        'id': 'nile_view',
        'label': AppLocale.placeWithView
            .getString(context),
        'svg': AppAssets.nileViewIcon,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 12.0,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: AppColors.textPrimary,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    AppLocale.appTitle
                        .getString(context),
                    style: theme.textTheme
                        .titleMedium
                        ?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints:
                    const BoxConstraints(),
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.textPrimary,
                  size: 22,
                ),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 18),
          Center(
            child: Column(
              children: [
                Text(
                  AppLocale.whyGoingOutTitle
                      .getString(context),
                  textAlign: TextAlign.center,
                  style: theme.textTheme
                      .headlineMedium
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  AppLocale.whyGoingOutSubtitle
                      .getString(context),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              physics:
                  const BouncingScrollPhysics(),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.22,
              ),
              itemCount: options.length,
              itemBuilder: (context, index) {
                final item = options[index];
                final id = item['id']!;

                final isSelected =
                    state.selectedMood == id ||
                        state.selectedOccasion == id;

                return PersonalizationGridCard(
                  title: item['label']!,
                  svgAsset: item['svg']!,
                  isSelected: isSelected,
                  onTap: () =>
                      cubit.selectOption(id),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          CustomButton(
            text: AppLocale
                .showSuitablePlaces
                .getString(context),
            isLoading: state.isSaving,
            backgroundColor:
                const Color(0xFF7E8082),
            textColor:
                AppColors.onDarkButton,
            borderRadius: 18,
            height: 50,
            onPressed: state.isSaving
                ? null
                : () {
                    cubit.savePreferences();
                  },
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(
          top: BorderSide(
            color: Color(0xFFF0ECE6),
            width: 1.0,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (index) =>
            setState(() => _bottomNavIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor:
            AppColors.surface,
        selectedItemColor:
            AppColors.primary,
        unselectedItemColor:
            AppColors.textMuted,
        selectedLabelStyle:
            const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          fontFamily: 'Cairo',
        ),
        unselectedLabelStyle:
            const TextStyle(
          fontSize: 11,
          fontFamily: 'Cairo',
        ),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.home_outlined,
            ),
            activeIcon: const Icon(
              Icons.home_rounded,
            ),
            label: AppLocale.navHome
                .getString(context),
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.map_outlined,
            ),
            activeIcon: const Icon(
              Icons.map_rounded,
            ),
            label: AppLocale.navMap
                .getString(context),
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.format_list_bulleted_rounded,
            ),
            activeIcon: const Icon(
              Icons.format_list_bulleted_rounded,
            ),
            label: AppLocale.navMyLists
                .getString(context),
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.person_outline_rounded,
            ),
            activeIcon: const Icon(
              Icons.person_rounded,
            ),
            label: AppLocale.navMyAccount
                .getString(context),
          ),
        ],
      ),
    );
  }
}