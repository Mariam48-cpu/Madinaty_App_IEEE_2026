import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  const ReviewModel({
    required super.id,
    required super.cafeId,
    required super.userId,
    required super.userName,
    super.userAvatar,
    required super.rating,
    required super.text,
    super.images,
    required super.createdAt,
  });

  factory ReviewModel.fromEntity(ReviewEntity entity) {
    return ReviewModel(
      id: entity.id,
      cafeId: entity.cafeId,
      userId: entity.userId,
      userName: entity.userName,
      userAvatar: entity.userAvatar,
      rating: entity.rating,
      text: entity.text,
      images: entity.images,
      createdAt: entity.createdAt,
    );
  }

  factory ReviewModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc, [
    String? fallbackCafeId,
  ]) {
    final data = doc.data() ?? {};
    return ReviewModel.fromMap(data, doc.id, fallbackCafeId);
  }

  factory ReviewModel.fromMap(
    Map<String, dynamic> data,
    String id, [
    String? fallbackCafeId,
  ]) {
    DateTime parseDate(dynamic val) {
      if (val == null) return DateTime.now();
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      if (val is int) return DateTime.fromMillisecondsSinceEpoch(val);
      return DateTime.now();
    }

    final rawImages = data['images'];
    List<String> imagesList = [];
    if (rawImages is List) {
      imagesList = rawImages.whereType<String>().toList();
    }

    return ReviewModel(
      id: id,
      cafeId: (data['cafeId'] as String?) ?? fallbackCafeId ?? '',
      userId: (data['userId'] as String?) ?? '',
      userName: (data['userName'] as String?) ?? '',
      userAvatar: data['userAvatar'] as String?,
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      text: (data['text'] as String?) ?? '',
      images: imagesList,
      createdAt: parseDate(data['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{
      'cafeId': cafeId,
      'userId': userId,
      'userName': userName,
      if (userAvatar != null && userAvatar!.isNotEmpty) 'userAvatar': userAvatar,
      'rating': rating,
      'text': text,
      'images': images,
      'createdAt': Timestamp.fromDate(createdAt),
    };

    return data;
  }
}
