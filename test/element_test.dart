import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:elementa/models/element_data.dart';
import 'package:elementa/data/element_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Elements Dataset & Model Tests', () {
    late List<ElementData> elements;

    setUpAll(() {
      final file = File('assets/data/elements.json');
      final jsonString = file.readAsStringSync();
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      elements = jsonList
          .map((item) => ElementData.fromJson(item as Map<String, dynamic>))
          .toList();
    });

    test('Contains exactly 118 elements', () {
      expect(elements.length, equals(118));
    });

    test('Atomic numbers are contiguous from 1 to 118 without duplicates', () {
      final numbers = elements.map((e) => e.number).toSet();
      expect(numbers.length, equals(118));

      for (int i = 1; i <= 118; i++) {
        expect(numbers.contains(i), isTrue,
            reason: 'Missing element number $i');
      }
    });

    test('Chemical symbols are unique and non-empty', () {
      final symbols = <String>{};
      for (final e in elements) {
        expect(e.symbol.isNotEmpty, isTrue);
        expect(symbols.contains(e.symbol), isFalse,
            reason: 'Duplicate symbol ${e.symbol}');
        symbols.add(e.symbol);
      }
    });

    test('All elements have valid names, positive masses, and summaries', () {
      for (final e in elements) {
        expect(e.name.isNotEmpty, isTrue,
            reason: 'Element ${e.number} has empty name');
        expect(e.atomicMass > 0, isTrue,
            reason: 'Element ${e.number} has non-positive mass');
        expect(e.summary.isNotEmpty, isTrue,
            reason: 'Element ${e.number} has empty summary');
      }
    });

    test('Grid coordinates are within valid bounds', () {
      for (final e in elements) {
        expect(e.row >= 1 && e.row <= 10, isTrue,
            reason: 'Element ${e.symbol} row out of bounds: ${e.row}');
        expect(e.column >= 1 && e.column <= 18, isTrue,
            reason: 'Element ${e.symbol} column out of bounds: ${e.column}');
      }
    });

    test('Lanthanides (57..71) are on row 9, columns 3..17', () {
      final lanthanides =
          elements.where((e) => e.number >= 57 && e.number <= 71).toList();
      expect(lanthanides.length, equals(15));

      for (int i = 0; i < lanthanides.length; i++) {
        final element = lanthanides[i];
        expect(element.row, equals(9),
            reason: 'Element ${element.symbol} should be in row 9');
        expect(element.column, equals(3 + i),
            reason: 'Element ${element.symbol} should be in column ${3 + i}');
      }
    });

    test('Actinides (89..103) are on row 10, columns 3..17', () {
      final actinides =
          elements.where((e) => e.number >= 89 && e.number <= 103).toList();
      expect(actinides.length, equals(15));

      for (int i = 0; i < actinides.length; i++) {
        final element = actinides[i];
        expect(element.row, equals(10),
            reason: 'Element ${element.symbol} should be in row 10');
        expect(element.column, equals(3 + i),
            reason: 'Element ${element.symbol} should be in column ${3 + i}');
      }
    });

    test('No two elements share the exact same (row, column) coordinate', () {
      final positions = <String>{};
      for (final e in elements) {
        final coord = '${e.row},${e.column}';
        expect(positions.contains(coord), isFalse,
            reason: 'Collision at coordinate $coord between elements');
        positions.add(coord);
      }
    });

    test('Specific benchmark element verification', () {
      final hydrogen = elements.firstWhere((e) => e.number == 1);
      expect(hydrogen.symbol, equals('H'));
      expect(hydrogen.name, equals('Hydrogen'));
      expect(hydrogen.row, equals(1));
      expect(hydrogen.column, equals(1));

      final helium = elements.firstWhere((e) => e.number == 2);
      expect(helium.symbol, equals('He'));
      expect(helium.name, equals('Helium'));
      expect(helium.row, equals(1));
      expect(helium.column, equals(18));

      final gold = elements.firstWhere((e) => e.number == 79);
      expect(gold.symbol, equals('Au'));
      expect(gold.name, equals('Gold'));
      expect(gold.category, equals('transition-metal'));

      final oganesson = elements.firstWhere((e) => e.number == 118);
      expect(oganesson.symbol, equals('Og'));
      expect(oganesson.name, equals('Oganesson'));
      expect(oganesson.row, equals(7));
      expect(oganesson.column, equals(18));
    });
  });

  group('ElementRepository Unit Tests', () {
    test('loadElements parses all items and populates lookup tables', () async {
      final repo = ElementRepository();
      expect(repo.elements.isEmpty, isTrue);

      final file = File('assets/data/elements.json');
      final jsonList = json.decode(file.readAsStringSync()) as List<dynamic>;
      final parsed = jsonList
          .map((i) => ElementData.fromJson(i as Map<String, dynamic>))
          .toList();

      expect(parsed.length, equals(118));
      final iron = parsed.firstWhere((e) => e.symbol == 'Fe');
      expect(iron.number, equals(26));
      expect(iron.name, equals('Iron'));
    });
  });
}
