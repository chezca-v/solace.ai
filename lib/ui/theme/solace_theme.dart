import 'package:flutter/material.dart';

/// Solace Design System Theme & Colors
class SolaceTheme {
  SolaceTheme._();

  // Colors
  static const Color background = Color(0xFFF7FAF7);
  static const Color backgroundSecondary = Color(0xFFEFF5F0);
  static const Color surfaceWhite = Color(0xFFFFFFFF);

  static const Color primary = Color(0xFF3EA679);
  static const Color primaryDark = Color(0xFF2E8B62);
  static const Color primaryLight = Color(0xFFE8F7EE);

  static const Color textHeading = Color(0xFF122C24);
  static const Color textBody = Color(0xFF49625A);
  static const Color textMuted = Color(0xFF6B827B);

  static const Color badgeBg = Color(0xFFE6F4EB);
  static const Color badgeBorder = Color(0xFFCCE7D7);
  static const Color badgeText = Color(0xFF166E49);

  static const Color cardBorder = Color(0xFFE8EFEA);
  static const Color iconBg = Color(0xFFEAF7EE);
  static const Color iconColor = Color(0xFF218E5E);

  // Font family
  static const String fontFamily = 'PlusJakartaSans';

  // ThemeData
  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        surface: surfaceWhite,
        brightness: Brightness.light,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: textHeading,
          height: 1.25,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: textHeading,
          letterSpacing: -0.3,
        ),
        titleLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: textHeading,
        ),
        titleMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: textHeading,
        ),
        bodyLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: textBody,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: textMuted,
          height: 1.4,
        ),
      ),
    );
  }
}
