import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/element_data.dart';
import '../data/element_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/periodic_table_grid.dart';
import '../widgets/element_detail_dialog.dart';
import '../widgets/category_detail_sheet.dart';

/// Main screen displaying the interactive Periodic Table of Elements
/// with real-time search, category filtering, element focusing, and pan/zoom controls.
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
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  String? _errorMessage;
  String? _highlightedCategory;

  // Search & Focus state (Release 3, 4, 5)
  bool _isSearchActive = false;
  String _searchQuery = '';
  List<ElementData> _searchResults = [];
  Set<int>? _matchingElementNumbers;
  int? _focusedElementNumber;

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
    _searchController.dispose();
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

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.trim();
      if (_searchQuery.isEmpty) {
        _searchResults = [];
        _matchingElementNumbers = null;
        _focusedElementNumber = null;
      } else {
        _searchResults = _repository.search(_searchQuery);
        _matchingElementNumbers = _searchResults.map((e) => e.number).toSet();
        if (_searchResults.isNotEmpty) {
          _focusedElementNumber = _searchResults.first.number;
          _focusElement(_searchResults.first);
        } else {
          _focusedElementNumber = null;
        }
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _searchResults = [];
      _matchingElementNumbers = null;
      _focusedElementNumber = null;
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearchActive = !_isSearchActive;
      if (!_isSearchActive) {
        _clearSearch();
      }
    });
  }

  void _focusElement(ElementData element) {
    setState(() {
      _focusedElementNumber = element.number;
    });

    final centerOffset = PeriodicTableGrid.getElementCenterOffset(element.row, element.column);
    final currentScale = _transformationController.value.getMaxScaleOnAxis().clamp(0.9, 1.6);
    final size = MediaQuery.of(context).size;
    
    // Calculate translation to position the target cell comfortably in the center
    final targetX = (size.width / 2) - (centerOffset.dx * currentScale);
    final targetY = ((size.height - 180) / 2) - (centerOffset.dy * currentScale);

    _transformationController.value = Matrix4.identity()
      ..scaleByDouble(currentScale, currentScale, 1.0, 1.0)
      ..setTranslationRaw(targetX, targetY, 0.0);
  }

  void _onElementTapped(ElementData element) {
    ElementDetailDialog.show(
      context,
      element,
      repository: _repository,
      onCategoryTapped: () => _onCategoryTapped(element.category),
      onElementChanged: (newElement) {
        _focusElement(newElement);
      },
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
        title: _isSearchActive ? _buildSearchAppBarField() : _buildAppBarTitle(),
        actions: [
          IconButton(
            visualDensity: VisualDensity.compact,
            iconSize: 20,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            padding: const EdgeInsets.all(AppSpacing.xs + 2),
            icon: Icon(
              _isSearchActive ? Icons.close : Icons.search,
              color: _isSearchActive ? const Color(0xFF38BDF8) : AppTheme.textSecondary,
            ),
            tooltip: _isSearchActive ? 'Close Search' : 'Search Elements',
            onPressed: _toggleSearch,
          ),
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

  Widget _buildAppBarTitle() {
    return Row(
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
    );
  }

  Widget _buildSearchAppBarField() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      onChanged: _onSearchChanged,
      style: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 14.5,
      ),
      decoration: InputDecoration(
        hintText: 'Search symbol, name, or # (e.g. Au, Gold, 79)...',
        hintStyle: GoogleFonts.inter(
          color: Colors.white.withValues(alpha: 0.45),
          fontSize: 13.0,
        ),
        border: InputBorder.none,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
      ),
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
        // Real-time search result chips bar (if search is active with results)
        if (_isSearchActive && _searchQuery.isNotEmpty) _buildSearchResultsBar(),

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
                matchingElementNumbers: _matchingElementNumbers,
                focusedElementNumber: _focusedElementNumber,
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

  /// Horizontal bar showing matched elements for quick tapping
  Widget _buildSearchResultsBar() {
    if (_searchResults.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
        color: AppTheme.surfaceCard,
        child: Text(
          'No elements match "$_searchQuery"',
          style: GoogleFonts.inter(
            color: AppTheme.textMuted,
            fontSize: 12.0,
          ),
        ),
      );
    }

    return Container(
      height: 44,
      color: AppTheme.surfaceCard,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
        scrollDirection: Axis.horizontal,
        itemCount: _searchResults.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final e = _searchResults[index];
          final isFocused = _focusedElementNumber == e.number;

          return ActionChip(
            onPressed: () {
              _focusElement(e);
            },
            backgroundColor: isFocused
                ? const Color(0xFF38BDF8).withValues(alpha: 0.25)
                : e.categoryColor.withValues(alpha: 0.15),
            side: BorderSide(
              color: isFocused ? const Color(0xFF38BDF8) : e.categoryColor.withValues(alpha: 0.6),
              width: isFocused ? 1.5 : 1.0,
            ),
            labelPadding: const EdgeInsets.symmetric(horizontal: 4),
            avatar: Container(
              width: 16,
              height: 16,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: e.categoryColor,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${e.number}',
                style: GoogleFonts.jetBrainsMono(
                  color: Colors.black,
                  fontSize: 8.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            label: Text(
              '${e.symbol} • ${e.name}',
              style: GoogleFonts.inter(
                color: isFocused ? Colors.white : Colors.white.withValues(alpha: 0.9),
                fontSize: 11.5,
                fontWeight: isFocused ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          );
        },
      ),
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
                            color: cat.color.withValues(alpha: 0.5),
                            blurRadius: 4.0,
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
                    const SizedBox(width: 4),
                    Text(
                      '($count)',
                      style: GoogleFonts.jetBrainsMono(
                        color: Colors.white.withValues(alpha: 0.45),
                        fontSize: 10.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Active filter notification strip when a category is selected
  Widget _buildActiveFilterBanner() {
    final catInfo = AppTheme.getCategoryInfo(_highlightedCategory!);
    final count = _repository.getByCategory(_highlightedCategory!).length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs + 1,
      ),
      decoration: BoxDecoration(
        color: catInfo.color.withValues(alpha: 0.15),
        border: Border(
          bottom: BorderSide(
            color: catInfo.color.withValues(alpha: 0.35),
          ),
        ),
      ),
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
              'Filtering: ${catInfo.displayName} ($count elements) • Other categories dimmed',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: Colors.white.withValues(alpha: 0.95),
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
                horizontal: AppSpacing.xs + 2,
                vertical: 2,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Clear',
                    style: GoogleFonts.inter(
                      color: catInfo.color,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(Icons.close, size: 13, color: catInfo.color),
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
              '• Search & Filter: Search by element name, symbol, or atomic number. Matches are highlighted and focused on the table.\n'
              '• Deeper Properties: Inspect electron configurations, melting/boiling points, density, electronegativity, and discovery history.\n'
              '• Sequential Navigation: Step smoothly through elements sequentially with Previous/Next controls.\n'
              '• Interactive Legend: Tap any category chip in the top bar to inspect its scientific definition and highlight elements on the grid.\n'
              '• Zoom & Pan: Drag to pan across groups 1–18; pinch or use the zoom buttons to inspect any element.',
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
