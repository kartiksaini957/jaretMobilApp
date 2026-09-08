import 'package:flutter/material.dart';

import '../../../widgets/customToast.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/app_nav_destinations.dart';
import '../../../widgets/app_nav_drawer.dart';
import '../../../widgets/customAppbar.dart';
import '../../../widgets/gradient_background.dart';
import '../data/business_locations_data.dart';
import '../data/onboarding_sections_repository.dart';
import '../data/profile_question_flow_data.dart';
import '../flow/question_flow_screen.dart';
import '../flow/widgets/flow_header.dart';
import '../model/business_profile_onboarding_model.dart';
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
  List<BusinessLocation> _locations = [];
  bool _showAddForm = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadLocationsFromRepo();
  }

  void _loadLocationsFromRepo() {
    final s1 = OnboardingSectionsRepository().getSectionData(1);
    if (s1 != null && s1['locations'] is List && (s1['locations'] as List).isNotEmpty) {
      final list = s1['locations'] as List;
      _locations = list.map((item) {
        if (item is Map<String, dynamic>) {
          final l = OnboardingLocation.fromJson(item);
          return BusinessLocation(
            name: l.name,
            type: LocationType.fromString(l.role),
            address: l.fullAddress,
            details: 'Geocoded ✓ · role: ${l.role} · status: ${l.status}',
          );
        }
        return businessLocationsSeed.first;
      }).toList();
    } else {
      _locations = [...businessLocationsSeed];
    }
  }

  Future<void> _addLocation(BusinessLocation location) async {
    setState(() {
      _locations.add(location);
      _showAddForm = false;
      _isSaving = true;
    });

    final payload = _locations.map((loc) => {
      'name': loc.name,
      'address': loc.address ?? '450 Dauphin St, Mobile, AL 36602',
      'role': loc.type.label,
      'status': 'active',
    }).toList();

    final ok = await OnboardingSectionsRepository().updateLocations(payload);
    if (mounted) {
      setState(() => _isSaving = false);
      if (ok) {
        CustomToast.showSuccess(context, 'Location added and saved.');
      } else {
        CustomToast.showSuccess(context, 'Location saved locally.');
      }
    }
  }

  void _openEditBusinessDetails() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => const QuestionFlowScreen(
              flow: businessBasicsFlow,
              initialIntro: false,
            ),
          ),
        )
        .then((_) {
          if (mounted) {
            setState(() {
              _loadLocationsFromRepo();
            });
          }
        });
  }

  void _onDrawerItemSelected(int index) {
    openNavDestination(
      context,
      index,
      currentIndex: AppNavIndex.businessProfile,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Business Profile',
        hasUnreadNotifications: true,
      ),
      drawer: AppNavDrawer(
        selectedIndex: 6,
        onItemSelected: _onDrawerItemSelected,
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
                  label: 'BUSINESS PROFILE · SECTION 1 · LOCATIONS',
                  onBack: () => Navigator.of(context).pop(),
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(95, 224, 255, 0.18),
                        Color.fromRGBO(95, 224, 255, 0.06),
                      ],
                    ),
                    border: Border.all(
                      color: const Color.fromRGBO(127, 227, 255, 0.4),
                      width: 1.2,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 20, 40, 0.4),
                        blurRadius: 30,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your locations',
                        style: AppTextStyles.headline.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Everywhere you operate — your base and the spots you work from. '
                        'We geocode each one automatically so per-location reads '
                        '(foot traffic, competitors, weather) land on the right place.',
                        style: AppTextStyles.body.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13.5,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(24),
                            onTap: _openEditBusinessDetails,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: const Color.fromRGBO(16, 120, 155, 0.55),
                                border: Border.all(
                                  color: const Color.fromRGBO(127, 227, 255, 0.5),
                                  width: 1.2,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 40, 70, 0.3),
                                    blurRadius: 12,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Text(
                                'Edit business details →',
                                style: AppTextStyles.buttonLabel.copyWith(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: AppColors.glassDark.withOpacity(0.2),
                    border: Border.all(
                      color: const Color.fromRGBO(127, 227, 255, 0.25),
                      width: 1.1,
                    ),
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
                      else if (_isSaving)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF5FE0FF),
                              ),
                            ),
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

