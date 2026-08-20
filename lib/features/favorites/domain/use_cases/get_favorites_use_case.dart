import 'package:injectable/injectable.dart';
import '../entities/favorite_item_entity.dart';
import '../repositories/favorites_repository_interface.dart';

@injectable
class GetFavoritesUseCase {
  final FavoritesRepositoryInterface repository;

  const GetFavoritesUseCase({required this.repository});

  Future<List<FavoriteItemEntity>> call({FavoriteTargetType? type}) {
    return repository.getFavorites(type: type);
  }
}
