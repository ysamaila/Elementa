import 'package:flutter/material.dart';

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
  String get categoryDisplayName {
    switch (category) {
      case 'alkali-metal':
        return 'Alkali Metal';
      case 'alkaline-earth':
        return 'Alkaline Earth Metal';
      case 'transition-metal':
        return 'Transition Metal';
      case 'post-transition-metal':
        return 'Post-Transition Metal';
      case 'metalloid':
        return 'Metalloid';
      case 'reactive-nonmetal':
        return 'Reactive Nonmetal';
      case 'noble-gas':
        return 'Noble Gas';
      case 'lanthanide':
        return 'Lanthanide';
      case 'actinide':
        return 'Actinide';
      case 'unknown':
      default:
        return 'Unknown';
    }
  }

  /// Distinct, accessible color for each chemical category.
  Color get categoryColor {
    switch (category) {
      case 'alkali-metal':
        return const Color(0xFFEF4444); // Crimson red
      case 'alkaline-earth':
        return const Color(0xFFF97316); // Bright orange
      case 'transition-metal':
        return const Color(0xFF3B82F6); // Vibrant blue
      case 'post-transition-metal':
        return const Color(0xFF06B6D4); // Cyan
      case 'metalloid':
        return const Color(0xFF10B981); // Emerald green
      case 'reactive-nonmetal':
        return const Color(0xFF84CC16); // Lime green
      case 'noble-gas':
        return const Color(0xFFA855F7); // Purple
      case 'lanthanide':
        return const Color(0xFFEC4899); // Pink
      case 'actinide':
        return const Color(0xFFF43F5E); // Rose
      case 'unknown':
      default:
        return const Color(0xFF64748B); // Slate
    }
  }

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
