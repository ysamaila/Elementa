import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:elementa/main.dart';

void main() {
  testWidgets('ElementaApp smoke test and verify zero layout overflow on mobile',
      (WidgetTester tester) async {
    // Set standard mobile viewport (360 x 640)
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const ElementaApp());
    await tester.pump();

    // Verify title loads
    expect(find.text('Elementa'), findsOneWidget);

    // Verify zero layout or rendering overflow exceptions occurred
    expect(tester.takeException(), isNull);
  });
}
