import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/menu_category_entity.dart';

import 'product_model.dart';

class MenuCategoryModel {
  final String id;
  final String cafeId;
  final String name;
  final List<ProductModel> products;

  const MenuCategoryModel({
    required this.id,
    required this.cafeId,
    required this.name,
    this.products = const [],
  });

  factory MenuCategoryModel.fromJson(Map<String, dynamic> json) {
    final productsJson = json['products'] as List? ?? [];
    return MenuCategoryModel(
      id: json['id'] ?? '',
      cafeId: json['cafeId'] ?? '',
      name: json['name'] ?? '',
      products: productsJson
          .map(
            (product) => ProductModel.fromJson(product as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cafeId': cafeId,
      'name': name,
      'products': products.map((product) => product.toJson()).toList(),
    };
  }

  MenuCategoryEntity toEntity() {
    return MenuCategoryEntity(
      id: id,
      cafeId: cafeId,
      name: name,
      products: products.map((product) => product.toEntity()).toList(),
    );
  }
}
