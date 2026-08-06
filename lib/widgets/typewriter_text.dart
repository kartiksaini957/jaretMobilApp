import 'package:flutter/material.dart';

/// Reveals [text] one word at a time, each word fading in just after the
/// one before it.
///
/// The full string is always laid out — hidden words are drawn fully
/// transparent rather than omitted — so the surrounding card keeps its
/// final height from the very first frame instead of growing mid-animation.
class TypewriterText extends StatefulWidget {
  const TypewriterText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.wordStagger = const Duration(milliseconds: 55),
    this.wordFade = const Duration(milliseconds: 220),
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  /// Gap between the start of one word's fade and the next.
  final Duration wordStagger;

  /// How long a single word takes to fade in.
  final Duration wordFade;

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _totalDuration,
  )..forward();

  late List<String> _words = _splitWords(widget.text);

  static List<String> _splitWords(String text) =>
      text.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();

  Duration get _totalDuration =>
      widget.wordStagger * (_words.length - 1).clamp(0, _words.length) +
      widget.wordFade;

  @override
  void didUpdateWidget(TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    // New sentence (e.g. a refresh landed) — replay from the first word.
    if (widget.text != oldWidget.text) {
      _words = _splitWords(widget.text);
      _controller
        ..duration = _totalDuration
        ..forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_words.isEmpty) return const SizedBox.shrink();

    final baseColor =
        widget.style?.color ?? DefaultTextStyle.of(context).style.color ??
        Colors.white;
    final elapsedMs = _totalDuration.inMilliseconds;
    final staggerMs = widget.wordStagger.inMilliseconds;
    final fadeMs = widget.wordFade.inMilliseconds;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final playedMs = _controller.value * elapsedMs;
        return Text.rich(
          TextSpan(
            children: [
              for (var i = 0; i < _words.length; i++)
                TextSpan(
                  text: i == 0 ? _words[i] : ' ${_words[i]}',
                  style: (widget.style ?? const TextStyle()).copyWith(
                    color: baseColor.withValues(
                      alpha: fadeMs == 0
                          ? 1
                          : ((playedMs - i * staggerMs) / fadeMs).clamp(0.0, 1.0),
                    ),
                  ),
                ),
            ],
          ),
          textAlign: widget.textAlign,
        );
      },
    );
  }
}