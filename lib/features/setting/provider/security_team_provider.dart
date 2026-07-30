import 'package:flutter_riverpod/flutter_riverpod.dart';

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
}

class TeamMember {
  const TeamMember({
    required this.id,
    required this.name,
    required this.role,
    this.isOwner = false,
  });

  final String id;
  final String name;
  final String role;
  final bool isOwner;
}

class SecurityTeamState {
  const SecurityTeamState({
    this.twoFactorEnabled = true,
    this.sessions = const [
      SessionItem(
        id: 'this_device',
        device: 'This device',
        location: 'Mobile, AL',
        lastActive: 'now',
        isCurrent: true,
      ),
      SessionItem(
        id: 'iphone',
        device: 'iPhone',
        location: 'Mobile, AL',
        lastActive: '3h ago',
      ),
    ],
    this.teamMembers = const [
      TeamMember(id: 'owner', name: 'Jaret (you)', role: 'Owner', isOwner: true),
      TeamMember(id: 'sam', name: 'sambooks@cpafirm.com', role: 'Bookkeeper'),
    ],
    this.advisorLink,
  });

  final bool twoFactorEnabled;
  final List<SessionItem> sessions;
  final List<TeamMember> teamMembers;
  final String? advisorLink;

  static const roles = ['Bookkeeper', 'Manager', 'Owner'];

  SecurityTeamState copyWith({
    bool? twoFactorEnabled,
    List<SessionItem>? sessions,
    List<TeamMember>? teamMembers,
    String? advisorLink,
  }) {
    return SecurityTeamState(
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      sessions: sessions ?? this.sessions,
      teamMembers: teamMembers ?? this.teamMembers,
      advisorLink: advisorLink ?? this.advisorLink,
    );
  }
}

/// Security & Team tab: 2FA, active sessions, team roster, and the
/// read-only advisor share link.
class SecurityTeamController extends Notifier<SecurityTeamState> {
  @override
  SecurityTeamState build() => const SecurityTeamState();

  void setTwoFactorEnabled(bool value) =>
      state = state.copyWith(twoFactorEnabled: value);

  void signOutSession(String id) {
    state = state.copyWith(
      sessions: state.sessions.where((s) => s.id != id || s.isCurrent).toList(),
    );
  }

  void signOutEverywhere() {
    state = state.copyWith(
      sessions: state.sessions.where((s) => s.isCurrent).toList(),
    );
  }

  void inviteMember(String email, String role) {
    final trimmed = email.trim();
    if (trimmed.isEmpty) return;
    state = state.copyWith(
      teamMembers: [
        ...state.teamMembers,
        TeamMember(
          id: '${trimmed}_${DateTime.now().microsecondsSinceEpoch}',
          name: trimmed,
          role: role,
        ),
      ],
    );
  }

  void removeMember(String id) {
    state = state.copyWith(
      teamMembers: state.teamMembers.where((m) => m.id != id).toList(),
    );
  }

  void createAdvisorLink() {
    state = state.copyWith(
      advisorLink: 'https://app.lightsignal.co/advisor/${DateTime.now().microsecondsSinceEpoch}',
    );
  }
}

final securityTeamProvider =
    NotifierProvider<SecurityTeamController, SecurityTeamState>(
      SecurityTeamController.new,
    );
