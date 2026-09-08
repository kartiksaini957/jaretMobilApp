import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api_services.dart';
import '../../../utils/pref_utils.dart';

class SessionItem {
  const SessionItem({
    required this.id,
    required this.device,
    required this.location,
    required this.lastActive,
    this.isCurrent = false,
  });

  final String id;
  final String device;
  final String location;
  final String lastActive;
  final bool isCurrent;

  String get formattedLastActive {
    if (isCurrent) return 'now';
    if (lastActive.isEmpty) return 'Active recently';
    final parsed = DateTime.tryParse(lastActive);
    if (parsed == null) return lastActive;
    final now = DateTime.now().toUtc();
    final diff = now.difference(parsed.toUtc());
    if (diff.inSeconds < 60 && diff.inSeconds >= 0) return 'just now';
    if (diff.inMinutes < 60 && diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24 && diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inDays < 30 && diff.inDays > 0) return '${diff.inDays}d ago';
    return '${parsed.year}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')}';
  }
}

class TeamMember {
  const TeamMember({
    required this.id,
    required this.name,
    required this.role,
    this.isOwner = false,
    this.status,
  });

  final String id;
  final String name;
  final String role;
  final bool isOwner;
  final String? status; // "invited", "active", etc. — null for the owner row
}

class SecurityTeamState {
  const SecurityTeamState({
    this.twoFactorEnabled = true,
    this.sessions = const [],
    this.teamMembers = const [],
    this.advisorLink,
    this.revokingSessionId,
    this.isRevokingAll = false,
    this.isLoadingTeam = true,
    this.isLoadingSessions = true,
    this.isInviting = false,
    this.removingMemberId,
    this.isCreatingLink = false,
    this.error,
    this.sessionsError,
  });

  final bool twoFactorEnabled;
  final List<SessionItem> sessions;
  final List<TeamMember> teamMembers;
  final String? advisorLink;
  final String? revokingSessionId;
  final bool isRevokingAll;
  final bool isLoadingTeam;
  final bool isLoadingSessions;
  final bool isInviting;
  final String? removingMemberId;
  final bool isCreatingLink;
  final String? error;
  final String? sessionsError;

  static const roles = ['Bookkeeper', 'Manager', 'Owner'];

  SecurityTeamState copyWith({
    bool? twoFactorEnabled,
    List<SessionItem>? sessions,
    List<TeamMember>? teamMembers,
    String? advisorLink,
    String? revokingSessionId,
    bool clearRevokingSessionId = false,
    bool? isRevokingAll,
    bool? isLoadingTeam,
    bool? isLoadingSessions,
    bool? isInviting,
    String? removingMemberId,
    bool clearRemovingMemberId = false,
    bool? isCreatingLink,
    String? error,
    String? sessionsError,
  }) {
    return SecurityTeamState(
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      sessions: sessions ?? this.sessions,
      teamMembers: teamMembers ?? this.teamMembers,
      advisorLink: advisorLink ?? this.advisorLink,
      revokingSessionId:
          clearRevokingSessionId ? null : (revokingSessionId ?? this.revokingSessionId),
      isRevokingAll: isRevokingAll ?? this.isRevokingAll,
      isLoadingTeam: isLoadingTeam ?? this.isLoadingTeam,
      isLoadingSessions: isLoadingSessions ?? this.isLoadingSessions,
      isInviting: isInviting ?? this.isInviting,
      removingMemberId:
          clearRemovingMemberId ? null : (removingMemberId ?? this.removingMemberId),
      isCreatingLink: isCreatingLink ?? this.isCreatingLink,
      error: error,
      sessionsError: sessionsError,
    );
  }
}

class SecurityTeamController extends Notifier<SecurityTeamState> {
  @override
  SecurityTeamState build() {
    Future.microtask(() {
      _loadTeam();
      _loadSessions();
    });
    return const SecurityTeamState();
  }

  void setTwoFactorEnabled(bool value) =>
      state = state.copyWith(twoFactorEnabled: value);

  // ---- sessions list ----
  Future<void> _loadSessions() async {
    state = state.copyWith(isLoadingSessions: true, sessionsError: null);
    try {
      final token = await PrefUtils.getAccessToken();
      if (token == null || token.isEmpty) {
        throw ApiException('Not signed in.');
      }
      final list = await ApiService().getSessions(accessToken: token);
      if (!ref.mounted) return;
      state = state.copyWith(
        sessions: list
            .map(
              (s) => SessionItem(
                id: s.sessionId,
                device: s.device,
                location: s.ipAddress,
                lastActive: s.lastActive,
                isCurrent: s.isCurrent,
              ),
            )
            .toList(),
        isLoadingSessions: false,
      );
    } catch (e) {
      if (!ref.mounted) return;
      final message =
          e is ApiException ? e.message : 'Could not load active sessions.';
      state = state.copyWith(isLoadingSessions: false, sessionsError: message);
    }
  }

  void refreshSessions() => _loadSessions();

  // ---- team list ----
  Future<void> _loadTeam() async {
    state = state.copyWith(isLoadingTeam: true, error: null);
    try {
      final token = await PrefUtils.getAccessToken();
      if (token == null || token.isEmpty) {
        throw ApiException('Not signed in.');
      }
      final list = await ApiService().getTeam(accessToken: token);
      if (!ref.mounted) return;
      state = state.copyWith(
        teamMembers: list
            .map(
              (m) => TeamMember(
                id: m.id,
                name: m.email,
                role: m.role,
                status: m.status,
                isOwner: m.role.toLowerCase() == 'owner',
              ),
            )
            .toList(),
        isLoadingTeam: false,
      );
    } catch (e) {
      if (!ref.mounted) return;
      final message = e is ApiException ? e.message : 'Could not load team.';
      state = state.copyWith(isLoadingTeam: false, error: message);
    }
  }

  void retryLoadTeam() => _loadTeam();

  Future<void> inviteMember(String email, String role) async {
    final trimmed = email.trim();
    if (trimmed.isEmpty) return;
    state = state.copyWith(isInviting: true, error: null);
    try {
      final token = await PrefUtils.getAccessToken();
      if (token == null || token.isEmpty) {
        throw ApiException('Not signed in.');
      }
      final invited = await ApiService().inviteTeamMember(
        accessToken: token,
        email: trimmed,
        role: role,
      );
      if (!ref.mounted) return;
      state = state.copyWith(
        teamMembers: [
          ...state.teamMembers,
          TeamMember(
            id: invited.id,
            name: invited.email,
            role: invited.role,
            status: invited.status,
          ),
        ],
        isInviting: false,
      );
    } catch (e) {
      if (!ref.mounted) return;
      final message = e is ApiException ? e.message : 'Could not send invite.';
      state = state.copyWith(isInviting: false, error: message);
    }
  }

  Future<void> removeMember(String id) async {
    state = state.copyWith(removingMemberId: id, error: null);
    try {
      final token = await PrefUtils.getAccessToken();
      if (token == null || token.isEmpty) {
        throw ApiException('Not signed in.');
      }
      await ApiService().removeTeamMember(accessToken: token, memberId: id);
      if (!ref.mounted) return;
      state = state.copyWith(
        teamMembers: state.teamMembers.where((m) => m.id != id).toList(),
        clearRemovingMemberId: true,
      );
    } catch (e) {
      if (!ref.mounted) return;
      final message = e is ApiException ? e.message : 'Could not remove team member.';
      state = state.copyWith(clearRemovingMemberId: true, error: message);
    }
  }

  // ---- sessions ----
  Future<void> signOutSession(String id) async {
    state = state.copyWith(revokingSessionId: id, error: null);
    try {
      final token = await PrefUtils.getAccessToken();
      if (token == null || token.isEmpty) {
        throw ApiException('Not signed in.');
      }
      await ApiService().revokeSession(accessToken: token, sessionId: id);
      if (!ref.mounted) return;
      state = state.copyWith(
        sessions: state.sessions.where((s) => s.id != id).toList(),
        clearRevokingSessionId: true,
      );
      // Reload in background
      _loadSessions();
    } catch (e) {
      if (!ref.mounted) return;
      final message = e is ApiException ? e.message : 'Could not sign out that session.';
      state = state.copyWith(clearRevokingSessionId: true, error: message);
    }
  }

  Future<void> signOutEverywhere() async {
    state = state.copyWith(isRevokingAll: true, error: null);
    try {
      final token = await PrefUtils.getAccessToken();
      if (token == null || token.isEmpty) {
        throw ApiException('Not signed in.');
      }
      await ApiService().revokeAllSessions(accessToken: token);
      if (!ref.mounted) return;
      state = state.copyWith(
        sessions: state.sessions.where((s) => s.isCurrent).toList(),
        isRevokingAll: false,
      );
      _loadSessions();
    } catch (e) {
      if (!ref.mounted) return;
      final message = e is ApiException ? e.message : 'Could not sign out other sessions.';
      state = state.copyWith(isRevokingAll: false, error: message);
    }
  }

  // ---- advisor share link ----
  Future<void> createAdvisorLink() async {
    state = state.copyWith(isCreatingLink: true, error: null);
    try {
      final token = await PrefUtils.getAccessToken();
      if (token == null || token.isEmpty) {
        throw ApiException('Not signed in.');
      }
      final link = await ApiService().createShareLink(accessToken: token);
      if (!ref.mounted) return;
      state = state.copyWith(advisorLink: link.shareUrl, isCreatingLink: false);
    } catch (e) {
      if (!ref.mounted) return;
      final message = e is ApiException ? e.message : 'Could not create advisor link.';
      state = state.copyWith(isCreatingLink: false, error: message);
    }
  }
}

final securityTeamProvider =
    NotifierProvider<SecurityTeamController, SecurityTeamState>(
      SecurityTeamController.new,
    );