// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reaction_chain/theme/player_colors.dart';

// Essentially the :root and CSS variables in Flutter.
class AppTheme {
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFF0F1317),
      colorScheme: const ColorScheme.dark(
        surface: Color(0xFF0F1317), // background
        surfaceContainerHighest: Color(0xFF1A1F25), // surface
        surfaceContainerHigh: Color(0xFF262C35), // subsurface
        onSurface: Color(0xFFE6E6E6), // foreground
        onSurfaceVariant: Color(0x80E6E6E6), // subforeground
        primary: Color(0xFFD178FE), // primary
        scrim: Color(0x80000000), // overlay
      ),
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme)
          .copyWith(
            displayLarge: GoogleFonts.poppins(fontSize: 48, fontWeight: .bold),
            displayMedium: GoogleFonts.poppins(fontSize: 24, fontWeight: .bold),
            displaySmall: GoogleFonts.poppins(fontSize: 16),
          ),
      iconTheme: const IconThemeData(color: Color(0xFFE6E6E6)),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: const Color(0xFF1A1F25),
          foregroundColor: const Color(0xFFE6E6E6),
        ),
      ),
      listTileTheme: ListTileThemeData(iconColor: const Color(0xFFE6E6E6)),
      extensions: const [PlayerColors.dark],
    );
  }
}
