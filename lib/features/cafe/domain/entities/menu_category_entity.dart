import 'product_entity.dart';

class MenuCategoryEntity {
  final String id;
  final String cafeId;
  final String name;
  final List<ProductEntity> products;

  const MenuCategoryEntity({
    required this.id,
    required this.cafeId,
    required this.name,
    this.products = const [],
  });
}