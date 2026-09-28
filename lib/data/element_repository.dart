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

  /// Searches elements by symbol, name, or atomic number.
  List<ElementData> search(String query) {
    final cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) return [];

    final asNumber = int.tryParse(cleanQuery);
    final results = <ElementData>[];
    final seen = <int>{};

    void addMatch(ElementData e) {
      if (seen.add(e.number)) {
        results.add(e);
      }
    }

    // 1. Exact atomic number match
    if (asNumber != null) {
      final numMatch = getByNumber(asNumber);
      if (numMatch != null) addMatch(numMatch);
    }

    // 2. Exact symbol match
    final exactSymbol = getBySymbol(cleanQuery);
    if (exactSymbol != null) addMatch(exactSymbol);

    // 3. Symbol starts with
    for (final e in elements) {
      if (e.symbol.toLowerCase().startsWith(cleanQuery)) {
        addMatch(e);
      }
    }

    // 4. Name starts with
    for (final e in elements) {
      if (e.name.toLowerCase().startsWith(cleanQuery)) {
        addMatch(e);
      }
    }

    // 5. Name contains
    for (final e in elements) {
      if (e.name.toLowerCase().contains(cleanQuery)) {
        addMatch(e);
      }
    }

    // 6. Atomic number starts with (e.g. searching "1" matches 1, 10-19, 100-118)
    if (asNumber != null) {
      for (final e in elements) {
        if (e.number.toString().startsWith(cleanQuery)) {
          addMatch(e);
        }
      }
    }

    return results;
  }

  /// Returns the predecessor element by atomic number (wraps around to 118 if at 1).
  ElementData? getPrevious(int currentNumber) {
    if (elements.isEmpty) return null;
    final target = currentNumber <= 1 ? 118 : currentNumber - 1;
    return getByNumber(target);
  }

  /// Returns the successor element by atomic number (wraps around to 1 if at 118).
  ElementData? getNext(int currentNumber) {
    if (elements.isEmpty) return null;
    final target = currentNumber >= 118 ? 1 : currentNumber + 1;
    return getByNumber(target);
  }

  /// Returns all unique category identifiers present in the dataset.
  List<String> getUniqueCategories() {
    final categories = <String>{};
    for (final e in elements) {
      categories.add(e.category);
    }
    return categories.toList();
  }

  /// Sets elements directly from memory (ideal for testing or preloaded caches).
  void setElements(List<ElementData> elementsList) {
    final sorted = List<ElementData>.from(elementsList)
      ..sort((a, b) => a.number.compareTo(b.number));
    _cachedElements = sorted;
    _elementsByNumber = {for (final e in sorted) e.number: e};
    _elementsBySymbol = {for (final e in sorted) e.symbol.toLowerCase(): e};
    _elementsByGrid = {for (final e in sorted) '${e.row},${e.column}': e};
  }

  /// Resets internal cache (helpful for unit testing).
  void clearCache() {
    _cachedElements = null;
    _elementsByNumber = null;
    _elementsBySymbol = null;
    _elementsByGrid = null;
  }
}
