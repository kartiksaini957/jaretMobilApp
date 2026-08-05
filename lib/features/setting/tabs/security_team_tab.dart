import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../widgets/customToast.dart';
import '../provider/security_team_provider.dart';
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

  void _invite() {
    final email = _inviteController.text.trim();
    if (email.isEmpty) {
      CustomToast.showError(context, 'Enter an email to invite.');
      return;
    }
    ref.read(securityTeamProvider.notifier).inviteMember(email, _inviteRole);
    _inviteController.clear();
    CustomToast.showSuccess(context, 'Invite sent to $email.');
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
              onPressed: () =>
                  CustomToast.showInfo(context, 'Opening password change…'),
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
        const SettingsGroupLabel('Active sessions'),
        for (final session in security.sessions)
          SettingsListRow(
            text:
                '${session.device} · ${session.location} · '
                '${session.lastActive}',
            trailing: [
              if (session.isCurrent)
                const SettingsRowNote('current')
              else
                SettingsPillButton(
                  label: 'Sign out',
                  compact: true,
                  onPressed: () => controller.signOutSession(session.id),
                ),
            ],
          ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: SettingsPillButton(
            label: 'Sign out everywhere',
            tone: SettingsButtonTone.danger,
            onPressed: controller.signOutEverywhere,
          ),
        ),
        const SettingsGroupLabel('Team'),
        for (final member in security.teamMembers)
          SettingsListRow(
            text: '${member.name} · ${member.role}',
            trailing: [
              if (member.isOwner)
                const SettingsRowNote('full access')
              else
                SettingsPillButton(
                  label: 'Remove',
                  compact: true,
                  onPressed: () => controller.removeMember(member.id),
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
              label: 'Invite',
              tone: SettingsButtonTone.primary,
              onPressed: _invite,
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
              label: security.advisorLink == null ? 'Create link' : 'Copy link',
              onPressed: () {
                if (security.advisorLink == null) {
                  controller.createAdvisorLink();
                  return;
                }
                CustomToast.showSuccess(context, 'Link copied.');
              },
            ),
          ],
        ),
      ],
    );
  }
}
