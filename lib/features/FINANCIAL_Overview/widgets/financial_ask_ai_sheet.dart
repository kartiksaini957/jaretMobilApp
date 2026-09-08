import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../data/financial_overview_data.dart';

class FinancialAskAiSheet extends StatefulWidget {
  const FinancialAskAiSheet({
    super.key,
    required this.metricLabel,
    required this.seedTranscript,
  });

  final String metricLabel;
  final List<AskAiMessage> seedTranscript;

  static Future<void> show(
    BuildContext context, {
    required String metricLabel,
    required List<AskAiMessage> seedTranscript,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => FinancialAskAiSheet(
        metricLabel: metricLabel,
        seedTranscript: seedTranscript,
      ),
    );
  }

  @override
  State<FinancialAskAiSheet> createState() => _FinancialAskAiSheetState();
}

class _FinancialAskAiSheetState extends State<FinancialAskAiSheet> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  late final List<AskAiMessage> _messages = [...widget.seedTranscript];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(AskAiMessage(fromAi: false, text: text));
      _messages.add(
        AskAiMessage(
          fromAi: true,
          text:
              'Got it — scoped to ${widget.metricLabel}, I\'ll factor '
              "that in next time this read refreshes.",
        ),
      );
    });
    _controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        top: false,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          decoration: const BoxDecoration(
            color: AppColors.sheetSurface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.glassBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'ASK ABOUT ${widget.metricLabel.toUpperCase()}',
                style: AppTextStyles.eyebrow,
              ),
              const SizedBox(height: 12),
              Flexible(
                child: ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Align(
                        alignment: message.fromAi
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth:
                                MediaQuery.of(context).size.width * 0.75,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: message.fromAi
                                ? AppColors.glassLight
                                : AppColors.accent,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            message.text,
                            style: TextStyle(
                              color: message.fromAi
                                  ? AppColors.white
                                  : AppColors.ink,
                              fontSize: 12.5,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.glassLight,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: TextField(
                        controller: _controller,
                        onSubmitted: (_) => _send(),
                        style: AppTextStyles.small.copyWith(
                          color: AppColors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Ask anything about '
                              '${widget.metricLabel}...',
                          hintStyle: AppTextStyles.small,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _send,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: AppColors.ink,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Ask',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Scoped to this ratio · there is no tab-bottom Ask AI on '
                'Financial Overview',
                style: AppTextStyles.small.copyWith(fontSize: 10.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
