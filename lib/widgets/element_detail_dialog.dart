import 'package:flutter/material.dart';
import '../models/element_data.dart';

/// Modal dialog displaying full detailed information about a selected element.
class ElementDetailDialog extends StatelessWidget {
  final ElementData element;

  const ElementDetailDialog({
    super.key,
    required this.element,
  });

  static Future<void> show(BuildContext context, ElementData element) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => ElementDetailDialog(element: element),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = element.categoryColor;

    return Dialog(
      backgroundColor: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(color: color.withValues(alpha: 0.5), width: 1.5),
      ),
      elevation: 24,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with glowing category color banner
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(18.0)),
                  gradient: LinearGradient(
                    colors: [
                      color.withValues(alpha: 0.35),
                      const Color(0xFF1E293B),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Row(
                  children: [
                    // Element Symbol badge
                    Container(
                      width: 72,
                      height: 72,
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(14.0),
                        border: Border.all(color: color, width: 2.0),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.3),
                            blurRadius: 10.0,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${element.number}',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            element.symbol,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16.0),

                    // Name, category badge
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            element.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6.0),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: color.withValues(alpha: 0.7),
                                width: 1.0,
                              ),
                            ),
                            child: Text(
                              element.categoryDisplayName,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.95),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Close icon button
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              // Properties grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildPropertyCard(
                        'Atomic Number',
                        '${element.number}',
                        Icons.tag,
                        color,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildPropertyCard(
                        'Atomic Mass',
                        '${element.formattedAtomicMass} u',
                        Icons.scale,
                        color,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildPropertyCard(
                        'Period',
                        '${element.period}',
                        Icons.view_agenda,
                        color,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildPropertyCard(
                        'Group',
                        element.group != null ? '${element.group}' : 'N/A',
                        Icons.view_column,
                        color,
                      ),
                    ),
                  ],
                ),
              ),

              // Summary section
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, size: 18, color: color),
                        const SizedBox(width: 8),
                        const Text(
                          'Overview',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      padding: const EdgeInsets.all(14.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: Text(
                        element.summary.isNotEmpty
                            ? element.summary
                            : 'No summary available for ${element.name}.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 13.5,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: accentColor.withValues(alpha: 0.8)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
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
