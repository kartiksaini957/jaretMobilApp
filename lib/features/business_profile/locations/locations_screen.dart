import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/customAppbar.dart';
import '../../../widgets/gradient_background.dart';
import '../data/business_locations_data.dart';
import '../flow/widgets/flow_header.dart';
import 'widgets/add_location_form.dart';
import 'widgets/location_card.dart';

/// "Your locations" — every storefront/spot the business operates from,
/// geocoded automatically, plus a form to add more.
class LocationsScreen extends StatefulWidget {
  const LocationsScreen({super.key});

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  late final List<BusinessLocation> _locations = [...businessLocationsSeed];
  bool _showAddForm = false;

  void _addLocation(BusinessLocation location) {
    setState(() {
      _locations.add(location);
      _showAddForm = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Business Profile',
        hasUnreadNotifications: true,
      ),
      body: GradientBackground(
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FlowHeader(
                  label: 'SECTION 1 · LOCATIONS',
                  onBack: () => Navigator.of(context).pop(),
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.glassDark.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.glassLight),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your locations',
                        style: AppTextStyles.headline.copyWith(fontSize: 19),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Everywhere you operate — your storefront and '
                        'anywhere else you sell. We geocode each one '
                        'automatically so per-location reads (foot '
                        'traffic, competitors, weather) land on the '
                        'right place.',
                        style: AppTextStyles.small,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.glassDark.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.glassLight),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < _locations.length; i++)
                        LocationCard(
                          location: _locations[i],
                          showDivider:
                              i != _locations.length - 1 || _showAddForm,
                        ),
                      if (_showAddForm)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: AddLocationForm(
                            onAdd: _addLocation,
                            onCancel: () =>
                                setState(() => _showAddForm = false),
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: OutlinedButton(
                            onPressed: () =>
                                setState(() => _showAddForm = true),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: AppColors.glassBorder,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: Text(
                              '+ Add a location',
                              style: AppTextStyles.buttonLabel.copyWith(
                                fontSize: 11.5,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
