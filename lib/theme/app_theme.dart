import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color creamBackground = Color(0xFFF8F6F2);
  static const Color cardSurface = Colors.white;
  static const Color saffronRed = Color(0xFFE23744);
  static const Color spiceRust = Color(0xFFE85D04);
  static const Color turmericAmber = Color(0xFFD97706);
  static const Color forestEmerald = Color(0xFF10B981);
  static const Color darkStone = Color(0xFF1C1917);
  static const Color mutedText = Color(0xFF78716C);
  static const Color borderGrey = Color(0xFFE7E5E4);

  // Desi Urgency Badges
  static const Color urgentLalBg = Color(0xFFFEE2E2);
  static const Color urgentLalText = Color(0xFFDC2626);
  static const Color soonPeelaBg = Color(0xFFFEF3C7);
  static const Color soonPeelaText = Color(0xFFD97706);
  static const Color safeHaraBg = Color(0xFFD1FAE5);
  static const Color safeHaraText = Color(0xFF059669);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: creamBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: saffronRed,
        primary: saffronRed,
        secondary: turmericAmber,
        surface: cardSurface,
      ),
      textTheme: GoogleFonts.outfitTextTheme().apply(
        bodyColor: darkStone,
        displayColor: darkStone,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: creamBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: darkStone),
      ),
      cardTheme: CardThemeData(
        color: cardSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderGrey, width: 1),
        ),
      ),
    );
  }
}
