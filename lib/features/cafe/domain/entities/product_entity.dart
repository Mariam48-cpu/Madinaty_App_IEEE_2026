class ProductEntity {
  final String id;
  final String cafeId;
  final String categoryId;
  final String name;
  final String description;
  final double price;
  final String image;
  final List<String> options;

  const ProductEntity({
    required this.id,
    required this.cafeId,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    this.options = const [],
  });
}
