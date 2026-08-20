import '../entities/favorite_item_entity.dart';

abstract class FavoritesRepositoryInterface {
  Future<void> addFavorite(FavoriteItemEntity item);

  Future<void> removeFavorite(String favoriteId);

  Future<void> toggleFavorite(FavoriteItemEntity item);

  Future<List<FavoriteItemEntity>> getFavorites({FavoriteTargetType? type});

  Stream<List<FavoriteItemEntity>> watchFavorites({FavoriteTargetType? type});

  Future<bool> isFavorite({
    required String targetId,
    required FavoriteTargetType type,
  });
}
