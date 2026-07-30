import 'package:flutter/material.dart';
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${session.device} · ${session.location} · ${session.lastActive}',
                    style: const TextStyle(
                      color: SettingsColors.white,
                      fontSize: 13,
                    ),
                  ),
                ),
                if (session.isCurrent)
                  const Text(
                    'current',
                    style: TextStyle(
                      color: SettingsColors.faintText,
                      fontSize: 12,
                    ),
                  )
                else
                  SettingsPillButton(
                    label: 'Sign out',
                    onPressed: () => controller.signOutSession(session.id),
                  ),
              ],
            ),
          ),
        const SizedBox(height: 10),
        SettingsPillButton(
          label: 'Sign out everywhere',
          danger: true,
          onPressed: controller.signOutEverywhere,
        ),
        const SettingsGroupLabel('Team'),
        for (final member in security.teamMembers)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    member.name,
                    style: const TextStyle(
                      color: SettingsColors.white,
                      fontSize: 13,
                    ),
                  ),
                ),
                Text(
                  member.isOwner ? '${member.role} · full access' : member.role,
                  style: const TextStyle(
                    color: SettingsColors.faintText,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 10),
                if (!member.isOwner)
                  SettingsPillButton(
                    label: 'Remove',
                    onPressed: () => controller.removeMember(member.id),
                  ),
              ],
            ),
          ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: SettingsTextField(
                controller: _inviteController,
                hintText: 'email@...',
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: SettingsColors.cardFillStrong,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: SettingsColors.cardBorder),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _inviteRole,
                  isDense: true,
                  dropdownColor: const Color(0xFF0A4A63),
                  style: const TextStyle(
                    color: SettingsColors.white,
                    fontSize: 13,
                  ),
                  items: [
                    for (final role in SecurityTeamState.roles)
                      DropdownMenuItem(value: role, child: Text(role)),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _inviteRole = value);
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            SettingsPillButton(
              label: 'Invite',
              onPressed: () {
                controller.inviteMember(_inviteController.text, _inviteRole);
                _inviteController.clear();
              },
            ),
          ],
        ),
        const SettingsGroupLabel('Advisor view link'),
        Text(
          security.advisorLink ??
              'A read-only link to your Financial Overview and Business Health for your accountant — no account needed. Expires in 30 days.',
          style: const TextStyle(
            color: SettingsColors.faintText,
            fontSize: 12,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 10),
        SettingsPillButton(
          label: security.advisorLink == null ? 'Create link' : 'Copy link',
          onPressed: () {
            if (security.advisorLink == null) {
              controller.createAdvisorLink();
            } else {
              CustomToast.showSuccess(context, 'Link copied.');
            }
          },
        ),
      ],
    );
  }
}
