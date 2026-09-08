// opportunity_search_field.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/opportunity/opportunities_provider.dart';
import 'package:flutter_application_1/features/opportunity/opportunities_screen.dart';
import 'package:flutter_application_1/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class OpportunitySearchField extends ConsumerStatefulWidget {
  const OpportunitySearchField({super.key});

  @override
  ConsumerState<OpportunitySearchField> createState() =>
      _OpportunitySearchFieldState();
}

class _OpportunitySearchFieldState
    extends ConsumerState<OpportunitySearchField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _link = LayerLink();

  // NEW — key on the search box container so we can read its exact
  // rendered width and give the dropdown the SAME width (fixes the
  // "result box is wider on the right" issue).
  final GlobalKey _fieldKey = GlobalKey();

  OverlayEntry? _entry;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _showOverlay();
    } else {
      // small delay so a tap on a result registers before we close it
      Future.delayed(const Duration(milliseconds: 150), _removeOverlay);
    }
  }

  // NEW — reads the current width of the search field from its RenderBox.
  double _fieldWidth() {
    final box = _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    return box?.size.width ?? 300;
  }

  void _showOverlay() {
    _removeOverlay();
    final overlay = Overlay.of(context);
    _entry = OverlayEntry(
      builder: (ctx) {
        // Consumer here so the list rebuilds as results/filters change
        return Consumer(
          builder: (ctx, ref, _) {
            final data = ref.watch(opportunitiesControllerProvider).value;
            final query = _controller.text.trim();
            final results = data?.filtered ?? [];
            if (query.isEmpty || results.isEmpty) {
              return const SizedBox.shrink();
            }
            return Stack(
              children: [
                CompositedTransformFollower(
                  link: _link,
                  showWhenUnlinked: false,
                  offset: const Offset(0, 52),
                  // CHANGED — wrap in a SizedBox with the exact field
                  // width instead of letting it stretch to full screen.
                  child: SizedBox(
                    width: _fieldWidth(),
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        constraints: const BoxConstraints(maxHeight: 320),
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
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          itemCount: results.length > 6 ? 6 : results.length,
                          itemBuilder: (ctx, i) {
                            final item = results[i];
                            return ListTile(
                              dense: true,
                              title: Text(
                                item.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                '${item.type.toUpperCase()} · ${item.source}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.dmSans(
                                  fontSize: 11,
                                  color: AppColors.mutedText,
                                ),
                              ),
                              trailing: Text(
                                '${item.matchScore}',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.goodText,
                                ),
                              ),
                              onTap: () {
                                ref
                                    .read(
                                      opportunitiesControllerProvider.notifier,
                                    )
                                    .promoteToHero(item.id);
                                _controller.clear();
                                ref
                                    .read(
                                      opportunitiesControllerProvider.notifier,
                                    )
                                    .setSearchQuery('');
                                _focusNode.unfocus();
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
    overlay.insert(_entry!);
  }

  void _removeOverlay() {
    _entry?.remove();
    _entry = null;
  }

  @override
  void dispose() {
    _removeOverlay();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: Container(
        key:
            _fieldKey, // NEW — needed so _fieldWidth() can read this box's size
        height: 48,
        decoration: glassDecoration(),
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          style: AppTextStyles.body,
          onChanged: (v) {
            ref
                .read(opportunitiesControllerProvider.notifier)
                .setSearchQuery(v);
            _entry?.markNeedsBuild(); // refresh overlay results as you type
          },
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search, color: Colors.white70),
            hintText: "Search — by name, source, or type...",
            hintStyle: TextStyle(color: Colors.white54),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
        ),
      ),
    );
  }
}
