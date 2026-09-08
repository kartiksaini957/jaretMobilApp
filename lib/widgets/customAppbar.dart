import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/notification/notificationScreen.dart';
import '../features/notification/provider/notification_provider.dart';
import '../theme/app_theme.dart';
import 'smooth_animations.dart';

/// Top app bar shared by dashboard-style screens: a hamburger button that
/// opens the [Scaffold]'s drawer, a centered title, and a notification
/// bell with an unread-dot badge.
class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.hasUnreadNotifications,
    this.onNotificationTap,
  });

  final String title;
  final bool? hasUnreadNotifications;
  final VoidCallback? onNotificationTap;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(notificationProvider);
    final showDot = hasUnreadNotifications ?? (notificationState.count > 0);

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: AppColors.white),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      title: Text(title, style: AppTextStyles.logo),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 6),
          child: SmoothScaleTap(
            onTap:
                onNotificationTap ??
                () async {
                  await Navigator.of(context).push(
                    SmoothPageRoute(builder: (_) => const NotificationScreen()),
                  );
                  if (context.mounted) {
                    ref.read(notificationProvider.notifier).fetchAlerts();
                  }
                },
            child: SizedBox(
              width: 44,
              height: 44,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Image.asset(
                    'assets/images/notification.png',
                    width: 30,
                    height: 30,
                  ),
                  if (showDot)
                    Positioned(
                      top: 9,
                      right: 12,
                      child: SmoothPulsingBadge(
                        child: Container(
                          width: 8.5,
                          height: 8.5,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF5A5F),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFFF5A5F,
                                ).withValues(alpha: 0.6),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
