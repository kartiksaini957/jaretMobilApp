// import 'package:flutter/material.dart';

// import '../../opportunity/ScenarioLab/widgets/scenario_lab_colors.dart';

// /// "Recommended steps" detail panel used for the Steps category.
// class StepsDetailPanel extends StatelessWidget {
//   const StepsDetailPanel({
//     super.key,
//     required this.stepIndex,
//     required this.stepCount,
//     required this.title,
//     required this.body,
//     required this.timeline,
//     required this.primaryLabel,
//     required this.secondaryLabel,
//   });

//   final int stepIndex;
//   final int stepCount;
//   final String title;
//   final String body;
//   final String timeline;
//   final String primaryLabel;
//   final String secondaryLabel;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: ScenarioLabColors.cardFillStrong,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: ScenarioLabColors.cardBorder),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'STEP $stepIndex OF $stepCount',
//             style: const TextStyle(
//               color: ScenarioLabColors.faintText,
//               fontSize: 10.5,
//               fontWeight: FontWeight.w700,
//               letterSpacing: 0.6,
//             ),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             title,
//             style: const TextStyle(
//               color: ScenarioLabColors.white,
//               fontSize: 16,
//               fontWeight: FontWeight.w800,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             body,
//             style: const TextStyle(
//               color: ScenarioLabColors.mutedText,
//               fontSize: 12.5,
//               height: 1.45,
//             ),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             timeline,
//             style: const TextStyle(
//               color: ScenarioLabColors.faintText,
//               fontSize: 12.5,
//               height: 1.45,
//             ),
//           ),
//           const SizedBox(height: 16),
//           LayoutBuilder(
//             builder: (context, constraints) {
//               final isNarrow = constraints.maxWidth < 340;
//               final primary = _ActionButton(
//                 label: primaryLabel,
//                 filled: true,
//                 onTap: () {},
//               );
//               final secondary = _ActionButton(
//                 label: secondaryLabel,
//                 filled: false,
//                 onTap: () {},
//               );
//               if (isNarrow) {
//                 return Column(
//                   children: [primary, const SizedBox(height: 10), secondary],
//                 );
//               }
//               return Row(
//                 children: [
//                   Expanded(child: primary),
//                   const SizedBox(width: 10),
//                   Expanded(child: secondary),
//                 ],
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _ActionButton extends StatelessWidget {
//   const _ActionButton({
//     required this.label,
//     required this.filled,
//     required this.onTap,
//   });

//   final String label;
//   final bool filled;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: filled ? ScenarioLabColors.glow : Colors.transparent,
//       borderRadius: BorderRadius.circular(20),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(20),
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 11),
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             border: filled
//                 ? null
//                 : Border.all(color: ScenarioLabColors.cardBorder),
//           ),
//           child: Text(
//             label,
//             style: TextStyle(
//               color: filled
//                   ? const Color(0xFF0A2A57)
//                   : ScenarioLabColors.white,
//               fontSize: 12.5,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
