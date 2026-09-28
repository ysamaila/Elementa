import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/element_data.dart';
import '../data/element_repository.dart';
import '../theme/app_theme.dart';

/// Interactive modal sheet or dialog displaying deep chemical and physical properties for an element,
/// with sequential navigation (prev/next) and fluid entrance animations.
class ElementDetailDialog extends StatefulWidget {
  final ElementData initialElement;
  final ElementRepository? repository;
  final VoidCallback? onCategoryTapped;
  final ValueChanged<ElementData>? onElementChanged;

  const ElementDetailDialog({
    super.key,
    required this.initialElement,
    this.repository,
    this.onCategoryTapped,
    this.onElementChanged,
  });

  /// Displays the element detail card as a modal bottom sheet on mobile devices,
  /// or as a centered dialog on larger tablet viewports.
  static Future<void> show(
    BuildContext context,
    ElementData element, {
    ElementRepository? repository,
    VoidCallback? onCategoryTapped,
    ValueChanged<ElementData>? onElementChanged,
  }) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    if (isTablet) {
      return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (context) => Dialog(
          backgroundColor: AppTheme.surfaceCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
            side: BorderSide(
              color: element.categoryColor.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          elevation: 24,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520, maxHeight: 720),
            child: ElementDetailDialog(
              initialElement: element,
              repository: repository,
              onCategoryTapped: onCategoryTapped,
              onElementChanged: onElementChanged,
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
            color: element.categoryColor.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.92,
        ),
        child: ElementDetailDialog(
          initialElement: element,
          repository: repository,
          onCategoryTapped: onCategoryTapped,
          onElementChanged: onElementChanged,
        ),
      ),
    );
  }

  @override
  State<ElementDetailDialog> createState() => _ElementDetailDialogState();
}

class _ElementDetailDialogState extends State<ElementDetailDialog> {
  late ElementData _element;

  @override
  void initState() {
    super.initState();
    _element = widget.initialElement;
  }

  void _navigateTo(ElementData target) {
    setState(() {
      _element = target;
    });
    widget.onElementChanged?.call(target);
  }

  void _goToPrevious() {
    if (widget.repository == null) return;
    final prev = widget.repository!.getPrevious(_element.number);
    if (prev != null) _navigateTo(prev);
  }

  void _goToNext() {
    if (widget.repository == null) return;
    final next = widget.repository!.getNext(_element.number);
    if (next != null) _navigateTo(next);
  }

  @override
  Widget build(BuildContext context) {
    final color = _element.categoryColor;
    final hasRepo = widget.repository != null;
    final prevElement = hasRepo ? widget.repository!.getPrevious(_element.number) : null;
    final nextElement = hasRepo ? widget.repository!.getNext(_element.number) : null;

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

          // Sequential navigation bar: Previous | Close | Next
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous element button
                if (hasRepo && prevElement != null)
                  Flexible(
                    child: TextButton.icon(
                      onPressed: _goToPrevious,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white70,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        visualDensity: VisualDensity.compact,
                      ),
                      icon: const Icon(Icons.chevron_left, size: 18),
                      label: Text(
                        '#${prevElement.number} ${prevElement.symbol}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox(width: 60),

                // Close Button
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.close, color: Colors.white70, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),

                // Next element button
                if (hasRepo && nextElement != null)
                  Flexible(
                    child: TextButton(
                      onPressed: _goToNext,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white70,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        visualDensity: VisualDensity.compact,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              '#${nextElement.number} ${nextElement.symbol}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Icon(Icons.chevron_right, size: 18),
                        ],
                      ),
                    ),
                  )
                else
                  const SizedBox(width: 60),
              ],
            ),
          ),

          // Header with glowing category color gradient
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.xs,
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
                // Element Symbol badge (Large visual anchor with entrance animation)
                Container(
                  width: 72,
                  height: 72,
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(color: color, width: 2.0),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 12.0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${_element.number}',
                        style: GoogleFonts.jetBrainsMono(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        _element.symbol,
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          height: 1.05,
                        ),
                      ),
                    ],
                  ),
                ).animate().scale(duration: 250.ms, curve: Curves.easeOutBack),
                const SizedBox(width: AppSpacing.md),

                // Name, category pill badge & state pill
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _element.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Wrap(
                        spacing: AppSpacing.xs,
                        runSpacing: AppSpacing.xs,
                        children: [
                          // Category pill
                          InkWell(
                            onTap: () {
                              if (widget.onCategoryTapped != null) {
                                Navigator.of(context).pop();
                                widget.onCategoryTapped!();
                              }
                            },
                            borderRadius: BorderRadius.circular(8.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.22),
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  color: color.withValues(alpha: 0.65),
                                  width: 1.0,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 7,
                                    height: 7,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    _element.categoryDisplayName,
                                    style: GoogleFonts.inter(
                                      color: Colors.white.withValues(alpha: 0.95),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (widget.onCategoryTapped != null) ...[
                                    const SizedBox(width: 2),
                                    Icon(
                                      Icons.chevron_right,
                                      size: 13,
                                      color: Colors.white.withValues(alpha: 0.7),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),

                          // State of matter pill
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                                width: 1.0,
                              ),
                            ),
                            child: Text(
                              _element.state,
                              style: GoogleFonts.inter(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Electron Configuration Banner (Release 4 & 5 deep scientific data)
          if (_element.electronConfiguration.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xs),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm + 2,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: color.withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.hub_outlined, size: 16, color: color),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Electron Config:',
                      style: GoogleFonts.inter(
                        color: AppTheme.textMuted,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        _element.electronConfiguration,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.jetBrainsMono(
                          color: Colors.white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.xs),

          // Section 1: Core Atomic Properties
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: _buildPropertyCard(
                    'Atomic Number',
                    '${_element.number}',
                    Icons.tag,
                    color,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _buildPropertyCard(
                    'Atomic Mass',
                    '${_element.formattedAtomicMass} u',
                    Icons.scale,
                    color,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: _buildPropertyCard(
                    'Period',
                    'Period ${_element.period}',
                    Icons.view_agenda_outlined,
                    color,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _buildPropertyCard(
                    'Group',
                    _element.group != null ? 'Group ${_element.group}' : 'f-block',
                    Icons.view_column_outlined,
                    color,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Section 2: Physical & Thermodynamic Properties (Release 4 Deeper Data)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.thermostat_outlined, size: 16, color: color),
                    const SizedBox(width: AppSpacing.xs + 2),
                    Expanded(
                      child: Text(
                        'Physical & Thermal Properties',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: _buildPropertyCard(
                        'Melting Point',
                        _element.formattedMeltingPoint,
                        Icons.ac_unit,
                        color,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _buildPropertyCard(
                        'Boiling Point',
                        _element.formattedBoilingPoint,
                        Icons.local_fire_department_outlined,
                        color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: _buildPropertyCard(
                        'Density',
                        _element.formattedDensity,
                        Icons.line_weight,
                        color,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _buildPropertyCard(
                        'Electronegativity',
                        _element.formattedElectronegativity,
                        Icons.electric_bolt_outlined,
                        color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Section 3: History & Discovery
          if (_element.discoveryYear.isNotEmpty || _element.discoveredBy.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.history_edu, size: 16, color: color),
                      const SizedBox(width: AppSpacing.xs + 2),
                      Expanded(
                        child: Text(
                          'Discovery & History',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.sm + 2),
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.xs + 2),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Icon(Icons.explore_outlined, size: 18, color: color),
                        ),
                        const SizedBox(width: AppSpacing.sm + 2),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Discovered: ${_element.discoveryYear}',
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (_element.discoveredBy.isNotEmpty)
                                Text(
                                  'By ${_element.discoveredBy}',
                                  style: GoogleFonts.inter(
                                    color: AppTheme.textMuted,
                                    fontSize: 11.5,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Section 4: Overview summary
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: color),
                    const SizedBox(width: AppSpacing.xs + 2),
                    Expanded(
                      child: Text(
                        'Overview',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: BorderRadius.circular(14.0),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Text(
                    _element.summary.isNotEmpty
                        ? _element.summary
                        : 'No chemical overview available for ${_element.name}.',
                    style: GoogleFonts.inter(
                      color: Colors.white.withValues(alpha: 0.88),
                      fontSize: 13.0,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyCard(
    String label,
    String value,
    IconData icon,
    Color accentColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Icon(icon, size: 16, color: accentColor),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: AppTheme.textMuted,
                    fontSize: 10.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
