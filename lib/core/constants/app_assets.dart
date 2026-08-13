/// Centralized asset path constants for the Madinaty application.
abstract class AppAssets {
  // Prevent instantiation
  const AppAssets._();

  // --- Base Paths ---
  static const String _imagesPath = 'assets/images';
  static const String _iconsPath = 'assets/icons';

  // --- Images ---
  static const String appLogo = '$_imagesPath/logo.png';
  static const String splashBackground = '$_imagesPath/splash_bg.png';
  static const String defaultAvatar = '$_imagesPath/default_avatar.png';
  static const String placePlaceholder = '$_imagesPath/place_placeholder.png';
  static const String coffeePlaceholder = '$_imagesPath/coffee_placeholder.png';

  // --- Icons ---
  static const String searchIcon = '$_iconsPath/ic_search.svg';
  static const String filterIcon = '$_iconsPath/ic_filter.svg';
  static const String locationIcon = '$_iconsPath/ic_location.svg';
  static const String notificationIcon = '$_iconsPath/ic_notification.svg';
  static const String heartIcon = '$_iconsPath/ic_heart.svg';
  static const String heartFilledIcon = '$_iconsPath/ic_heart_filled.svg';
  static const String starIcon = '$_iconsPath/ic_star.svg';
  static const String calendarIcon = '$_iconsPath/ic_calendar.svg';
  static const String clockIcon = '$_iconsPath/ic_clock.svg';

  // --- Bottom Navigation Icons ---
  static const String navHome = '$_iconsPath/ic_nav_home.svg';
  static const String navMap = '$_iconsPath/ic_nav_map.svg';
  static const String navLists = '$_iconsPath/ic_nav_lists.svg';
  static const String navProfile = '$_iconsPath/ic_nav_profile.svg';
}
