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

  // Deeper scientific & physical properties (Releases 3-5)
  final String electronConfiguration;
  final String state;
  final double? meltingPoint;
  final double? boilingPoint;
  final double? density;
  final double? electronegativity;
  final String discoveryYear;
  final String discoveredBy;

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
    this.electronConfiguration = '',
    this.state = 'Unknown',
    this.meltingPoint,
    this.boilingPoint,
    this.density,
    this.electronegativity,
    this.discoveryYear = '',
    this.discoveredBy = '',
  });

  factory ElementData.fromJson(Map<String, dynamic> json) {
    final rawMass = json['atomicMass'] ?? json['mass'];
    double parsedMass = 0.0;
    if (rawMass is num) {
      parsedMass = rawMass.toDouble();
    } else if (rawMass is String) {
      parsedMass = double.tryParse(rawMass) ?? 0.0;
    }

    double? parseOptionalDouble(dynamic val) {
      if (val == null) return null;
      if (val is num) return val.toDouble();
      if (val is String) return double.tryParse(val);
      return null;
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
      electronConfiguration: json['electronConfiguration'] as String? ?? '',
      state: json['state'] as String? ?? 'Unknown',
      meltingPoint: parseOptionalDouble(json['meltingPoint']),
      boilingPoint: parseOptionalDouble(json['boilingPoint']),
      density: parseOptionalDouble(json['density']),
      electronegativity: parseOptionalDouble(json['electronegativity']),
      discoveryYear: json['discoveryYear']?.toString() ?? '',
      discoveredBy: json['discoveredBy'] as String? ?? '',
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
      'electronConfiguration': electronConfiguration,
      'state': state,
      'meltingPoint': meltingPoint,
      'boilingPoint': boilingPoint,
      'density': density,
      'electronegativity': electronegativity,
      'discoveryYear': discoveryYear,
      'discoveredBy': discoveredBy,
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

  /// Formatted melting point in °C
  String get formattedMeltingPoint =>
      meltingPoint != null ? '${meltingPoint!.toStringAsFixed(1)} °C' : 'Unknown';

  /// Formatted boiling point in °C
  String get formattedBoilingPoint =>
      boilingPoint != null ? '${boilingPoint!.toStringAsFixed(1)} °C' : 'Unknown';

  /// Formatted density with unit
  String get formattedDensity {
    if (density == null) return 'Unknown';
    final unit = state.toLowerCase() == 'gas' ? 'g/L' : 'g/cm³';
    final valStr = density! < 1 ? density!.toStringAsFixed(4) : density!.toStringAsFixed(2);
    return '$valStr $unit';
  }

  /// Formatted electronegativity on the Pauling scale
  String get formattedElectronegativity =>
      electronegativity != null ? electronegativity!.toStringAsFixed(2) : 'N/A';

  /// Formatted discovery attribution
  String get formattedDiscovery {
    if (discoveryYear.isEmpty && discoveredBy.isEmpty) return 'Ancient';
    if (discoveredBy.isEmpty) return discoveryYear;
    return '$discoveryYear — $discoveredBy';
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
