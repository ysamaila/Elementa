import 'package:flutter/material.dart';
import '../models/element_data.dart';
import '../data/element_repository.dart';
import 'element_box.dart';

/// Renders the complete periodic table layout (18 columns x 7 main rows + 2 detached rows).
class PeriodicTableGrid extends StatelessWidget {
  final ElementRepository repository;
  final ValueChanged<ElementData> onElementSelected;
  final TransformationController? transformationController;

  static const double cellWidth = 58.0;
  static const double cellHeight = 62.0;
  static const double cellSpacing = 4.0;
  static const double headerSize = 28.0;

  const PeriodicTableGrid({
    super.key,
    required this.repository,
    required this.onElementSelected,
    this.transformationController,
  });

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: transformationController,
      minScale: 0.25,
      maxScale: 3.5,
      boundaryMargin: const EdgeInsets.all(100.0),
      constrained: false,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group Header row (1 to 18)
            _buildGroupHeaderRow(),
            const SizedBox(height: cellSpacing),

            // Rows 1 to 7: Periods 1 to 7
            for (int r = 1; r <= 7; r++) ...[
              _buildMainTableRow(r),
              const SizedBox(height: cellSpacing),
            ],

            // Separator gap between main table and f-block
            const SizedBox(height: 18.0),

            // Row 9: Lanthanides series (57 to 71)
            _buildFBlockRow(
              rowIndex: 9,
              seriesTitle: 'Lanthanides',
              color: const Color(0xFFEC4899),
            ),
            const SizedBox(height: cellSpacing),

            // Row 10: Actinides series (89 to 103)
            _buildFBlockRow(
              rowIndex: 10,
              seriesTitle: 'Actinides',
              color: const Color(0xFFF43F5E),
            ),
          ],
        ),
      ),
    );
  }

  /// Row of column group numbers (1..18)
  Widget _buildGroupHeaderRow() {
    return Row(
      children: [
        // Corner spacer matching period label width
        const SizedBox(width: headerSize + cellSpacing),

        for (int c = 1; c <= 18; c++) ...[
          Container(
            width: cellWidth,
            height: headerSize,
            alignment: Alignment.center,
            child: Text(
              '$c',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.45),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (c < 18) const SizedBox(width: cellSpacing),
        ],
      ],
    );
  }

  /// Main table row for periods 1 to 7
  Widget _buildMainTableRow(int row) {
    return Row(
      children: [
        // Period number indicator on the left
        Container(
          width: headerSize,
          height: cellHeight,
          alignment: Alignment.center,
          child: Text(
            '$row',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.45),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: cellSpacing),

        // 18 column cells
        for (int c = 1; c <= 18; c++) ...[
          _buildCell(row, c),
          if (c < 18) const SizedBox(width: cellSpacing),
        ],
      ],
    );
  }

  /// Build a single cell in the main grid
  Widget _buildCell(int row, int col) {
    // Check for Lanthanides placeholder (Period 6, Group 3)
    if (row == 6 && col == 3) {
      return const SizedBox(
        width: cellWidth,
        height: cellHeight,
        child: SeriesPlaceholderBox(
          range: '57–71',
          title: 'La–Lu',
          color: Color(0xFFEC4899),
        ),
      );
    }

    // Check for Actinides placeholder (Period 7, Group 3)
    if (row == 7 && col == 3) {
      return const SizedBox(
        width: cellWidth,
        height: cellHeight,
        child: SeriesPlaceholderBox(
          range: '89–103',
          title: 'Ac–Lr',
          color: Color(0xFFF43F5E),
        ),
      );
    }

    // Lookup element by row and column
    final element = repository.getByGrid(row, col);
    if (element != null) {
      return SizedBox(
        width: cellWidth,
        height: cellHeight,
        child: ElementBox(
          element: element,
          onTap: () => onElementSelected(element),
        ),
      );
    }

    // Empty cell in the table layout
    return const SizedBox(
      width: cellWidth,
      height: cellHeight,
    );
  }

  /// Row for Lanthanides (row 9) or Actinides (row 10)
  Widget _buildFBlockRow({
    required int rowIndex,
    required String seriesTitle,
    required Color color,
  }) {
    return Row(
      children: [
        // Left offset spacer matching period + col 1 & col 2
        const SizedBox(
          width: headerSize + cellSpacing + (cellWidth + cellSpacing) * 2,
        ),

        // 15 elements in the series (columns 3 to 17)
        for (int c = 3; c <= 17; c++) ...[
          _buildFBlockCell(rowIndex, c),
          if (c < 17) const SizedBox(width: cellSpacing),
        ],

        // Spacer for column 18
        const SizedBox(width: cellSpacing + cellWidth),
      ],
    );
  }

  Widget _buildFBlockCell(int row, int col) {
    final element = repository.getByGrid(row, col);
    if (element != null) {
      return SizedBox(
        width: cellWidth,
        height: cellHeight,
        child: ElementBox(
          element: element,
          onTap: () => onElementSelected(element),
        ),
      );
    }
    return const SizedBox(
      width: cellWidth,
      height: cellHeight,
    );
  }
}
