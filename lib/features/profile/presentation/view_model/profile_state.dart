part of 'profile_cubit.dart';

abstract class ProfileState {}
class ProfileInitial extends ProfileState {}
class ProfileLoading extends ProfileState {}
class ProfileLoaded extends ProfileState {
  final UserEntity user;
  ProfileLoaded(this.user);
}
class ProfileUpdating extends ProfileState {}
class ProfileUpdateSuccess extends ProfileState {}
class ProfileDeleting extends ProfileState {}
class ProfileAccountDeleted extends ProfileState {}
class ProfileLoggedOut extends ProfileState {}
class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}