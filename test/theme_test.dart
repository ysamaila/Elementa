import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:elementa/theme/app_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('AppSpacing Scale Tests', () {
    test('Follows 4 / 8 / 16 / 24 / 32 / 48 standard scale', () {
      expect(AppSpacing.xs, equals(4.0));
      expect(AppSpacing.sm, equals(8.0));
      expect(AppSpacing.md, equals(16.0));
      expect(AppSpacing.lg, equals(24.0));
      expect(AppSpacing.xl, equals(32.0));
      expect(AppSpacing.xxl, equals(48.0));
    });
  });

  group('AppTheme & Category Palette Tests', () {
    test('All 10 chemical categories have distinct colors and descriptions', () {
      expect(AppTheme.categories.length, equals(10));

      final uniqueColors = <Color>{};
      for (final entry in AppTheme.categories.entries) {
        final info = entry.value;
        expect(info.id.isNotEmpty, isTrue);
        expect(info.displayName.isNotEmpty, isTrue);
        expect(info.description.isNotEmpty, isTrue);
        expect(uniqueColors.contains(info.color), isFalse,
            reason: 'Color collision for category ${entry.key}');
        uniqueColors.add(info.color);
      }
    });

    test('getCategoryColor returns valid colors including fallback', () {
      expect(AppTheme.getCategoryColor('alkali-metal'), equals(AppTheme.alkaliMetalColor));
      expect(AppTheme.getCategoryColor('noble-gas'), equals(AppTheme.nobleGasColor));
      expect(AppTheme.getCategoryColor('non-existent'), equals(AppTheme.unknownColor));
    });

    test('getCategoryDisplayName returns human-friendly labels', () {
      expect(AppTheme.getCategoryDisplayName('alkali-metal'), equals('Alkali Metal'));
      expect(AppTheme.getCategoryDisplayName('alkaline-earth'), equals('Alkaline Earth'));
      expect(AppTheme.getCategoryDisplayName('unknown'), equals('Unknown / Synthetic'));
    });

    test('darkTheme generates valid ThemeData without errors', () {
      final theme = AppTheme.darkTheme;
      expect(theme.brightness, equals(Brightness.dark));
      expect(theme.scaffoldBackgroundColor, equals(AppTheme.background));
      expect(theme.useMaterial3, isTrue);
    });
  });
}
