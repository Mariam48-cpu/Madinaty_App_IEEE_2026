import 'package:injectable/injectable.dart';
import '../entities/favorite_item_entity.dart';
import '../repositories/favorites_repository_interface.dart';

@injectable
class IsFavoriteUseCase {
  final FavoritesRepositoryInterface repository;

  const IsFavoriteUseCase({required this.repository});

  Future<bool> call({
    required String targetId,
    required FavoriteTargetType type,
  }) {
    return repository.isFavorite(targetId: targetId, type: type);
  }
}
