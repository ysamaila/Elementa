import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/element_data.dart';
import '../data/element_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/periodic_table_grid.dart';
import '../widgets/element_detail_dialog.dart';
import '../widgets/category_detail_sheet.dart';

/// Main screen displaying the interactive Periodic Table of Elements.
class PeriodicTableScreen extends StatefulWidget {
  final ElementRepository? repository;

  const PeriodicTableScreen({super.key, this.repository});

  @override
  State<PeriodicTableScreen> createState() => _PeriodicTableScreenState();
}

class _PeriodicTableScreenState extends State<PeriodicTableScreen> {
  late final ElementRepository _repository;
  final TransformationController _transformationController =
      TransformationController();

  bool _isLoading = true;
  String? _errorMessage;
  String? _highlightedCategory;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? ElementRepository();
    if (_repository.elements.isNotEmpty) {
      _isLoading = false;
    } else {
      _loadElements();
    }
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  Future<void> _loadElements() async {
    try {
      await _repository.loadElements();
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load elements: $e';
        });
      }
    }
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  void _zoomIn() {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    if (currentScale < 3.0) {
      _transformationController.value = _transformationController.value.clone()
        ..scaleByDouble(1.25, 1.25, 1.0, 1.0);
    }
  }

  void _zoomOut() {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    if (currentScale > 0.3) {
      _transformationController.value = _transformationController.value.clone()
        ..scaleByDouble(0.8, 0.8, 1.0, 1.0);
    }
  }

  void _onElementTapped(ElementData element) {
    ElementDetailDialog.show(
      context,
      element,
      onCategoryTapped: () => _onCategoryTapped(element.category),
    );
  }

  void _onCategoryTapped(String categoryKey) {
    final categoryInfo = AppTheme.getCategoryInfo(categoryKey);
    final elementsInCategory = _repository.getByCategory(categoryKey);

    CategoryDetailSheet.show(
      context: context,
      categoryInfo: categoryInfo,
      elements: elementsInCategory,
      onElementSelected: _onElementTapped,
      isHighlighted: _highlightedCategory == categoryKey,
      onHighlightToggle: () {
        setState(() {
          if (_highlightedCategory == categoryKey) {
            _highlightedCategory = null;
          } else {
            _highlightedCategory = categoryKey;
          }
        });
        Navigator.of(context).pop();
      },
    );
  }

  void _clearHighlight() {
    setState(() {
      _highlightedCategory = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        titleSpacing: AppSpacing.md,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xs + 2),
              decoration: BoxDecoration(
                color: AppTheme.transitionMetalColor.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: AppTheme.transitionMetalColor.withValues(alpha: 0.5),
                ),
              ),
              child: const Icon(
                Icons.science,
                color: AppTheme.transitionMetalColor,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.sm + 2),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Elementa',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                      letterSpacing: 0.2,
                    ),
                  ),
                  Text(
                    'Periodic Table of Elements',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            visualDensity: VisualDensity.compact,
            iconSize: 20,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            padding: const EdgeInsets.all(AppSpacing.xs + 2),
            icon: const Icon(Icons.zoom_out, color: AppTheme.textSecondary),
            tooltip: 'Zoom Out',
            onPressed: _zoomOut,
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            iconSize: 20,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            padding: const EdgeInsets.all(AppSpacing.xs + 2),
            icon: const Icon(Icons.zoom_in, color: AppTheme.textSecondary),
            tooltip: 'Zoom In',
            onPressed: _zoomIn,
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            iconSize: 20,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            padding: const EdgeInsets.all(AppSpacing.xs + 2),
            icon: const Icon(Icons.fit_screen, color: AppTheme.textSecondary),
            tooltip: 'Reset View',
            onPressed: _resetZoom,
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            iconSize: 20,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            padding: const EdgeInsets.all(AppSpacing.xs + 2),
            icon: const Icon(Icons.info_outline, color: AppTheme.textSecondary),
            tooltip: 'App Info',
            onPressed: _showInfoDialog,
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppTheme.transitionMetalColor,
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
              const SizedBox(height: AppSpacing.md),
              Text(
                _errorMessage!,
                style: GoogleFonts.inter(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _errorMessage = null;
                  });
                  _loadElements();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        // Persistent, tappable category legend bar
        _buildCategoryLegendBar(),

        // Active category filter banner (if highlighted)
        if (_highlightedCategory != null) _buildActiveFilterBanner(),

        // Main table canvas with pan/zoom
        Expanded(
          child: Stack(
            children: [
              PeriodicTableGrid(
                repository: _repository,
                onElementSelected: _onElementTapped,
                onCategorySelected: _onCategoryTapped,
                transformationController: _transformationController,
                highlightedCategory: _highlightedCategory,
              ),

              // Navigation hint pill at bottom
              Positioned(
                bottom: AppSpacing.md,
                left: AppSpacing.md,
                right: AppSpacing.md,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceCard.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.35),
                          blurRadius: 8.0,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.pinch,
                          size: 16,
                          color: Colors.white.withValues(alpha: 0.75),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Flexible(
                          child: Text(
                            'Pinch to zoom • Pan to explore • Tap for details',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Persistent, tappable legend allowing users to identify and inspect categories
  Widget _buildCategoryLegendBar() {
    final categories = AppTheme.categories.values.toList();

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppTheme.surface.withValues(alpha: 0.85),
        border: const Border(
          bottom: BorderSide(
            color: AppTheme.borderLight,
          ),
        ),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = _highlightedCategory == cat.id;
          final count = _repository.getByCategory(cat.id).length;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _onCategoryTapped(cat.id),
              borderRadius: BorderRadius.circular(16.0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm + 2,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? cat.color.withValues(alpha: 0.28)
                      : cat.color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: isSelected
                        ? cat.color
                        : cat.color.withValues(alpha: 0.35),
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: cat.color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: cat.color.withValues(alpha: 0.6),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs + 2),
                    Text(
                      cat.displayName,
                      style: GoogleFonts.inter(
                        color: isSelected
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.85),
                        fontSize: 11.5,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                    if (count > 0) ...[
                      const SizedBox(width: 4),
                      Text(
                        '($count)',
                        style: GoogleFonts.jetBrainsMono(
                          color: isSelected
                              ? cat.color
                              : Colors.white.withValues(alpha: 0.45),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Banner displayed when a category filter / highlight is active
  Widget _buildActiveFilterBanner() {
    final catInfo = AppTheme.getCategoryInfo(_highlightedCategory!);
    final count = _repository.getByCategory(_highlightedCategory!).length;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs + 2,
      ),
      color: catInfo.color.withValues(alpha: 0.16),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: catInfo.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Showing ${catInfo.displayName} ($count elements) • Tap legend or button to reset',
              style: GoogleFonts.inter(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          InkWell(
            onTap: _clearHighlight,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 2,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.close, size: 14, color: Colors.white70),
                  const SizedBox(width: 2),
                  Text(
                    'Clear',
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppTheme.borderLight),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xs + 2),
              decoration: BoxDecoration(
                color: AppTheme.transitionMetalColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.science,
                color: AppTheme.transitionMetalColor,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.sm + 2),
            Text(
              'About Elementa',
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Elementa is an offline interactive periodic table reference application covering all 118 chemical elements from Hydrogen to Oganesson.',
              style: GoogleFonts.inter(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 13.5,
                height: 1.45,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              '• Interactive Legend: Tap any category chip in the top bar to inspect its scientific definition and highlight elements on the grid.\n'
              '• Zoom & Pan: Drag to pan across groups 1–18; pinch or use the zoom buttons to inspect any element.\n'
              '• Element Details: Tap any element tile to open its complete detail card with atomic weight, group, period, and summary.',
              style: GoogleFonts.inter(
                color: Colors.white.withValues(alpha: 0.65),
                fontSize: 12.5,
                height: 1.55,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Got it',
              style: GoogleFonts.inter(
                color: AppTheme.transitionMetalColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
