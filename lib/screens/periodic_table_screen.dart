import 'package:flutter/material.dart';
import '../models/element_data.dart';
import '../data/element_repository.dart';
import '../widgets/periodic_table_grid.dart';
import '../widgets/element_detail_dialog.dart';

/// Main screen displaying the interactive Periodic Table of Elements.
class PeriodicTableScreen extends StatefulWidget {
  const PeriodicTableScreen({super.key});

  @override
  State<PeriodicTableScreen> createState() => _PeriodicTableScreenState();
}

class _PeriodicTableScreenState extends State<PeriodicTableScreen> {
  final ElementRepository _repository = ElementRepository();
  final TransformationController _transformationController =
      TransformationController();

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadElements();
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
    ElementDetailDialog.show(context, element);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Deep navy / slate 900
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 2,
        titleSpacing: 12.0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.5),
                ),
              ),
              child: const Icon(
                Icons.science,
                color: Color(0xFF60A5FA),
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            const Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Elementa',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.4,
                    ),
                  ),
                  Text(
                    'Periodic Table',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: Colors.white60,
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
            padding: const EdgeInsets.all(6),
            icon: const Icon(Icons.zoom_out, color: Colors.white70),
            tooltip: 'Zoom Out',
            onPressed: _zoomOut,
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            iconSize: 20,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            padding: const EdgeInsets.all(6),
            icon: const Icon(Icons.zoom_in, color: Colors.white70),
            tooltip: 'Zoom In',
            onPressed: _zoomIn,
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            iconSize: 20,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            padding: const EdgeInsets.all(6),
            icon: const Icon(Icons.fit_screen, color: Colors.white70),
            tooltip: 'Reset View',
            onPressed: _resetZoom,
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            iconSize: 20,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            padding: const EdgeInsets.all(6),
            icon: const Icon(Icons.info_outline, color: Colors.white70),
            tooltip: 'App Info',
            onPressed: _showInfoDialog,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF3B82F6),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
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
        // Category legend bar
        _buildCategoryLegendBar(),

        // Main table canvas with pan/zoom
        Expanded(
          child: Stack(
            children: [
              PeriodicTableGrid(
                repository: _repository,
                onElementSelected: _onElementTapped,
                transformationController: _transformationController,
              ),

              // Navigation hint pill at bottom
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B).withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
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
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Pinch to zoom • Pan to move • Tap for details',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
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

  Widget _buildCategoryLegendBar() {
    const categories = [
      {'name': 'Alkali Metal', 'color': Color(0xFFEF4444)},
      {'name': 'Alkaline Earth', 'color': Color(0xFFF97316)},
      {'name': 'Transition Metal', 'color': Color(0xFF3B82F6)},
      {'name': 'Post-Transition', 'color': Color(0xFF06B6D4)},
      {'name': 'Metalloid', 'color': Color(0xFF10B981)},
      {'name': 'Reactive Nonmetal', 'color': Color(0xFF84CC16)},
      {'name': 'Noble Gas', 'color': Color(0xFFA855F7)},
      {'name': 'Lanthanide', 'color': Color(0xFFEC4899)},
      {'name': 'Actinide', 'color': Color(0xFFF43F5E)},
      {'name': 'Unknown', 'color': Color(0xFF64748B)},
    ];

    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.6),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.06),
          ),
        ),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final color = cat['color'] as Color;
          final name = cat['name'] as String;

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.5),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Text(
                name,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showInfoDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.science, color: Color(0xFF60A5FA)),
            SizedBox(width: 10),
            Text(
              'About Elementa',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Elementa is an offline interactive periodic table reference app covering all 118 verified elements.',
              style: TextStyle(color: Colors.white70, fontSize: 13.5, height: 1.4),
            ),
            SizedBox(height: 12),
            Text(
              '• Drag with your finger to pan across groups and periods.\n'
              '• Pinch in/out or use the zoom buttons in the app bar to adjust scaling.\n'
              '• Tap any element to inspect its atomic number, mass, group, period, category, and overview.',
              style: TextStyle(color: Colors.white60, fontSize: 12.5, height: 1.5),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
