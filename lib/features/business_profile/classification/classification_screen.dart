import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/customAppbar.dart';
import '../../../widgets/customToast.dart';
import '../../../widgets/gradient_background.dart';
import '../data/classification_data.dart';
import '../flow/widgets/flow_header.dart';
import 'widgets/classification_header_card.dart';
import 'widgets/classification_item_block.dart';

/// "How LightSignal sees your business" — review each classification the
/// AI has made, one at a time or all at once, and correct anything wrong.
class ClassificationScreen extends StatefulWidget {
  const ClassificationScreen({super.key});

  @override
  State<ClassificationScreen> createState() => _ClassificationScreenState();
}

class _ClassificationScreenState extends State<ClassificationScreen> {
  bool _showAllAtOnce = false;
  int _currentIndex = 0;

  int? _editingIndex;
  final Map<int, String> _corrections = {};
  final Map<int, TextEditingController> _controllers = {};

  TextEditingController _controllerFor(int index) =>
      _controllers.putIfAbsent(index, TextEditingController.new);

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startCorrecting(int index) => setState(() => _editingIndex = index);

  void _cancelCorrecting(int index) {
    _controllerFor(index).clear();
    setState(() => _editingIndex = null);
  }

  void _saveCorrection(int index) {
    final text = _controllerFor(index).text.trim();
    if (text.isEmpty) return;
    setState(() {
      _corrections[index] = text;
      _editingIndex = null;
    });
  }

  void _looksRight() {
    if (_currentIndex < classificationItems.length - 1) {
      setState(() => _currentIndex++);
    } else {
      CustomToast.showSuccess(context, 'Classification reviewed.');
      Navigator.of(context).pop();
    }
  }

  void _goBackItem() {
    if (_currentIndex > 0) setState(() => _currentIndex--);
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
                  label: 'CLASSIFICATION',
                  onBack: () => Navigator.of(context).pop(),
                ),
                const SizedBox(height: 14),
                ClassificationHeaderCard(
                  lastClassifiedLabel: 'Last classified Feb 9 · v4',
                  showingAllAtOnce: _showAllAtOnce,
                  onToggleMode: () =>
                      setState(() => _showAllAtOnce = !_showAllAtOnce),
                  onHistoryTap: () {},
                ),
                const SizedBox(height: 16),
                _showAllAtOnce ? _buildAllAtOnce() : _buildOneAtATime(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOneAtATime() {
    final item = classificationItems[_currentIndex];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.glassDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_currentIndex + 1} OF $classificationTotalCount',
            style: AppTextStyles.eyebrow,
          ),
          const SizedBox(height: 8),
          ClassificationItemBlock(
            item: item,
            isEditing: _editingIndex == _currentIndex,
            isCorrected: _corrections.containsKey(_currentIndex),
            controller: _controllerFor(_currentIndex),
            onCorrectThisTap: () => _startCorrecting(_currentIndex),
            onSave: () => _saveCorrection(_currentIndex),
            onCancel: () => _cancelCorrecting(_currentIndex),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              OutlinedButton(
                onPressed: _currentIndex == 0 ? null : _goBackItem,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.glassBorder),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  '← Back',
                  style: AppTextStyles.buttonLabel.copyWith(fontSize: 13.5),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _looksRight,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.ink,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Looks right →',
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAllAtOnce() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.glassDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          for (var i = 0; i < classificationItems.length; i++)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                border: i != classificationItems.length - 1
                    ? const Border(
                        bottom: BorderSide(color: AppColors.glassBorderSoft),
                      )
                    : null,
              ),
              child: ClassificationItemBlock(
                item: classificationItems[i],
                isEditing: _editingIndex == i,
                isCorrected: _corrections.containsKey(i),
                controller: _controllerFor(i),
                onCorrectThisTap: () => _startCorrecting(i),
                onSave: () => _saveCorrection(i),
                onCancel: () => _cancelCorrecting(i),
              ),
            ),
        ],
      ),
    );
  }
}
