import 'package:flutter/material.dart';

import '../../../core/api_services.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/pref_utils.dart';
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
  final _controller = TextEditingController();
  List<OwnerNote> _notes = [];
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchNotes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = await PrefUtils.getAccessToken();
      if (token == null || token.isEmpty) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _notes = [...ownerNotesSeed];
          });
        }
        return;
      }

      final list =
          await ApiService().getBusinessProfileNotes(accessToken: token);
      if (mounted) {
        setState(() {
          _isLoading = false;
          _notes = list;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        CustomToast.showError(context, e.toString());
      }
    }
  }

  Future<void> _saveNote() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final token = await PrefUtils.getAccessToken();
      if (token == null || token.isEmpty) {
        throw 'Authentication token not found. Please log in again.';
      }

      final savedNote = await ApiService().addBusinessProfileNote(
        accessToken: token,
        text: text,
      );

      if (mounted) {
        setState(() {
          _notes.insert(0, savedNote);
          _controller.clear();
        });
        CustomToast.showSuccess(context, 'Note saved.');
      }
    } catch (e) {
      if (mounted) {
        CustomToast.showError(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _deleteNote(int index, OwnerNote note) async {
    setState(() {
      _notes.removeAt(index);
    });
    CustomToast.showSuccess(context, 'Note deleted.');

    if (note.id.isNotEmpty) {
      try {
        final token = await PrefUtils.getAccessToken();
        if (token != null && token.isNotEmpty) {
          await ApiService().deleteBusinessProfileNote(
            accessToken: token,
            noteId: note.id,
          );
        }
      } catch (e) {
        debugPrint('Error deleting note from API: $e');
      }
    }
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
          child: RefreshIndicator(
            onRefresh: _fetchNotes,
            color: AppColors.accent,
            backgroundColor: AppColors.glassDark,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FlowHeader(
                    label: 'OWNER NOTES',
                    onBack: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(height: 14),
                  OwnerNoteInputCard(
                    controller: _controller,
                    onSave: _saveNote,
                    isSaving: _isSaving,
                  ),
                  const SizedBox(height: 16),
                  if (_isLoading)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: AppColors.glassDark,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: AppColors.accent,
                        ),
                      ),
                    )
                  else
                    OwnerNotesList(
                      notes: _notes,
                      onDelete: _deleteNote,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
