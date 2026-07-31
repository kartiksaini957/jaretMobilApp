import 'package:flutter/material.dart';

import '../../../../theme/app_theme.dart';
import '../../data/business_locations_data.dart';

/// One row in the locations list: pin icon, name + type badge, and either
/// the geocoded address/details or a "Geocoding…" pending state.
class LocationCard extends StatelessWidget {
  const LocationCard({
    super.key,
    required this.location,
    this.showDivider = true,
  });

  final BusinessLocation location;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: AppColors.glassBorderSoft))
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.location_on, size: 16, color: AppColors.accent),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Text(
                      location.name,
                      style: AppTextStyles.buttonLabel.copyWith(fontSize: 14),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: Text(
                        location.type.badgeLabel,
                        style: const TextStyle(
                          color: AppColors.faintText,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                if (location.isPending) ...[
                  Text('Address pending', style: AppTextStyles.small),
                  Text(
                    'Geocoding…',
                    style: AppTextStyles.small.copyWith(
                      color: AppColors.warnDot,
                    ),
                  ),
                ] else ...[
                  Text(location.address!, style: AppTextStyles.small),
                  if (location.details != null)
                    Text(location.details!, style: AppTextStyles.small),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
