// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:madinaty_app_ieee_2026/core/services/location_service.dart'
    as _i162;
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
    gh.factory<_i46.FavoritesRemoteDataSourceInterface>(
      () => _i472.FavoritesRemoteDataSourceImpl(),
    );
    gh.factory<_i297.CafeeRepositoryInterface>(
      () => _i920.CafeRepositoryFirebase(
        dataSource: gh<_i793.CafeFirestoreDataSource>(),
      ),
    );
    gh.factory<_i762.ReviewsRemoteDataSourceInterface>(
      () => _i451.ReviewsRemoteDataSourceImpl(),
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
    gh.factory<_i784.GetNearbyCafes>(
      () => _i784.GetNearbyCafes(gh<_i1020.CafeRepositoryInterface>()),
    );
    gh.factory<_i616.SearchCafes>(
      () => _i616.SearchCafes(gh<_i1020.CafeRepositoryInterface>()),
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
    return this;
  }
}
