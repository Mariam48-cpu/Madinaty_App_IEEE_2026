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

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i162.LocationService>(() => _i162.LocationService());
    gh.lazySingleton<_i1013.GooglePlacesDataSource>(
      () => _i1013.GooglePlacesDataSource(),
    );
    gh.factory<_i1020.CafeRepositoryInterface>(
      () => _i525.CafeRepositoryImpl(gh<_i1013.GooglePlacesDataSource>()),
    );
    gh.factory<_i708.DiscoveryCubit>(
      () => _i708.DiscoveryCubit(
        repository: gh<_i1020.CafeRepositoryInterface>(),
        locationService: gh<_i162.LocationService>(),
      ),
    );
    gh.factory<_i784.GetNearbyCafes>(
      () => _i784.GetNearbyCafes(gh<_i1020.CafeRepositoryInterface>()),
    );
    gh.factory<_i616.SearchCafes>(
      () => _i616.SearchCafes(gh<_i1020.CafeRepositoryInterface>()),
    );
    return this;
  }
}
