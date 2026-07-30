import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('Onboarding screen shows the first pane and CTA', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    expect(find.text('LightSignal'), findsOneWidget);
    expect(find.text('Start your free trial'), findsOneWidget);
    expect(find.text('I already have an account'), findsOneWidget);
  });
}
