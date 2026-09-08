import 'package:flutter/material.dart';
import 'core/api_services.dart';
import 'features/auth/connect_quickbooks_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'theme/app_theme.dart';
import 'utils/pref_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1020), 
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 110,
                height: 110,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Image.asset(
                  'assets/images/ls_logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "LightSignal",
                style: AppTextStyles.body.copyWith(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "AI-Powered Business Intelligence",
                style: AppTextStyles.body.copyWith(
                  color: Colors.white70,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _checkLogin() async {
    await Future.delayed(const Duration(seconds: 2));
    final hasToken = await PrefUtils.hasAccessToken();
    if (!mounted) return;
    if (hasToken) {
      try {
        final user = await ApiService().getAuthMe();
        if (!mounted) return;
        if (!user.quickbooksConnected) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ConnectQuickbooksScreen()),
          );
          return;
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      } catch (e) {
        if (!mounted) return;
        if (e is ApiException && e.statusCode == 401) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const DashboardScreen()),
          );
        }
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    }
  }
}
