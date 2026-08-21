import 'package:injectable/injectable.dart';
import '../repositories/favorites_repository_interface.dart';

@injectable
class RemoveFavoriteUseCase {
  final FavoritesRepositoryInterface repository;

  const RemoveFavoriteUseCase({required this.repository});

  Future<void> call(String favoriteId) {
    return repository.removeFavorite(favoriteId);
  }
}
