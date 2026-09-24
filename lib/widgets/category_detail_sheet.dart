import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/element_data.dart';
import '../theme/app_theme.dart';

/// Modal bottom sheet presenting in-depth chemical classification information for a selected category.
class CategoryDetailSheet extends StatelessWidget {
  final CategoryInfo categoryInfo;
  final List<ElementData> elements;
  final ValueChanged<ElementData>? onElementSelected;
  final VoidCallback? onHighlightToggle;
  final bool isHighlighted;

  const CategoryDetailSheet({
    super.key,
    required this.categoryInfo,
    required this.elements,
    this.onElementSelected,
    this.onHighlightToggle,
    this.isHighlighted = false,
  });

  static Future<void> show({
    required BuildContext context,
    required CategoryInfo categoryInfo,
    required List<ElementData> elements,
    ValueChanged<ElementData>? onElementSelected,
    VoidCallback? onHighlightToggle,
    bool isHighlighted = false,
  }) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    if (isTablet) {
      return showDialog<void>(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: AppTheme.surfaceCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
            side: BorderSide(
              color: categoryInfo.color.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480, maxHeight: 600),
            child: CategoryDetailSheet(
              categoryInfo: categoryInfo,
              elements: elements,
              onElementSelected: onElementSelected,
              onHighlightToggle: onHighlightToggle,
              isHighlighted: isHighlighted,
            ),
          ),
        ),
      );
    }

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
          border: Border.all(
            color: categoryInfo.color.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: CategoryDetailSheet(
          categoryInfo: categoryInfo,
          elements: elements,
          onElementSelected: onElementSelected,
          onHighlightToggle: onHighlightToggle,
          isHighlighted: isHighlighted,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = categoryInfo.color;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle for bottom sheet
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.xs),
              width: 36.0,
              height: 4.0,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),

          // Header banner
          Container(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.32),
                  AppTheme.surfaceCard,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Row(
              children: [
                // Category icon dot
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: color, width: 2.0),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.35),
                        blurRadius: 8.0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm + 2),

                // Category title & count
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        categoryInfo.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${elements.length} ${elements.length == 1 ? "element" : "elements"} in this family',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Close button
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          // Description card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(14.0),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
              child: Text(
                categoryInfo.description,
                style: GoogleFonts.inter(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 13.0,
                  height: 1.45,
                ),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Elements list section header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Elements in Series',
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (onHighlightToggle != null)
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      foregroundColor: isHighlighted ? Colors.white : color,
                    ),
                    onPressed: () {
                      onHighlightToggle?.call();
                    },
                    icon: Icon(
                      isHighlighted ? Icons.visibility_off : Icons.filter_list,
                      size: 16,
                    ),
                    label: Text(
                      isHighlighted ? 'Clear Highlight' : 'Highlight on Grid',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xs),

          // Chips of all elements in this category
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Wrap(
              spacing: AppSpacing.xs + 2,
              runSpacing: AppSpacing.xs + 2,
              children: elements.map((element) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    onElementSelected?.call(element);
                  },
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: color.withValues(alpha: 0.4),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${element.number}',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 9.5,
                            color: Colors.white60,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          element.symbol,
                          style: GoogleFonts.outfit(
                            fontSize: 12.5,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          element.name,
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
