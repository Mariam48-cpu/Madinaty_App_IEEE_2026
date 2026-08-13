import 'package:flutter/material.dart';

abstract class AppColors {
  // Prevent instantiation
  const AppColors._();

  // --- Primary & Accent Colors ---
  /// Warm Terracotta / Chestnut Brown (Primary brand accent)
  static const Color primary = Color(0xFF8A5A36);

  /// Lighter shade of primary for hover / focus states
  static const Color primaryLight = Color(0xFFA66E38);

  /// Dark shade of primary for pressed states
  static const Color primaryDark = Color(0xFF684124);

  /// Soft warm tan tint for selected indicators and active pill backgrounds
  static const Color primaryContainer = Color(0xFFF3EBE1);

  /// Text / icon color on top of [primaryContainer]
  static const Color onPrimaryContainer = Color(0xFF52331C);

  // --- Button & Dark Accent Colors ---
  /// Dark charcoal used for primary action buttons & high-contrast chips in Figma
  static const Color darkButton = Color(0xFF1E1E1E);

  /// Text color on top of dark button
  static const Color onDarkButton = Color(0xFFFFFFFF);

  // --- Canvas & Surface Colors ---
  /// Main scaffold background color (warm soft off-white / cream)
  static const Color background = Color(0xFFFBF8F5);

  /// Primary surface color for cards, dialogs, and sheets
  static const Color surface = Color(0xFFFFFFFF);

  /// Secondary surface color for inner card sections and soft backgrounds
  static const Color surfaceVariant = Color(0xFFF7F3EE);

  /// Input background color
  static const Color inputBackground = Color(0xFFFFFFFF);

  // --- Text Colors ---
  /// High emphasis text (titles, headings, primary labels)
  static const Color textPrimary = Color(0xFF1E1E1E);

  /// Medium emphasis text (subtitles, secondary info, body text)
  static const Color textSecondary = Color(0xFF6E6761);

  /// Low emphasis text (placeholders, hints, disabled labels)
  static const Color textMuted = Color(0xFFA39C96);

  /// Light text for dark backgrounds
  static const Color textWhite = Color(0xFFFFFFFF);

  // --- Borders & Dividers ---
  /// Default border color for inputs, cards, and outlines
  static const Color border = Color(0xFFEADBCE);

  /// Subtle divider color
  static const Color divider = Color(0xFFEDE7DF);

  // --- Status & Feedback Colors ---
  /// Success green (e.g. confirmed bookings, active statuses)
  static const Color success = Color(0xFF2E7D32);
  static const Color successContainer = Color(0xFFE8F5E9);

  /// Warning / Discount orange
  static const Color warning = Color(0xFFE65100);
  static const Color warningContainer = Color(0xFFFFF3E0);

  /// Error red
  static const Color error = Color(0xFFD32F2F);
  static const Color errorContainer = Color(0xFFFFEBEE);

  /// Info blue
  static const Color info = Color(0xFF1976D2);
  static const Color infoContainer = Color(0xFFE3F2FD);

  // --- Navigation & Interactive ---
  /// Bottom nav active item pill fill
  static const Color navActivePill = Color(0xFFEFE4D8);

  /// Chip background color (unselected)
  static const Color chipBackground = Color(0xFFF3EBE1);

  /// Chip border color
  static const Color chipBorder = Color(0xFFE8DEC8);
}
