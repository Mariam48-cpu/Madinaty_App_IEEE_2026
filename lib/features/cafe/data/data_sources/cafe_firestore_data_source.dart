import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';

import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/cafe_experience_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/menu_category_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/product_entity.dart';

import 'package:madinaty_app_ieee_2026/features/discovery/data/data_sources/google_places_datasource.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/data/models/cafe_dto.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/data/models/initial_location_seed_data.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';

@injectable
class CafeFirestoreDataSource {
  static const int requiredSeedCafeCount = 30;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final GooglePlacesDataSource googlePlaces;

  CafeFirestoreDataSource({required this.googlePlaces});

  CollectionReference<Map<String, dynamic>> locationCafes(String locationId) {
    return firestore
        .collection('locations')
        .doc(locationId)
        .collection('cafes');
  }

  DocumentReference<Map<String, dynamic>> locationDoc(String locationId) {
    return firestore.collection('locations').doc(locationId);
  }

  Future<List<CafeEntity>> getLocationCafes(String locationId) async {
    final snapshot = await locationCafes(locationId).get();

    return snapshot.docs.map(toEntity).toList(growable: false);
  }

  Future<int> getLocationCafeCount(String locationId) async {
    final snapshot = await locationCafes(locationId).count().get();

    return snapshot.count ?? 0;
  }

  Future<String?> findNearestStoredLocationId({
    required double latitude,
    required double longitude,
    double maxDistanceInMeters = 30000,
  }) async {
    final snapshot = await firestore.collection('locations').get();

    String? bestId;
    double bestDistance = double.infinity;

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final lat = (data['latitude'] as num?)?.toDouble();
      final lon = (data['longitude'] as num?)?.toDouble();

      if (lat == null || lon == null) continue;

      final distance = const Distance().as(
        LengthUnit.Meter,
        LatLng(latitude, longitude),
        LatLng(lat, lon),
      );

      if (distance > maxDistanceInMeters || distance >= bestDistance) {
        continue;
      }
      final cafeCount =
          (data['cafeCount'] as num?)?.toInt() ??
          await getLocationCafeCount(doc.id);

      if (cafeCount <= 0) continue;

      bestId = doc.id;
      bestDistance = distance;
    }

    return bestId;
  }

  Future<bool> isLocationSeeded(String locationId) async {
    final count = await getLocationCafeCount(locationId);

    return count >= requiredSeedCafeCount;
  }

  Future<List<CafeEntity>> getOrSeedLocationCafes({
    required String locationId,
    required String locationName,
    required double latitude,
    required double longitude,
    required double radiusInMeters,
  }) async {
    final firebaseCafes = await getLocationCafes(locationId);

    if (firebaseCafes.length >= requiredSeedCafeCount) {
      return firebaseCafes;
    }
    final googleCafes = await googlePlaces.getCafesForLocation(
      latitude: latitude,
      longitude: longitude,
      radiusInMeters: radiusInMeters,
      targetCount: requiredSeedCafeCount,
    );

    if (googleCafes.isEmpty) {
      return firebaseCafes;
    }
    final seedLocations = buildInitialLocationSeedData();

    final seedLocation = seedLocations
        .cast<InitialLocationSeedData?>()
        .firstWhere(
          (location) => location!.id == locationId,
          orElse: () => null,
        );

    final seedCafes = seedLocation?.cafes ?? const <SeedCafeData>[];

    final mergedCafes = <CafeEntity>[];

    for (var i = 0; i < googleCafes.length; i++) {
      final googleCafe = googleCafes[i];

      final seedCafe = seedCafes.isNotEmpty
          ? seedCafes[i % seedCafes.length]
          : null;

      final entity = mergeGoogleWithSeed(
        googleCafe: googleCafe,
        seedCafe: seedCafe,
      );

      mergedCafes.add(entity);
    }

    await saveCafesForLocation(
      locationId: locationId,
      locationName: locationName,
      latitude: latitude,
      longitude: longitude,
      cafes: mergedCafes,
    );

    final updated = await getLocationCafes(locationId);

    if (updated.isNotEmpty) {
      return updated;
    }

    return mergedCafes;
  }

  CafeEntity mergeGoogleWithSeed({
    required CafeDto googleCafe,
    required SeedCafeData? seedCafe,
  }) {
    return CafeEntity(
      id: googleCafe.id,
      name: googleCafe.name,
      location: LatLng(
        googleCafe.location.latitude,
        googleCafe.location.longitude,
      ),
      rating: googleCafe.rating,
      reviewsCount: googleCafe.reviewsCount,
      photos: seedCafe == null ? const [] : [seedCafe.imageUrl],
      address: googleCafe.address,
      isOpen: googleCafe.isOpen,
      description:
          seedCafe?.description ?? 'A cafe discovered through Google Places.',
      openingHours: seedCafe?.openingHours ?? googleCafe.openingHours,
      attributes: seedCafe?.attributes ?? const [],
    );
  }

  Future<void> saveCafesForLocation({
    required String locationId,
    required String locationName,
    required double latitude,
    required double longitude,
    required Iterable<CafeEntity> cafes,
  }) async {
    final list = cafes.toList(growable: false);

    final collection = locationCafes(locationId);

    final batch = firestore.batch();

    for (final cafe in list) {
      final cafeRef = collection.doc(cafe.id);
      batch.set(cafeRef, cafeToMap(cafe), SetOptions(merge: true));
    }
    if (list.isNotEmpty) {
      await batch.commit();
    }

    final seedLocations = buildInitialLocationSeedData();

    final seedLocation = seedLocations
        .cast<InitialLocationSeedData?>()
        .firstWhere(
          (location) => location!.id == locationId,
          orElse: () => null,
        );

    final seedCafes = seedLocation?.cafes ?? const <SeedCafeData>[];

    for (var i = 0; i < list.length; i++) {
      final cafe = list[i];

      if (seedCafes.isEmpty) {
        continue;
      }

      final seedCafe = seedCafes[i % seedCafes.length];

      await saveCafeMenu(
        locationId: locationId,
        cafeId: cafe.id,
        seedCafe: seedCafe,
      );
    }

    final count = await getLocationCafeCount(locationId);

    await locationDoc(locationId).set({
      'name': locationName,
      'latitude': latitude,
      'longitude': longitude,

      'seeded': count >= requiredSeedCafeCount,

      'preSeeded': count >= requiredSeedCafeCount,

      'cafeCount': count,

      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Map<String, dynamic> cafeToMap(CafeEntity cafe) {
    return {
      'googlePlaceId': cafe.id,
      'name': cafe.name,

      'latitude': cafe.location.latitude,

      'longitude': cafe.location.longitude,

      'rating': cafe.rating,

      'reviewsCount': cafe.reviewsCount,

      'address': cafe.address,

      'isOpen': cafe.isOpen,

      'description': cafe.description,

      'openingHours': cafe.openingHours,

      'attributes': cafe.attributes,

      'photos': cafe.photos,

      'imageUrl': cafe.photos.isNotEmpty ? cafe.photos.first : '',

      'source': 'google_places_with_seed_assets',

      'cachedAt': FieldValue.serverTimestamp(),
    };
  }

  CafeEntity toEntity(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;

    final imageUrl = (data['imageUrl'] ?? '').toString();

    final photos = List<String>.from(data['photos'] ?? []);

    final mergedPhotos = photos.isNotEmpty
        ? photos
        : imageUrl.isNotEmpty
        ? <String>[imageUrl]
        : const <String>[];

    return CafeEntity(
      id: (data['googlePlaceId'] ?? doc.id).toString(),

      name: (data['name'] ?? '').toString(),

      location: LatLng(
        (data['latitude'] ?? 0.0).toDouble(),
        (data['longitude'] ?? 0.0).toDouble(),
      ),

      rating: (data['rating'] ?? 0.0).toDouble(),

      reviewsCount: (data['reviewsCount'] ?? 0).toInt(),

      photos: mergedPhotos,

      address: (data['address'] ?? '').toString(),

      isOpen: data['isOpen'] as bool? ?? false,

      description: (data['description'] ?? '').toString(),

      openingHours: (data['openingHours'] ?? '').toString(),

      attributes: List<String>.from(data['attributes'] ?? []),
    );
  }

  Future<List<CafeEntity>> searchLocationCafes({
    required String locationId,
    required String query,
  }) async {
    final snapshot = await locationCafes(locationId).get();

    final q = query.trim().toLowerCase();

    return snapshot.docs
        .map(toEntity)
        .where(
          (cafe) =>
              cafe.name.toLowerCase().contains(q) ||
              cafe.address.toLowerCase().contains(q),
        )
        .toList();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> findCafeDocument(
    String cafeId,
  ) async {
    final locations = await firestore.collection('locations').get();

    for (final location in locations.docs) {
      final doc = await location.reference
          .collection('cafes')
          .doc(cafeId)
          .get();

      if (doc.exists) {
        return doc;
      }
    }

    return null;
  }

  Future<CafeExperienceEntity> getCafeExperience(CafeEntity cafe) async {
    final cafeDoc = await findCafeDocument(cafe.id);

    if (cafeDoc == null) {
      return CafeExperienceEntity(cafe: cafe, menu: const []);
    }

    final storedCafe = toEntity(cafeDoc);

    final menu = await getMenuFromCafe(cafeDoc);

    return CafeExperienceEntity(cafe: storedCafe, menu: menu);
  }

  Future<List<MenuCategoryEntity>> getCafeMenu(String cafeId) async {
    final cafeDoc = await findCafeDocument(cafeId);

    if (cafeDoc == null) {
      return const [];
    }

    return getMenuFromCafe(cafeDoc);
  }

  Future<List<MenuCategoryEntity>> getMenuFromCafe(
    DocumentSnapshot<Map<String, dynamic>> cafeDoc,
  ) async {
    final categoriesSnapshot = await cafeDoc.reference
        .collection('menuCategories')
        .get();

    final categories = <MenuCategoryEntity>[];

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

          name: (data['name'] ?? '').toString(),

          description: (data['description'] ?? '').toString(),

          price: (data['price'] ?? 0).toDouble(),

          image: (data['imageUrl'] ?? data['image'] ?? '').toString(),

          options: List<String>.from(data['options'] ?? []),
        );
      }).toList();

      categories.add(
        MenuCategoryEntity(
          id: categoryDoc.id,

          cafeId: cafeDoc.id,

          name: (categoryData['name'] ?? '').toString(),

          products: products,
        ),
      );
    }

    return categories;
  }

  Future<void> saveCafeMenu({
    required String locationId,
    required String cafeId,
    required SeedCafeData seedCafe,
  }) async {
    final cafeRef = locationCafes(locationId).doc(cafeId);

    for (final category in seedCafe.menuCategories) {
      final categoryRef = cafeRef.collection('menuCategories').doc(category.id);

      await categoryRef.set({'name': category.name});

      for (final product in category.products) {
        final productRef = categoryRef.collection('products').doc(product.id);

        await productRef.set({
          'name': product.name,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'options': product.options,
        });
      }
    }
  }
}
