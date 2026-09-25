import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NeoColors {
  static const Color background = Color(0xFFFFFBEB); // Warm Cream
  static const Color surface = Color(0xFFFFFFFF);
  static const Color dark = Color(0xFF121212); // Pure Black Border
  static const Color primaryYellow = Color(0xFFFFE600);
  static const Color primaryPink = Color(0xFFFF5C8D);
  static const Color primaryCyan = Color(0xFF00E5FF);
  static const Color primaryGreen = Color(0xFF26DE81);
  static const Color primaryOrange = Color(0xFFFF7A00);
  static const Color primaryPurple = Color(0xFF8854D0);

  static const List<Color> cardPalette = [
    Color(0xFFFFE600), // Yellow
    Color(0xFFFF5C8D), // Pink
    Color(0xFF00E5FF), // Cyan
    Color(0xFF26DE81), // Green
    Color(0xFFFF7A00), // Orange
    Color(0xFF8854D0), // Purple
    Color(0xFFFC5C65), // Coral Red
    Color(0xFF45AAF2), // Sky Blue
  ];
}

class NeoBox {
  static BoxDecoration container({
    Color color = Colors.white,
    double borderWidth = 3.0,
    double borderRadius = 12.0,
    Offset shadowOffset = const Offset(4, 4),
    Color borderColor = NeoColors.dark,
    Color shadowColor = NeoColors.dark,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: borderColor, width: borderWidth),
      boxShadow: [
        BoxShadow(
          color: shadowColor,
          offset: shadowOffset,
          blurRadius: 0,
        ),
      ],
    );
  }

  static BoxDecoration circle({
    Color color = Colors.white,
    double borderWidth = 3.0,
    Offset shadowOffset = const Offset(3, 3),
  }) {
    return BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      border: Border.all(color: NeoColors.dark, width: borderWidth),
      boxShadow: [
        BoxShadow(
          color: NeoColors.dark,
          offset: shadowOffset,
          blurRadius: 0,
        ),
      ],
    );
  }
}

class NeoTypography {
  static const List<String> fontFallbacks = [
    'Segoe UI',
    'Roboto',
    'Helvetica Neue',
    'Arial',
    'sans-serif',
  ];

  static TextStyle heading({double fontSize = 24, Color color = NeoColors.dark}) {
    return GoogleFonts.spaceGrotesk(
      fontSize: fontSize,
      fontWeight: FontWeight.w900,
      color: color,
      letterSpacing: -0.5,
      textStyle: const TextStyle(fontFamilyFallback: fontFallbacks),
    );
  }

  static TextStyle subHeading({double fontSize = 16, Color color = NeoColors.dark}) {
    return GoogleFonts.spaceGrotesk(
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      color: color,
      textStyle: const TextStyle(fontFamilyFallback: fontFallbacks),
    );
  }

  static TextStyle body({double fontSize = 14, Color color = NeoColors.dark, FontWeight fontWeight = FontWeight.w600}) {
    return GoogleFonts.spaceGrotesk(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      textStyle: const TextStyle(fontFamilyFallback: fontFallbacks),
    );
  }

  static TextStyle label({double fontSize = 12, Color color = NeoColors.dark}) {
    return GoogleFonts.spaceGrotesk(
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      color: color,
      letterSpacing: 0.8,
      textStyle: const TextStyle(fontFamilyFallback: fontFallbacks),
    );
  }
}
