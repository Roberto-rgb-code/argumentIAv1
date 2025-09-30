import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final seed = const Color(0xFF5B7CFF); // Indigo alegre

ThemeData buildAppTheme() {
  final base = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light),
    useMaterial3: true,
  );

  return base.copyWith(
    textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).copyWith(
      headlineLarge: GoogleFonts.poppins(fontWeight: FontWeight.w700),
      headlineMedium: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      titleLarge: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      bodyLarge: GoogleFonts.poppins(),
      bodyMedium: GoogleFonts.poppins(),
    ),
    appBarTheme: base.appBarTheme.copyWith(
      elevation: 0,
      backgroundColor: base.colorScheme.surface,
      foregroundColor: base.colorScheme.onSurface,
      centerTitle: true,
    ),
    cardTheme: base.cardTheme.copyWith(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
    ),
  );
}
