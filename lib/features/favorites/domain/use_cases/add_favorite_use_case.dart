import 'package:injectable/injectable.dart';
import '../entities/favorite_item_entity.dart';
import '../repositories/favorites_repository_interface.dart';

@injectable
class AddFavoriteUseCase {
  final FavoritesRepositoryInterface repository;

  const AddFavoriteUseCase({required this.repository});

  Future<void> call(FavoriteItemEntity item) {
    return repository.addFavorite(item);
  }
}
