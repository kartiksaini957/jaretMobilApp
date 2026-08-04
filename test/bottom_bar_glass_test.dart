import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/bottombar/app_bottom_bar.dart';
import 'package:flutter_application_1/widgets/gradient_background.dart';

/// Renders the frosted-glass bottom nav over the LightSignal field so the
/// bar's fill, rim, blur and shadows can be checked against the spec.
void main() {
  testWidgets('bottom bar glass renders over the field', (tester) async {
    tester.view.physicalSize = const Size(860, 440);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.transparent,
          body: GradientBackground(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AppBottomBar(
                  selectedIndex: 0,
                  onTap: (_) {},
                  items: const [
                    BottomBarItem(
                      icon: Icons.check_circle_outline,
                      badgeCount: 1,
                    ),
                    BottomBarItem(icon: Icons.flag_outlined, badgeCount: 3),
                    BottomBarItem(icon: Icons.bolt),
                    BottomBarItem(icon: Icons.bar_chart, badgeCount: 5),
                    BottomBarItem(icon: Icons.chat),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 3));

    await expectLater(
      find.byType(GradientBackground),
      matchesGoldenFile('goldens/ls_bottom_bar.png'),
    );
  });
}
