import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../models/initial_location_seed_data.dart';

@injectable
class InitialLocationSeeder {
  final FirebaseFirestore firestore;

  InitialLocationSeeder({required this.firestore});

  static const int requiredCafeCount = 30;

  CollectionReference<Map<String, dynamic>> cafesCollection(String locationId) {
    return firestore
        .collection('locations')
        .doc(locationId)
        .collection('cafes');
  }

  Future<bool> isSeeded(String locationId) async {
    final snapshot = await cafesCollection(locationId).count().get();

    return (snapshot.count ?? 0) >= requiredCafeCount;
  }

  Future<void> seedLocation(InitialLocationSeedData location) async {
    final alreadySeeded = await isSeeded(location.id);

    if (alreadySeeded) {
      return;
    }
    WriteBatch batch = firestore.batch();
    int operationCount = 0;
    final locationRef = firestore.collection('locations').doc(location.id);

    batch.set(locationRef, {
      'name': location.name,
      'latitude': location.center.latitude,
      'longitude': location.center.longitude,
      'radiusInMeters': location.radiusInMeters,
      'seeded': false,
      'preSeeded': true,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    operationCount++;

    for (final cafe in location.cafes) {
      final cafeRef = cafesCollection(location.id).doc(cafe.id);

      final cafeLatitude = location.center.latitude + cafe.latitudeOffset;

      final cafeLongitude = location.center.longitude + cafe.longitudeOffset;

      batch.set(cafeRef, {
        'googlePlaceId': cafe.id,
        'name': cafe.name,
        'latitude': cafeLatitude,
        'longitude': cafeLongitude,
        'rating': cafe.rating,
        'reviewsCount': cafe.reviewsCount,
        'imageUrl': cafe.imageUrl,
        'photos': [cafe.imageUrl],
        'address': cafe.address,
        'isOpen': cafe.isOpen,
        'description': cafe.description,
        'openingHours': cafe.openingHours,
        'attributes': cafe.attributes,
        'source': 'initial_seed',
        'cachedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      operationCount++;

      if (operationCount >= 450) {
        await batch.commit();

        batch = firestore.batch();
        operationCount = 0;
      }

      for (final category in cafe.menuCategories) {
        final categoryRef = cafeRef
            .collection('menuCategories')
            .doc(category.id);

        batch.set(categoryRef, {
          'name': category.name,
          'cafeId': cafe.id,
        }, SetOptions(merge: true));

        operationCount++;

        if (operationCount >= 450) {
          await batch.commit();

          batch = firestore.batch();
          operationCount = 0;
        }
        for (final product in category.products) {
          final productRef = categoryRef.collection('products').doc(product.id);

          batch.set(productRef, {
            'name': product.name,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'options': product.options,
            'cafeId': cafe.id,
            'categoryId': category.id,
          }, SetOptions(merge: true));

          operationCount++;

          if (operationCount >= 450) {
            await batch.commit();

            batch = firestore.batch();
            operationCount = 0;
          }
        }
      }
    }

    if (operationCount > 0) {
      await batch.commit();
    }

    final count = await cafesCollection(location.id).count().get();

    final cafeCount = count.count ?? 0;

    await locationRef.set({
      'seeded': cafeCount >= requiredCafeCount,
      'preSeeded': true,
      'cafeCount': cafeCount,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> seedAllLocations() async {
    final locations = buildInitialLocationSeedData();

    for (final location in locations) {
      await seedLocation(location);
    }
  }
}
