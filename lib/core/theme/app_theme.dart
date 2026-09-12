
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

abstract class AppTheme {
  const AppTheme._();

  // ============================================================
  // DEFAULT THEME
  // ============================================================

  /// Kept for backward compatibility.
  /// Arabic is the default application language.
  static ThemeData get lightTheme {
    return lightThemeForLocale(const Locale('ar', 'EG'));
  }

  // ============================================================
  // LOCALE-AWARE THEME
  // ============================================================

  static ThemeData lightThemeForLocale(Locale locale) {
    final String fontFamily =
        AppTypography.fontFamilyForLocale(locale);

    final List<String> fontFamilyFallback =
        AppTypography.fontFamilyFallbackForLocale(locale);

    const colorScheme = ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.textWhite,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      secondary: AppColors.darkButton,
      onSecondary: AppColors.onDarkButton,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      surfaceContainerHighest: AppColors.surfaceVariant,
      error: AppColors.error,
      onError: AppColors.textWhite,
      outline: AppColors.border,
      outlineVariant: AppColors.divider,
    );

    return ThemeData(
      useMaterial3: true,

      // ========================================================
      // GLOBAL FONT
      // ========================================================

      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,

      // ========================================================
      // COLORS
      // ========================================================

      colorScheme: colorScheme,

      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,
      dividerColor: AppColors.divider,

      // ========================================================
      // TYPOGRAPHY
      // ========================================================

      textTheme: AppTypography.textTheme,
      primaryTextTheme: AppTypography.textTheme,

      // ========================================================
      // APP BAR
      // ========================================================

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,

        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
          size: 24,
        ),

        actionsIconTheme: const IconThemeData(
          color: AppColors.textPrimary,
          size: 24,
        ),

        titleTextStyle: AppTypography.titleLarge.copyWith(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          color: AppColors.textPrimary,
        ),
      ),

      // ========================================================
      // ELEVATED BUTTON
      // ========================================================

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkButton,
          foregroundColor: AppColors.onDarkButton,

          disabledBackgroundColor: AppColors.border,
          disabledForegroundColor: AppColors.textMuted,

          elevation: 0,

          minimumSize: const Size(88, 48),

          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),

          textStyle: AppTypography.labelLarge.copyWith(
            fontFamily: fontFamily,
            fontFamilyFallback: fontFamilyFallback,
            color: AppColors.onDarkButton,
          ),
        ),
      ),

      // ========================================================
      // OUTLINED BUTTON
      // ========================================================

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          disabledForegroundColor: AppColors.textMuted,

          minimumSize: const Size(88, 48),

          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),

          side: const BorderSide(
            color: AppColors.border,
            width: 1.2,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),

          textStyle: AppTypography.labelLarge.copyWith(
            fontFamily: fontFamily,
            fontFamilyFallback: fontFamilyFallback,
          ),
        ),
      ),

      // ========================================================
      // TEXT BUTTON
      // ========================================================

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.textMuted,

          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          textStyle: AppTypography.labelLarge.copyWith(
            fontFamily: fontFamily,
            fontFamilyFallback: fontFamilyFallback,
            color: AppColors.primary,
          ),
        ),
      ),

      // ========================================================
      // FLOATING ACTION BUTTON
      // ========================================================

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
        elevation: 2,
        highlightElevation: 4,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // ========================================================
      // CARD
      // ========================================================

      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
      ),

      // ========================================================
      // INPUT FIELDS
      // ========================================================

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputBackground,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),

        hintStyle: AppTypography.bodyMedium.copyWith(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          color: AppColors.textMuted,
        ),

        labelStyle: AppTypography.bodyMedium.copyWith(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          color: AppColors.textSecondary,
        ),

        errorStyle: AppTypography.bodySmall.copyWith(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          color: AppColors.error,
        ),

        prefixIconColor: AppColors.textSecondary,
        suffixIconColor: AppColors.textSecondary,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1.5,
          ),
        ),
      ),

      // ========================================================
      // CHIP
      // ========================================================

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.chipBackground,
        disabledColor: AppColors.surfaceVariant,

        selectedColor: AppColors.darkButton,
        secondarySelectedColor: AppColors.primary,

        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),

        labelStyle: AppTypography.bodyMedium.copyWith(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          color: AppColors.textPrimary,
        ),

        secondaryLabelStyle: AppTypography.bodyMedium.copyWith(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          color: AppColors.textWhite,
        ),

        brightness: Brightness.light,

        elevation: 0,
        pressElevation: 0,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide.none,
        ),

        showCheckmark: false,
      ),

      // ========================================================
      // OLD BOTTOM NAVIGATION BAR
      // ========================================================

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,

        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,

        selectedIconTheme: const IconThemeData(
          size: 24,
          color: AppColors.primary,
        ),

        unselectedIconTheme: const IconThemeData(
          size: 24,
          color: AppColors.textMuted,
        ),

        selectedLabelStyle: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),

        unselectedLabelStyle: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),

        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // ========================================================
      // MATERIAL 3 NAVIGATION BAR
      // ========================================================

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.navActivePill,
        elevation: 8,

        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return AppTypography.labelSmall.copyWith(
                fontFamily: fontFamily,
                fontFamilyFallback: fontFamilyFallback,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              );
            }

            return AppTypography.labelSmall.copyWith(
              fontFamily: fontFamily,
              fontFamilyFallback: fontFamilyFallback,
              color: AppColors.textMuted,
            );
          },
        ),

        iconTheme: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(
                size: 24,
                color: AppColors.primary,
              );
            }

            return const IconThemeData(
              size: 24,
              color: AppColors.textMuted,
            );
          },
        ),
      ),

      // ========================================================
      // TAB BAR
      // ========================================================

      tabBarTheme: TabBarThemeData(
        indicatorSize: TabBarIndicatorSize.tab,

        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
        ),

        labelColor: AppColors.textWhite,
        unselectedLabelColor: AppColors.textSecondary,

        labelStyle: AppTypography.titleMedium.copyWith(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontWeight: FontWeight.bold,
        ),

        unselectedLabelStyle: AppTypography.bodyMedium.copyWith(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
        ),

        dividerColor: Colors.transparent,
      ),

      // ========================================================
      // DIVIDER
      // ========================================================

      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      // ========================================================
      // DIALOG
      // ========================================================

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        elevation: 6,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),

        titleTextStyle: AppTypography.headlineSmall.copyWith(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
        ),

        contentTextStyle: AppTypography.bodyMedium.copyWith(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
        ),
      ),

      // ========================================================
      // BOTTOM SHEET
      // ========================================================

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        modalBackgroundColor: AppColors.surface,
        elevation: 8,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),

        clipBehavior: Clip.antiAlias,
      ),

      // ========================================================
      // CHECKBOX
      // ========================================================

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary;
            }

            return AppColors.surface;
          },
        ),

        checkColor: WidgetStateProperty.all(
          AppColors.textWhite,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),

        side: const BorderSide(
          color: AppColors.border,
          width: 1.5,
        ),
      ),

      // ========================================================
      // RADIO
      // ========================================================

      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary;
            }

            return AppColors.textMuted;
          },
        ),
      ),

      // ========================================================
      // SWITCH
      // ========================================================

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.textWhite;
            }

            return AppColors.textMuted;
          },
        ),

        trackColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary;
            }

            return AppColors.surfaceVariant;
          },
        ),

        trackOutlineColor: WidgetStateProperty.all(
          Colors.transparent,
        ),
      ),
    );
  }
}
