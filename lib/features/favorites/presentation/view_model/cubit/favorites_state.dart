import '../../../domain/entities/favorite_item_entity.dart';

abstract class FavoritesState {
  const FavoritesState();
}

class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

class FavoritesLoaded extends FavoritesState {
  final List<FavoriteItemEntity> allFavorites;
  final FavoriteTargetType selectedTab;
  final Set<String> favoriteIds;

  const FavoritesLoaded({
    required this.allFavorites,
    this.selectedTab = FavoriteTargetType.cafe,
    this.favoriteIds = const {},
  });

  List<FavoriteItemEntity> get cafes =>
      allFavorites.where((item) => item.isCafe).toList();

  List<FavoriteItemEntity> get products =>
      allFavorites.where((item) => item.isProduct).toList();

  List<FavoriteItemEntity> get currentTabItems =>
      selectedTab == FavoriteTargetType.cafe ? cafes : products;

  bool isFavorite(FavoriteTargetType type, String targetId) =>
      favoriteIds.contains(FavoriteItemEntity.generateId(type, targetId));

  FavoritesLoaded copyWith({
    List<FavoriteItemEntity>? allFavorites,
    FavoriteTargetType? selectedTab,
    Set<String>? favoriteIds,
  }) {
    return FavoritesLoaded(
      allFavorites: allFavorites ?? this.allFavorites,
      selectedTab: selectedTab ?? this.selectedTab,
      favoriteIds: favoriteIds ?? this.favoriteIds,
    );
  }
}

class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError({required this.message});
}
