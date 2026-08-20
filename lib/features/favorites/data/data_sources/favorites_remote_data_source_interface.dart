import '../../domain/entities/favorite_item_entity.dart';
import '../models/favorite_item_model.dart';

abstract class FavoritesRemoteDataSourceInterface {
  Future<void> addFavorite(FavoriteItemModel item);

  Future<void> removeFavorite(String favoriteId);

  Future<void> toggleFavorite(FavoriteItemModel item);

  Future<List<FavoriteItemModel>> getFavorites({FavoriteTargetType? type});

  Stream<List<FavoriteItemModel>> watchFavorites({FavoriteTargetType? type});

  Future<bool> isFavorite({
    required String targetId,
    required FavoriteTargetType type,
  });
}
