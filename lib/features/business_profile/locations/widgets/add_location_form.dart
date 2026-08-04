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
    hintStyle: AppTextStyles.small.copyWith(
      fontSize: 13,
      fontWeight: FontWeight.w400,
    ),
    filled: true,
    fillColor: AppColors.white.withOpacity(0.07),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.glassBorder),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.glassBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.white),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.glassDark.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            style: AppTextStyles.small.copyWith(
              color: AppColors.white,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
            decoration: _decoration(
              'Name this spot — e.g. weekend market stall',
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _addressController,
            style: AppTextStyles.small.copyWith(
              color: AppColors.white,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
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
                    style: AppTextStyles.small.copyWith(
                      color: AppColors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
            ],
            items: [
              for (final type in LocationType.values)
                DropdownMenuItem(
                  value: type,
                  child: Text(
                    type.label,
                    style: AppTextStyles.small.copyWith(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
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
            style: AppTextStyles.small.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
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
                child: Text(
                  'Add location',
                  style: AppTextStyles.small.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF04303F),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: widget.onCancel,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.white.withOpacity(0.24)),
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
                  style: AppTextStyles.buttonLabel.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
