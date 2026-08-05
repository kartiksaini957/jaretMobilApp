import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/app_theme.dart';
import '../../../theme/lightsignal/ls_css.dart';
import '../../business_health/business_health_screen.dart';
import '../../opportunity/opportunities_screen.dart';
import '../provider/notification_bell_provider.dart';
import '../theme/settings_colors.dart';
import 'settings_row_controls.dart';

/// The app-shell notification bell: a glass pill with an unread badge that
/// opens a glass dropdown of notification rows.
///
/// Tapping a row marks it read (which also stops its escalation timer) and
/// deep-links to the tab that owns it. With nothing in the inbox the
/// dropdown shows "You're all caught up." rather than inventing rows.
class NotificationBell extends ConsumerStatefulWidget {
  const NotificationBell({super.key});

  @override
  ConsumerState<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends ConsumerState<NotificationBell> {
  final _link = LayerLink();
  final _portalController = OverlayPortalController();

  void _toggle() =>
      _portalController.isShowing ? _close() : _portalController.show();

  void _close() => _portalController.hide();

  void _openNotification(AppNotification notification) {
    ref.read(notificationBellProvider.notifier).markRead(notification.id);
    _close();

    final builder = switch (notification.target) {
      NotificationTarget.businessHealth => (_) => const BusinessHealthScreen(),
      NotificationTarget.opportunities => (_) => const OpportunitiesScreen(),
      NotificationTarget.none => null,
    };
    if (builder == null) return;
    Navigator.of(context).push(MaterialPageRoute(builder: builder));
  }

  @override
  Widget build(BuildContext context) {
    final unread = ref.watch(unreadNotificationCountProvider);

    return CompositedTransformTarget(
      link: _link,
      child: OverlayPortal(
        controller: _portalController,
        overlayChildBuilder: (context) => _NotificationDropdown(
          link: _link,
          onDismiss: _close,
          onOpen: _openNotification,
        ),
        child: Semantics(
          button: true,
          label: unread == 0
              ? 'Notifications'
              : 'Notifications, $unread unread',
          child: _BellButton(unread: unread, onTap: _toggle),
        ),
      ),
    );
  }
}

/// `.bell` — a 42px glass pill with the unread `.badge` hanging off it.
class _BellButton extends StatelessWidget {
  const _BellButton({required this.unread, required this.onTap});

  final int unread;
  final VoidCallback onTap;

  static final Gradient _fill = LsCss.linearGradient(
    degrees: 160,
    colors: const [Color(0x5C355060), Color(0x51203D4C)],
  );

  /// `linear-gradient(160deg,#FFD1C4,#FF9E8A)`
  static final Gradient _badgeFill = LsCss.linearGradient(
    degrees: 160,
    colors: const [Color(0xFFFFD1C4), Color(0xFFFF9E8A)],
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 52,
        height: 52,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: _fill,
                shape: BoxShape.circle,
                border: Border.all(color: SettingsColors.connectorBorder),
              ),
              child: const Icon(
                Icons.notifications_none_outlined,
                size: 18,
                color: SettingsColors.soft,
              ),
            ),
            if (unread > 0)
              Positioned(
                top: 3,
                right: 3,
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 19,
                    minHeight: 19,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
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
                      fontSize: 10.5,
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

/// `.belldrop` — the glass panel of notification rows.
class _NotificationDropdown extends ConsumerWidget {
  const _NotificationDropdown({
    required this.link,
    required this.onDismiss,
    required this.onOpen,
  });

  final LayerLink link;
  final VoidCallback onDismiss;
  final ValueChanged<AppNotification> onOpen;

  static const double _maxWidth = 400;

  static final Gradient _fill = LsCss.linearGradient(
    degrees: 160,
    colors: const [Color(0xB01B3F52), Color(0xA5183A4C)],
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationBellProvider);
    final media = MediaQuery.of(context);
    final width = (media.size.width - 32).clamp(0.0, _maxWidth);

    return Stack(
      children: [
        // Outside-tap closes, matching the reference's document listener.
        Positioned.fill(
          child: GestureDetector(
            onTap: onDismiss,
            behavior: HitTestBehavior.opaque,
            child: const SizedBox.shrink(),
          ),
        ),
        CompositedTransformFollower(
          link: link,
          targetAnchor: Alignment.bottomRight,
          followerAnchor: Alignment.topRight,
          offset: const Offset(0, 6),
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: BackdropFilter(
                  filter: lsBackdropFilter(blur: 22, saturate: 1.4),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: _fill,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0x4DFFFFFF)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xB300101C),
                          offset: Offset(0, 24),
                          blurRadius: 60,
                          spreadRadius: -18,
                        ),
                      ],
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: media.size.height * 0.6,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _DropdownHeader(
                            onMarkAllRead: notifications.any((n) => !n.read)
                                ? () => ref
                                      .read(notificationBellProvider.notifier)
                                      .markAllRead()
                                : null,
                          ),
                          Flexible(
                            child: notifications.isEmpty
                                ? const _EmptyInbox()
                                : ListView.separated(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: notifications.length,
                                    separatorBuilder: (_, _) => const Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: Color(0x14FFFFFF),
                                    ),
                                    itemBuilder: (context, i) =>
                                        _NotificationRow(
                                          notification: notifications[i],
                                          onTap: () => onOpen(notifications[i]),
                                        ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// `.bhd` — "NOTIFICATIONS" with the "Mark all read" affordance.
class _DropdownHeader extends StatelessWidget {
  const _DropdownHeader({required this.onMarkAllRead});

  final VoidCallback? onMarkAllRead;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0x1FFFFFFF))),
      ),
      child: Row(
        children: [
          Flexible(
            child: Text(
              'NOTIFICATIONS',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.eyebrow.copyWith(
                color: SettingsColors.soft,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
          ),
          if (onMarkAllRead != null) ...[
            const SizedBox(width: 12),
            GestureDetector(
              onTap: onMarkAllRead,
              behavior: HitTestBehavior.opaque,
              child: Text(
                'Mark all read',
                maxLines: 1,
                style: AppTextStyles.body.copyWith(
                  color: SettingsColors.accent,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// `.nrow` — severity dot, title, and the "category · age · opens X" meta.
class _NotificationRow extends StatelessWidget {
  const _NotificationRow({required this.notification, required this.onTap});

  final AppNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: SettingsColors.white.withValues(alpha: 0.08),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: SettingsStatusDot(
                  color: notification.severity.dotColor,
                  size: 8,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: AppTextStyles.body.copyWith(
                        // `.nrow.read .nt` dims and un-bolds the title.
                        color: notification.read
                            ? SettingsColors.soft
                            : SettingsColors.white,
                        fontSize: 13,
                        fontWeight: notification.read
                            ? FontWeight.w600
                            : FontWeight.w700,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      notification.meta,
                      style: AppTextStyles.body.copyWith(
                        color: SettingsColors.soft,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// `.bempty` — what the bell shows until something actually fires.
class _EmptyInbox extends StatelessWidget {
  const _EmptyInbox();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 26),
      child: Text(
        'You\'re all caught up.',
        textAlign: TextAlign.center,
        style: AppTextStyles.body.copyWith(
          color: SettingsColors.soft,
          fontSize: 13,
        ),
      ),
    );
  }
}
