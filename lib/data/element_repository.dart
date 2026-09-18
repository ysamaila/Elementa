import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/element_data.dart';

/// Repository responsible for loading and querying chemical elements from assets.
class ElementRepository {
  List<ElementData>? _cachedElements;
  Map<int, ElementData>? _elementsByNumber;
  Map<String, ElementData>? _elementsBySymbol;
  Map<String, ElementData>? _elementsByGrid; // key: "$row,$col"

  /// Returns cached elements if already loaded, or empty list.
  List<ElementData> get elements => _cachedElements ?? [];

  /// Loads elements from the bundled JSON asset.
  Future<List<ElementData>> loadElements({AssetBundle? bundle}) async {
    if (_cachedElements != null) {
      return _cachedElements!;
    }

    final targetBundle = bundle ?? rootBundle;
    final jsonString = await targetBundle.loadString('assets/data/elements.json');
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;

    final parsedElements = jsonList
        .map((item) => ElementData.fromJson(item as Map<String, dynamic>))
        .toList();

    // Sort by atomic number ascending
    parsedElements.sort((a, b) => a.number.compareTo(b.number));

    _cachedElements = parsedElements;
    _elementsByNumber = {for (final e in parsedElements) e.number: e};
    _elementsBySymbol = {for (final e in parsedElements) e.symbol.toLowerCase(): e};
    _elementsByGrid = {for (final e in parsedElements) '${e.row},${e.column}': e};

    return parsedElements;
  }

  /// Looks up an element by atomic number (1..118).
  ElementData? getByNumber(int number) {
    return _elementsByNumber?[number];
  }

  /// Looks up an element by chemical symbol (e.g. "H", "Au").
  ElementData? getBySymbol(String symbol) {
    return _elementsBySymbol?[symbol.toLowerCase()];
  }

  /// Looks up an element by its grid coordinates (row 1..10, col 1..18).
  ElementData? getByGrid(int row, int col) {
    return _elementsByGrid?['$row,$col'];
  }

  /// Returns all elements belonging to a specific category.
  List<ElementData> getByCategory(String category) {
    return elements.where((e) => e.category == category).toList();
  }

  /// Returns all unique category identifiers present in the dataset.
  List<String> getUniqueCategories() {
    final categories = <String>{};
    for (final e in elements) {
      categories.add(e.category);
    }
    return categories.toList();
  }

  /// Resets internal cache (helpful for unit testing).
  void clearCache() {
    _cachedElements = null;
    _elementsByNumber = null;
    _elementsBySymbol = null;
    _elementsByGrid = null;
  }
}
