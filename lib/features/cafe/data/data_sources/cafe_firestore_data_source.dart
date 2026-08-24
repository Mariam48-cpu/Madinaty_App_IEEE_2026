import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/cafe_experience_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/menu_category_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/product_entity.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';

@injectable
class CafeFirestoreDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CafeFirestoreDataSource();

  Future<CafeExperienceEntity> getCafeExperience(CafeEntity googleCafe) async {
    try {
      final cafesSnapshot = await firestore.collection('cafes').get();

      if (cafesSnapshot.docs.isEmpty) {
        return _createDefaultCafeExperience(googleCafe);
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
        rating: googleCafe.rating > 0 ? googleCafe.rating : 4.5,
        address: googleCafe.address,
        isOpen: googleCafe.isOpen,
        photos: googleCafe.photos.isNotEmpty
            ? googleCafe.photos
            : (firebasePhotos.isNotEmpty ? firebasePhotos : _defaultCafePhotos),
        description: firebaseDescription.isNotEmpty
            ? firebaseDescription
            : 'مكان مميز يقدم أجود أنواع القهوة المختصة والمشروبات والحلويات بأجواء مريحة وهادئة.',
        reviewsCount: firebaseReviewsCount > 0
            ? firebaseReviewsCount
            : (googleCafe.reviewsCount > 0 ? googleCafe.reviewsCount : 45),
        openingHours: firebaseOpeningHours.isNotEmpty
            ? firebaseOpeningHours
            : '08:00 ص - 12:00 م',
        attributes: firebaseAttributes.isNotEmpty
            ? firebaseAttributes
            : ['واي فاي مجاني', 'جلسات داخلية وخارجية', 'موسيقى هادئة'],
      );

      final menu = await getMenuFromCafe(firebaseCafe);

      return CafeExperienceEntity(
        cafe: mergedCafe,
        menu: menu.isNotEmpty ? menu : _getDefaultMenu(googleCafe.id),
      );
    } catch (_) {
      return _createDefaultCafeExperience(googleCafe);
    }
  }

  Future<List<MenuCategoryEntity>> getCafeMenu(String firebaseCafeId) async {
    try {
      final cafeReference = firestore.collection('cafes').doc(firebaseCafeId);
      final cafeDoc = await cafeReference.get();

      if (!cafeDoc.exists) {
        return _getDefaultMenu(firebaseCafeId);
      }

      final menu = await getMenuFromCafe(cafeDoc);
      return menu.isNotEmpty ? menu : _getDefaultMenu(firebaseCafeId);
    } catch (_) {
      return _getDefaultMenu(firebaseCafeId);
    }
  }

  Future<List<MenuCategoryEntity>> getMenuFromCafe(
    DocumentSnapshot<Map<String, dynamic>> cafeDoc,
  ) async {
    try {
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
    } catch (_) {
      return _getDefaultMenu(cafeDoc.id);
    }
  }

  Future<List<String>> getRandomCafePhotos() async {
    try {
      final cafesSnapshot = await firestore.collection('cafes').get();

      if (cafesSnapshot.docs.isEmpty) {
        return _defaultCafePhotos;
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
        return _defaultCafePhotos;
      }

      allPhotos.shuffle(Random());
      return allPhotos;
    } catch (_) {
      return _defaultCafePhotos;
    }
  }

  CafeExperienceEntity _createDefaultCafeExperience(CafeEntity googleCafe) {
    final mergedCafe = CafeEntity(
      id: googleCafe.id,
      name: googleCafe.name,
      location: googleCafe.location,
      rating: googleCafe.rating > 0 ? googleCafe.rating : 4.6,
      address: googleCafe.address.isNotEmpty
          ? googleCafe.address
          : 'مدينتي، القاهرة',
      isOpen: googleCafe.isOpen,
      photos: googleCafe.photos.isNotEmpty
          ? googleCafe.photos
          : _defaultCafePhotos,
      description: googleCafe.description.isNotEmpty
          ? googleCafe.description
          : 'كافيه مميز يقدم تشكيلة رائعة من القهوة المختصة والمشروبات والحلويات في أجواء عصرية ومريحة تناسب العمل والاسترخاء.',
      reviewsCount: googleCafe.reviewsCount > 0 ? googleCafe.reviewsCount : 38,
      openingHours: googleCafe.openingHours.isNotEmpty
          ? googleCafe.openingHours
          : '08:00 ص - 12:00 م',
      attributes: googleCafe.attributes.isNotEmpty
          ? googleCafe.attributes
          : ['واي فاي مجاني', 'جلسات داخلية وخارجية', 'قهوة مختصة', 'موسيقى هادئة'],
    );

    return CafeExperienceEntity(
      cafe: mergedCafe,
      menu: _getDefaultMenu(googleCafe.id),
    );
  }

  static const List<String> _defaultCafePhotos = [
    'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=800&auto=format&fit=crop&q=60',
    'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=800&auto=format&fit=crop&q=60',
    'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800&auto=format&fit=crop&q=60',
  ];

  List<MenuCategoryEntity> _getDefaultMenu(String cafeId) {
    return [
      MenuCategoryEntity(
        id: 'cat_hot_coffee',
        cafeId: cafeId,
        name: 'قهوة ساخنة',
        products: [
          ProductEntity(
            id: 'p_spanish_latte',
            cafeId: cafeId,
            categoryId: 'cat_hot_coffee',
            name: 'سبانيش لاتيه',
            description:
                'إسبريسو غني ممزوج بالحليب المكثف المحلى والحليب المبخر الرغوي.',
            price: 65.0,
            image:
                'https://images.unsplash.com/photo-1541167760496-1628856ab772?w=500&auto=format&fit=crop&q=60',
            options: ['كبير', 'وسط', 'صغير', 'حليب بقري', 'حليب لوز', 'حليب شوفان'],
          ),
          ProductEntity(
            id: 'p_flat_white',
            cafeId: cafeId,
            categoryId: 'cat_hot_coffee',
            name: 'فلات وايت',
            description:
                'دبل شوت إسبريسو مع طبقة ناعمة من الحليب المبخر والميكروفوم.',
            price: 55.0,
            image:
                'https://images.unsplash.com/photo-1577968897966-3d4325b36b61?w=500&auto=format&fit=crop&q=60',
            options: ['وسط', 'صغير', 'حليب بقري', 'حليب لوز'],
          ),
          ProductEntity(
            id: 'p_cappuccino',
            cafeId: cafeId,
            categoryId: 'cat_hot_coffee',
            name: 'كابتشينو',
            description:
                'إسبريسو كلاسيكي متوازن مع حليب مبخر ورغوة حليب كثيفة غنية.',
            price: 50.0,
            image:
                'https://images.unsplash.com/photo-1534778101976-62847782c213?w=500&auto=format&fit=crop&q=60',
            options: ['كبير', 'وسط', 'صغير'],
          ),
        ],
      ),
      MenuCategoryEntity(
        id: 'cat_cold_coffee',
        cafeId: cafeId,
        name: 'مشروبات باردة',
        products: [
          ProductEntity(
            id: 'p_iced_latte',
            cafeId: cafeId,
            categoryId: 'cat_cold_coffee',
            name: 'آيس لاتيه',
            description:
                'إسبريسو منعش مسكوب على الحليب البارد مع قطع الثلج.',
            price: 60.0,
            image:
                'https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?w=500&auto=format&fit=crop&q=60',
            options: ['كبير', 'وسط', 'حليب لوز', 'حليب شوفان'],
          ),
          ProductEntity(
            id: 'p_cold_brew',
            cafeId: cafeId,
            categoryId: 'cat_cold_coffee',
            name: 'كولد برو',
            description:
                'قهوة منقوعة ببطء لأكثر من 18 ساعة لنكهة ناعمة وأقل حمضية.',
            price: 70.0,
            image:
                'https://images.unsplash.com/photo-1517701604599-bb29b565090c?w=500&auto=format&fit=crop&q=60',
            options: ['كبير', 'وسط'],
          ),
        ],
      ),
      MenuCategoryEntity(
        id: 'cat_desserts',
        cafeId: cafeId,
        name: 'حلويات ومخبوزات',
        products: [
          ProductEntity(
            id: 'p_san_sebastian',
            cafeId: cafeId,
            categoryId: 'cat_desserts',
            name: 'سان سباستيان تشيز كيك',
            description:
                'تشيز كيك كريمي مخبوز بحواف مكرملة يقدم مع صوص الشوكولاتة الفاخرة.',
            price: 75.0,
            image:
                'https://images.unsplash.com/photo-1533134242443-d4fd215305ad?w=500&auto=format&fit=crop&q=60',
            options: ['شريحة واحدة'],
          ),
          ProductEntity(
            id: 'p_croissant',
            cafeId: cafeId,
            categoryId: 'cat_desserts',
            name: 'كرواسون زبدة فرنسي',
            description:
                'كرواسون طازج وهش بالزبدة الطبيعية الفاخرة ومخبوز يومياً.',
            price: 40.0,
            image:
                'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=500&auto=format&fit=crop&q=60',
            options: ['سادة', 'جبنة', 'شوكولاتة'],
          ),
        ],
      ),
    ];
  }
}
