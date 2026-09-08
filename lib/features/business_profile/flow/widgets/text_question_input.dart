import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../theme/app_theme.dart';

class TextQuestionInput extends StatelessWidget {
  const TextQuestionInput({
    super.key,
    required this.controller,
    this.placeholder,
    this.onChanged,
    this.minLines,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String? placeholder;
  final ValueChanged<String>? onChanged;
  final int? minLines;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(0, 42, 65, 0.35),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color.fromRGBO(127, 227, 255, 0.35),
          width: 1.1,
        ),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        minLines: minLines,
        maxLines: maxLines,
        style: GoogleFonts.dmSans(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        cursorColor: AppColors.accent,
        decoration: InputDecoration(
          hintText: placeholder ?? '',
          hintStyle: GoogleFonts.dmSans(
            color: Colors.white.withOpacity(0.68),
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
        ),
      ),
    );
  }
}
