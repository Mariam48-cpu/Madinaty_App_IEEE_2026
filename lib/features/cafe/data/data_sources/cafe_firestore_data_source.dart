import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/menu_category_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/product_entity.dart';

@injectable
class CafeFirestoreDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CafeFirestoreDataSource();

  Future<List<String>> getRandomCafePhotos() async {
    final cafesSnapshot = await firestore.collection('cafes').get();
    if (cafesSnapshot.docs.isEmpty) {
      return [];
    }

    final List<String> allPhotos = [];

    for (final cafeDoc in cafesSnapshot.docs) {
      final data = cafeDoc.data();

      final photos = data['photos'];

      if (photos is List) {
        for (final photo in photos) {
          if (photo is String && photo.trim().isNotEmpty) {
            allPhotos.add(photo);
          }
        }
      }
    }

    if (allPhotos.isEmpty) {
      return [];
    }

    allPhotos.shuffle(Random());

    return allPhotos;
  }

  Future<List<MenuCategoryEntity>> getCafeMenu(String cafeId) async {
    final categoriesSnapshot = await firestore
        .collection('cafes')
        .doc(cafeId)
        .collection('menuCategories')
        .get();

    final List<MenuCategoryEntity> categories = [];

    for (final categoryDoc in categoriesSnapshot.docs) {
      final productsSnapshot = await categoryDoc.reference
          .collection('products')
          .get();

      final products = productsSnapshot.docs.map((productDoc) {
        final data = productDoc.data();

        return ProductEntity(
          id: productDoc.id,
          cafeId: cafeId,
          categoryId: categoryDoc.id,
          name: data['name'] ?? '',
          description: data['description'] ?? '',
          price: (data['price'] ?? 0).toDouble(),
          image: data['image'] ?? '',
          options: List<String>.from(data['options'] ?? []),
        );
      }).toList();

      categories.add(
        MenuCategoryEntity(
          id: categoryDoc.id,
          cafeId: cafeId,
          name: categoryDoc.data()['name'] ?? '',
          products: products,
        ),
      );
    }

    return categories;
  }
}
