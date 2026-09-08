import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api_services.dart';
import 'package:flutter_application_1/features/opportunity/model/oportunityModel.dart';
import 'package:flutter_application_1/features/opportunity/widgets/OpportunitySearchField.dart';
import 'package:flutter_application_1/features/opportunity/widgets/TypeFilterDropdown.dart';
import 'package:flutter_application_1/widgets/gradient_background.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/customAppbar.dart';
import 'metric_card.dart';
import 'opportunities_provider.dart';
import '../../widgets/app_nav_destinations.dart';

class OpportunitiesScreen extends ConsumerWidget {
  const OpportunitiesScreen({super.key});
  void _onDrawerItemSelected(BuildContext context, int index) {
    openNavDestination(context, index, currentIndex: AppNavIndex.opportunities);
  }

  void _openPortfolioSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _PortfolioSheet(),
    );
  }

  void _openOpportunityDetailSheet(
    BuildContext context,
    OpportunityCard opportunity,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _OpportunityDetailSheet(opportunity: opportunity),
    );
  }

  static const _weekdayNames = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static const _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  String get _today {
    final now = DateTime.now();
    final weekday = _weekdayNames[now.weekday - 1];
    final month = _monthNames[now.month - 1];
    return '$weekday, $month ${now.day}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opportunitiesAsync = ref.watch(opportunitiesControllerProvider);
    return opportunitiesAsync.when(
      loading: () {
        return Scaffold(
          backgroundColor: AppColors.baseDeep,
          appBar: const CustomAppBar(
            title: 'Opportunities',
            hasUnreadNotifications: true,
          ),
          drawer: AppNavDrawer(
            selectedIndex: 4,
            onItemSelected: (index) {
              _onDrawerItemSelected(context, index);
            },
          ),
          body: const GradientBackground(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
      error: (error, stack) {
        final String errMsg = (error is ApiException)
            ? error.message
            : (error.toString().replaceFirst('Exception: ', ''));

        return Scaffold(
          backgroundColor: AppColors.baseDeep,
          appBar: const CustomAppBar(
            title: 'Opportunities',
            hasUnreadNotifications: true,
          ),
          drawer: AppNavDrawer(
            selectedIndex: 4,
            onItemSelected: (index) {
              _onDrawerItemSelected(context, index);
            },
          ),
          body: GradientBackground(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppColors.glassDark,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppColors.glassBorder.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: AppColors.yellow,
                        size: 42,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Opportunities Unavailable',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.headline.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        errMsg,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.mutedText,
                          fontSize: 13.5,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          ref
                              .read(opportunitiesControllerProvider.notifier)
                              .load();
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.accent.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.refresh_rounded,
                                size: 18,
                                color: AppColors.accent,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Retry',
                                style: AppTextStyles.small.copyWith(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
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
      data: (data) {
        final hero = data.hero;
        return Scaffold(
          appBar: const CustomAppBar(
            title: 'Opportunities',
            hasUnreadNotifications: true,
          ),
          drawer: AppNavDrawer(
            selectedIndex: 4,
            onItemSelected: (index) {
              _onDrawerItemSelected(context, index);
            },
          ),
          body: GradientBackground(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _today,
                      style: AppTextStyles.eyebrow.copyWith(
                        fontSize: 12.5,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Events, contracts and programs matched to Nonna\nRosa's Pizzeria — Bay Ridge, Brooklyn.",
                      style: AppTextStyles.body,
                    ),
                    const SizedBox(height: 28),
                    Text(
                      "THIS MONTH",
                      style: AppTextStyles.eyebrow.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.45,
                      children: [
                        MetricCard(
                          title: "ACTIVE\nOPPORTUNITIES",
                          value: "${data.kpis.activeOpportunitiesCount}",
                          subtitle: data.kpis.activeOpportunitiesDescriptor,
                        ),
                        MetricCard(
                          title: "NEW THIS WEEK",
                          value: "${data.kpis.newThisWeekCount}",
                          subtitle: data.kpis.newThisWeekLabel,
                          badge: "NEW",
                        ),
                        MetricCard(
                          title: "TOTAL POTENTIAL\nVALUE",
                          value: data.kpis.totalPotentialValue,
                          subtitle: "Across matches",
                        ),
                        MetricCard(
                          title: "AVG FIT SCORE",
                          value: "${data.kpis.avgFitScore}",
                          subtitle: "Good alignment",
                        ),
                      ],
                    ),

                    // GridView.count(
                    //   shrinkWrap: true,
                    //   physics: const NeverScrollableScrollPhysics(),
                    //   crossAxisCount: 2,
                    //   mainAxisSpacing: 12,
                    //   crossAxisSpacing: 12,
                    //   childAspectRatio: 1.45,
                    //   children: [
                    //     MetricCard(
                    //       title: "ACTIVE\nOPPORTUNITIES",
                    //       value: "${data.active}",
                    //       subtitle: "Browse all matches",
                    //     ),
                    //     MetricCard(
                    //       title: "NEW THIS WEEK",
                    //       value: "${data.newThisWeek}",
                    //       subtitle: "Fresh since Monday",
                    //       badge: "NEW",
                    //     ),
                    //     MetricCard(
                    //       title: "TOTAL POTENTIAL\nVALUE",
                    //       value: data.totalValue,
                    //       subtitle: "Across 11 estimates",
                    //     ),
                    //     MetricCard(
                    //       title: "AVG FIT SCORE",
                    //       value: "${data.fitScore}",
                    //       subtitle: "Good alignment",
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: glassDecoration(),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "EVENT READINESS",
                                  style: AppTextStyles.eyebrow.copyWith(
                                    color: AppColors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "events",
                                  style: AppTextStyles.body.copyWith(
                                    color: AppColors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "${data.kpis.eventReadinessIndex}",
                            style: GoogleFonts.spaceGrotesk(
                              color: AppColors.accent,
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "SEARCH & EXPLORE",
                      style: AppTextStyles.eyebrow.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const OpportunitySearchField(),

                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: const [
                          TypeFilterDropdown(), // CHANGED — ab actual dropdown hai
                          SizedBox(width: 8),
                          DistanceFilterDropdown(), // CHANGED
                          SizedBox(width: 8),
                          RiskFilterDropdown(), // CHANGED
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "RECOMMENDED FOR YOU  ${data.moreMatches.length + (hero != null ? 1 : 0)}",
                      style: AppTextStyles.eyebrow.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (hero != null) ...[
                      Container(
                        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                        decoration: glassDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.glassLight.withOpacity(.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: AppColors.glassBorder,
                                    ),
                                  ),
                                  child: Text(
                                    hero.type.toUpperCase(),
                                    style: AppTextStyles.eyebrow.copyWith(
                                      color: AppColors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                _scoreBox('${hero.matchScore}', 'MATCH'),
                                const SizedBox(width: 8),
                                _scoreBox('${hero.readinessScore}', 'READY'),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Text(
                              hero.title,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 17.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              hero.source,
                              style: GoogleFonts.dmSans(
                                fontSize: 12,
                                height: 1.35,
                                fontWeight: FontWeight.w400,
                                color: AppColors.mutedText,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                if (hero.dataTrustIndicator.isNotEmpty)
                                  _statusTag(
                                    icon: Icons.check_circle_outline,
                                    text: hero.dataTrustIndicator,
                                  ),
                                if (hero.dataTrustIndicator.isNotEmpty)
                                  const SizedBox(width: 8),
                                if (hero.riskLevel.isNotEmpty)
                                  _statusTag(
                                    dot: true,
                                    text: 'Risk: ${hero.riskLevel}',
                                  ),
                                const SizedBox(width: 8),
                                Text(
                                  hero.distanceLabel,
                                  style: GoogleFonts.dmSans(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.mutedText,
                                  ),
                                ),
                              ],
                            ),
                            if (hero.expiresAt.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.yellow.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(color: AppColors.yellow),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 13,
                                      color: AppColors.warnText,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      hero.expiresAt,
                                      style: GoogleFonts.dmSans(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.warnText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            if (hero.whyReasonCodes.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              Text(
                                hero.whyReasonCodes
                                    .map((r) => '• $r')
                                    .join('\n\n'),
                                style: GoogleFonts.dmSans(
                                  fontSize: 12.5,
                                  height: 1.45,
                                  color: AppColors.mutedText,
                                ),
                              ),
                            ],
                            const SizedBox(height: 16),
                            Container(height: 1, color: AppColors.glassBorder),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${hero.estimatedRevenue} · ${hero.listedFee}',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 11.5,
                                      height: 1.45,
                                      color: AppColors.mutedText,
                                    ),
                                  ),
                                ),
                                // "In portfolio" aur "View" buttons WAISE HI rehne do (onPressed: () {})
                                // OutlinedButton(
                                //   onPressed: () {},
                                //   style: OutlinedButton.styleFrom(
                                //     backgroundColor: Colors.white.withOpacity(
                                //       0.06,
                                //     ),
                                //     side: BorderSide(
                                //       color: Colors.white.withOpacity(0.24),
                                //     ),
                                //     shape: RoundedRectangleBorder(
                                //       borderRadius: BorderRadius.circular(11),
                                //     ),
                                //     padding: const EdgeInsets.symmetric(
                                //       horizontal: 13,
                                //       vertical: 8,
                                //     ),
                                //   ),
                                //   child: Row(
                                //     mainAxisSize: MainAxisSize.min,
                                //     children: [
                                //       Icon(
                                //         Icons.check_circle,
                                //         size: 14,
                                //         color: AppColors.white,
                                //       ),
                                //       const SizedBox(width: 6),
                                //       Text(
                                //         "In portfolio",
                                //         style: GoogleFonts.dmSans(
                                //           fontSize: 12.5,
                                //           fontWeight: FontWeight.w700,
                                _TrackButton(opportunity: hero, ref: ref),
                                const SizedBox(width: 8),
                                OutlinedButton(
                                  onPressed: () => _openOpportunityDetailSheet(
                                    context,
                                    hero,
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white.withValues(
                                      alpha: 0.06,
                                    ),
                                    side: BorderSide(
                                      color: Colors.white.withValues(
                                        alpha: 0.24,
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(11),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 13,
                                      vertical: 8,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.remove_red_eye_outlined,
                                        size: 14,
                                        color: AppColors.white,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        "View",
                                        style: GoogleFonts.dmSans(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],

                    if (data.moreMatches.isNotEmpty) ...[
                      const SizedBox(height: 28),
                      Text(
                        "More matches — tap one to bring it to the top",
                        style: AppTextStyles.eyebrow.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 140,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: data.moreMatches.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final item = data.moreMatches[index];
                            return SizedBox(
                              width: 200,
                              child: GestureDetector(
                                onTap: () {
                                  ref
                                      .read(
                                        opportunitiesControllerProvider
                                            .notifier,
                                      )
                                      .promoteToHero(item.id);
                                },
                                child: _matchCard(
                                  type: item.type.toUpperCase(),
                                  badge: item.expiresAt.isNotEmpty
                                      ? item.expiresAt.replaceAll(
                                          'Closes in ',
                                          '',
                                        )
                                      : null,
                                  title: item.title,
                                  distance: item.distanceLabel,
                                  score1: '${item.matchScore}',
                                  score2: '${item.readinessScore}',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                    const SizedBox(height: 28),
                    Text(
                      "YOUR PORTFOLIO",
                      style: AppTextStyles.eyebrow.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: glassDecoration(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Your portfolio",
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.dmSans(
                                fontSize: 12,
                                color: AppColors.mutedText,
                              ),
                              children: [
                                TextSpan(
                                  text: "2 active · 4 past · ",
                                  style: GoogleFonts.dmSans(
                                    fontSize: 12,
                                    color: AppColors.mutedText, // green
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(
                                  text: "~\$14K",
                                  style: GoogleFonts.dmSans(
                                    fontSize: 12,
                                    color: AppColors.goodText, // green
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(
                                  text: " committed",
                                  style: GoogleFonts.dmSans(
                                    fontSize: 12,
                                    color: AppColors.mutedText, // green
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 14,
                                color: AppColors.warnText,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "Next: storefront grant closes in 8 days",
                                style: GoogleFonts.dmSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.warnText,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Container(height: 1, color: AppColors.glassBorder),
                          const SizedBox(height: 14),
                          _portfolioItem(
                            title: "School Pizza-Party Vendor Window —\nSpring",
                            subtitle: "Vendor program · Selected",
                            score1: "88",
                            score2: "82",
                          ),
                          const SizedBox(height: 14),
                          Container(height: 1, color: AppColors.glassBorder),
                          const SizedBox(height: 14),
                          _portfolioItem(
                            title:
                                "Storefront Improvement Grant —\nBorough Commerce Program",
                            subtitle: "Grant · Tracked",
                            score1: "81",
                            score2: "90",
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            child: StatefulBuilder(
                              builder: (context, setLocalState) {
                                double scale = 1.0;
                                return GestureDetector(
                                  onTapDown: (_) =>
                                      setLocalState(() => scale = 0.97),
                                  onTapUp: (_) =>
                                      setLocalState(() => scale = 1.0),
                                  onTapCancel: () =>
                                      setLocalState(() => scale = 1.0),
                                  onTap: () => _openPortfolioSheet(context),
                                  child: AnimatedScale(
                                    scale: scale,
                                    duration: const Duration(milliseconds: 160),
                                    curve: Curves.easeOutCubic,
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 13,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.06),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.28),
                                          width: 1,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Open portfolio",
                                          style: GoogleFonts.dmSans(
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

BoxDecoration glassDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(16),

    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.fromRGBO(8, 40, 56, 0.14),
        Color.fromRGBO(8, 40, 56, 0.13),
      ],
    ),

    boxShadow: const [
      // Outer shadow
      BoxShadow(
        color: Color.fromRGBO(0, 20, 40, 0.20),
        offset: Offset(0, 18),
        blurRadius: 44,
        spreadRadius: -22,
      ),

      // Inset shadow (Flutter doesn't support inset directly)
      // Iske liye foreground decoration ya custom painter use karna padega.
    ],
  );
}

Widget _scoreBox(String value, String label) {
  return Container(
    padding: const EdgeInsets.all(8),

    decoration: BoxDecoration(
      color: AppColors.glassLight.withOpacity(.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.glassBorder),
    ),

    child: Column(
      children: [
        Text(
          value,
          style: GoogleFonts.spaceGrotesk(
            color: AppColors.goodDot,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        Text(label, style: AppTextStyles.eyebrow.copyWith(fontSize: 9)),
      ],
    ),
  );
}

Widget _tag(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),

    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: AppColors.glassBorder),
    ),

    child: Text(text, style: AppTextStyles.body),
  );
}

Widget _matchCard({
  required String type,
  required String title,
  required String distance,
  String? badge,
  String? score1,
  String? score2,
}) {
  return Container(
    padding: const EdgeInsets.all(12),

    decoration: glassDecoration(),

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Row(
          children: [
            Text(type, style: AppTextStyles.eyebrow.copyWith(fontSize: 9.5)),

            const Spacer(),

            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.yellow.withOpacity(.1),
                  border: Border.all(color: AppColors.yellow),
                ),

                child: Text(
                  badge,
                  style: GoogleFonts.dmSans(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.warnText,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 8),

        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),

        const Spacer(),

        Expanded(
          child: Row(
            children: [
              Text(
                distance,
                style: GoogleFonts.dmSans(
                  fontSize: 10,
                  color: AppColors.mutedText,
                ),
              ),

              const Spacer(),

              if (score1 != null && score1!.isNotEmpty)
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: score1,
                        style: GoogleFonts.spaceGrotesk(
                          color: AppColors.goodText,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: " / ",
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white70,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: score2,
                        style: GoogleFonts.spaceGrotesk(
                          color: AppColors.warnText,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _portfolioItem({
  required String title,
  required String subtitle,
  required String score1,
  required String score2,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: GoogleFonts.dmSans(
                fontSize: 11,
                color: AppColors.mutedText,
              ),
            ),
          ],
        ),
      ),
      SizedBox(width: 5),

      // 👇 scores side-by-side, same color, same size
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            score1,
            style: GoogleFonts.spaceGrotesk(
              color: AppColors.accent,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            score2,
            style: GoogleFonts.spaceGrotesk(
              color: AppColors.accent, // same color now
              fontSize: 18, // same size now
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ],
  );
}

class _PortfolioSheet extends StatefulWidget {
  const _PortfolioSheet();

  @override
  State<_PortfolioSheet> createState() => _PortfolioSheetState();
}

class _PortfolioSheetState extends State<_PortfolioSheet> {
  bool _showCurrent = true;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(maxHeight: screenHeight * 0.86),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 34),
      decoration: BoxDecoration(
        color: const Color(0xFF08364C),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(26),
          topRight: Radius.circular(26),
        ),
        border: const Border(top: BorderSide(color: Colors.white24, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.45),
            blurRadius: 50,
            offset: const Offset(0, -20),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),

            Text(
              "Your portfolio",
              style: GoogleFonts.spaceGrotesk(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "2 active · 4 past · ~\$14K committed · next deadline in 8 days",
              style: GoogleFonts.dmSans(
                fontSize: 12.5,
                color: AppColors.mutedText,
              ),
            ),

            const SizedBox(height: 18),

            // Tabs
            // Tabs
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withOpacity(0.14)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _sheetTab("Current", _showCurrent, () {
                    setState(() => _showCurrent = true);
                  }),
                  _sheetTab("Past", !_showCurrent, () {
                    setState(() => _showCurrent = false);
                  }),
                ],
              ),
            ),

            const SizedBox(height: 18),

            if (_showCurrent) ...[
              _portfolioRow(
                title: "School Pizza-Party Vendor Window —\nSpring",
                status: "On track",
                detail: "Party 1 served · check-in in 2 days",
                statusColor: AppColors.goodText,
              ),

              const SizedBox(height: 14),

              Container(height: 1, color: AppColors.glassBorder),

              const SizedBox(height: 14),

              _portfolioRow(
                title:
                    "Storefront Improvement Grant —\nBorough Commerce Program",
                status: "On track",
                detail: "Submitted · decision expected in ~3 weeks",
                statusColor: AppColors.goodText,
              ),
            ] else ...[
              _portfolioRow(
                title: "December Office-Party Tray Run",
                status: "Completed",
                detail: "Catering · Dec 2025 · Completed",
                statusColor: AppColors.mutedText,
              ),

              const SizedBox(height: 14),

              Container(height: 1, color: AppColors.glassBorder),

              const SizedBox(height: 14),

              _portfolioRow(
                title: "86th Street Fall Fair — Booth",
                status: "Completed",
                detail: "Event · Sep 2025 · Completed",
                statusColor: AppColors.mutedText,
              ),

              const SizedBox(height: 14),

              Container(height: 1, color: AppColors.glassBorder),

              const SizedBox(height: 14),

              _portfolioRow(
                title: "Greenmarket Trial — 4 Weekends",
                status: "Completed",
                detail: "Vendor program · Jun 2025 · Completed",
                statusColor: AppColors.mutedText,
              ),
            ],

            const SizedBox(height: 18),
            Text(
              "Tap a row to open its prep plan, checklist, and check-ins.",
              style: GoogleFonts.dmSans(
                fontSize: 12,
                color: AppColors.mutedText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sheetTab(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.glassLight : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.glassBorder : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? Colors.white : AppColors.mutedText,
          ),
        ),
      ),
    );
  }

  Widget _portfolioRow({
    required String title,
    required String status,
    required String detail,
    required Color statusColor,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        status,
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: AppColors.mutedText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "· $detail",
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: AppColors.mutedText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.glassLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: const Icon(Icons.edit, size: 16, color: Colors.white70),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Colors.white54),
          ],
        ),
      ),
    );
  }
}

Widget _statusTag({IconData? icon, bool dot = false, required String text}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: AppColors.glassLight,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.glassBorderSoft),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) Icon(icon, size: 12, color: AppColors.goodDot),

        if (dot)
          Container(
            width: 7,
            height: 7,
            margin: const EdgeInsets.only(right: 6),
            decoration: const BoxDecoration(
              color: AppColors.goodText,
              shape: BoxShape.circle,
            ),
          ),

        if (icon != null) const SizedBox(width: 5),

        Text(
          text,
          style: GoogleFonts.dmSans(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      ],
    ),
  );
}

class _TrackButton extends StatelessWidget {
  const _TrackButton({required this.opportunity, required this.ref});

  final OpportunityCard opportunity;
  final WidgetRef ref;

  Future<void> _onTrackTap(BuildContext context) async {
    try {
      await ref
          .read(opportunitiesControllerProvider.notifier)
          .trackOpportunity(opportunity.id);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not track: $e')));
      }
    }
  }

  Future<void> _onUntrackTap(BuildContext context) async {
    try {
      await ref
          .read(opportunitiesControllerProvider.notifier)
          .untrackOpportunity(opportunity.id);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not untrack: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(opportunitiesControllerProvider).value;
    final tracked = data?.isTracked(opportunity.id) ?? false;
    final tracking = data?.isTracking(opportunity.id) ?? false;

    if (tracked) {
      // Ab tappable hai — tap karke untrack (status: "None") ho jayega
      return OutlinedButton(
        onPressed: tracking ? null : () => _onUntrackTap(context),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.06),
          disabledBackgroundColor: Colors.white.withOpacity(0.06),
          side: BorderSide(color: Colors.white.withOpacity(0.24)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (tracking)
              const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            else
              Icon(Icons.check_circle, size: 14, color: AppColors.white),
            const SizedBox(width: 6),
            Text(
              tracking ? "Removing…" : "In portfolio",
              style: GoogleFonts.dmSans(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return OutlinedButton(
      onPressed: tracking ? null : () => _onTrackTap(context),
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.06),
        side: BorderSide(color: Colors.white.withOpacity(0.24)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (tracking)
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          else
            const Icon(Icons.add_circle_outline, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            tracking ? "Tracking…" : "Track",
            style: GoogleFonts.dmSans(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _OpportunityDetailSheet extends ConsumerWidget {
  const _OpportunityDetailSheet({required this.opportunity});

  final OpportunityCard opportunity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;
    final data = ref.watch(opportunitiesControllerProvider).value;
    final tracked = data?.isTracked(opportunity.id) ?? false;
    final tracking = data?.isTracking(opportunity.id) ?? false;

    final whyList = opportunity.whyReasonCodes.isNotEmpty
        ? opportunity.whyReasonCodes
        : [
            "Six pizza-party inquiries hit the shop this month — you took two and turned four away",
            "Parties land in your 2–5pm weekday lull, off the Friday dough line",
            "Trays are your highest-margin format — no delivery-app commission on a school drop-off",
            "Your \$52,400 cash covers the \$75 vendor-list fee many times over",
          ];

    final riskList = opportunity.riskSignals.isNotEmpty
        ? opportunity.riskSignals
        : [
            "Insurance: schools on the district calendar require a certificate of liability naming the school",
            "Payment terms: parent associations often pay by check on delivery — confirm before booking staff",
          ];

    final subtitleParts = <String>[];
    if (opportunity.source.isNotEmpty) {
      subtitleParts.add(opportunity.source);
    }
    if (opportunity.expiresAt.isNotEmpty) {
      final exp = opportunity.expiresAt.toLowerCase().startsWith('closes')
          ? opportunity.expiresAt.toLowerCase()
          : 'closes in ${opportunity.expiresAt}';
      subtitleParts.add(exp);
    }

    final subtitleText = subtitleParts.isNotEmpty
        ? subtitleParts.join(' · ')
        : 'Parent-association vendor list · public schools on the district calendar · closes in 12 days';

    return Container(
      constraints: BoxConstraints(maxHeight: screenHeight * 0.90),
      decoration: BoxDecoration(
        color: const Color(0xFF083144),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(26),
          topRight: Radius.circular(26),
        ),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.2), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 50,
            offset: const Offset(0, -20),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.28),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),

              // Category Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.22),
                  ),
                ),
                child: Text(
                  opportunity.type.toUpperCase(),
                  style: GoogleFonts.dmSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Title
              Text(
                opportunity.title,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),

              // Subtitle
              Text(
                subtitleText,
                style: GoogleFonts.dmSans(
                  fontSize: 12.5,
                  color: AppColors.mutedText,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),

              // Readiness Box
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.16),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 62,
                      height: 62,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const RadialGradient(
                          colors: [Color(0xFF0F5A73), Color(0xFF073042)],
                        ),
                        border: Border.all(
                          color: const Color(0xFF26B2D4).withValues(alpha: 0.6),
                          width: 2.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${opportunity.readinessScore}',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Readiness",
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            "Orb visualization — coming soon",
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              color: AppColors.mutedText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Pills Row: Verified, Risk, Distance
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _pillItem(
                    icon: Icons.verified_outlined,
                    iconColor: AppColors.goodDot,
                    label: opportunity.dataTrustIndicator.isNotEmpty
                        ? opportunity.dataTrustIndicator
                        : "Verified",
                  ),
                  _pillItem(
                    dotColor: AppColors.goodDot,
                    label:
                        "Risk: ${opportunity.riskLevel.isNotEmpty ? opportunity.riskLevel : 'Low'}",
                  ),
                  _pillItem(
                    icon: Icons.location_on_outlined,
                    iconColor: AppColors.mutedText,
                    label: opportunity.distanceLabel.isNotEmpty
                        ? opportunity.distanceLabel.replaceAll('⌖ ', '')
                        : "~${opportunity.driveTimeMinutes} min · ${opportunity.distanceMiles} mi",
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // Section: Why this was suggested
              Text(
                "Why this was suggested",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              ...whyList.map(
                (reason) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 5.5,
                        height: 5.5,
                        margin: const EdgeInsets.only(top: 6, right: 9),
                        decoration: const BoxDecoration(
                          color: Color(0xFF26B2D4),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          reason,
                          style: GoogleFonts.dmSans(
                            fontSize: 12.5,
                            color: Colors.white.withValues(alpha: 0.88),
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Section: Things to verify before committing
              Text(
                "Things to verify before committing",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.14),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < riskList.length; i++) ...[
                      if (i > 0) const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 1),
                            child: Icon(
                              Icons.warning_amber_rounded,
                              size: 16,
                              color: Color(0xFFE5A93C),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              riskList[i],
                              style: GoogleFonts.dmSans(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.85),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Section: Financials
              Text(
                "Financials",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                opportunity.estimatedRevenue.isNotEmpty
                    ? "${opportunity.estimatedRevenue} — ${opportunity.listedFee.isNotEmpty ? opportunity.listedFee : 'parties avg 8 trays on your \$45/\$85 sheet-pan menu'}"
                    : "\$3.6K/season — parties avg 8 trays on your \$45/\$85 sheet-pan menu",
                style: GoogleFonts.dmSans(
                  fontSize: 12.5,
                  color: Colors.white.withValues(alpha: 0.88),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 20),

              // Section: Links
              Text(
                "Links",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              // if (opportunity.registrationUrl.trim().isNotEmpty &&
              //     opportunity.sourceUrl.trim().isNotEmpty) ...[
              //   Row(
              //     children: [
              //       Expanded(
              //         child: OutlinedButton(
              //           onPressed: () {},
              //           style: OutlinedButton.styleFrom(
              //             backgroundColor: const Color(0xFF0D5E75),
              //             side: BorderSide(
              //               color: const Color(
              //                 0xFF26B2D4,
              //               ).withValues(alpha: 0.5),
              //             ),
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(12),
              //             ),
              //             padding: const EdgeInsets.symmetric(vertical: 12),
              //           ),
              //           child: Text(
              //             "Apply / Register",
              //             style: GoogleFonts.dmSans(
              //               fontSize: 12.5,
              //               fontWeight: FontWeight.w700,
              //               color: Colors.white,
              //             ),
              //           ),
              //         ),
              //       ),
              //       const SizedBox(width: 10),
              //       Expanded(
              //         child: OutlinedButton(
              //           onPressed: () {},
              //           style: OutlinedButton.styleFrom(
              //             backgroundColor: Colors.white.withValues(alpha: 0.06),
              //             side: BorderSide(
              //               color: Colors.white.withValues(alpha: 0.24),
              //             ),
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(12),
              //             ),
              //             padding: const EdgeInsets.symmetric(vertical: 12),
              //           ),
              //           child: Text(
              //             "View original listing",
              //             style: GoogleFonts.dmSans(
              //               fontSize: 12.5,
              //               fontWeight: FontWeight.w700,
              //               color: Colors.white,
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ] else if (opportunity.registrationUrl.trim().isNotEmpty) ...[
              //   SizedBox(
              //     width: double.infinity,
              //     child: OutlinedButton(
              //       onPressed: () {},
              //       style: OutlinedButton.styleFrom(
              //         backgroundColor: const Color(0xFF0D5E75),
              //         side: BorderSide(
              //           color: const Color(0xFF26B2D4).withValues(alpha: 0.5),
              //         ),
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(12),
              //         ),
              //         padding: const EdgeInsets.symmetric(vertical: 12),
              //       ),
              //       child: Text(
              //         "Apply / Register",
              //         style: GoogleFonts.dmSans(
              //           fontSize: 12.5,
              //           fontWeight: FontWeight.w700,
              //           color: Colors.white,
              //         ),
              //       ),
              //     ),
              //   ),
              // ] else if (opportunity.sourceUrl.trim().isNotEmpty) ...[
              //   SizedBox(
              //     width: double.infinity,
              //     child: OutlinedButton(
              //       onPressed: () {},
              //       style: OutlinedButton.styleFrom(
              //         backgroundColor: Colors.white.withValues(alpha: 0.06),
              //         side: BorderSide(
              //           color: Colors.white.withValues(alpha: 0.24),
              //         ),
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(12),
              //         ),
              //         padding: const EdgeInsets.symmetric(vertical: 12),
              //       ),
              //       child: Text(
              //         "View original listing",
              //         style: GoogleFonts.dmSans(
              //           fontSize: 12.5,
              //           fontWeight: FontWeight.w700,
              //           color: Colors.white,
              //         ),
              //       ),
              //     ),
              //   ),
              // ]

              // else ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  "Registration guidance not available",
                  style: GoogleFonts.dmSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ),

              // ],
              const SizedBox(height: 16),

              // Divider
              Container(height: 1, color: Colors.white.withValues(alpha: 0.12)),
              const SizedBox(height: 14),

              // Disclaimer
              Text(
                "LightSignal is not affiliated with this opportunity. Verify all details with the organizer.",
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  color: AppColors.mutedText,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 18),

              // Selected / Track Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: tracking
                      ? null
                      : () async {
                          try {
                            if (tracked) {
                              await ref
                                  .read(
                                    opportunitiesControllerProvider.notifier,
                                  )
                                  .untrackOpportunity(opportunity.id);
                            } else {
                              await ref
                                  .read(
                                    opportunitiesControllerProvider.notifier,
                                  )
                                  .trackOpportunity(opportunity.id);
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          }
                        },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: tracked
                        ? const Color(0xFF135B70)
                        : Colors.white.withValues(alpha: 0.08),
                    side: BorderSide(
                      color: tracked
                          ? const Color(0xFF26B2D4)
                          : Colors.white.withValues(alpha: 0.28),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  child: tracking
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (tracked) ...[
                              const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "Selected",
                                style: GoogleFonts.dmSans(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ] else ...[
                              const Icon(
                                Icons.add_circle_outline,
                                size: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "Track opportunity",
                                style: GoogleFonts.dmSans(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  tracked
                      ? "Committed — showing as Selected in your portfolio."
                      : "Add this to your portfolio to track progress.",
                  style: GoogleFonts.dmSans(
                    fontSize: 11.5,
                    color: AppColors.mutedText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _pillItem({
    IconData? icon,
    Color? iconColor,
    Color? dotColor,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: iconColor ?? Colors.white),
            const SizedBox(width: 5),
          ],
          if (dotColor != null) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
