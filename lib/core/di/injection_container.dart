import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ==================================================
// AUTH
// ==================================================

import '../../features/auth/data/data_sources/auth_data_source_interface.dart';
import '../../features/auth/data/data_sources/auth_data_source_imp.dart';
import '../../features/auth/data/repositories/auth_repo_imp.dart';
import '../../features/auth/domain/repositories/auth_repo_interface.dart';

// ==================================================
// ONBOARDING
// ==================================================

import '../../features/onboarding/data/data_sources/onboarding_local_data_source.dart';
import '../../features/onboarding/data/repositories/onboarding_repository_impl.dart';
import '../../features/onboarding/domain/repositories/onboarding_repository.dart';
import '../../features/onboarding/domain/use_cases/get_onboarding_pages.dart';
import '../../features/onboarding/domain/use_cases/is_onboarding_seen.dart';
import '../../features/onboarding/domain/use_cases/set_onboarding_seen.dart';
import '../../features/onboarding/presentation/view_model/onboarding_bloc.dart';

// ==================================================
// PERSONALIZATION
// ==================================================

import '../../features/personalization/data/data_sources/personalization_remote_data_source_imp.dart';
import '../../features/personalization/data/data_sources/personalization_remote_data_source_interface.dart';
import '../../features/personalization/data/repositories/personalization_repo_imp.dart';
import '../../features/personalization/domain/repositories/personalization_repository_interface.dart';
import '../../features/personalization/domain/use_cases/get_user_preferences_usecase.dart';
import '../../features/personalization/domain/use_cases/save_user_preferences_usecase.dart';

// ==================================================
// HOME
// ==================================================

import '../../features/home/data/data_sources/google_places_datasource.dart';
import '../../features/home/data/repositories/recommendation_repository_impl.dart';
import '../../features/home/domain/repositories/recommendation_repository.dart';
import '../../features/home/domain/use_cases/get_recommendations_use_case.dart';
import '../../features/home/domain/use_cases/search_cafes_use_case.dart';
import '../../features/home/presentation/view_model/home_cubit.dart';

// ==================================================
// DISCOVERY
// ==================================================

import '../../features/discovery/data/data_sources/google_places_datasource.dart'
as discovery;
import '../../features/discovery/data/repositories/cafe_repository_impl.dart';
import '../../features/discovery/domain/repositories/cafe_repository_interface.dart';
import '../../features/discovery/presentation/view_model/cubit/discovery_cubit.dart';

// ==================================================
// CAFE
// ==================================================

import '../../features/cafe/data/data_sources/cafe_firestore_data_source.dart';
import '../../features/cafe/data/repositories/cafe_repository_firebase.dart';
import '../../features/cafe/domain/repositories/cafe_repository_interface.dart';
import '../../features/cafe/domain/use_cases/get_cafe_experience_use_case.dart';
import '../../features/cafe/domain/use_cases/get_cafe_menu_use_case.dart';
import '../../features/cafe/presentation/view_model/cubit/cafe_cubit.dart';

// ==================================================
// BOOKING
// ==================================================

import '../../features/booking/data/repositories/booking_repository_impl.dart';
import '../../features/booking/domain/repositories/booking_repository_interface.dart';
import '../../features/booking/domain/use_cases/create_booking_usecase.dart';
import '../../features/booking/domain/use_cases/get_booking_usecase.dart';
import '../../features/booking/domain/use_cases/update_booking_status_usecase.dart';
import '../../features/booking/presentation/view_model/cubit/booking_cubit.dart';

// ==================================================
// FAVORITES
// ==================================================

import '../../features/favorites/data/data_sources/favorites_remote_data_source_interface.dart';
import '../../features/favorites/data/data_sources/favorites_remote_data_source_impl.dart';
import '../../features/favorites/data/repositories/favorites_repository_impl.dart';
import '../../features/favorites/domain/repositories/favorites_repository_interface.dart';
import '../../features/favorites/domain/use_cases/add_favorite_use_case.dart';
import '../../features/favorites/domain/use_cases/get_favorites_use_case.dart';
import '../../features/favorites/domain/use_cases/is_favorite_use_case.dart';
import '../../features/favorites/domain/use_cases/remove_favorite_use_case.dart';
import '../../features/favorites/domain/use_cases/toggle_favorite_use_case.dart';
import '../../features/favorites/domain/use_cases/watch_favorites_use_case.dart';
import '../../features/favorites/presentation/view_model/cubit/favorites_cubit.dart';

// ==================================================
// PROFILE
// ==================================================

import '../../features/profile/data/data_sources/profile_remote_data_source.dart';
import '../../features/profile/data/repositories/profile_repo_imp.dart';
import '../../features/profile/domain/repositories/profile_repo_interface.dart';
import '../../features/profile/domain/use_cases/get_profile_use_case.dart';
import '../../features/profile/domain/use_cases/update_profile_use_case.dart';
import '../../features/profile/presentation/view_model/profile_cubit.dart';

// ==================================================
// NOTIFICATIONS
// ==================================================

import '../../features/notifications/data/data_sources/notification_remote_data_source.dart';
import '../../features/notifications/data/repositories/notification_repo_imp.dart';
import '../../features/notifications/domain/repositories/notification_repo_interface.dart';
import '../../features/notifications/domain/use_cases/get_notifications_use_case.dart';
import '../../features/notifications/domain/use_cases/create_notification_use_case.dart';
import '../../features/notifications/domain/use_cases/mark_notification_read_use_case.dart';
import '../../features/notifications/domain/use_cases/mark_all_notifications_as_read_use_case.dart';
import '../../features/notifications/domain/use_cases/delete_notification_use_case.dart';
import '../../features/notifications/presentation/view_model/notification_cubit.dart';

// ==================================================
// REVIEWS
// ==================================================

import '../../features/reviews/data/data_sources/reviews_remote_data_source_impl.dart';
import '../../features/reviews/data/data_sources/reviews_remote_data_source_interface.dart';
import '../../features/reviews/data/repositories/reviews_repository_impl.dart';
import '../../features/reviews/domain/repositories/reviews_repository_interface.dart';
import '../../features/reviews/domain/use_cases/get_cafe_reviews_use_case.dart';
import '../../features/reviews/domain/use_cases/get_user_review_use_case.dart';
import '../../features/reviews/domain/use_cases/submit_review_use_case.dart';
import '../../features/reviews/domain/use_cases/watch_cafe_reviews_use_case.dart';
import '../../features/reviews/presentation/view_model/cubit/reviews_cubit.dart';

// ==================================================
// CORE SERVICES
// ==================================================

import '../services/location_service.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  // ==================================================
  // CORE
  // ==================================================

  final sharedPreferences = await SharedPreferences.getInstance();

  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  sl.registerLazySingleton<LocationService>(() => LocationService());

  sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn.instance);

  // ==================================================
  // AUTH
  // ==================================================

  sl.registerLazySingleton<AuthRemoteDataSourceInterface>(
        () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl<FirebaseAuth>(),
      firestore: sl<FirebaseFirestore>(),
      googleSignIn: sl<GoogleSignIn>(),
    ),
  );

  sl.registerLazySingleton<AuthRepoInterface>(
        () => AuthRepoImpl(remoteDataSource: sl<AuthRemoteDataSourceInterface>()),
  );

  // ==================================================
  // ONBOARDING
  // ==================================================

  sl.registerLazySingleton<OnboardingLocalDataSource>(
        () => OnboardingLocalDataSource(sl<SharedPreferences>()),
  );

  sl.registerLazySingleton<OnboardingRepository>(
        () => OnboardingRepositoryImpl(sl<OnboardingLocalDataSource>()),
  );

  sl.registerLazySingleton<GetOnboardingPages>(
        () => GetOnboardingPages(sl<OnboardingRepository>()),
  );

  sl.registerLazySingleton<SetOnboardingSeen>(
        () => SetOnboardingSeen(sl<OnboardingRepository>()),
  );

  sl.registerLazySingleton<IsOnboardingSeen>(
        () => IsOnboardingSeen(sl<OnboardingRepository>()),
  );

  sl.registerFactory<OnboardingBloc>(
        () => OnboardingBloc(
      getOnboardingPages: sl<GetOnboardingPages>(),
      setOnboardingSeen: sl<SetOnboardingSeen>(),
    ),
  );

  // ==================================================
  // PERSONALIZATION
  // ==================================================

  sl.registerLazySingleton<PersonalizationRemoteDataSourceInterface>(
        () => PersonalizationRemoteDataSourceImpl(
      firebaseAuth: sl<FirebaseAuth>(),
      firestore: sl<FirebaseFirestore>(),
    ),
  );

  sl.registerLazySingleton<PersonalizationRepositoryInterface>(
        () => PersonalizationRepoImpl(
      remoteDataSource: sl<PersonalizationRemoteDataSourceInterface>(),
    ),
  );

  sl.registerLazySingleton<GetUserPreferencesUseCase>(
        () => GetUserPreferencesUseCase(sl<PersonalizationRepositoryInterface>()),
  );

  sl.registerLazySingleton<SaveUserPreferencesUseCase>(
        () => SaveUserPreferencesUseCase(sl<PersonalizationRepositoryInterface>()),
  );

  // ==================================================
  // HOME
  // ==================================================

  sl.registerLazySingleton<GooglePlacesDataSource>(
        () => GooglePlacesDataSource(),
  );

  sl.registerLazySingleton<RecommendationRepository>(
        () => RecommendationRepositoryImpl(
      sl<GooglePlacesDataSource>(),
      sl<FirebaseFirestore>(),
    ),
  );

  sl.registerLazySingleton<GetRecommendationsUseCase>(
        () => GetRecommendationsUseCase(sl<RecommendationRepository>()),
  );

  sl.registerLazySingleton<SearchCafesUseCase>(
        () => SearchCafesUseCase(sl<RecommendationRepository>()),
  );

  sl.registerFactoryParam<HomeCubit, String, void>(
        (currentUserId, _) => HomeCubit(
      getRecommendationsUseCase: sl<GetRecommendationsUseCase>(),
      getUserPreferencesUseCase: sl<GetUserPreferencesUseCase>(),
      searchCafesUseCase: sl<SearchCafesUseCase>(),
      currentUserId: currentUserId,
    ),
  );

  // ==================================================
  // REVIEWS
  // ==================================================

  sl.registerLazySingleton<ReviewsRemoteDataSourceInterface>(
        () => ReviewsRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<ReviewsRepositoryInterface>(
        () => ReviewsRepositoryImpl(
      dataSource: sl<ReviewsRemoteDataSourceInterface>(),
    ),
  );

  sl.registerLazySingleton<GetCafeReviewsUseCase>(
        () => GetCafeReviewsUseCase(repository: sl<ReviewsRepositoryInterface>()),
  );

  sl.registerLazySingleton<GetUserReviewUseCase>(
        () => GetUserReviewUseCase(repository: sl<ReviewsRepositoryInterface>()),
  );

  sl.registerLazySingleton<SubmitReviewUseCase>(
        () => SubmitReviewUseCase(repository: sl<ReviewsRepositoryInterface>()),
  );

  sl.registerLazySingleton<WatchCafeReviewsUseCase>(
        () => WatchCafeReviewsUseCase(repository: sl<ReviewsRepositoryInterface>()),
  );

  sl.registerFactory<ReviewsCubit>(
        () => ReviewsCubit(
      getCafeReviewsUseCase: sl<GetCafeReviewsUseCase>(),
      watchCafeReviewsUseCase: sl<WatchCafeReviewsUseCase>(),
      submitReviewUseCase: sl<SubmitReviewUseCase>(),
      getUserReviewUseCase: sl<GetUserReviewUseCase>(),
    ),
  );

  // ==================================================
  // DISCOVERY
  // ==================================================

  sl.registerLazySingleton<discovery.GooglePlacesDataSource>(
        () => discovery.GooglePlacesDataSource(),
  );

  sl.registerLazySingleton<CafeFirestoreDataSource>(
        () => CafeFirestoreDataSource(),
  );

  sl.registerLazySingleton<CafeRepositoryInterface>(
        () => CafeRepositoryImpl(
      googlePlacesDataSource: sl<discovery.GooglePlacesDataSource>(),
      firebaseDataSource: sl<CafeFirestoreDataSource>(),
    ),
  );

  sl.registerFactory<DiscoveryCubit>(
        () => DiscoveryCubit(
      repository: sl<CafeRepositoryInterface>(),
      locationService: sl<LocationService>(),
    ),
  );

  // ==================================================
  // CAFE
  // ==================================================

  sl.registerLazySingleton<CafeeRepositoryInterface>(
        () => CafeRepositoryFirebase(dataSource: sl<CafeFirestoreDataSource>()),
  );

  sl.registerLazySingleton<GetCafeExperienceUseCase>(
        () => GetCafeExperienceUseCase(repository: sl<CafeeRepositoryInterface>()),
  );

  sl.registerLazySingleton<GetCafeMenuUseCase>(
        () => GetCafeMenuUseCase(repository: sl<CafeeRepositoryInterface>()),
  );

  sl.registerFactory<CafeCubit>(
        () => CafeCubit(
      getCafeExperienceUseCase: sl<GetCafeExperienceUseCase>(),
      getCafeMenuUseCase: sl<GetCafeMenuUseCase>(),
    ),
  );

  // ==================================================
  // BOOKING
  // ==================================================

  sl.registerLazySingleton<BookingRepositoryInterface>(
        () => BookingRepositoryImpl(),
  );

  sl.registerLazySingleton<CreateBookingUseCase>(
        () => CreateBookingUseCase(sl<BookingRepositoryInterface>()),
  );

  sl.registerLazySingleton<GetBookingUseCase>(
        () => GetBookingUseCase(sl<BookingRepositoryInterface>()),
  );

  sl.registerLazySingleton<UpdateBookingStatusUseCase>(
        () => UpdateBookingStatusUseCase(sl<BookingRepositoryInterface>()),
  );

  sl.registerFactory<BookingCubit>(
        () => BookingCubit(
      sl<CreateBookingUseCase>(),
      sl<GetBookingUseCase>(),
      sl<UpdateBookingStatusUseCase>(),
    ),
  );

  // ==================================================
  // FAVORITES
  // ==================================================

  sl.registerLazySingleton<FavoritesRemoteDataSourceInterface>(
        () => FavoritesRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<FavoritesRepositoryInterface>(
        () => FavoritesRepositoryImpl(
      dataSource: sl<FavoritesRemoteDataSourceInterface>(),
    ),
  );

  sl.registerLazySingleton<AddFavoriteUseCase>(
        () => AddFavoriteUseCase(repository: sl<FavoritesRepositoryInterface>()),
  );

  sl.registerLazySingleton<GetFavoritesUseCase>(
        () => GetFavoritesUseCase(repository: sl<FavoritesRepositoryInterface>()),
  );

  sl.registerLazySingleton<IsFavoriteUseCase>(
        () => IsFavoriteUseCase(repository: sl<FavoritesRepositoryInterface>()),
  );

  sl.registerLazySingleton<RemoveFavoriteUseCase>(
        () => RemoveFavoriteUseCase(repository: sl<FavoritesRepositoryInterface>()),
  );

  sl.registerLazySingleton<ToggleFavoriteUseCase>(
        () => ToggleFavoriteUseCase(repository: sl<FavoritesRepositoryInterface>()),
  );

  sl.registerLazySingleton<WatchFavoritesUseCase>(
        () => WatchFavoritesUseCase(repository: sl<FavoritesRepositoryInterface>()),
  );

  sl.registerFactory<FavoritesCubit>(
        () => FavoritesCubit(
      watchFavoritesUseCase: sl<WatchFavoritesUseCase>(),
      toggleFavoriteUseCase: sl<ToggleFavoriteUseCase>(),
      removeFavoriteUseCase: sl<RemoveFavoriteUseCase>(),
      getFavoritesUseCase: sl<GetFavoritesUseCase>(),
    ),
  );

  // ==================================================
  // NOTIFICATIONS DATA
  // ==================================================

  sl.registerLazySingleton<NotificationRemoteDataSource>(
        () => NotificationRemoteDataSourceImpl(firestore: sl<FirebaseFirestore>()),
  );

  sl.registerLazySingleton<NotificationRepoInterface>(
        () => NotificationRepoImp(
      remoteDataSource: sl<NotificationRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<CreateNotificationUseCase>(
        () => CreateNotificationUseCase(sl<NotificationRepoInterface>()),
  );

  sl.registerLazySingleton<GetNotificationsUseCase>(
        () => GetNotificationsUseCase(sl<NotificationRepoInterface>()),
  );

  sl.registerLazySingleton<MarkNotificationReadUseCase>(
        () => MarkNotificationReadUseCase(sl<NotificationRepoInterface>()),
  );

  sl.registerLazySingleton<MarkAllNotificationsAsReadUseCase>(
        () => MarkAllNotificationsAsReadUseCase(sl<NotificationRepoInterface>()),
  );

  sl.registerLazySingleton<DeleteNotificationUseCase>(
        () => DeleteNotificationUseCase(sl<NotificationRepoInterface>()),
  );

  // ==================================================
  // PROFILE
  // ==================================================

  sl.registerLazySingleton<ProfileRemoteDataSource>(
        () => ProfileRemoteDataSourceImpl(firestore: sl<FirebaseFirestore>()),
  );

  sl.registerLazySingleton<ProfileRepoInterface>(
        () => ProfileRepoImp(remoteDataSource: sl<ProfileRemoteDataSource>()),
  );

  sl.registerLazySingleton<GetProfileUseCase>(
        () => GetProfileUseCase(sl<ProfileRepoInterface>()),
  );

  sl.registerLazySingleton<UpdateProfileUseCase>(
        () => UpdateProfileUseCase(sl<ProfileRepoInterface>()),
  );

  sl.registerFactory<ProfileCubit>(
        () => ProfileCubit(
      getUserProfileUseCase: sl<GetProfileUseCase>(),
      updateProfileUseCase: sl<UpdateProfileUseCase>(),
      authRepository: sl<AuthRepoInterface>(),
      createNotificationUseCase: sl<CreateNotificationUseCase>(),
    ),
  );

  // ==================================================
  // NOTIFICATION CUBIT
  // ==================================================

  sl.registerFactory<NotificationCubit>(
        () => NotificationCubit(
      getNotificationsUseCase: sl<GetNotificationsUseCase>(),
      markNotificationReadUseCase: sl<MarkNotificationReadUseCase>(),
      markAllNotificationsAsReadUseCase:
      sl<MarkAllNotificationsAsReadUseCase>(),
      deleteNotificationUseCase: sl<DeleteNotificationUseCase>(),
      notificationRepository: sl<NotificationRepoInterface>(),
    ),
  );
}