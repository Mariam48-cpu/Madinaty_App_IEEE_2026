import 'package:injectable/injectable.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/menu_category_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/repositories/cafe_repository_interface.dart';

@injectable
class GetCafeMenuUseCase {
  final CafeeRepositoryInterface repository;

  GetCafeMenuUseCase({
    required this.repository,
  });

  Future<List<MenuCategoryEntity>> call(String cafeId) {
    return repository.getCafeMenu(cafeId);
  }
}