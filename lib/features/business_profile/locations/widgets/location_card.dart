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
          Padding(
            padding: EdgeInsets.only(top: 2),
            child: Container(
              decoration: BoxDecoration(
                // color: AppColors.accent,
                border: Border.all(color: AppColors.glassBorder),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text("📍"),
              ),
            ),
            // Icon(Icons.location_on, size: 16, color: AppColors.critDot),
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
                      style: AppTextStyles.buttonLabel.copyWith(fontSize: 13.5),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.white.withOpacity(0.24),
                        ),
                      ),
                      child: Text(
                        location.type.badgeLabel,
                        style: AppTextStyles.buttonLabel.copyWith(
                          color: AppColors.white,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                if (location.isPending) ...[
                  Text(
                    'Address pending',
                    style: AppTextStyles.small.copyWith(fontSize: 12),
                  ),
                  Text(
                    'Geocoding…',
                    style: AppTextStyles.small.copyWith(
                      fontSize: 11,
                      // color: AppColors.warnDot,
                    ),
                  ),
                ] else ...[
                  Text(
                    location.address!,
                    style: AppTextStyles.small.copyWith(fontSize: 12),
                  ),
                  if (location.details != null)
                    Text(
                      location.details!,
                      style: AppTextStyles.small.copyWith(fontSize: 11),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
