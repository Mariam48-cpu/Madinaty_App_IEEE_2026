part of 'profile_cubit.dart';

abstract class ProfileState {}
class ProfileInitial extends ProfileState {}
class ProfileLoading extends ProfileState {}
class ProfileLoaded extends ProfileState {
  final UserEntity user;
  final int bookingsCount;
  final int favoritesCount;
  final int ordersCount;
  final int favoritePlacesCount;
  final int favoriteProductsCount;

  ProfileLoaded(
    this.user, {
    this.bookingsCount = 0,
    this.favoritesCount = 0,
    this.ordersCount = 0,
    this.favoritePlacesCount = 0,
    this.favoriteProductsCount = 0,
  });

  ProfileLoaded copyWith({
    UserEntity? user,
    int? bookingsCount,
    int? favoritesCount,
    int? ordersCount,
    int? favoritePlacesCount,
    int? favoriteProductsCount,
  }) {
    return ProfileLoaded(
      user ?? this.user,
      bookingsCount: bookingsCount ?? this.bookingsCount,
      favoritesCount: favoritesCount ?? this.favoritesCount,
      ordersCount: ordersCount ?? this.ordersCount,
      favoritePlacesCount: favoritePlacesCount ?? this.favoritePlacesCount,
      favoriteProductsCount:
          favoriteProductsCount ?? this.favoriteProductsCount,
    );
  }
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