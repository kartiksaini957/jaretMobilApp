import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/widgets/gradient_background.dart';

/// Renders the LightSignal Visual Foundation v2 field (§2) with its motion
/// layers (§4.1 streaks, §4.2 motes) so the background can be checked
/// against the spec.
///
/// Run `flutter test --update-goldens` to refresh the reference images.
void main() {
  /// The field is built from fractional positions, so it must hold its look
  /// at any viewport.
  const viewports = <String, Size>{
    'phone': Size(430, 932),
    'tablet': Size(1024, 768),
  };

  viewports.forEach((name, size) {
    testWidgets('field background renders — $name', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: GradientBackground(child: SizedBox.expand()),
        ),
      );
      // Land mid-drift so the streak and mote layers are both visible.
      await tester.pump(const Duration(seconds: 6));

      await expectLater(
        find.byType(GradientBackground),
        matchesGoldenFile('goldens/ls_field_$name.png'),
      );
    });
  });
}
