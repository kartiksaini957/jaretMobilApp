import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../widgets/customToast.dart';
import '../provider/security_team_provider.dart';
import '../theme/settings_colors.dart';
import '../widgets/settings_row_controls.dart';
import '../widgets/settings_section_card.dart';

class SecurityTeamTab extends ConsumerStatefulWidget {
  const SecurityTeamTab({super.key});

  @override
  ConsumerState<SecurityTeamTab> createState() => _SecurityTeamTabState();
}

class _SecurityTeamTabState extends ConsumerState<SecurityTeamTab> {
  final _inviteController = TextEditingController();
  String _inviteRole = SecurityTeamState.roles.first;

  @override
  void dispose() {
    _inviteController.dispose();
    super.dispose();
  }

  Future<void> _invite() async {
    final email = _inviteController.text.trim();
    if (email.isEmpty) {
      CustomToast.showError(context, 'Enter an email to invite.');
      return;
    }
    await ref
        .read(securityTeamProvider.notifier)
        .inviteMember(email, _inviteRole);
    if (!mounted) return;
    final error = ref.read(securityTeamProvider).error;
    if (error != null) {
      CustomToast.showError(context, error);
    } else {
      _inviteController.clear();
      CustomToast.showSuccess(context, 'Invite sent to $email.');
    }
  }

  Future<void> _removeMember(String id) async {
    await ref.read(securityTeamProvider.notifier).removeMember(id);
    if (!mounted) return;
    final error = ref.read(securityTeamProvider).error;
    if (error != null) {
      CustomToast.showError(context, error);
    } else {
      CustomToast.showSuccess(context, 'Team member removed.');
    }
  }

  Future<void> _signOutSession(String id) async {
    await ref.read(securityTeamProvider.notifier).signOutSession(id);
    if (!mounted) return;
    final error = ref.read(securityTeamProvider).error;
    if (error != null) {
      CustomToast.showError(context, error);
    } else {
      CustomToast.showSuccess(context, 'Session signed out.');
    }
  }

  Future<void> _signOutEverywhere() async {
    await ref.read(securityTeamProvider.notifier).signOutEverywhere();
    if (!mounted) return;
    final error = ref.read(securityTeamProvider).error;
    if (error != null) {
      CustomToast.showError(context, error);
    } else {
      CustomToast.showSuccess(context, 'Signed out of all other sessions.');
    }
  }

  Future<void> _createOrCopyLink(String? existingLink) async {
    if (existingLink == null) {
      await ref.read(securityTeamProvider.notifier).createAdvisorLink();
      if (!mounted) return;
      final error = ref.read(securityTeamProvider).error;
      if (error != null) {
        CustomToast.showError(context, error);
      } else {
        CustomToast.showSuccess(context, 'Advisor link created.');
      }
      return;
    }
    await Clipboard.setData(ClipboardData(text: existingLink));
    if (!mounted) return;
    CustomToast.showSuccess(context, 'Link copied.');
  }

  @override
  Widget build(BuildContext context) {
    final security = ref.watch(securityTeamProvider);
    final controller = ref.read(securityTeamProvider.notifier);

    return SettingsSectionCard(
      title: 'Security & Team',
      subtitle: 'Who can get in, and who\'s on the account.',
      children: [
        SettingsActionRow(
          label: 'Password',
          actions: [
            SettingsPillButton(
              label: 'Change password',
              onPressed: () => CustomToast.showInfo(
                context,
                'Contact support to change your password',
              ),
            ),
          ],
        ),
        const SettingsDivider(),
        SettingsToggleRow(
          label: 'Two-factor authentication',
          subtitle: 'A code from your phone at sign-in. Strongly recommended.',
          value: security.twoFactorEnabled,
          onChanged: controller.setTwoFactorEnabled,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SettingsGroupLabel('Active sessions'),
            if (!security.isLoadingSessions)
              IconButton(
                icon: const Icon(
                  Icons.refresh_rounded,
                  size: 18,
                  color: SettingsColors.soft,
                ),
                tooltip: 'Refresh sessions',
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  CustomToast.showInfo(context, 'Refreshing sessions…');
                  controller.refreshSessions();
                },
              ),
          ],
        ),
        if (security.isLoadingSessions && security.sessions.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.8,
                    color: SettingsColors.accent,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Loading active sessions…',
                  style: TextStyle(color: SettingsColors.soft, fontSize: 12.5),
                ),
              ],
            ),
          )
        else if (security.sessions.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'No active sessions found.',
              style: TextStyle(color: SettingsColors.soft, fontSize: 12.5),
            ),
          )
        else
          for (final session in security.sessions)
            SettingsListRow(
              text: session.location.isNotEmpty
                  ? '${session.device} · ${session.location} · ${session.formattedLastActive}'
                  : '${session.device} · ${session.formattedLastActive}',
              trailing: [
                if (session.isCurrent)
                  const SettingsRowNote('current')
                else
                  SettingsPillButton(
                    label: security.revokingSessionId == session.id
                        ? 'Signing out…'
                        : 'Sign out',
                    compact: true,
                    onPressed: security.revokingSessionId == session.id
                        ? null
                        : () => _signOutSession(session.id),
                  ),
              ],
            ),
        if (security.sessions.where((s) => !s.isCurrent).isNotEmpty) ...[
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: SettingsPillButton(
              label: security.isRevokingAll
                  ? 'Signing out…'
                  : 'Sign out everywhere',
              tone: SettingsButtonTone.danger,
              onPressed: security.isRevokingAll ? null : _signOutEverywhere,
            ),
          ),
        ],
        const SettingsGroupLabel('Team'),
        if (security.isLoadingTeam && security.teamMembers.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.8,
                    color: SettingsColors.accent,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Loading team members…',
                  style: TextStyle(color: SettingsColors.soft, fontSize: 12.5),
                ),
              ],
            ),
          )
        else if (security.teamMembers.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'No team members yet.',
              style: TextStyle(color: SettingsColors.soft, fontSize: 12.5),
            ),
          )
        else
          for (final member in security.teamMembers)
            SettingsListRow(
              text: member.status != null && member.status != 'active'
                  ? '${member.name} · ${member.role} · ${member.status}'
                  : '${member.name} · ${member.role}',
              trailing: [
                if (member.isOwner)
                  const SettingsRowNote('full access')
                else
                  SettingsPillButton(
                    label: security.removingMemberId == member.id
                        ? 'Removing…'
                        : 'Remove',
                    compact: true,
                    onPressed: security.removingMemberId == member.id
                        ? null
                        : () => _removeMember(member.id),
                  ),
              ],
            ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SettingsTextField(
              controller: _inviteController,
              hintText: 'email@...',
              width: 220,
              onSubmitted: (_) => _invite(),
            ),
            SizedBox(
              width: 140,
              child: SettingsDropdown<String>(
                value: _inviteRole,
                options: SecurityTeamState.roles,
                onChanged: (v) => setState(() => _inviteRole = v),
              ),
            ),
            SettingsPillButton(
              label: security.isInviting ? 'Inviting…' : 'Invite',
              tone: SettingsButtonTone.primary,
              onPressed: security.isInviting ? null : _invite,
            ),
          ],
        ),
        const SettingsDivider(),
        SettingsActionRow(
          label: 'Advisor view link',
          subtitle:
              security.advisorLink ??
              'A read-only link to your Financial Overview and Business '
                  'Health for your accountant — no account needed. Expires '
                  'in 30 days.',
          actions: [
            SettingsPillButton(
              label: security.isCreatingLink
                  ? 'Creating…'
                  : (security.advisorLink == null
                        ? 'Create link'
                        : 'Copy link'),
              onPressed: security.isCreatingLink
                  ? null
                  : () => _createOrCopyLink(security.advisorLink),
            ),
          ],
        ),
      ],
    );
  }
}
