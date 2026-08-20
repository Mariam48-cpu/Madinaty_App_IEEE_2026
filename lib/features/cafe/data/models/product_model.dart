
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/product_entity.dart';

class ProductModel {
  final String id;
  final String cafeId;
  final String categoryId;
  final String name;
  final String description;
  final double price;
  final String image;
  final List<String> options;

  const ProductModel({
    required this.id,
    required this.cafeId,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    this.options = const [],
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      cafeId: json['cafeId'] ?? '',
      categoryId: json['categoryId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      image: json['image'] ?? '',
      options: List<String>.from(json['options'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cafeId': cafeId,
      'categoryId': categoryId,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'options': options,
    };
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      cafeId: cafeId,
      categoryId: categoryId,
      name: name,
      description: description,
      price: price,
      image: image,
      options: options,
    );
  }
}
