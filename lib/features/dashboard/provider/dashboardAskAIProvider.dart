// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/features/dashboard/model/dashboardAskAIhistoryModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/api_services.dart';
import '../../../utils/pref_utils.dart';

enum ChatRole { user, assistant }

class ChatMessage {
  const ChatMessage({
    required this.role,
    required this.text,
    this.isLoading = false,
  });

  final ChatRole role;
  final String text;
  final bool isLoading;
}

class DashboardChatNotifier extends StateNotifier<List<ChatMessage>> {
  DashboardChatNotifier(this.ref) : super([]); 
  // DashboardChatNotifier() : super([]);
  final Ref ref;   
  String? _chatId;
  bool _loading = false;
  bool get isLoadingHistory => _loading;
  bool get isSending => state.isNotEmpty && state.last.isLoading;

  Future<void> sendMessage(String question) async {
    final trimmed = question.trim();
    if (trimmed.isEmpty || isSending) return;

    // user msg + placeholder loading bubble for the answer
    state = [
      ...state,
      ChatMessage(role: ChatRole.user, text: trimmed),
      const ChatMessage(role: ChatRole.assistant, text: '', isLoading: true),
    ];

    try {
      final token = await PrefUtils.getAccessToken();
      if (token == null || token.isEmpty) {
        throw ApiException('Not signed in.');
      }
      final response = await ApiService().askDashboard(
        accessToken: token,
        question: trimmed,
        chatId: _chatId,
      );
      _chatId = response.data.chatId;

      state = [
        ...state.sublist(0, state.length - 1),
        ChatMessage(role: ChatRole.assistant, text: response.data.answer),
      ];
    } catch (e) {
      final message = e is ApiException
          ? e.message
          : 'Something went wrong. Please try again.';
      state = [
        ...state.sublist(0, state.length - 1),
        ChatMessage(role: ChatRole.assistant, text: message),
      ];
    }
  }

  Future<void> openChat(String chatId) async {
    ref.read(chatHistoryLoadingProvider.notifier).state = true;  
    _loading = true;
    state = []; // clear while loading
    try {
      final token = await PrefUtils.getAccessToken();
      if (token == null || token.isEmpty) {
        throw ApiException('Not signed in.');
      }
      final detail = await ApiService().getDashboardChatDetail(
        accessToken: token,
        chatId: chatId,
      );
      _chatId = detail.id;
      state = [
        for (final m in detail.messages)
          ChatMessage(
            role: m.role == 'q' ? ChatRole.user : ChatRole.assistant,
            text: m.text,
          ),
      ];
    } catch (e) {
      final message = e is ApiException ? e.message : 'Could not load chat.';
      state = [ChatMessage(role: ChatRole.assistant, text: message)];
    } finally {
      _loading = false;
       ref.read(chatHistoryLoadingProvider.notifier).state = false;  
    }
  }

  void startNewChat() {
    _chatId = null;
    state = [];
  }
}

final dashboardChatProvider =
    StateNotifierProvider.autoDispose<DashboardChatNotifier, List<ChatMessage>>(
      (ref) => DashboardChatNotifier(ref),
    );
    final chatHistoryLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);
final chatSearchQueryProvider = StateProvider.autoDispose<String>((ref) => '');

/// Chat list, refetches automatically whenever chatSearchQueryProvider changes.
final dashboardChatListProvider = FutureProvider.autoDispose<List<ChatSummary>>(
  (ref) async {
    final query = ref.watch(chatSearchQueryProvider);
    final token = await PrefUtils.getAccessToken();
    if (token == null || token.isEmpty) {
      throw ApiException('Not signed in.');
    }
    final response = await ApiService().getDashboardChats(
      accessToken: token,
      query: query,
    );
    return response.data;
  },
);
