import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';

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

  ProfileCubit({
    required this.getUserProfileUseCase,
    required this.updateProfileUseCase,
    required this.authRepository,
    required this.createNotificationUseCase,
  }) : super( ProfileInitial());

  Future<void> fetchUserProfile(String uid) async {
    emit( ProfileLoading());

    final result = await getUserProfileUseCase(uid);

    result.fold(
          (failure) => emit(ProfileError(failure.toString())),
          (user) => emit(ProfileLoaded(user)),
    );
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