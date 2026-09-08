// filter_dropdown_chip.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_1/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterDropdownChip extends StatefulWidget {
  const FilterDropdownChip({
    super.key,
    required this.label,
    required this.panelBuilder,
    this.badgeCount = 0,
    this.panelWidth = 230,
  });

  final String label;
  final int badgeCount;
  final double panelWidth;

  /// Build the panel content. Call `close()` from inside (e.g. after a
  /// radio selection) to auto-close the dropdown.
  final Widget Function(BuildContext context, VoidCallback close) panelBuilder;

  @override
  State<FilterDropdownChip> createState() => _FilterDropdownChipState();
}

class _FilterDropdownChipState extends State<FilterDropdownChip> {
  final LayerLink _link = LayerLink();
  OverlayEntry? _entry;
  bool _open = false;

  void _toggle() => _open ? _close() : _showOverlay();

  void _showOverlay() {
    final overlay = Overlay.of(context);
    _entry = OverlayEntry(
      builder: (ctx) {
        return Stack(
          children: [
            // Tap anywhere outside the panel to close it.
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _close,
              ),
            ),
            CompositedTransformFollower(
              link: _link,
              showWhenUnlinked: false,
              offset: const Offset(0, 8),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: widget.panelWidth,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B2E42),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  // Always calls `widget.panelBuilder` — i.e. the builder
                  // belonging to the CURRENT widget instance, which
                  // didUpdateWidget below keeps fresh via markNeedsBuild.
                  child: widget.panelBuilder(ctx, _close),
                ),
              ),
            ),
          ],
        );
      },
    );
    overlay.insert(_entry!);
    setState(() => _open = true);
  }

  void _close() {
    _entry?.remove();
    _entry = null;
    if (mounted) setState(() => _open = false);
  }

  // Keeps the open overlay in sync with new provider state.
  //
  // didUpdateWidget runs DURING the parent's build phase (Type/Distance/
  // RiskFilterDropdown rebuilding after you tap a checkbox). Calling
  // `_entry.markNeedsBuild()` synchronously here throws:
  //   "setState() or markNeedsBuild() called during build"
  // because the Overlay's own widget is a totally separate part of the
  // tree that Flutter is not currently in the middle of building.
  //
  // FIX: schedule the rebuild for right after this frame's build phase
  // finishes, via addPostFrameCallback. By then Flutter is out of the
  // build phase, so markNeedsBuild() is safe to call, and it still
  // happens on the very next frame — visually instant.
  @override
  void didUpdateWidget(covariant FilterDropdownChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_entry != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Guard: dropdown may have been closed / widget disposed by the
        // time this callback runs.
        if (_entry != null) {
          _entry!.markNeedsBuild();
        }
      });
    }
  }

  @override
  void dispose() {
    _entry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: GestureDetector(
        onTap: _toggle,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _open ? AppColors.accent : Colors.white24,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: GoogleFonts.dmSans(
                  fontSize: 12.5,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (widget.badgeCount > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 1,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${widget.badgeCount}',
                    style: GoogleFonts.dmSans(
                      fontSize: 10.5,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
              const SizedBox(width: 4),
              Icon(
                _open ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                size: 16,
                color: Colors.white70,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
