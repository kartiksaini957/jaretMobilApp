// import 'package:flutter/material.dart';

// import '../../opportunity/ScenarioLab/widgets/scenario_lab_colors.dart';

// class AssumptionData {
//   const AssumptionData({
//     required this.label,
//     required this.value,
//     required this.source,
//   });

//   final String label;
//   final String value;
//   final String source;
// }

// /// Collapsible "ASSUMPTIONS" list with an edit icon per row.
// class AssumptionsSection extends StatefulWidget {
//   const AssumptionsSection({super.key, required this.assumptions});

//   final List<AssumptionData> assumptions;

//   @override
//   State<AssumptionsSection> createState() => _AssumptionsSectionState();
// }

// class _AssumptionsSectionState extends State<AssumptionsSection> {
//   bool _expanded = false;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: ScenarioLabColors.cardFill,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: ScenarioLabColors.cardBorder),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           InkWell(
//             onTap: () => setState(() => _expanded = !_expanded),
//             borderRadius: BorderRadius.circular(16),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//               child: Row(
//                 children: [
//                   const Text(
//                     'ASSUMPTIONS',
//                     style: TextStyle(
//                       color: ScenarioLabColors.white,
//                       fontSize: 13,
//                       fontWeight: FontWeight.w800,
//                       letterSpacing: 0.5,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Container(
//                     width: 20,
//                     height: 20,
//                     alignment: Alignment.center,
//                     decoration: const BoxDecoration(
//                       color: ScenarioLabColors.cardFillStrong,
//                       shape: BoxShape.circle,
//                     ),
//                     child: Text(
//                       '${widget.assumptions.length}',
//                       style: const TextStyle(
//                         color: ScenarioLabColors.white,
//                         fontSize: 11,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ),
//                   const Spacer(),
//                   AnimatedRotation(
//                     turns: _expanded ? 0.25 : 0,
//                     duration: const Duration(milliseconds: 200),
//                     child: const Icon(
//                       Icons.chevron_right,
//                       color: ScenarioLabColors.faintText,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           AnimatedSize(
//             duration: const Duration(milliseconds: 200),
//             curve: Curves.easeInOut,
//             alignment: Alignment.topCenter,
//             child: !_expanded
//                 ? const SizedBox(width: double.infinity)
//                 : Padding(
//                     padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
//                     child: Column(
//                       children: [
//                         for (var i = 0; i < widget.assumptions.length; i++) ...[
//                           if (i > 0)
//                             Container(
//                               height: 1,
//                               color: ScenarioLabColors.cardBorder,
//                               margin: const EdgeInsets.symmetric(vertical: 10),
//                             ),
//                           _AssumptionRow(data: widget.assumptions[i]),
//                         ],
//                       ],
//                     ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _AssumptionRow extends StatelessWidget {
//   const _AssumptionRow({required this.data});

//   final AssumptionData data;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: Text(
//             data.label,
//             style: const TextStyle(
//               color: ScenarioLabColors.mutedText,
//               fontSize: 13,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Text(
//               data.value,
//               style: const TextStyle(
//                 color: ScenarioLabColors.white,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w800,
//               ),
//             ),
//             Text(
//               data.source,
//               style: const TextStyle(
//                 color: ScenarioLabColors.faintText,
//                 fontSize: 10.5,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(width: 10),
//         InkWell(
//           onTap: () {},
//           child: const Icon(
//             Icons.edit_outlined,
//             size: 16,
//             color: ScenarioLabColors.faintText,
//           ),
//         ),
//       ],
//     );
//   }
// }
