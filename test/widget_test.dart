import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:elementa/main.dart';
import 'package:elementa/models/element_data.dart';
import 'package:elementa/data/element_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Widget Tests & Visual Polish Verification', () {
    late ElementRepository testRepo;

    setUpAll(() {
      GoogleFonts.config.allowRuntimeFetching = false;
      final file = File('assets/data/elements.json');
      final jsonList = json.decode(file.readAsStringSync()) as List<dynamic>;
      final elements = jsonList
          .map((item) => ElementData.fromJson(item as Map<String, dynamic>))
          .toList();
      testRepo = ElementRepository()..setElements(elements);
    });

    testWidgets('ElementaApp renders on mobile without layout overflow',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(ElementaApp(repository: testRepo));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Verify header title and subtitle
      expect(find.text('Elementa'), findsOneWidget);
      expect(find.text('Periodic Table of Elements'), findsOneWidget);

      // Verify category legend bar contains category chips
      expect(find.text('Alkali Metal'), findsOneWidget);

      // Verify zero layout or rendering overflow exceptions occurred
      expect(tester.takeException(), isNull);
    });

    testWidgets('Tapping category in legend opens CategoryDetailSheet and toggles highlight',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(ElementaApp(repository: testRepo));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Find and tap "Alkali Metal" chip in legend
      final alkaliMetalChip = find.text('Alkali Metal');
      expect(alkaliMetalChip, findsOneWidget);
      await tester.tap(alkaliMetalChip);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      // Sheet should be visible showing category details and series count
      expect(find.text('Elements in Series'), findsOneWidget);
      expect(
        find.textContaining('Highly reactive, soft, silvery metals'),
        findsOneWidget,
      );

      // Verify highlight button is available and scroll to it if needed
      final highlightButton = find.text('Highlight on Grid');
      expect(highlightButton, findsOneWidget);
      await tester.ensureVisible(highlightButton);
      await tester.pumpAndSettle();

      // Tap highlight button
      await tester.tap(highlightButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      // Filter banner should now be visible on main screen
      expect(find.textContaining('Alkali Metal'), findsWidgets);

      // Tap "Clear" button to reset filter
      final clearButton = find.text('Clear');
      expect(clearButton, findsOneWidget);
      await tester.tap(clearButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      // Filter banner clear button should now be dismissed
      expect(find.text('Clear'), findsNothing);
    });

    testWidgets('Tapping element box opens polished ElementDetailDialog with deep properties & navigation',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(ElementaApp(repository: testRepo));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Find Hydrogen (H) tile on the grid
      final hydrogenFinder = find.text('Hydrogen');
      expect(hydrogenFinder, findsWidgets);

      await tester.tap(hydrogenFinder.first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      // Detail sheet should now be displayed with core and deep properties
      expect(find.text('Atomic Number'), findsOneWidget);
      expect(find.text('Atomic Mass'), findsOneWidget);
      expect(find.text('Period'), findsOneWidget);
      expect(find.text('Group'), findsOneWidget);
      expect(find.text('Overview'), findsOneWidget);
      expect(find.text('Electron Config:'), findsOneWidget);
      expect(find.text('Melting Point'), findsOneWidget);
      expect(find.text('Boiling Point'), findsOneWidget);
      expect(find.text('Density'), findsOneWidget);

      // Verify sequential navigation buttons exist (prev wraps to #118 Og, next goes to #2 He)
      expect(find.text('#118 Og'), findsOneWidget);
      expect(find.text('#2 He'), findsOneWidget);

      // Tap Next button to navigate to Helium (#2 He)
      await tester.tap(find.text('#2 He'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Now Helium details should be visible
      expect(find.text('Helium'), findsWidgets);
      expect(find.text('#1 H'), findsOneWidget);

      // Dismiss dialog via close button
      final closeButton = find.byIcon(Icons.close);
      expect(closeButton, findsOneWidget);
      await tester.tap(closeButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(tester.takeException(), isNull);
    });

    testWidgets('Search bar allows searching and highlights matching elements',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(ElementaApp(repository: testRepo));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Tap search icon in app bar
      final searchIconButton = find.byTooltip('Search Elements');
      expect(searchIconButton, findsOneWidget);
      await tester.tap(searchIconButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Enter "Au" into the search field
      final textFieldFinder = find.byType(TextField);
      expect(textFieldFinder, findsOneWidget);
      await tester.enterText(textFieldFinder, 'Au');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Matching result chip for Gold should appear
      expect(find.text('Au • Gold'), findsOneWidget);

      // Close search
      final closeSearchButton = find.byTooltip('Close Search');
      expect(closeSearchButton, findsOneWidget);
      await tester.tap(closeSearchButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(TextField), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('App renders seamlessly on tablet aspect ratio (800x1280)',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1280);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(ElementaApp(repository: testRepo));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Elementa'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
