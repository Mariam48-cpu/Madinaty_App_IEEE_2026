import 'package:injectable/injectable.dart';
import '../entities/favorite_item_entity.dart';
import '../repositories/favorites_repository_interface.dart';

@injectable
class ToggleFavoriteUseCase {
  final FavoritesRepositoryInterface repository;

  const ToggleFavoriteUseCase({required this.repository});

  Future<void> call(FavoriteItemEntity item) {
    return repository.toggleFavorite(item);
  }
}
