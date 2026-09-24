import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/element_data.dart';
import '../theme/app_theme.dart';

/// Interactive tile representing a single element box in the periodic table.
class ElementBox extends StatelessWidget {
  final ElementData element;
  final VoidCallback? onTap;
  final double size;
  final bool isDimmed;
  final bool isSelected;

  const ElementBox({
    super.key,
    required this.element,
    this.onTap,
    this.size = 62.0,
    this.isDimmed = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = element.categoryColor;

    return AnimatedOpacity(
      opacity: isDimmed ? 0.28 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.0),
          splashColor: color.withValues(alpha: 0.35),
          highlightColor: color.withValues(alpha: 0.15),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: size,
            height: size,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: 3.5,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withValues(alpha: isSelected ? 0.35 : 0.20),
                  color.withValues(alpha: isSelected ? 0.18 : 0.07),
                ],
              ),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: isSelected
                    ? Colors.white
                    : color.withValues(alpha: isDimmed ? 0.3 : 0.75),
                width: isSelected ? 1.8 : 1.1,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: isSelected ? 0.45 : 0.15),
                  blurRadius: isSelected ? 8.0 : 4.0,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Atomic number
                Text(
                  '${element.number}',
                  style: GoogleFonts.jetBrainsMono(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 8.5,
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                  ),
                ),

                // Chemical symbol
                Center(
                  child: Text(
                    element.symbol,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 16.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      height: 1.0,
                    ),
                  ),
                ),

                // Element name
                Text(
                  element.name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 7.5,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.2,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Placeholder box for the Lanthanide (57-71) or Actinide (89-103) group indicator in the main grid.
class SeriesPlaceholderBox extends StatelessWidget {
  final String range;
  final String title;
  final Color color;
  final double size;
  final VoidCallback? onTap;

  const SeriesPlaceholderBox({
    super.key,
    required this.range,
    required this.title,
    required this.color,
    this.size = 62.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: 3.5,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: color.withValues(alpha: 0.45),
            width: 1.1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              range,
              style: GoogleFonts.jetBrainsMono(
                color: color.withValues(alpha: 0.95),
                fontSize: 9.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2.0),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 7.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
