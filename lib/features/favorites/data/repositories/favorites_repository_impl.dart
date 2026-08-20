import 'package:injectable/injectable.dart';
import '../../domain/entities/favorite_item_entity.dart';
import '../../domain/repositories/favorites_repository_interface.dart';
import '../data_sources/favorites_remote_data_source_interface.dart';
import '../models/favorite_item_model.dart';

@Injectable(as: FavoritesRepositoryInterface)
class FavoritesRepositoryImpl implements FavoritesRepositoryInterface {
  final FavoritesRemoteDataSourceInterface dataSource;

  FavoritesRepositoryImpl({required this.dataSource});

  @override
  Future<void> addFavorite(FavoriteItemEntity item) {
    final model = FavoriteItemModel.fromEntity(item);
    return dataSource.addFavorite(model);
  }

  @override
  Future<void> removeFavorite(String favoriteId) {
    return dataSource.removeFavorite(favoriteId);
  }

  @override
  Future<void> toggleFavorite(FavoriteItemEntity item) {
    final model = FavoriteItemModel.fromEntity(item);
    return dataSource.toggleFavorite(model);
  }

  @override
  Future<List<FavoriteItemEntity>> getFavorites({
    FavoriteTargetType? type,
  }) async {
    final models = await dataSource.getFavorites(type: type);
    return models;
  }

  @override
  Stream<List<FavoriteItemEntity>> watchFavorites({
    FavoriteTargetType? type,
  }) {
    return dataSource.watchFavorites(type: type);
  }

  @override
  Future<bool> isFavorite({
    required String targetId,
    required FavoriteTargetType type,
  }) {
    return dataSource.isFavorite(targetId: targetId, type: type);
  }
}
