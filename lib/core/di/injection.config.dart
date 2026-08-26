// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:madinaty_app_ieee_2026/core/services/location_service.dart'
as _i162;
import 'package:madinaty_app_ieee_2026/features/ai_planner/data/datasources/ai_planner_data_source.dart'
as _i928;
import 'package:madinaty_app_ieee_2026/features/ai_planner/data/datasources/weather_data_source.dart'
as _i482;
import 'package:madinaty_app_ieee_2026/features/ai_planner/data/repositories/ai_planner_repository_impl.dart'
as _i397;
import 'package:madinaty_app_ieee_2026/features/ai_planner/domain/repositories/ai_planner_repository.dart'
as _i663;
import 'package:madinaty_app_ieee_2026/features/ai_planner/domain/use_cases/create_ai_plan.dart'
as _i812;
import 'package:madinaty_app_ieee_2026/features/ai_planner/presentation/view_model/ai_planner_cubit.dart'
as _i237;
import 'package:madinaty_app_ieee_2026/features/booking/data/repositories/booking_repository_impl.dart'
as _i498;
import 'package:madinaty_app_ieee_2026/features/booking/domain/repositories/booking_repository_interface.dart'
as _i1025;
import 'package:madinaty_app_ieee_2026/features/booking/domain/use_cases/create_booking_usecase.dart'
as _i102;
import 'package:madinaty_app_ieee_2026/features/booking/domain/use_cases/get_booking_usecase.dart'
as _i749;
import 'package:madinaty_app_ieee_2026/features/booking/domain/use_cases/update_booking_status_usecase.dart'
as _i266;
import 'package:madinaty_app_ieee_2026/features/booking/presentation/view_model/cubit/booking_cubit.dart'
as _i437;
import 'package:madinaty_app_ieee_2026/features/cafe/data/data_sources/cafe_firestore_data_source.dart'
as _i793;
import 'package:madinaty_app_ieee_2026/features/cafe/data/repositories/cafe_repository_firebase.dart'
as _i920;
import 'package:madinaty_app_ieee_2026/features/cafe/domain/repositories/cafe_repository_interface.dart'
as _i297;
import 'package:madinaty_app_ieee_2026/features/cafe/domain/use_cases/get_cafe_experience_use_case.dart'
as _i473;
import 'package:madinaty_app_ieee_2026/features/cafe/domain/use_cases/get_cafe_menu_use_case.dart'
as _i297;
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view_model/cubit/cafe_cubit.dart'
as _i1062;
import 'package:madinaty_app_ieee_2026/features/cart/data/data_sources/cart_remote_data_source_impl.dart'
as _i40;
import 'package:madinaty_app_ieee_2026/features/cart/data/data_sources/cart_remote_data_source_interface.dart'
as _i451;
import 'package:madinaty_app_ieee_2026/features/cart/data/repositories/cart_repository_impl.dart'
as _i633;
import 'package:madinaty_app_ieee_2026/features/cart/domain/repositories/cart_repository_interface.dart'
as _i473;
import 'package:madinaty_app_ieee_2026/features/cart/domain/use_cases/add_to_cart_use_case.dart'
as _i393;
import 'package:madinaty_app_ieee_2026/features/cart/domain/use_cases/clear_cart_use_case.dart'
as _i708;
import 'package:madinaty_app_ieee_2026/features/cart/domain/use_cases/get_cart_use_case.dart'
as _i87;
import 'package:madinaty_app_ieee_2026/features/cart/domain/use_cases/remove_from_cart_use_case.dart'
as _i861;
import 'package:madinaty_app_ieee_2026/features/cart/domain/use_cases/update_cart_quantity_use_case.dart'
as _i930;
import 'package:madinaty_app_ieee_2026/features/cart/domain/use_cases/watch_cart_use_case.dart'
as _i733;
import 'package:madinaty_app_ieee_2026/features/cart/presentation/view_model/cubit/cart_cubit.dart'
as _i495;
import 'package:madinaty_app_ieee_2026/features/discovery/data/data_sources/google_places_datasource.dart'
as _i1013;
import 'package:madinaty_app_ieee_2026/features/discovery/data/repositories/cafe_repository_impl.dart'
as _i525;
import 'package:madinaty_app_ieee_2026/features/discovery/domain/repositories/cafe_repository_interface.dart'
as _i1020;
import 'package:madinaty_app_ieee_2026/features/discovery/domain/use_cases/get_nearby_cafes.dart'
as _i784;
import 'package:madinaty_app_ieee_2026/features/discovery/domain/use_cases/search_cafes.dart'
as _i616;
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view_model/cubit/discovery_cubit.dart'
as _i708;
import 'package:madinaty_app_ieee_2026/features/favorites/data/data_sources/favorites_remote_data_source_impl.dart'
as _i472;
import 'package:madinaty_app_ieee_2026/features/favorites/data/data_sources/favorites_remote_data_source_interface.dart'
as _i46;
import 'package:madinaty_app_ieee_2026/features/favorites/data/repositories/favorites_repository_impl.dart'
as _i166;
import 'package:madinaty_app_ieee_2026/features/favorites/domain/repositories/favorites_repository_interface.dart'
as _i954;
import 'package:madinaty_app_ieee_2026/features/favorites/domain/use_cases/add_favorite_use_case.dart'
as _i968;
import 'package:madinaty_app_ieee_2026/features/favorites/domain/use_cases/get_favorites_use_case.dart'
as _i453;
import 'package:madinaty_app_ieee_2026/features/favorites/domain/use_cases/is_favorite_use_case.dart'
as _i917;
import 'package:madinaty_app_ieee_2026/features/favorites/domain/use_cases/remove_favorite_use_case.dart'
as _i237;
import 'package:madinaty_app_ieee_2026/features/favorites/domain/use_cases/toggle_favorite_use_case.dart'
as _i289;
import 'package:madinaty_app_ieee_2026/features/favorites/domain/use_cases/watch_favorites_use_case.dart'
as _i860;
import 'package:madinaty_app_ieee_2026/features/favorites/presentation/view_model/cubit/favorites_cubit.dart'
as _i1042;
import 'package:madinaty_app_ieee_2026/features/home/data/data_sources/google_places_datasource.dart'
as _i1065;
import 'package:madinaty_app_ieee_2026/features/home/data/repositories/recommendation_repository_impl.dart'
as _i632;
import 'package:madinaty_app_ieee_2026/features/home/domain/repositories/recommendation_repository.dart'
as _i131;
import 'package:madinaty_app_ieee_2026/features/home/domain/use_cases/get_recommendations_use_case.dart'
as _i839;
import 'package:madinaty_app_ieee_2026/features/home/domain/use_cases/search_cafes_use_case.dart'
as _i965;
import 'package:madinaty_app_ieee_2026/features/home/presentation/view_model/home_cubit.dart'
as _i991;
import 'package:madinaty_app_ieee_2026/features/notifications/domain/use_cases/create_notification_use_case.dart'
as _i999;
import 'package:madinaty_app_ieee_2026/features/personalization/data/data_sources/personalization_remote_data_source_imp.dart'
as _i1009;
import 'package:madinaty_app_ieee_2026/features/personalization/data/data_sources/personalization_remote_data_source_interface.dart'
as _i587;
import 'package:madinaty_app_ieee_2026/features/personalization/data/repositories/personalization_repo_imp.dart'
as _i210;
import 'package:madinaty_app_ieee_2026/features/personalization/domain/repositories/personalization_repository_interface.dart'
as _i557;
import 'package:madinaty_app_ieee_2026/features/personalization/domain/use_cases/get_user_preferences_usecase.dart'
as _i957;
import 'package:madinaty_app_ieee_2026/features/pre_order/data/data_sources/pre_order_remote_data_source_impl.dart'
as _i261;
import 'package:madinaty_app_ieee_2026/features/pre_order/data/data_sources/pre_order_remote_data_source_interface.dart'
as _i484;
import 'package:madinaty_app_ieee_2026/features/pre_order/data/repositories/pre_order_repository_impl.dart'
as _i447;
import 'package:madinaty_app_ieee_2026/features/pre_order/domain/repositories/pre_order_repository_interface.dart'
as _i810;
import 'package:madinaty_app_ieee_2026/features/pre_order/domain/use_cases/cancel_pre_order_use_case.dart'
as _i351;
import 'package:madinaty_app_ieee_2026/features/pre_order/domain/use_cases/create_pre_order_use_case.dart'
as _i340;
import 'package:madinaty_app_ieee_2026/features/pre_order/domain/use_cases/get_pre_order_use_case.dart'
as _i142;
import 'package:madinaty_app_ieee_2026/features/pre_order/domain/use_cases/get_user_pre_orders_use_case.dart'
as _i237;
import 'package:madinaty_app_ieee_2026/features/pre_order/domain/use_cases/update_pre_order_status_use_case.dart'
as _i925;
import 'package:madinaty_app_ieee_2026/features/pre_order/domain/use_cases/watch_user_pre_orders_use_case.dart'
as _i16;
import 'package:madinaty_app_ieee_2026/features/pre_order/presentation/view_model/cubit/pre_order_cubit.dart'
as _i768;
import 'package:madinaty_app_ieee_2026/features/reviews/data/data_sources/reviews_remote_data_source_impl.dart'
as _i451;
import 'package:madinaty_app_ieee_2026/features/reviews/data/data_sources/reviews_remote_data_source_interface.dart'
as _i762;
import 'package:madinaty_app_ieee_2026/features/reviews/data/repositories/reviews_repository_impl.dart'
as _i73;
import 'package:madinaty_app_ieee_2026/features/reviews/domain/repositories/reviews_repository_interface.dart'
as _i361;
import 'package:madinaty_app_ieee_2026/features/reviews/domain/use_cases/get_cafe_reviews_use_case.dart'
as _i914;
import 'package:madinaty_app_ieee_2026/features/reviews/domain/use_cases/get_user_review_use_case.dart'
as _i866;
import 'package:madinaty_app_ieee_2026/features/reviews/domain/use_cases/submit_review_use_case.dart'
as _i868;
import 'package:madinaty_app_ieee_2026/features/reviews/domain/use_cases/watch_cafe_reviews_use_case.dart'
as _i302;
import 'package:madinaty_app_ieee_2026/features/reviews/presentation/view_model/cubit/reviews_cubit.dart'
as _i79;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i162.LocationService>(() => _i162.LocationService());
    gh.factory<_i793.CafeFirestoreDataSource>(
          () => _i793.CafeFirestoreDataSource(),
    );
    gh.factory<_i1013.GooglePlacesDataSource>(
          () => _i1013.GooglePlacesDataSource(),
    );
    gh.factory<_i1065.GooglePlacesDataSource>(
          () => _i1065.GooglePlacesDataSource(),
    );
    gh.lazySingleton<_i587.PersonalizationRemoteDataSourceInterface>(
          () => _i1009.PersonalizationRemoteDataSourceImpl(
        firebaseAuth: gh<_i59.FirebaseAuth>(),
        firestore: gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i482.WeatherDataSource>(
          () => _i482.WeatherDataSourceImpl(),
    );
    gh.lazySingleton<_i557.PersonalizationRepositoryInterface>(
          () => _i210.PersonalizationRepoImpl(
        remoteDataSource: gh<_i587.PersonalizationRemoteDataSourceInterface>(),
      ),
    );
    gh.factory<_i46.FavoritesRemoteDataSourceInterface>(
          () => _i472.FavoritesRemoteDataSourceImpl(),
    );
    gh.factory<_i484.PreOrderRemoteDataSourceInterface>(
          () => _i261.PreOrderRemoteDataSourceImpl(),
    );
    gh.factory<_i297.CafeeRepositoryInterface>(
          () => _i920.CafeRepositoryFirebase(
        dataSource: gh<_i793.CafeFirestoreDataSource>(),
      ),
    );
    gh.lazySingleton<_i928.AIPlannerDataSource>(
          () => _i928.AIPlannerDataSourceImpl(),
    );
    gh.factory<_i451.CartRemoteDataSourceInterface>(
          () => _i40.CartRemoteDataSourceImpl(),
    );
    gh.factory<_i762.ReviewsRemoteDataSourceInterface>(
          () => _i451.ReviewsRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i1025.BookingRepositoryInterface>(
          () =>
          _i498.BookingRepositoryImpl(firestore: gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i1020.CafeRepositoryInterface>(
          () => _i525.CafeRepositoryImpl(
        googlePlacesDataSource: gh<_i1013.GooglePlacesDataSource>(),
        firebaseDataSource: gh<_i793.CafeFirestoreDataSource>(),
      ),
    );
    gh.factory<_i361.ReviewsRepositoryInterface>(
          () => _i73.ReviewsRepositoryImpl(
        dataSource: gh<_i762.ReviewsRemoteDataSourceInterface>(),
      ),
    );
    gh.lazySingleton<_i131.RecommendationRepository>(
          () => _i632.RecommendationRepositoryImpl(
        gh<_i1065.GooglePlacesDataSource>(),
        gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.factory<_i810.PreOrderRepositoryInterface>(
          () => _i447.PreOrderRepositoryImpl(
        dataSource: gh<_i484.PreOrderRemoteDataSourceInterface>(),
      ),
    );
    gh.factory<_i954.FavoritesRepositoryInterface>(
          () => _i166.FavoritesRepositoryImpl(
        dataSource: gh<_i46.FavoritesRemoteDataSourceInterface>(),
      ),
    );
    gh.factory<_i473.GetCafeExperienceUseCase>(
          () => _i473.GetCafeExperienceUseCase(
        repository: gh<_i297.CafeeRepositoryInterface>(),
      ),
    );
    gh.factory<_i297.GetCafeMenuUseCase>(
          () => _i297.GetCafeMenuUseCase(
        repository: gh<_i297.CafeeRepositoryInterface>(),
      ),
    );
    gh.factory<_i473.CartRepositoryInterface>(
          () => _i633.CartRepositoryImpl(
        dataSource: gh<_i451.CartRemoteDataSourceInterface>(),
      ),
    );
    gh.factory<_i784.GetNearbyCafes>(
          () => _i784.GetNearbyCafes(gh<_i1020.CafeRepositoryInterface>()),
    );
    gh.factory<_i616.SearchCafes>(
          () => _i616.SearchCafes(gh<_i1020.CafeRepositoryInterface>()),
    );
    gh.factory<_i102.CreateBookingUseCase>(
          () => _i102.CreateBookingUseCase(gh<_i1025.BookingRepositoryInterface>()),
    );
    gh.factory<_i749.GetBookingUseCase>(
          () => _i749.GetBookingUseCase(gh<_i1025.BookingRepositoryInterface>()),
    );
    gh.factory<_i266.UpdateBookingStatusUseCase>(
          () => _i266.UpdateBookingStatusUseCase(
        gh<_i1025.BookingRepositoryInterface>(),
      ),
    );
    gh.factory<_i839.GetRecommendationsUseCase>(
          () =>
          _i839.GetRecommendationsUseCase(gh<_i131.RecommendationRepository>()),
    );
    gh.factory<_i965.SearchCafesUseCase>(
          () => _i965.SearchCafesUseCase(gh<_i131.RecommendationRepository>()),
    );
    gh.factory<_i708.DiscoveryCubit>(
          () => _i708.DiscoveryCubit(
        repository: gh<_i1020.CafeRepositoryInterface>(),
        locationService: gh<_i162.LocationService>(),
      ),
    );
    gh.factory<_i968.AddFavoriteUseCase>(
          () => _i968.AddFavoriteUseCase(
        repository: gh<_i954.FavoritesRepositoryInterface>(),
      ),
    );
    gh.factory<_i453.GetFavoritesUseCase>(
          () => _i453.GetFavoritesUseCase(
        repository: gh<_i954.FavoritesRepositoryInterface>(),
      ),
    );
    gh.factory<_i917.IsFavoriteUseCase>(
          () => _i917.IsFavoriteUseCase(
        repository: gh<_i954.FavoritesRepositoryInterface>(),
      ),
    );
    gh.factory<_i237.RemoveFavoriteUseCase>(
          () => _i237.RemoveFavoriteUseCase(
        repository: gh<_i954.FavoritesRepositoryInterface>(),
      ),
    );
    gh.factory<_i289.ToggleFavoriteUseCase>(
          () => _i289.ToggleFavoriteUseCase(
        repository: gh<_i954.FavoritesRepositoryInterface>(),
      ),
    );
    gh.factory<_i860.WatchFavoritesUseCase>(
          () => _i860.WatchFavoritesUseCase(
        repository: gh<_i954.FavoritesRepositoryInterface>(),
      ),
    );
    gh.factory<_i1062.CafeCubit>(
          () => _i1062.CafeCubit(
        getCafeExperienceUseCase: gh<_i473.GetCafeExperienceUseCase>(),
        getCafeMenuUseCase: gh<_i297.GetCafeMenuUseCase>(),
      ),
    );
    gh.factory<_i914.GetCafeReviewsUseCase>(
          () => _i914.GetCafeReviewsUseCase(
        repository: gh<_i361.ReviewsRepositoryInterface>(),
      ),
    );
    gh.factory<_i866.GetUserReviewUseCase>(
          () => _i866.GetUserReviewUseCase(
        repository: gh<_i361.ReviewsRepositoryInterface>(),
      ),
    );
    gh.factory<_i868.SubmitReviewUseCase>(
          () => _i868.SubmitReviewUseCase(
        repository: gh<_i361.ReviewsRepositoryInterface>(),
      ),
    );
    gh.factory<_i302.WatchCafeReviewsUseCase>(
          () => _i302.WatchCafeReviewsUseCase(
        repository: gh<_i361.ReviewsRepositoryInterface>(),
      ),
    );
    gh.lazySingleton<_i663.AIPlannerRepository>(
          () => _i397.AIPlannerRepositoryImpl(
        aiDataSource: gh<_i928.AIPlannerDataSource>(),
        weatherDataSource: gh<_i482.WeatherDataSource>(),
        discoveryRepository: gh<_i1020.CafeRepositoryInterface>(),
        cafeRepository: gh<_i297.CafeeRepositoryInterface>(),
        locationService: gh<_i162.LocationService>(),
      ),
    );
    gh.factory<_i733.WatchCartUseCase>(
          () => _i733.WatchCartUseCase(
        gh<_i473.CartRepositoryInterface>(),
        repository: gh<_i473.CartRepositoryInterface>(),
      ),
    );
    gh.factory<_i351.CancelPreOrderUseCase>(
          () => _i351.CancelPreOrderUseCase(
        repository: gh<_i810.PreOrderRepositoryInterface>(),
      ),
    );
    gh.factory<_i340.CreatePreOrderUseCase>(
          () => _i340.CreatePreOrderUseCase(
        repository: gh<_i810.PreOrderRepositoryInterface>(),
      ),
    );
    gh.factory<_i142.GetPreOrderUseCase>(
          () => _i142.GetPreOrderUseCase(
        repository: gh<_i810.PreOrderRepositoryInterface>(),
      ),
    );
    gh.factory<_i237.GetUserPreOrdersUseCase>(
          () => _i237.GetUserPreOrdersUseCase(
        repository: gh<_i810.PreOrderRepositoryInterface>(),
      ),
    );
    gh.factory<_i925.UpdatePreOrderStatusUseCase>(
          () => _i925.UpdatePreOrderStatusUseCase(
        repository: gh<_i810.PreOrderRepositoryInterface>(),
      ),
    );
    gh.factory<_i16.WatchUserPreOrdersUseCase>(
          () => _i16.WatchUserPreOrdersUseCase(
        repository: gh<_i810.PreOrderRepositoryInterface>(),
      ),
    );
    gh.factory<_i1042.FavoritesCubit>(
          () => _i1042.FavoritesCubit(
        watchFavoritesUseCase: gh<_i860.WatchFavoritesUseCase>(),
        toggleFavoriteUseCase: gh<_i289.ToggleFavoriteUseCase>(),
        removeFavoriteUseCase: gh<_i237.RemoveFavoriteUseCase>(),
        getFavoritesUseCase: gh<_i453.GetFavoritesUseCase>(),
      ),
    );
    gh.factory<_i79.ReviewsCubit>(
          () => _i79.ReviewsCubit(
        getCafeReviewsUseCase: gh<_i914.GetCafeReviewsUseCase>(),
        watchCafeReviewsUseCase: gh<_i302.WatchCafeReviewsUseCase>(),
        submitReviewUseCase: gh<_i868.SubmitReviewUseCase>(),
        getUserReviewUseCase: gh<_i866.GetUserReviewUseCase>(),
      ),
    );
    gh.factory<_i393.AddToCartUseCase>(
          () => _i393.AddToCartUseCase(
        repository: gh<_i473.CartRepositoryInterface>(),
      ),
    );
    gh.factory<_i708.ClearCartUseCase>(
          () => _i708.ClearCartUseCase(
        repository: gh<_i473.CartRepositoryInterface>(),
      ),
    );
    gh.factory<_i87.GetCartUseCase>(
          () =>
          _i87.GetCartUseCase(repository: gh<_i473.CartRepositoryInterface>()),
    );
    gh.factory<_i861.RemoveFromCartUseCase>(
          () => _i861.RemoveFromCartUseCase(
        repository: gh<_i473.CartRepositoryInterface>(),
      ),
    );
    gh.factory<_i930.UpdateCartQuantityUseCase>(
          () => _i930.UpdateCartQuantityUseCase(
        repository: gh<_i473.CartRepositoryInterface>(),
      ),
    );
    gh.factory<_i768.PreOrderCubit>(
          () => _i768.PreOrderCubit(
        getCafeMenuUseCase: gh<_i297.GetCafeMenuUseCase>(),
        createPreOrderUseCase: gh<_i340.CreatePreOrderUseCase>(),
      ),
    );
    gh.factory<_i437.BookingCubit>(
          () => _i437.BookingCubit(
        gh<_i102.CreateBookingUseCase>(),
        gh<_i749.GetBookingUseCase>(),
        gh<_i266.UpdateBookingStatusUseCase>(),
        gh<_i999.CreateNotificationUseCase>(),
      ),
    );
    gh.factoryParam<_i991.HomeCubit, String, dynamic>(
          (currentUserId, _) => _i991.HomeCubit(
        getRecommendationsUseCase: gh<_i839.GetRecommendationsUseCase>(),
        getUserPreferencesUseCase: gh<_i957.GetUserPreferencesUseCase>(),
        searchCafesUseCase: gh<_i965.SearchCafesUseCase>(),
        currentUserId: currentUserId,
      ),
    );
    gh.factory<_i495.CartCubit>(
          () => _i495.CartCubit(
        watchCartUseCase: gh<_i733.WatchCartUseCase>(),
        addToCartUseCase: gh<_i393.AddToCartUseCase>(),
        updateCartQuantityUseCase: gh<_i930.UpdateCartQuantityUseCase>(),
        removeCartUseCase: gh<_i861.RemoveFromCartUseCase>(),
        clearCartUseCase: gh<_i708.ClearCartUseCase>(),
        getCartUseCase: gh<_i87.GetCartUseCase>(),
      ),
    );
    gh.factory<_i812.CreateAIPlan>(
          () => _i812.CreateAIPlan(gh<_i663.AIPlannerRepository>()),
    );
    gh.factory<_i237.AIPlannerCubit>(
          () => _i237.AIPlannerCubit(gh<_i812.CreateAIPlan>()),
    );
    return this;
  }
}
