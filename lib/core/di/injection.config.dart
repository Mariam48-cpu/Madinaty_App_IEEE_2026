// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:madinaty_app_ieee_2026/core/services/location_service.dart'
    as _i162;
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
import 'package:madinaty_app_ieee_2026/features/discovery/data/data_sources/google_places_datasource.dart'
    as _i1013;
import 'package:madinaty_app_ieee_2026/features/discovery/data/data_sources/initial_location_seeder.dart'
    as _i628;
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

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i162.LocationService>(() => _i162.LocationService());
    gh.factory<_i1013.GooglePlacesDataSource>(
      () => _i1013.GooglePlacesDataSource(),
    );
    gh.lazySingleton<_i1025.BookingRepositoryInterface>(
      () => _i498.BookingRepositoryImpl(),
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
    gh.factory<_i793.CafeFirestoreDataSource>(
      () => _i793.CafeFirestoreDataSource(
        googlePlaces: gh<_i1013.GooglePlacesDataSource>(),
      ),
    );
    gh.factory<_i628.InitialLocationSeeder>(
      () =>
          _i628.InitialLocationSeeder(firestore: gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i1020.CafeRepositoryInterface>(
      () => _i525.CafeRepositoryImpl(
        googlePlacesDataSource: gh<_i1013.GooglePlacesDataSource>(),
        firebaseDataSource: gh<_i793.CafeFirestoreDataSource>(),
      ),
    );
    gh.factory<_i473.GetCafeExperienceUseCase>(
      () => _i473.GetCafeExperienceUseCase(
        repository: gh<_i1020.CafeRepositoryInterface>(),
      ),
    );
    gh.factory<_i297.GetCafeMenuUseCase>(
      () => _i297.GetCafeMenuUseCase(
        repository: gh<_i1020.CafeRepositoryInterface>(),
      ),
    );
    gh.factory<_i437.BookingCubit>(
      () => _i437.BookingCubit(
        gh<_i102.CreateBookingUseCase>(),
        gh<_i749.GetBookingUseCase>(),
        gh<_i266.UpdateBookingStatusUseCase>(),
      ),
    );
    gh.factory<_i784.GetNearbyCafes>(
      () => _i784.GetNearbyCafes(gh<_i1020.CafeRepositoryInterface>()),
    );
    gh.factory<_i616.SearchCafes>(
      () => _i616.SearchCafes(gh<_i1020.CafeRepositoryInterface>()),
    );
    gh.factory<_i297.CafeeRepositoryInterface>(
      () => _i920.CafeRepositoryFirebase(
        dataSource: gh<_i793.CafeFirestoreDataSource>(),
      ),
    );
    gh.factory<_i708.DiscoveryCubit>(
      () => _i708.DiscoveryCubit(
        repository: gh<_i1020.CafeRepositoryInterface>(),
        locationService: gh<_i162.LocationService>(),
      ),
    );
    gh.factory<_i1062.CafeCubit>(
      () => _i1062.CafeCubit(
        getCafeExperienceUseCase: gh<_i473.GetCafeExperienceUseCase>(),
        getCafeMenuUseCase: gh<_i297.GetCafeMenuUseCase>(),
      ),
    );
    return this;
  }
}
