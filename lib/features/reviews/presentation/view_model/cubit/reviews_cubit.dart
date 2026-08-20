import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/entities/rating_breakdown_entity.dart';
import '../../../domain/entities/review_entity.dart';
import '../../../domain/use_cases/get_cafe_reviews_use_case.dart';
import '../../../domain/use_cases/get_user_review_use_case.dart';
import '../../../domain/use_cases/submit_review_use_case.dart';
import '../../../domain/use_cases/watch_cafe_reviews_use_case.dart';
import 'reviews_state.dart';

@injectable
class ReviewsCubit extends Cubit<ReviewsState> {
  final GetCafeReviewsUseCase getCafeReviewsUseCase;
  final WatchCafeReviewsUseCase watchCafeReviewsUseCase;
  final SubmitReviewUseCase submitReviewUseCase;
  final GetUserReviewUseCase getUserReviewUseCase;

  StreamSubscription<List<ReviewEntity>>? _reviewsSubscription;

  ReviewsCubit({
    required this.getCafeReviewsUseCase,
    required this.watchCafeReviewsUseCase,
    required this.submitReviewUseCase,
    required this.getUserReviewUseCase,
  }) : super(const ReviewsInitial());

  User? get currentUser => FirebaseAuth.instance.currentUser;

  bool get isAuthenticated => currentUser != null;

  String? get currentUserId => currentUser?.uid;

  String get currentUserName =>
      currentUser?.displayName ??
      currentUser?.email?.split('@').first ??
      '';

  String? get currentUserAvatar => currentUser?.photoURL;

  Future<String> resolveUserName(String uid) async {
    // 1. Try FirebaseAuth displayName if populated
    final displayName = currentUser?.displayName?.trim();
    if (displayName != null && displayName.isNotEmpty) {
      return displayName;
    }

    // 2. Fetch the user's registered name from Firestore users collection
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        final firestoreName = doc.data()?['name']?.toString().trim();
        if (firestoreName != null && firestoreName.isNotEmpty) {
          currentUser?.updateDisplayName(firestoreName);
          return firestoreName;
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print('[ReviewsCubit] Error fetching user profile name: $e');
    }

    // 3. Fallback to email prefix
    final emailName = currentUser?.email?.split('@').first.trim();
    if (emailName != null && emailName.isNotEmpty) {
      return emailName;
    }

    return 'مستخدم';
  }

  void initReviewsWatcher(String cafeId) {
    emit(const ReviewsLoading());
    _reviewsSubscription?.cancel();
    _reviewsSubscription = watchCafeReviewsUseCase(cafeId).listen(
      (reviews) {
        _processReviews(reviews);
      },
      onError: (error, stackTrace) {
        // ignore: avoid_print
        print('[ReviewsCubit] Watch error: $error\n$stackTrace');
        emit(ReviewsError(message: error.toString()));
      },
    );
  }

  Future<void> loadReviews(String cafeId) async {
    emit(const ReviewsLoading());
    try {
      final reviews = await getCafeReviewsUseCase(cafeId);
      _processReviews(reviews);
    } catch (e, stackTrace) {
      // ignore: avoid_print
      print('[ReviewsCubit] Load error: $e\n$stackTrace');
      emit(ReviewsError(message: e.toString()));
    }
  }

  void _processReviews(List<ReviewEntity> reviews) {
    final breakdown = RatingBreakdownEntity.fromReviews(reviews);
    final uid = currentUserId;
    ReviewEntity? userReview;
    if (uid != null && uid.isNotEmpty) {
      final matches = reviews.where((r) => r.userId == uid);
      if (matches.isNotEmpty) {
        userReview = matches.first;
      }
    }

    if (state is ReviewsLoaded) {
      emit((state as ReviewsLoaded).copyWith(
        allReviews: reviews,
        breakdown: breakdown,
        userReview: userReview,
      ));
    } else {
      emit(ReviewsLoaded(
        allReviews: reviews,
        breakdown: breakdown,
        userReview: userReview,
      ));
    }
  }

  void selectFilter(ReviewFilterType filter) {
    if (state is ReviewsLoaded) {
      emit((state as ReviewsLoaded).copyWith(selectedFilter: filter));
    }
  }

  Future<bool> submitReview({
    required String cafeId,
    required double rating,
    required String text,
    List<String> images = const [],
    String? existingReviewId,
  }) async {
    if (!isAuthenticated || currentUserId == null) {
      if (state is ReviewsLoaded) {
        emit((state as ReviewsLoaded).copyWith(
          isSubmitting: false,
          submitError: 'auth_required',
          submitSuccess: false,
        ));
      }
      return false;
    }

    final uid = currentUserId!;
    final name = await resolveUserName(uid);
    final avatar = currentUserAvatar;

    final id = existingReviewId ??
        (state is ReviewsLoaded && (state as ReviewsLoaded).userReview != null
            ? (state as ReviewsLoaded).userReview!.id
            : '');

    final review = ReviewEntity(
      id: id,
      cafeId: cafeId,
      userId: uid,
      userName: name,
      userAvatar: avatar,
      rating: rating,
      text: text,
      images: images,
      createdAt: DateTime.now(),
    );

    if (state is ReviewsLoaded) {
      emit((state as ReviewsLoaded).copyWith(
        isSubmitting: true,
        clearSubmitError: true,
        submitSuccess: false,
      ));
    }

    try {
      await submitReviewUseCase(review);
      if (state is ReviewsLoaded) {
        emit((state as ReviewsLoaded).copyWith(
          isSubmitting: false,
          submitSuccess: true,
          userReview: review,
        ));
      }
      return true;
    } catch (e, stackTrace) {
      // ignore: avoid_print
      print('[ReviewsCubit] Submit review error: $e\n$stackTrace');
      if (state is ReviewsLoaded) {
        emit((state as ReviewsLoaded).copyWith(
          isSubmitting: false,
          submitError: e.toString(),
          submitSuccess: false,
        ));
      }
      return false;
    }
  }

  @override
  Future<void> close() {
    _reviewsSubscription?.cancel();
    return super.close();
  }
}
