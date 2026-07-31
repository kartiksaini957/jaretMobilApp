import 'package:flutter/material.dart';

import '../../../widgets/customAppbar.dart';
import '../../../widgets/customToast.dart';
import '../../../widgets/gradient_background.dart';
import '../data/owner_notes_data.dart';
import '../flow/widgets/flow_header.dart';
import 'widgets/owner_note_input_card.dart';
import 'widgets/owner_notes_list.dart';

/// "Tell LightSignal something" — a free-text note field plus the running
/// history of owner notes, newest first.
class OwnerNotesScreen extends StatefulWidget {
  const OwnerNotesScreen({super.key});

  @override
  State<OwnerNotesScreen> createState() => _OwnerNotesScreenState();
}

class _OwnerNotesScreenState extends State<OwnerNotesScreen> {
  static const _monthAbbrev = [
    'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
    'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
  ];

  final _controller = TextEditingController();
  late final List<OwnerNote> _notes = [...ownerNotesSeed];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _todayLabel {
    final now = DateTime.now();
    return '${_monthAbbrev[now.month - 1]} ${now.day}';
  }

  void _saveNote() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _notes.insert(0, OwnerNote(dateLabel: _todayLabel, body: text));
      _controller.clear();
    });
    CustomToast.showSuccess(context, 'Note saved.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Business Profile',
        hasUnreadNotifications: true,
      ),
      body: GradientBackground(
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FlowHeader(
                  label: 'OWNER NOTES',
                  onBack: () => Navigator.of(context).pop(),
                ),
                const SizedBox(height: 14),
                OwnerNoteInputCard(controller: _controller, onSave: _saveNote),
                const SizedBox(height: 16),
                OwnerNotesList(notes: _notes),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
