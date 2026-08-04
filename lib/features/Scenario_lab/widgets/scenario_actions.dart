import 'package:flutter/material.dart';

import '../../opportunity/ScenarioLab/widgets/scenario_lab_colors.dart';

/// Save scenario / Adjust an assumption / New scenario buttons, plus the
/// disclaimer line beneath them.
class ScenarioActionsRow extends StatelessWidget {
  const ScenarioActionsRow({
    super.key,
    required this.onSave,
    required this.onAdjust,
    required this.onNewScenario,
    this.disclaimer =
        'Projections are estimates based on your assumptions, not '
        'financial advice.',
  });

  final VoidCallback onSave;
  final VoidCallback onAdjust;
  final VoidCallback onNewScenario;
  final String disclaimer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ActionButton(label: 'Save scenario', filled: true, onTap: onSave),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                label: 'Adjust an assumption',
                filled: false,
                onTap: onAdjust,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ActionButton(
                label: 'New scenario',
                filled: false,
                onTap: onNewScenario,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          disclaimer,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: ScenarioLabColors.faintText,
            fontSize: 11,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.filled,
    required this.onTap,
  });

  final String label;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? ScenarioLabColors.white : Colors.transparent,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: filled
                ? null
                : Border.all(color: ScenarioLabColors.cardBorder),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: filled
                  ? const Color(0xFF0A2A57)
                  : ScenarioLabColors.white,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

/// "Save this scenario first, or start fresh?" confirmation dialog.
Future<void> showNewScenarioDialog(
  BuildContext context, {
  required VoidCallback onSaveFirst,
  required VoidCallback onStartFresh,
}) {
  return showDialog(
    context: context,
    builder: (context) => _GlassDialog(
      title: 'New scenario',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Save this scenario first, or start fresh?',
            style: TextStyle(
              color: ScenarioLabColors.mutedText,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _DialogButton(
                  label: 'Save first',
                  filled: false,
                  onTap: () {
                    Navigator.of(context).pop();
                    onSaveFirst();
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _DialogButton(
                  label: 'Start fresh',
                  filled: true,
                  onTap: () {
                    Navigator.of(context).pop();
                    onStartFresh();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

/// "Save scenario" name-entry dialog.
Future<void> showSaveScenarioDialog(
  BuildContext context, {
  required String initialName,
  required ValueChanged<String> onConfirm,
}) {
  final controller = TextEditingController(text: initialName);
  return showDialog(
    context: context,
    builder: (context) => _GlassDialog(
      title: 'Save scenario',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            style: const TextStyle(
              color: ScenarioLabColors.white,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: ScenarioLabColors.cardFill,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: ScenarioLabColors.cardBorder,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: ScenarioLabColors.cardBorder,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: ScenarioLabColors.white),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _DialogButton(
                  label: 'Cancel',
                  filled: false,
                  onTap: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _DialogButton(
                  label: 'Confirm',
                  filled: true,
                  onTap: () {
                    Navigator.of(context).pop();
                    onConfirm(controller.text);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _GlassDialog extends StatelessWidget {
  const _GlassDialog({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF11406E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ScenarioLabColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: ScenarioLabColors.white,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({
    required this.label,
    required this.filled,
    required this.onTap,
  });

  final String label;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? ScenarioLabColors.glow : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 11),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: filled
                ? null
                : Border.all(color: ScenarioLabColors.cardBorder),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: filled
                  ? const Color(0xFF0A2A57)
                  : ScenarioLabColors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
