import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/features/setting/provider/notification_bell_provider.dart';
import 'package:flutter_application_1/features/setting/settings_screen.dart';
import 'package:flutter_application_1/theme/app_theme.dart';

Future<void> _pumpSettings(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(theme: buildAppTheme(), home: const SettingsScreen()),
    ),
  );
  await tester.pump(const Duration(milliseconds: 100));
}

/// Switches to a tab by tapping its pill, then settles the rebuild.
Future<void> _openTab(WidgetTester tester, String label) async {
  await tester.tap(find.text(label));
  await tester.pump(const Duration(milliseconds: 100));
}

const _phone = Size(390, 844); // iPhone 14
const _ipad = Size(1024, 1366); // iPad Pro 12.9"

void main() {
  testWidgets('renders the breadcrumb, all eight tabs and the bell', (
    tester,
  ) async {
    await _pumpSettings(tester, _phone);

    expect(find.textContaining('LightSignal / '), findsOneWidget);
    for (final tab in [
      'General',
      'Integrations',
      'Data & Privacy',
      'Notifications',
      'Security & Team',
      'AI & Corrections',
      'Billing',
      'Backup',
    ]) {
      expect(find.text(tab), findsWidgets, reason: 'missing tab $tab');
    }
    // Badge starts at the three unread reference rows.
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('every tab builds without overflowing on a phone', (
    tester,
  ) async {
    await _pumpSettings(tester, _phone);

    for (final tab in [
      'Integrations',
      'Data & Privacy',
      'Notifications',
      'Security & Team',
      'AI & Corrections',
      'Billing',
      'Backup',
    ]) {
      await _openTab(tester, tab);
      expect(tester.takeException(), isNull, reason: 'tab $tab overflowed');
    }
  });

  testWidgets('connected connectors expose sync controls', (tester) async {
    await _pumpSettings(tester, _phone);
    await _openTab(tester, 'Integrations');

    // QuickBooks and Square ship connected in the reference.
    expect(find.text('Connected · synced 2h ago'), findsOneWidget);
    expect(find.text('Connected · synced 25m ago'), findsOneWidget);
    expect(find.text('Run sync now'), findsNWidgets(2));
    expect(find.text('Disconnect'), findsNWidgets(2));

    // Disconnected ones offer only Connect.
    expect(find.text('Not connected'), findsNWidgets(4));
    expect(find.text('Connect'), findsNWidgets(4));
  });

  testWidgets('disconnecting swaps a card back to the Connect state', (
    tester,
  ) async {
    await _pumpSettings(tester, _phone);
    await _openTab(tester, 'Integrations');

    final disconnect = find.text('Disconnect').first;
    await tester.ensureVisible(disconnect);
    await tester.pump();
    await tester.tap(disconnect);
    await tester.pump();

    expect(find.text('Run sync now'), findsOneWidget);
    expect(find.text('Connect'), findsNWidgets(5));
  });

  testWidgets('bell opens, marks all read, and empties the badge', (
    tester,
  ) async {
    await _pumpSettings(tester, _phone);

    await tester.tap(find.byIcon(Icons.notifications_none_outlined));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('NOTIFICATIONS'), findsOneWidget);
    expect(find.textContaining('Cash dipped below'), findsOneWidget);
    expect(find.textContaining('opens Business Health'), findsNWidgets(2));

    await tester.tap(find.text('Mark all read'));
    await tester.pump();

    expect(find.text('3'), findsNothing);
    expect(find.text('Mark all read'), findsNothing);
  });

  testWidgets('bell shows the caught-up state with an empty inbox', (
    tester,
  ) async {
    tester.view.physicalSize = _phone;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          notificationBellProvider.overrideWith(_EmptyBellController.new),
        ],
        child: MaterialApp(
          theme: buildAppTheme(),
          home: const SettingsScreen(),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    await tester.tap(find.byIcon(Icons.notifications_none_outlined));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('You\'re all caught up.'), findsOneWidget);
  });

  testWidgets('caps content width and goes two-column on iPad', (
    tester,
  ) async {
    await _pumpSettings(tester, _ipad);
    await _openTab(tester, 'Integrations');

    // Two connector cards per accounting row rather than a single stack.
    final qbo = tester.getRect(find.text('QuickBooks Online'));
    final xero = tester.getRect(find.text('Xero'));
    expect(
      xero.left,
      greaterThan(qbo.right),
      reason: 'Xero should sit beside QuickBooks, not under it',
    );
  });
}

class _EmptyBellController extends NotificationBellController {
  @override
  List<AppNotification> build() => const [];
}
