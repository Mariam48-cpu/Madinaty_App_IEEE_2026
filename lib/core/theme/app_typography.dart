import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class AppTypography {
  const AppTypography._();

  // ============================================================
  // FONT FAMILIES
  // ============================================================

  /// Arabic primary font.
  static const String arabicFontFamily = 'ReemKufi';

  /// English primary font.
  static const String englishFontFamily = 'Tajawal';

  /// Decorative font - use only for special headings / branding.
  static const String decorativeFontFamily = 'BerkshireSwash';

  /// Kept for backward compatibility with existing code.
  /// The actual application font is selected dynamically by locale
  /// inside AppTheme.
  static const String fontFamily = arabicFontFamily;

  /// Arabic fallback fonts.
  static const List<String> arabicFontFamilyFallback = [
    'ReemKufi',
    'Tajawal',
    'Cairo',
    'Roboto',
    'sans-serif',
  ];

  /// English fallback fonts.
  static const List<String> englishFontFamilyFallback = [
    'Tajawal',
    'Roboto',
    'sans-serif',
  ];

  /// Decorative font fallback.
  static const List<String> decorativeFontFamilyFallback = [
    'BerkshireSwash',
    'Tajawal',
    'ReemKufi',
    'Roboto',
    'sans-serif',
  ];

  /// Returns the correct primary font for the current locale.
  static String fontFamilyForLocale(Locale locale) {
    return locale.languageCode == 'ar' ? arabicFontFamily : englishFontFamily;
  }

  /// Returns the correct fallback fonts for the current locale.
  static List<String> fontFamilyFallbackForLocale(Locale locale) {
    return locale.languageCode == 'ar'
        ? arabicFontFamilyFallback
        : englishFontFamilyFallback;
  }

  // ============================================================
  // DECORATIVE STYLE
  // ============================================================

  /// Use this only for special branding / hero headings.
  ///
  /// Example:
  /// Text(
  ///   'Madinaty AI',
  ///   style: AppTypography.decorative,
  /// )
  static const TextStyle decorative = TextStyle(
    fontFamily: decorativeFontFamily,
    fontFamilyFallback: decorativeFontFamilyFallback,
    fontSize: 28,
    fontWeight: FontWeight.w400,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  // ============================================================
  // DISPLAY
  // ============================================================

  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.35,
    color: AppColors.textPrimary,
  );

  // ============================================================
  // HEADLINES
  // ============================================================

  static const TextStyle headlineLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    height: 1.35,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.35,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  // ============================================================
  // TITLES
  // ============================================================

  static const TextStyle titleLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  // ============================================================
  // BODY
  // ============================================================

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textMuted,
  );

  // ============================================================
  // LABELS
  // ============================================================

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.textMuted,
  );

  // ============================================================
  // COMPLETE MATERIAL 3 TEXT THEME
  // ============================================================

  static const TextTheme textTheme = TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );
}
