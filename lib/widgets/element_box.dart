import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/element_data.dart';
import '../theme/app_theme.dart';

/// Interactive tile representing a single element box in the periodic table.
class ElementBox extends StatefulWidget {
  final ElementData element;
  final VoidCallback? onTap;
  final double size;
  final bool isDimmed;
  final bool isSelected;
  final bool isHighlighted;

  const ElementBox({
    super.key,
    required this.element,
    this.onTap,
    this.size = 62.0,
    this.isDimmed = false,
    this.isSelected = false,
    this.isHighlighted = false,
  });

  @override
  State<ElementBox> createState() => _ElementBoxState();
}

class _ElementBoxState extends State<ElementBox> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.element.categoryColor;
    final isSpecial = widget.isSelected || widget.isHighlighted;

    Widget boxContent = AnimatedScale(
      scale: _isPressed ? 0.92 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOutCubic,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: widget.size,
        height: widget.size,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: 3.5,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: isSpecial ? 0.45 : 0.20),
              color.withValues(alpha: isSpecial ? 0.28 : 0.07),
            ],
          ),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: widget.isHighlighted
                ? const Color(0xFF38BDF8)
                : widget.isSelected
                    ? Colors.white
                    : color.withValues(alpha: widget.isDimmed ? 0.3 : 0.75),
            width: isSpecial ? 2.0 : 1.1,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.isHighlighted
                  ? const Color(0xFF38BDF8).withValues(alpha: 0.6)
                  : color.withValues(alpha: widget.isSelected ? 0.5 : 0.15),
              blurRadius: isSpecial ? 10.0 : 4.0,
              spreadRadius: widget.isHighlighted ? 1.0 : 0.0,
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
              '${widget.element.number}',
              style: GoogleFonts.jetBrainsMono(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 8.5,
                fontWeight: FontWeight.w600,
                height: 1.0,
              ),
            ),

            // Chemical symbol
            Center(
              child: Text(
                widget.element.symbol,
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
              widget.element.name,
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
    );

    if (widget.isHighlighted) {
      boxContent = boxContent
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .scale(
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.06, 1.06),
            duration: 650.ms,
            curve: Curves.easeInOut,
          )
          .shimmer(
            duration: 1200.ms,
            color: const Color(0xFF38BDF8).withValues(alpha: 0.4),
          );
    }

    return AnimatedOpacity(
      opacity: widget.isDimmed ? 0.28 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: widget.onTap,
          child: boxContent,
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
