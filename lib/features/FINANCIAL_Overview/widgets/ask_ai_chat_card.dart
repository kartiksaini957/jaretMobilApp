import 'package:flutter/material.dart';

import '../theme/financial_colors.dart';

class _ChatMessage {
  const _ChatMessage({required this.text, required this.isUser});

  final String text;
  final bool isUser;
}

class AskAiChatCard extends StatefulWidget {
  const AskAiChatCard({super.key, required this.kpiName});

  final String kpiName;

  @override
  State<AskAiChatCard> createState() => _AskAiChatCardState();
}

class _AskAiChatCardState extends State<AskAiChatCard> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [
    const _ChatMessage(text: "What's driving my gross margin?", isUser: true),
    const _ChatMessage(
      text: 'Something went wrong. Please try again.',
      isUser: false,
    ),
  ];

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
      _messages.add(_ChatMessage(text: text, isUser: true));
      _messages.add(
        const _ChatMessage(
          text: 'Something went wrong. Please try again.',
          isUser: false,
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FinancialColors.cardDarkFill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FinancialColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                size: 15,
                color: FinancialColors.white,
              ),
              const SizedBox(width: 8),
              const Text(
                'Ask AI about this KPI',
                style: TextStyle(
                  color: FinancialColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 160),
            child: ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Align(
                    alignment: message.isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: message.isUser
                            ? FinancialColors.cardLightFill
                            : FinancialColors.cardBorder,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        message.text,
                        style: const TextStyle(
                          color: FinancialColors.white,
                          fontSize: 12.5,
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
                    color: FinancialColors.cardLightFill,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: FinancialColors.cardBorder),
                  ),
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _send(),
                    style: const TextStyle(
                      color: FinancialColors.white,
                      fontSize: 12.5,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Ask about ${widget.kpiName}...',
                      hintStyle: const TextStyle(
                        color: FinancialColors.faintText,
                      ),
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
              InkWell(
                onTap: _send,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: FinancialColors.cardLightFill,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.send,
                    size: 16,
                    color: FinancialColors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
