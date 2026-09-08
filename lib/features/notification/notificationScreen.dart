import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../../widgets/customToast.dart';
import '../../widgets/gradient_background.dart';
import '../../widgets/smooth_animations.dart';
import 'model/alert_notification_model.dart';
import 'provider/notification_provider.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  String _formatTime(String rawDate) {
    if (rawDate.isEmpty) return '';
    final parsed = DateTime.tryParse(rawDate);
    if (parsed == null) return rawDate;
    final local = parsed.toLocal();
    final now = DateTime.now();
    final diff = now.difference(local);

    if (diff.inSeconds < 60 && diff.inSeconds >= 0) return 'Just now';
    if (diff.inMinutes < 60 && diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    }
    if (diff.inHours < 24 && diff.inHours > 0) {
      return '${diff.inHours}h ago';
    }
    if (diff.inDays < 7 && diff.inDays > 0) {
      return '${diff.inDays}d ago';
    }
    return '${local.day.toString().padLeft(2, '0')}/${local.month.toString().padLeft(2, '0')}/${local.year}';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationProvider);
    final controller = ref.read(notificationProvider.notifier);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.glassLight,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.glassBorderSoft, width: 1),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 15,
                color: AppColors.white,
              ),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
        ),
        title: Text(
          'Notifications',
          style: AppTextStyles.headline.copyWith(fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh_rounded,
              color: AppColors.soft,
              size: 20,
            ),
            tooltip: 'Refresh',
            onPressed: () {
              CustomToast.showInfo(context, 'Refreshing notifications…');
              controller.refresh();
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: GradientBackground(
        child: SafeArea(
          child: RefreshIndicator(
            color: AppColors.accent,
            backgroundColor: AppColors.sheetSurface,
            onRefresh: () async => controller.refresh(),
            child: _buildBody(state, controller),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    NotificationState state,
    NotificationController controller,
  ) {
    if (state.isLoading && state.alerts.isEmpty) {
      return _buildLoadingList();
    }

    if (state.errorMessage != null && state.alerts.isEmpty) {
      return _buildErrorState(state.errorMessage!, controller);
    }

    if (state.alerts.isEmpty) {
      return SmoothFadeSlide(
        duration: const Duration(milliseconds: 300),
        child: _buildEmptyState(controller),
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
      itemCount: state.alerts.length,
      itemBuilder: (context, index) {
        final alert = state.alerts[index];
        return SmoothFadeSlide(
          delay: Duration(milliseconds: index * 40),
          child: _buildAlertCard(alert),
        );
      },
    );
  }

  Widget _buildHeaderBanner(NotificationState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.glassDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.glassBorderSoft, width: 0.8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.warnDot.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.warnDot.withValues(alpha: 0.35),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.warnDot,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  '${state.count} Active ${state.count == 1 ? 'notification' : 'notifications'}',
                  style: GoogleFonts.dmSans(
                    color: AppColors.warnText,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          if (state.generatedAt.isNotEmpty)
            Text(
              'Generated ${_formatTime(state.generatedAt)}',
              style: GoogleFonts.dmSans(
                color: AppColors.mute,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(AlertNotificationItem alert) {
    final isDanger = alert.isDanger;
    final isWarning = alert.isWarning;

    final Color accentColor = isDanger
        ? AppColors.crit
        : isWarning
        ? AppColors.warnDot
        : AppColors.accent;

    final Color badgeBg = isDanger
        ? AppColors.crit.withValues(alpha: 0.15)
        : isWarning
        ? AppColors.warnDot.withValues(alpha: 0.15)
        : AppColors.accent.withValues(alpha: 0.15);

    final IconData icon = isDanger
        ? Icons.error_outline_rounded
        : isWarning
        ? Icons.warning_amber_rounded
        : Icons.info_outline_rounded;

    return SmoothScaleTap(
      scaleFactor: 0.98,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.glassDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: accentColor.withValues(alpha: 0.3), width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row: Icon + Title + Level badge + Metric
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: badgeBg,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: accentColor.withValues(alpha: 0.35),
                        width: 1,
                      ),
                    ),
                    child: Icon(icon, size: 14, color: accentColor),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      alert.title,
                      style: GoogleFonts.spaceGrotesk(
                        color: AppColors.white,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 6,
                  //     vertical: 2,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     color: badgeBg,
                  //     borderRadius: BorderRadius.circular(4),
                  //   ),
                  //   child: Text(
                  //     alert.level.toUpperCase(),
                  //     style: GoogleFonts.dmSans(
                  //       color: accentColor,
                  //       fontSize: 9.5,
                  //       fontWeight: FontWeight.w700,
                  //       letterSpacing: 0.4,
                  //     ),
                  //   ),
                  // ),
                  // if (alert.metric.isNotEmpty) ...[
                  //   const SizedBox(width: 5),
                  //   Container(
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 6,
                  //       vertical: 2,
                  //     ),
                  //     decoration: BoxDecoration(
                  //       color: AppColors.glassLight,
                  //       borderRadius: BorderRadius.circular(4),
                  //     ),
                  //     child: Text(
                  //       '#${alert.metric}',
                  //       style: GoogleFonts.spaceGrotesk(
                  //         color: AppColors.mute,
                  //         fontSize: 9.5,
                  //         fontWeight: FontWeight.w600,
                  //       ),
                  //     ),
                  //   ),
                  // ],
                ],
              ),
              const SizedBox(height: 6),

              // Description Message
              Padding(
                padding: const EdgeInsets.only(left: 2),
                child: Text(
                  alert.message,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.soft,
                    fontSize: 12.5,
                    height: 1.35,
                  ),
                ),
              ),

              // Recommended Action (compact callout)
              if (alert.action.isNotEmpty) ...[
                const SizedBox(height: 7),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.sheetSurface.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.2),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.lightbulb_outline_rounded,
                        size: 14,
                        color: AppColors.accent,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          alert.action,
                          style: GoogleFonts.dmSans(
                            color: AppColors.white,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            height: 1.25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ),
  );
}

  Widget _buildEmptyState(NotificationController controller) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppColors.glassDark,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppColors.glassBorderSoft,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.good.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.good.withValues(alpha: 0.3),
                            width: 1.2,
                          ),
                        ),
                        child: const Icon(
                          Icons.check_circle_outline_rounded,
                          size: 32,
                          color: AppColors.good,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'All Clear!',
                        style: AppTextStyles.headline.copyWith(fontSize: 18),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'No active alerts or warnings at this time. Your business vitals are operating smoothly.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.mute,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(String error, NotificationController controller) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.glassDark,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppColors.crit.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.crit.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.error_outline_rounded,
                          size: 28,
                          color: AppColors.crit,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Failed to Load Alerts',
                        style: AppTextStyles.headline.copyWith(fontSize: 17),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        error,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.mute,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: AppColors.ink,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => controller.refresh(),
                        icon: const Icon(Icons.refresh_rounded, size: 16),
                        label: Text(
                          'Retry',
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
      itemCount: 4,
      itemBuilder: (_, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          height: 90,
          decoration: BoxDecoration(
            color: AppColors.glassDark,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.glassBorderSoft, width: 0.8),
          ),
          child: const Center(
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.accent,
              ),
            ),
          ),
        );
      },
    );
  }
}
