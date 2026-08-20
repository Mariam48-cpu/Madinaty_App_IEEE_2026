import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../models/review_model.dart';
import 'reviews_remote_data_source_interface.dart';

@Injectable(as: ReviewsRemoteDataSourceInterface)
class ReviewsRemoteDataSourceImpl implements ReviewsRemoteDataSourceInterface {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ReviewsRemoteDataSourceImpl();

  CollectionReference<Map<String, dynamic>> _reviewsCollection(String cafeId) {
    return _firestore
        .collection('cafes')
        .doc(cafeId)
        .collection('reviews');
  }

  @override
  Future<List<ReviewModel>> getReviews(String cafeId) async {
    if (cafeId.isEmpty) return [];

    final snapshot = await _reviewsCollection(cafeId).get();

    final reviews = snapshot.docs
        .map((doc) => ReviewModel.fromFirestore(doc, cafeId))
        .toList();

    reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return reviews;
  }

  @override
  Stream<List<ReviewModel>> watchReviews(String cafeId) {
    if (cafeId.isEmpty) return Stream.value([]);

    return _reviewsCollection(cafeId).snapshots().map((snapshot) {
      final reviews = snapshot.docs
          .map((doc) => ReviewModel.fromFirestore(doc, cafeId))
          .toList();

      reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return reviews;
    });
  }

  @override
  Future<void> submitReview(ReviewModel review) async {
    final collection = _reviewsCollection(review.cafeId);
    final docId = review.id.isNotEmpty ? review.id : collection.doc().id;

    final reviewToSave = ReviewModel(
      id: docId,
      cafeId: review.cafeId,
      userId: review.userId,
      userName: review.userName,
      userAvatar: review.userAvatar,
      rating: review.rating,
      text: review.text,
      images: review.images,
      createdAt: review.createdAt,
    );

    await collection.doc(docId).set(reviewToSave.toMap(), SetOptions(merge: true));
  }

  @override
  Future<ReviewModel?> getUserReview({
    required String cafeId,
    required String userId,
  }) async {
    if (cafeId.isEmpty || userId.isEmpty) return null;

    final snapshot = await _reviewsCollection(cafeId)
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    return ReviewModel.fromFirestore(snapshot.docs.first, cafeId);
  }

  @override
  Future<void> deleteReview({
    required String cafeId,
    required String reviewId,
  }) async {
    if (cafeId.isEmpty || reviewId.isEmpty) return;
    await _reviewsCollection(cafeId).doc(reviewId).delete();
  }
}
