import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextTheme textTheme(ColorScheme scheme) {
    final base = GoogleFonts.interTextTheme();
    return base.copyWith(
      displaySmall:  base.displaySmall?.copyWith(fontWeight: FontWeight.w600),
      headlineMedium: base.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
      titleLarge:   base.titleLarge?.copyWith(fontWeight: FontWeight.w600),
      titleMedium:  base.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      bodyLarge:    base.bodyLarge,
      bodyMedium:   base.bodyMedium,
      labelLarge:   base.labelLarge?.copyWith(letterSpacing: .2),
    );
  }
}