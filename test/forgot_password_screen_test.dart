import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/features/auth/forgot_password_screen.dart';
import 'package:flutter_application_1/theme/app_theme.dart';

Future<void> _pumpAt(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(theme: buildAppTheme(), home: const ForgotPasswordScreen()),
  );
  await tester.pump(const Duration(milliseconds: 100));
}

void main() {
  testWidgets('renders the reference content on a phone', (tester) async {
    await _pumpAt(tester, const Size(390, 844)); // iPhone 14

    expect(find.text('PASSWORD RESET'), findsOneWidget);
    expect(find.text('Forgot your password?'), findsOneWidget);
    expect(
      find.text('Enter your email and we\'ll send you a link to reset it.'),
      findsOneWidget,
    );
    expect(find.text('Work email'), findsOneWidget);
    expect(find.text('Send reset link'), findsOneWidget);
    expect(find.text('Remembered it? '), findsOneWidget);
    expect(find.text('Back to sign in'), findsNWidgets(2));
  });

  testWidgets('shows the inline error for a malformed email', (tester) async {
    await _pumpAt(tester, const Size(390, 844));

    await tester.enterText(find.byType(TextFormField), 'not-an-email');
    await tester.tap(find.text('Send reset link'));
    await tester.pump();

    expect(
      find.text('That email doesn’t look right. Mind checking it?'),
      findsOneWidget,
    );
  });

  testWidgets('caps the form column at 460 on iPad', (tester) async {
    await _pumpAt(tester, const Size(1024, 1366)); // iPad Pro 12.9"

    final cardWidth = tester.getSize(find.byType(Form)).width;
    expect(cardWidth, lessThanOrEqualTo(460));

    // Still centred rather than pinned to the left edge.
    final centre = tester.getCenter(find.byType(Form));
    expect(centre.dx, moreOrLessEquals(512, epsilon: 1));
  });

  testWidgets('no overflow on the smallest supported phone', (tester) async {
    await _pumpAt(tester, const Size(320, 568)); // iPhone SE 1st gen
    expect(tester.takeException(), isNull);
  });
}
