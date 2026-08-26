import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/entities/favorite_item_entity.dart';
import '../../../domain/use_cases/get_favorites_use_case.dart';
import '../../../domain/use_cases/remove_favorite_use_case.dart';
import '../../../domain/use_cases/toggle_favorite_use_case.dart';
import '../../../domain/use_cases/watch_favorites_use_case.dart';
import 'favorites_state.dart';

@injectable
class FavoritesCubit extends Cubit<FavoritesState> {
  final WatchFavoritesUseCase watchFavoritesUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;
  final RemoveFavoriteUseCase removeFavoriteUseCase;
  final GetFavoritesUseCase getFavoritesUseCase;

  StreamSubscription<List<FavoriteItemEntity>>? _favoritesSubscription;

  FavoritesCubit({
    required this.watchFavoritesUseCase,
    required this.toggleFavoriteUseCase,
    required this.removeFavoriteUseCase,
    required this.getFavoritesUseCase,
  }) : super(const FavoritesInitial());

  void initFavoritesWatcher() {
    emit(const FavoritesLoading());
    _favoritesSubscription?.cancel();
    _favoritesSubscription = watchFavoritesUseCase().listen(
      (favorites) {
        final ids = favorites.map((f) => f.id).toSet();
        if (state is FavoritesLoaded) {
          emit((state as FavoritesLoaded).copyWith(
            allFavorites: favorites,
            favoriteIds: ids,
          ));
        } else {
          emit(FavoritesLoaded(
            allFavorites: favorites,
            favoriteIds: ids,
          ));
        }
      },
      onError: (error, stackTrace) {
        emit(FavoritesError(message: error.toString()));
      },
    );
  }

  void selectTab(FavoriteTargetType tab) {
    if (state is FavoritesLoaded) {
      emit((state as FavoritesLoaded).copyWith(selectedTab: tab));
    }
  }

  Future<void> toggleFavorite(FavoriteItemEntity item) async {
    try {
      await toggleFavoriteUseCase(item);
    } catch (e) {
      emit(FavoritesError(message: e.toString()));
    }
  }

  Future<void> removeFavorite(String favoriteId) async {
    try {
      await removeFavoriteUseCase(favoriteId);
    } catch (e) {
      emit(FavoritesError(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _favoritesSubscription?.cancel();
    return super.close();
  }
}
