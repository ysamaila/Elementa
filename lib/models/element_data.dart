import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Represents a single chemical element on the periodic table.
class ElementData {
  final int number;
  final String symbol;
  final String name;
  final double atomicMass;
  final String category;
  final int period;
  final int? group;
  final int row;
  final int column;
  final String summary;

  const ElementData({
    required this.number,
    required this.symbol,
    required this.name,
    required this.atomicMass,
    required this.category,
    required this.period,
    this.group,
    required this.row,
    required this.column,
    required this.summary,
  });

  factory ElementData.fromJson(Map<String, dynamic> json) {
    final rawMass = json['atomicMass'] ?? json['mass'];
    double parsedMass = 0.0;
    if (rawMass is num) {
      parsedMass = rawMass.toDouble();
    } else if (rawMass is String) {
      parsedMass = double.tryParse(rawMass) ?? 0.0;
    }

    return ElementData(
      number: json['number'] as int,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      atomicMass: parsedMass,
      category: json['category'] as String,
      period: json['period'] as int,
      group: json['group'] as int?,
      row: json['row'] as int,
      column: json['column'] as int,
      summary: json['summary'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'symbol': symbol,
      'name': name,
      'atomicMass': atomicMass,
      'category': category,
      'period': period,
      'group': group,
      'row': row,
      'column': column,
      'summary': summary,
    };
  }

  /// Returns a human-friendly category label.
  String get categoryDisplayName => AppTheme.getCategoryDisplayName(category);

  /// Distinct, accessible color for each chemical category.
  Color get categoryColor => AppTheme.getCategoryColor(category);

  /// Formatted atomic mass string (rounded to 3 decimal places or integer if integer).
  String get formattedAtomicMass {
    if (atomicMass == atomicMass.roundToDouble()) {
      return atomicMass.toInt().toString();
    }
    return atomicMass.toStringAsFixed(3);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ElementData &&
          runtimeType == other.runtimeType &&
          number == other.number;

  @override
  int get hashCode => number.hashCode;
}
