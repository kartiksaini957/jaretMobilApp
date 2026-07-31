import 'package:flutter/material.dart';

import '../../../../theme/app_theme.dart';
import '../../data/business_locations_data.dart';

/// Inline "+ Add a location" form: name, street address, and a type
/// dropdown. Submitting always yields a pending (geocoding) location.
class AddLocationForm extends StatefulWidget {
  const AddLocationForm({
    super.key,
    required this.onAdd,
    required this.onCancel,
  });

  final ValueChanged<BusinessLocation> onAdd;
  final VoidCallback onCancel;

  @override
  State<AddLocationForm> createState() => _AddLocationFormState();
}

class _AddLocationFormState extends State<AddLocationForm> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  LocationType _type = LocationType.regular;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: AppTextStyles.small,
    filled: true,
    fillColor: AppColors.glassLight,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.glassBorder),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.glassBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.accent),
    ),
  );

  void _submit() {
    final name = _nameController.text.trim();
    widget.onAdd(
      BusinessLocation(name: name.isEmpty ? 'New spot' : name, type: _type),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _nameController,
          style: AppTextStyles.small.copyWith(color: AppColors.white),
          decoration: _decoration('Name this spot — e.g. weekend market stall'),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _addressController,
          style: AppTextStyles.small.copyWith(color: AppColors.white),
          decoration: _decoration('Street address'),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<LocationType>(
          initialValue: _type,
          decoration: _decoration(''),
          dropdownColor: Colors.white,
          style: AppTextStyles.small.copyWith(color: AppColors.white),
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.white),
          selectedItemBuilder: (context) => [
            for (final type in LocationType.values)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  type.label,
                  style: AppTextStyles.small.copyWith(color: AppColors.white),
                ),
              ),
          ],
          items: [
            for (final type in LocationType.values)
              DropdownMenuItem(
                value: type,
                child: Text(
                  type.label,
                  style: AppTextStyles.small.copyWith(color: Colors.black),
                ),
              ),
          ],
          onChanged: (value) {
            if (value != null) setState(() => _type = value);
          },
        ),
        const SizedBox(height: 8),
        Text(
          'City, state, and neighborhood fill in automatically from the '
          'address.',
          style: AppTextStyles.small,
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.ink,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'Add location',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: 10),
            OutlinedButton(
              onPressed: widget.onCancel,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.glassBorder),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text(
                'Cancel',
                style: AppTextStyles.buttonLabel.copyWith(fontSize: 13.5),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
