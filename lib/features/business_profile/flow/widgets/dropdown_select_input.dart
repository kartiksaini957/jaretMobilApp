import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DropdownSelectInput extends StatefulWidget {
  const DropdownSelectInput({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelect,
    this.placeholder = 'Select',
  });

  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelect;
  final String placeholder;

  @override
  State<DropdownSelectInput> createState() => _DropdownSelectInputState();
}

class _DropdownSelectInputState extends State<DropdownSelectInput> {
  bool _isOpen = true; // Open by default as in screenshot

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Select Trigger Box
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => setState(() => _isOpen = !_isOpen),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(0, 42, 65, 0.35),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color.fromRGBO(127, 227, 255, 0.35),
                width: 1.1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.selected ?? widget.placeholder,
                    style: GoogleFonts.dmSans(
                      color: widget.selected != null
                          ? Colors.white
                          : Colors.white.withOpacity(0.7),
                      fontSize: 15,
                      fontWeight: widget.selected != null
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
                Icon(
                  _isOpen
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: Colors.white.withOpacity(0.8),
                  size: 20,
                ),
              ],
            ),
          ),
        ),

        // Dropdown Menu List
        if (_isOpen) ...[
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF07384E).withOpacity(0.95),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color.fromRGBO(127, 227, 255, 0.28),
                width: 1.1,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 20, 35, 0.5),
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: widget.options.map((option) {
                  final isSelected = widget.selected == option;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        widget.onSelect(option);
                        setState(() => _isOpen = false);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: isSelected
                              ? const Color.fromRGBO(127, 227, 255, 0.18)
                              : Colors.transparent,
                          border: isSelected
                              ? Border.all(
                                  color: const Color.fromRGBO(127, 227, 255, 0.45),
                                  width: 1.1,
                                )
                              : null,
                        ),
                        child: Text(
                          option,
                          style: GoogleFonts.dmSans(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
