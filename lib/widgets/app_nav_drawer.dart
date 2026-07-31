import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/providers/login_provider.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../theme/app_theme.dart';
import 'gradient_background.dart';

/// Side navigation drawer opened by [CustomAppBar]'s hamburger button.
/// Owns logout itself — clears the saved auth token and drops the user
/// back at onboarding — so every screen gets the same behavior for free.
class AppNavDrawer extends ConsumerWidget {
  const AppNavDrawer({super.key, this.selectedIndex = 0, this.onItemSelected});

  static const _items = [
    'Dashboard',
    'Demand Forecast',
    'Financial Overview',
    'Business Health',
    'Opportunities',
    'Scenario Lab',
    'Business Profile',
    'Settings',
  ];

  final int selectedIndex;
  final ValueChanged<int>? onItemSelected;

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    await ref.read(loginControllerProvider.notifier).logout();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.72,
      backgroundColor: Colors.transparent,
      child: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                     Expanded(
                      child: Text('LightSignal', style: AppTextStyles.logo),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.white,
                        size: 16,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.glassLight,
                        side: const BorderSide(color: AppColors.glassBorder),
                        shape: const CircleBorder(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ..._items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final label = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _DrawerItem(
                      label: label,
                      isSelected: index == selectedIndex,
                      onTap: () {
                        Navigator.of(context).pop();
                        onItemSelected?.call(index);
                      },
                    ),
                  );
                }),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => _logout(context, ref),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.glassBorder),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child:  Text(
                      'Log out',
                      style: AppTextStyles.buttonLabel,
                    ),
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

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.glassLight : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.glassBorder : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: AppColors.white,
            fontSize: 14.5,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
