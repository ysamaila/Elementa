import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Spacing scale following the 4 / 8 / 16 / 24 / 32 / 48 standard.
class AppSpacing {
  const AppSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

/// Category metadata containing educational descriptions and IUPAC classifications.
class CategoryInfo {
  final String id;
  final String displayName;
  final Color color;
  final String description;

  const CategoryInfo({
    required this.id,
    required this.displayName,
    required this.color,
    required this.description,
  });
}

/// Central application theme, color palettes, and typography definition.
class AppTheme {
  AppTheme._();

  // Core brand and neutral surfaces
  static const Color background = Color(0xFF090D16);
  static const Color surface = Color(0xFF111827);
  static const Color surfaceCard = Color(0xFF1E293B);
  static const Color surfaceCardElevated = Color(0xFF283548);
  static const Color border = Color(0xFF334155);
  static const Color borderLight = Color(0x2AFFFFFF);

  // Text hierarchy colors
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Category Color Palette (Accessible, visually distinct, harmonious)
  static const Color alkaliMetalColor = Color(0xFFF43F5E); // Vibrant Rose/Red
  static const Color alkalineEarthColor = Color(0xFFFB923C); // Warm Tangerine
  static const Color transitionMetalColor = Color(0xFF38BDF8); // Sky / Vivid Blue
  static const Color postTransitionMetalColor = Color(0xFF2DD4BF); // Teal Cyan
  static const Color metalloidColor = Color(0xFF34D399); // Emerald
  static const Color reactiveNonmetalColor = Color(0xFFA3E635); // Lime
  static const Color nobleGasColor = Color(0xFFA855F7); // Purple
  static const Color lanthanideColor = Color(0xFFF472B6); // Soft Orchid Pink
  static const Color actinideColor = Color(0xFFE879F9); // Radiant Fuchsia
  static const Color unknownColor = Color(0xFF94A3B8); // Cool Slate

  static const Map<String, CategoryInfo> categories = {
    'alkali-metal': CategoryInfo(
      id: 'alkali-metal',
      displayName: 'Alkali Metal',
      color: alkaliMetalColor,
      description:
          'Highly reactive, soft, silvery metals with one valence electron that easily form strongly alkaline hydroxides.',
    ),
    'alkaline-earth': CategoryInfo(
      id: 'alkaline-earth',
      displayName: 'Alkaline Earth',
      color: alkalineEarthColor,
      description:
          'Shiny, reactive divalent metals with relatively low densities and melting points that burn with characteristic flames.',
    ),
    'transition-metal': CategoryInfo(
      id: 'transition-metal',
      displayName: 'Transition Metal',
      color: transitionMetalColor,
      description:
          'Hard, ductile, conductive metallic elements characterized by partially filled d subshells and variable oxidation states.',
    ),
    'post-transition-metal': CategoryInfo(
      id: 'post-transition-metal',
      displayName: 'Post-Transition',
      color: postTransitionMetalColor,
      description:
          'Soft, lower melting point metals between transition metals and metalloids with covalent bonding tendencies.',
    ),
    'metalloid': CategoryInfo(
      id: 'metalloid',
      displayName: 'Metalloid',
      color: metalloidColor,
      description:
          'Semiconducting chemical elements exhibiting properties intermediate between metals and nonmetals.',
    ),
    'reactive-nonmetal': CategoryInfo(
      id: 'reactive-nonmetal',
      displayName: 'Reactive Nonmetal',
      color: reactiveNonmetalColor,
      description:
          'Electronegative non-metallic elements that readily accept or share electrons to form covalent compounds and salts.',
    ),
    'noble-gas': CategoryInfo(
      id: 'noble-gas',
      displayName: 'Noble Gas',
      color: nobleGasColor,
      description:
          'Odorless, colorless, extremely stable monatomic gases characterized by completely filled outer valence electron shells.',
    ),
    'lanthanide': CategoryInfo(
      id: 'lanthanide',
      displayName: 'Lanthanide',
      color: lanthanideColor,
      description:
          'Fifteen metallic rare-earth elements with filling 4f orbitals, similar chemical behaviors, and high magnetic moments.',
    ),
    'actinide': CategoryInfo(
      id: 'actinide',
      displayName: 'Actinide',
      color: actinideColor,
      description:
          'Fifteen radioactive heavy metallic elements with filling 5f orbitals, including uranium, thorium, and transuranic isotopes.',
    ),
    'unknown': CategoryInfo(
      id: 'unknown',
      displayName: 'Unknown / Synthetic',
      color: unknownColor,
      description:
          'Recently synthesized superheavy synthetic elements whose macroscopic physical properties are currently unverified.',
    ),
  };

  /// Returns the category color for a category key, falling back to unknown color.
  static Color getCategoryColor(String categoryKey) {
    return categories[categoryKey]?.color ?? unknownColor;
  }

  /// Returns display name for a category key.
  static String getCategoryDisplayName(String categoryKey) {
    return categories[categoryKey]?.displayName ?? 'Unknown';
  }

  /// Returns category info description.
  static CategoryInfo getCategoryInfo(String categoryKey) {
    return categories[categoryKey] ??
        const CategoryInfo(
          id: 'unknown',
          displayName: 'Unknown',
          color: unknownColor,
          description: 'Elements with undetermined chemical classification.',
        );
  }

  /// Typography styles
  static TextStyle get symbolStyle => GoogleFonts.outfit(
        fontSize: 16.0,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.0,
        color: textPrimary,
      );

  static TextStyle get symbolLargeStyle => GoogleFonts.outfit(
        fontSize: 28.0,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        height: 1.1,
        color: textPrimary,
      );

  static TextStyle get numberMonoStyle => GoogleFonts.jetBrainsMono(
        fontSize: 9.0,
        fontWeight: FontWeight.w600,
        height: 1.0,
        color: textSecondary,
      );

  static TextStyle get numberMonoLargeStyle => GoogleFonts.jetBrainsMono(
        fontSize: 12.0,
        fontWeight: FontWeight.w600,
        color: textSecondary,
      );

  /// Builds the ThemeData for the application.
  static ThemeData get darkTheme {
    final baseTextTheme = GoogleFonts.interTextTheme(ThemeData.dark().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: transitionMetalColor,
      colorScheme: const ColorScheme.dark(
        primary: transitionMetalColor,
        secondary: metalloidColor,
        surface: surface,
        onSurface: textPrimary,
      ),
      textTheme: baseTextTheme.copyWith(
        headlineMedium: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        titleLarge: GoogleFonts.outfit(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 14,
          height: 1.5,
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 12.5,
          height: 1.45,
          color: textSecondary,
        ),
        labelSmall: GoogleFonts.jetBrainsMono(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: textMuted,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        scrolledUnderElevation: 2.0,
        centerTitle: false,
        iconTheme: IconThemeData(color: textPrimary),
      ),
      cardTheme: CardThemeData(
        color: surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
          side: const BorderSide(color: borderLight, width: 1.0),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: const BorderSide(color: borderLight, width: 1.0),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surfaceCard,
        modalBackgroundColor: surfaceCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: borderLight,
        thickness: 1.0,
        space: 1.0,
      ),
    );
  }
}
