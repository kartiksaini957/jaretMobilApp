import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/dashboard/model/dashboardAskAIhistoryModel.dart';
import 'package:flutter_application_1/features/dashboard/provider/dashboardAskAIProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/app_theme.dart';
import 'dart:async';
// import '../model/dashboardChatsModel.dart';
// import '../provider/dashboardChatProvider.dart';

String _formatChatTime(String iso) {
  try {
    final dt = DateTime.parse(iso).toLocal();
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year} · $hour12:$minute $ampm';
  } catch (_) {
    return iso;
  }
}

Future<void> showChatHistorySheet(
  BuildContext context, {
  required WidgetRef ref,
}) {
  ref.read(chatSearchQueryProvider.notifier).state = '';
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const _ChatHistorySheet(),
  );
}

class _ChatHistorySheet extends ConsumerStatefulWidget {
  const _ChatHistorySheet();

  @override
  ConsumerState<_ChatHistorySheet> createState() => _ChatHistorySheetState();
}

class _ChatHistorySheetState extends ConsumerState<_ChatHistorySheet> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      ref.read(chatSearchQueryProvider.notifier).state = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatsAsync = ref.watch(dashboardChatListProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.baseDeep,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          child: Column(
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
              Text('CHAT HISTORY', style: AppTextStyles.eyebrow),
              const SizedBox(height: 12),
              TextField(
                controller: _searchController,
                style: AppTextStyles.body.copyWith(color: AppColors.white),
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search chats...',
                  hintStyle: AppTextStyles.body.copyWith(
                    color: AppColors.faintText,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.faintText,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: AppColors.glassDark,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.glassBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.glassBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.accent),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: chatsAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Center(
                    child: Text(
                      'Could not load chats.',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.faintText,
                      ),
                    ),
                  ),
                  data: (chats) {
                    if (chats.isEmpty) {
                      return Center(
                        child: Text(
                          'No chats found.',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.faintText,
                          ),
                        ),
                      );
                    }
                    return ListView.separated(
                      controller: scrollController,
                      itemCount: chats.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) =>
                          _ChatTile(chat: chats[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ChatTile extends ConsumerWidget {
  const _ChatTile({required this.chat});
  final ChatSummary chat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () async {
        Navigator.of(context).pop();
        await ref.read(dashboardChatProvider.notifier).openChat(chat.id);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.glassDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chat.title.isEmpty ? 'Untitled chat' : chat.title,
              style: AppTextStyles.body.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              _formatChatTime(
                chat.updatedAt.isNotEmpty ? chat.updatedAt : chat.createdAt,
              ),
              style: AppTextStyles.body.copyWith(
                color: AppColors.faintText,
                fontSize: 11.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
