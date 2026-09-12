import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madinaty_app_ieee_2026/core/di/injection_container.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/features/auth/data/models/user_model.dart';
import 'package:madinaty_app_ieee_2026/features/booking/domain/repositories/booking_repository_interface.dart';
import 'package:madinaty_app_ieee_2026/features/favorites/data/data_sources/favorites_remote_data_source_interface.dart';
import 'package:madinaty_app_ieee_2026/features/pre_order/data/data_sources/pre_order_remote_data_source_interface.dart';

import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/domain/repositories/auth_repo_interface.dart';
import '../../../notifications/domain/use_cases/create_notification_use_case.dart';
import '../../domain/use_cases/get_profile_use_case.dart';
import '../../domain/use_cases/update_profile_use_case.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getUserProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final AuthRepoInterface authRepository;
  final CreateNotificationUseCase createNotificationUseCase;

  StreamSubscription? _userSub;
  StreamSubscription? _bookingsSub;
  StreamSubscription? _favoritesSub;
  StreamSubscription? _ordersSub;

  ProfileCubit({
    required this.getUserProfileUseCase,
    required this.updateProfileUseCase,
    required this.authRepository,
    required this.createNotificationUseCase,
  }) : super(ProfileInitial());

  Future<void> fetchUserProfile(String uid) async {
    emit(ProfileLoading());

    final result = await getUserProfileUseCase(uid);

    result.fold(
      (failure) => emit(ProfileError(failure.toString())),
      (user) {
        emit(ProfileLoaded(user));
        _listenToUserCounts(uid);
      },
    );
  }

  void _listenToUserCounts(String uid) {
    _userSub?.cancel();
    _bookingsSub?.cancel();
    _favoritesSub?.cancel();
    _ordersSub?.cancel();

    _userSub = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists && snapshot.data() != null && state is ProfileLoaded) {
        final updatedUser = UserModel.fromMap(snapshot.data()!, uid);
        emit((state as ProfileLoaded).copyWith(user: updatedUser));
      }
    });

    if (sl.isRegistered<BookingRepositoryInterface>()) {
      _bookingsSub = sl<BookingRepositoryInterface>()
          .watchUserBookings(uid)
          .listen((bookings) {
        if (state is ProfileLoaded) {
          emit((state as ProfileLoaded).copyWith(bookingsCount: bookings.length));
        }
      });
    }

    if (sl.isRegistered<FavoritesRemoteDataSourceInterface>()) {
      _favoritesSub = sl<FavoritesRemoteDataSourceInterface>()
          .watchFavorites()
          .listen((favs) {
        if (state is ProfileLoaded) {
          final placesCount = favs.where((f) => f.isCafe).length;
          final productsCount = favs.where((f) => f.isProduct).length;
          emit((state as ProfileLoaded).copyWith(
            favoritesCount: favs.length,
            favoritePlacesCount: placesCount,
            favoriteProductsCount: productsCount,
          ));
        }
      });
    }

    if (sl.isRegistered<PreOrderRemoteDataSourceInterface>()) {
      _ordersSub = sl<PreOrderRemoteDataSourceInterface>()
          .watchUserPreOrders(uid)
          .listen((orders) {
        if (state is ProfileLoaded) {
          emit((state as ProfileLoaded).copyWith(ordersCount: orders.length));
        }
      });
    }
  }

  @override
  Future<void> close() {
    _userSub?.cancel();
    _bookingsSub?.cancel();
    _favoritesSub?.cancel();
    _ordersSub?.cancel();
    return super.close();
  }

  Future<void> updateProfile({
    required String uid,
    required String name,
    required String phone,
    DateTime? birthDate,
    File? imageFile,
  }) async {
    emit( ProfileUpdating());

    final result = await updateProfileUseCase(
      uid: uid,
      name: name,
      phone: phone,
      birthDate: birthDate,
      imageFile: imageFile,
    );

    result.fold(
          (failure) => emit(ProfileError(failure.toString())),
          (_) async {
        await createNotificationUseCase(
          uid: uid,
          title: AppLocale.profileUpdatedNotifTitle,
          body: AppLocale.profileUpdatedNotifBody,
          type: 'profile_update',
        );

        emit( ProfileUpdateSuccess());

        fetchUserProfile(uid);
      },
    );
  }

  Future<void> deleteAccount() async {
    try {
      emit( ProfileDeleting());

      await authRepository.deleteAccount();

      emit( ProfileAccountDeleted());
    } catch (e) {
      emit(ProfileError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> logout() async {
    try {
      await authRepository.logout();

      emit( ProfileLoggedOut());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}