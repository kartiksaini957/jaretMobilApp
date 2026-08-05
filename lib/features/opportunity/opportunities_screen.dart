import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/FINANCIAL_Overview/financial_overview_screen.dart';
import 'package:flutter_application_1/features/business_health/business_health_screen.dart';
import 'package:flutter_application_1/features/business_profile/business_profile_screen.dart';
import 'package:flutter_application_1/features/dashboard/dashboard_screen.dart';
import 'package:flutter_application_1/features/demand_Forecast/demand_forecast_screen.dart';
import 'package:flutter_application_1/widgets/gradient_background.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';

import '../../widgets/app_nav_drawer.dart';
import '../../widgets/customAppbar.dart';

// import '../features/FINANCIAL_Overview/financial_overview_screen.dart';
// import '../features/Scenario_lab/scenario_lab_screen.dart';
// import '../features/business_health/business_health_screen.dart';
// import '../features/business_profile/business_profile_screen.dart';
// import '../features/dashboard/dashboard_screen.dart';
// import '../features/demand_Forecast/demand_forecast_screen.dart';
// import '../widgets/gradient_background.dart';
import 'FilterChip.dart';
import 'ScenarioLab/cenario_lab_screen.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(opportunitiesProvider);

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
                  "Tuesday, February 11",
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
                  style: AppTextStyles.eyebrow.copyWith(color: AppColors.white),
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

                      value: "${data.active}",

                      subtitle: "Browse all matches",
                    ),

                    MetricCard(
                      title: "NEW THIS WEEK",

                      value: "${data.newThisWeek}",

                      subtitle: "Fresh since Monday",

                      badge: "NEW",
                    ),

                    MetricCard(
                      title: "TOTAL POTENTIAL\nVALUE",

                      value: data.totalValue,

                      subtitle: "Across 11 estimates",
                    ),

                    MetricCard(
                      title: "AVG FIT SCORE",

                      value: "${data.fitScore}",

                      subtitle: "Good alignment",
                    ),
                  ],
                ),

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
                              "3 events in the next 30 days",

                              style: AppTextStyles.body.copyWith(
                                color: AppColors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Text(
                        "${data.readiness}",

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
                  style: AppTextStyles.eyebrow.copyWith(color: AppColors.white),
                ),

                const SizedBox(height: 12),

                Container(
                  height: 48,

                  decoration: glassDecoration(),

                  child: TextField(
                    style: AppTextStyles.body,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.white70),

                      hintText: "Search — by name, source, or type...",

                      hintStyle: TextStyle(color: Colors.white54),

                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        // borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // The chips stay on one line and scroll sideways — a plain
                // Row overflows once they outgrow a narrow phone.
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: const [
                      FilterChipWidget(text: "Type"),
                      SizedBox(width: 8),
                      FilterChipWidget(text: "Distance"),
                      SizedBox(width: 8),
                      FilterChipWidget(text: "Risk"),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  "RECOMMENDED FOR YOU  14",
                  style: AppTextStyles.eyebrow.copyWith(color: AppColors.white),
                ),

                const SizedBox(height: 12),

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
                              border: Border.all(color: AppColors.glassBorder),
                            ),

                            child: Text(
                              "VENDOR PROGRAM",
                              style: AppTextStyles.eyebrow.copyWith(
                                color: AppColors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),

                          const Spacer(),

                          _scoreBox("88", "MATCH"),

                          const SizedBox(width: 8),

                          _scoreBox("82", "READY"),
                        ],
                      ),

                      const SizedBox(height: 14),

                      Text(
                        "School Pizza-Party\nVendor Window — Spring",
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 17.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Parent-association vendor list ·\npublic schools on the district calendar",
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
                          _statusTag(
                            icon: Icons.check_circle_outline,
                            text: "Verified",
                          ),

                          const SizedBox(width: 8),

                          _statusTag(dot: true, text: "Risk: Low"),

                          const SizedBox(width: 8),

                          Text(
                            "⌖ ~8 min · 2.6 mi",
                            style: GoogleFonts.dmSans(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w400,
                              color: AppColors.mutedText,
                            ),
                          ),
                        ],
                      ),

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
                              "closes in 12 days",
                              style: GoogleFonts.dmSans(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.warnText,
                              ),
                            ),
                          ],
                        ),

                        // child: Text(
                        //   "◷ closes in 12 days",
                        //   style: GoogleFonts.dmSans(
                        //     fontSize:12,
                        //     fontWeight:FontWeight.w400,
                        //     color: AppColors.warnText,
                        //   ),
                        // ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        "• Six pizza-party inquiries hit the shop this month\n"
                        "  — you took two and turned four away\n\n"
                        "• Parties land in your 2–5pm weekday lull, off the Friday dough line\n\n"
                        "• +2 more in detail →",
                        style: GoogleFonts.dmSans(
                          fontSize: 12.5,
                          height: 1.45,
                          color: AppColors.mutedText,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Container(height: 1, color: AppColors.glassBorder),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "\$3.6K/season —\nparties avg 8 trays on your \$45/\$85 sheet-pan menu",
                              style: GoogleFonts.dmSans(
                                fontSize: 11.5,
                                height: 1.45,
                                color: AppColors.mutedText,
                              ),
                            ),
                          ),

                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.06),
                              side: BorderSide(
                                color: Colors.white.withOpacity(0.24),
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
                                  Icons.check_circle,
                                  size: 14,
                                  color: AppColors.white, // mint/teal check
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "In portfolio",
                                  style: GoogleFonts.dmSans(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 8),

                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.06),
                              side: BorderSide(
                                color: Colors.white.withOpacity(0.24),
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
                                  color: AppColors.white, // cyan eye
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

                const SizedBox(height: 28),

                Text(
                  "More matches — tap one to bring it to the top",
                  style: AppTextStyles.eyebrow.copyWith(color: AppColors.white),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  height: 140,

                  child: Row(
                    children: [
                      Expanded(
                        child: _matchCard(
                          type: "RFP",
                          badge: "19d",
                          title:
                              "Office Park on 4th Ave —\nWeekly Staff-Lunch...",
                          distance: "~7 min · 1.2 mi",
                          score1: "86",
                          score2: "74",
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _matchCard(
                          type: "EVENT",
                          title: "5th Avenue Spring\nFair — Food Booth",
                          distance: "~3 min · 0.4 mi",
                          score1: "84",
                          score2: "78",
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                Text(
                  "YOUR PORTFOLIO",
                  style: AppTextStyles.eyebrow.copyWith(color: AppColors.white),
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
                              onTapUp: (_) => setLocalState(() => scale = 1.0),
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
