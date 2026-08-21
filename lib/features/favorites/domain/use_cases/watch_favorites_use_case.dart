import 'package:injectable/injectable.dart';
import '../entities/favorite_item_entity.dart';
import '../repositories/favorites_repository_interface.dart';

@injectable
class WatchFavoritesUseCase {
  final FavoritesRepositoryInterface repository;

  const WatchFavoritesUseCase({required this.repository});

  Stream<List<FavoriteItemEntity>> call({FavoriteTargetType? type}) {
    return repository.watchFavorites(type: type);
  }
}
