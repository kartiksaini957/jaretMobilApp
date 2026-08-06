// import 'package:flutter/material.dart';

// import '../../opportunity/ScenarioLab/widgets/scenario_lab_colors.dart';

// /// "PEER OUTCOME" / "ALTERNATIVE" style detail card used for the Peer
// /// outcomes and Alternatives categories.
// class NoteDetailPanel extends StatelessWidget {
//   const NoteDetailPanel({
//     super.key,
//     required this.eyebrow,
//     required this.headline,
//     required this.body,
//     required this.footnote,
//   });

//   final String eyebrow;
//   final String headline;
//   final String body;
//   final String footnote;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: ScenarioLabColors.cardFill,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: ScenarioLabColors.cardBorder),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             eyebrow,
//             style: const TextStyle(
//               color: ScenarioLabColors.faintText,
//               fontSize: 10.5,
//               fontWeight: FontWeight.w700,
//               letterSpacing: 0.6,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             headline,
//             style: const TextStyle(
//               color: ScenarioLabColors.white,
//               fontSize: 15.5,
//               fontWeight: FontWeight.w800,
//               height: 1.3,
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
//             footnote,
//             style: const TextStyle(
//               color: ScenarioLabColors.faintText,
//               fontSize: 12.5,
//               height: 1.45,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
