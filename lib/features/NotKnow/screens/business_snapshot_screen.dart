import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/app_logo.dart';
import '../../../widgets/app_text_field.dart';
import '../../../widgets/customElevatedbutton.dart';
import '../../../widgets/gradient_background.dart';
import '../widgets/secondary_button.dart';
import '../widgets/selectable_option_tile.dart';
import '../widgets/step_progress_bar.dart';
import 'value_preview_screen.dart';

/// Screen 2 — Business snapshot (step 1 of 3).
class BusinessSnapshotScreen extends StatefulWidget {
  const BusinessSnapshotScreen({super.key});

  @override
  State<BusinessSnapshotScreen> createState() => _BusinessSnapshotScreenState();
}

class _BusinessSnapshotScreenState extends State<BusinessSnapshotScreen> {
  static const _worryOptions = [
    'Cash getting tight',
    'Slow weeks blindside me',
    'Costs keep creeping up',
    'A big decision\'s coming',
    'Drowning in admin',
  ];

  final _businessNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _businessTypeController = TextEditingController();
  final Set<String> _selectedWorries = {};

  @override
  void dispose() {
    _businessNameController.dispose();
    _locationController.dispose();
    _businessTypeController.dispose();
    super.dispose();
  }

  void _toggleWorry(String worry) {
    setState(() {
      if (_selectedWorries.contains(worry)) {
        _selectedWorries.remove(worry);
      } else {
        _selectedWorries.add(worry);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppLogo(),
                const SizedBox(height: 24),
                 Text(
                  'STEP 1 OF 3 · YOUR BUSINESS',
                  style: AppTextStyles.eyebrow,
                ),
                const SizedBox(height: 10),
                const StepProgressBar(step: 1, totalSteps: 3),
                const SizedBox(height: 20),
                Text('Tell us the basics.', style: AppTextStyles.headline),
                const SizedBox(height: 8),
                 Text(
                  'Just enough to recognize your business. We\'ll fill in '
                  'the rest ourselves.',
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: 24),
                AppTextField(
                  label: 'Business name',
                  controller: _businessNameController,
                  hintText: 'Rivera & Co.',
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Where are you?',
                  controller: _locationController,
                  hintText: 'City, State',
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'What kind of business?',
                  controller: _businessTypeController,
                  hintText: 'Coffee shop, gym, contractor...',
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                const Text(
                  'What keeps you up at night?',
                  style: TextStyle(
                    color: AppColors.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ..._worryOptions.expand(
                  (worry) => [
                    SelectableOptionTile(
                      label: worry,
                      selected: _selectedWorries.contains(worry),
                      onTap: () => _toggleWorry(worry),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
                const SizedBox(height: 6),
                Text.rich(
                  TextSpan(
                    style: AppTextStyles.body,
                    children: [
                      TextSpan(
                        text: 'We found your Google listing. ',
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const TextSpan(
                        style: TextStyle(
                          color: AppColors.goodText,
                          fontWeight: FontWeight.w500,
                        ),
                        text:
                            'You\'re showing 4.5 stars across 212 reviews, '
                            'open now, ranked #3 for "dinner near you." '
                            'We\'ll fold this into your reads.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    SecondaryButton(
                      label: 'Back',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PrimaryButton(
                        label: 'See what we\'ll do for you',
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ValuePreviewScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
