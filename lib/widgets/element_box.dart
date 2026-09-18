import 'package:flutter/material.dart';
import '../models/element_data.dart';

/// Interactive tile representing a single element box in the periodic table.
class ElementBox extends StatelessWidget {
  final ElementData element;
  final VoidCallback? onTap;
  final double size;

  const ElementBox({
    super.key,
    required this.element,
    this.onTap,
    this.size = 62.0,
  });

  @override
  Widget build(BuildContext context) {
    final color = element.categoryColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6.0),
        splashColor: color.withValues(alpha: 0.4),
        highlightColor: color.withValues(alpha: 0.2),
        child: Container(
          width: size,
          height: size,
          padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(
              color: color.withValues(alpha: 0.65),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.12),
                blurRadius: 4.0,
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
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontSize: 9.0,
                  fontWeight: FontWeight.w600,
                  height: 1.0,
                ),
              ),

              // Chemical symbol
              Center(
                child: Text(
                  element.symbol,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
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
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 7.5,
                  fontWeight: FontWeight.w500,
                  height: 1.0,
                ),
              ),
            ],
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
        padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(
            color: color.withValues(alpha: 0.4),
            width: 1.0,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              range,
              style: TextStyle(
                color: color.withValues(alpha: 0.9),
                fontSize: 9.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2.0),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 7.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
