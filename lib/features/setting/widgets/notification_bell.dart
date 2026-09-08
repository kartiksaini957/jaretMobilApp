import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/app_theme.dart';
import '../../../theme/lightsignal/ls_css.dart';
import '../../notification/notificationScreen.dart';
import '../../notification/provider/notification_provider.dart';
import '../theme/settings_colors.dart';

import '../../../widgets/smooth_animations.dart';

class NotificationBell extends ConsumerStatefulWidget {
  const NotificationBell({super.key});

  @override
  ConsumerState<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends ConsumerState<NotificationBell> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationProvider.notifier).fetchAlerts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final notificationState = ref.watch(notificationProvider);
    final count = notificationState.count;

    return Semantics(
      button: true,
      label: count == 0 ? 'Notifications' : 'Notifications, $count unread',
      child: _BellButton(
        unread: count,
        onTap: () async {
          await Navigator.of(
            context,
          ).push(SmoothPageRoute(builder: (_) => const NotificationScreen()));
          if (mounted) {
            ref.read(notificationProvider.notifier).fetchAlerts();
          }
        },
      ),
    );
  }
}

class _BellButton extends StatelessWidget {
  const _BellButton({required this.unread, required this.onTap});
  final int unread;
  final VoidCallback onTap;
  static final Gradient _fill = LsCss.linearGradient(
    degrees: 160,
    colors: const [Color(0x5C355060), Color(0x51203D4C)],
  );
  static final Gradient _badgeFill = LsCss.linearGradient(
    degrees: 160,
    colors: const [Color(0xFFFFD1C4), Color(0xFFFF9E8A)],
  );

  @override
  Widget build(BuildContext context) {
    return SmoothScaleTap(
      onTap: onTap,
      child: SizedBox(
        width: 44,
        height: 44,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: _fill,
                shape: BoxShape.circle,
                border: Border.all(color: SettingsColors.connectorBorder),
              ),
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/notification.png',
                width: 28,
                height: 28,
              ),
            ),
            if (unread > 0)
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: _badgeFill,
                    borderRadius: BorderRadius.circular(99),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x99FF8C6E),
                        offset: Offset(0, 4),
                        blurRadius: 12,
                        spreadRadius: -4,
                      ),
                    ],
                  ),
                  child: Text(
                    '$unread',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.ink,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
