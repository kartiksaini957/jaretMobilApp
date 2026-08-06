// import 'package:flutter/material.dart';

// import '../../opportunity/ScenarioLab/widgets/scenario_lab_colors.dart';

// /// Sticky bottom input bar for asking/following up on a scenario.
// class FollowUpInputBar extends StatefulWidget {
//   const FollowUpInputBar({
//     super.key,
//     required this.hintText,
//     required this.onSubmit,
//   });

//   final String hintText;
//   final ValueChanged<String> onSubmit;

//   @override
//   State<FollowUpInputBar> createState() => _FollowUpInputBarState();
// }

// class _FollowUpInputBarState extends State<FollowUpInputBar> {
//   final _controller = TextEditingController();

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _submit() {
//     final text = _controller.text.trim();
//     if (text.isEmpty) return;
//     widget.onSubmit(text);
//     _controller.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: Container(
//             decoration: BoxDecoration(
//               color: ScenarioLabColors.cardFill,
//               borderRadius: BorderRadius.circular(24),
//               border: Border.all(color: ScenarioLabColors.cardBorder),
//             ),
//             child: TextField(
//               controller: _controller,
//               onSubmitted: (_) => _submit(),
//               style: const TextStyle(
//                 color: ScenarioLabColors.white,
//                 fontSize: 13,
//               ),
//               decoration: InputDecoration(
//                 hintText: widget.hintText,
//                 hintStyle: const TextStyle(
//                   color: ScenarioLabColors.faintText,
//                 ),
//                 border: InputBorder.none,
//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 12,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 8),
//         Material(
//           color: ScenarioLabColors.glow,
//           shape: const CircleBorder(),
//           child: InkWell(
//             onTap: _submit,
//             customBorder: const CircleBorder(),
//             child: const Padding(
//               padding: EdgeInsets.all(10),
//               child: Icon(
//                 Icons.arrow_upward,
//                 size: 18,
//                 color: Color(0xFF0A2A57),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
