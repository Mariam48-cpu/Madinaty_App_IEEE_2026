import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/cafe_experience_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/menu_category_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/product_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/repositories/cafe_repository_interface.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';

@Injectable(as: CafeeRepositoryInterface)
class CafeRepositoryFirebase implements CafeeRepositoryInterface {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  CafeRepositoryFirebase();

  @override
  Future<CafeExperienceEntity> getCafeExperience(CafeEntity googleCafe) async {
    final cafesSnapshot = await firestore.collection('cafes').get();

    if (cafesSnapshot.docs.isEmpty) {
      throw Exception('لا توجد بيانات كافيهات في Firebase');
    }

    final random = Random();

    final randomIndex = random.nextInt(cafesSnapshot.docs.length);

    final firebaseCafe = cafesSnapshot.docs[randomIndex];

    final firebaseData = firebaseCafe.data();

    final firebasePhotos = List<String>.from(firebaseData['photos'] ?? []);

    final firebaseDescription = firebaseData['description'] ?? '';

    final firebaseOpeningHours = firebaseData['openingHours'] ?? '';

    final firebaseAttributes = List<String>.from(
      firebaseData['attributes'] ?? [],
    );

    final firebaseReviewsCount = (firebaseData['reviewsCount'] ?? 0).toInt();
    final mergedCafe = CafeEntity(
      id: googleCafe.id,
      name: googleCafe.name,
      location: googleCafe.location,
      rating: googleCafe.rating,
      address: googleCafe.address,
      isOpen: googleCafe.isOpen,
      photos: googleCafe.photos.isNotEmpty ? googleCafe.photos : firebasePhotos,
      description: firebaseDescription,
      reviewsCount: firebaseReviewsCount,
      openingHours: firebaseOpeningHours,
      attributes: firebaseAttributes,
    );

    final menu = await getMenuFromCafe(firebaseCafe);

    return CafeExperienceEntity(cafe: mergedCafe, menu: menu);
  }

  @override
  Future<List<MenuCategoryEntity>> getCafeMenu(String firebaseCafeId) async {
    final cafeReference = firestore.collection('cafes').doc(firebaseCafeId);

    final cafeDoc = await cafeReference.get();

    if (!cafeDoc.exists) {
      throw Exception('الكافيه غير موجود في Firebase');
    }

    return getMenuFromCafe(cafeDoc);
  }

  Future<List<MenuCategoryEntity>> getMenuFromCafe(
    DocumentSnapshot<Map<String, dynamic>> cafeDoc,
  ) async {
    final categoriesSnapshot = await cafeDoc.reference
        .collection('menuCategories')
        .get();

    final List<MenuCategoryEntity> categories = [];

    for (final categoryDoc in categoriesSnapshot.docs) {
      final categoryData = categoryDoc.data();

      final productsSnapshot = await categoryDoc.reference
          .collection('products')
          .get();

      final products = productsSnapshot.docs.map((productDoc) {
        final data = productDoc.data();

        return ProductEntity(
          id: productDoc.id,
          cafeId: cafeDoc.id,
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
          cafeId: cafeDoc.id,
          name: categoryData['name'] ?? '',
          products: products,
        ),
      );
    }

    return categories;
  }
}
