import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Top app bar shared by dashboard-style screens: a hamburger button that
/// opens the [Scaffold]'s drawer, a centered title, and a notification
/// bell with an unread-dot badge.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.hasUnreadNotifications = false,
    this.onNotificationTap,
  });

  final String title;
  final bool hasUnreadNotifications;
  final VoidCallback? onNotificationTap;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: AppColors.white),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      title: Text(title, style: AppTextStyles.logo),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: IconButton(
            onPressed: onNotificationTap,
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.notifications_none_outlined,
                  color: AppColors.white,
                ),
                if (hasUnreadNotifications)
                  Positioned(
                    top: -1,
                    right: -1,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF5A5F),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
