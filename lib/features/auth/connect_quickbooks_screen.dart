import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/api_services.dart';
import '../../theme/app_theme.dart';
import '../../widgets/customToast.dart';
import '../../widgets/in_app_webview_screen.dart';
import '../dashboard/dashboard_screen.dart';
import 'login_screen.dart';

class ConnectQuickbooksScreen extends StatefulWidget {
  const ConnectQuickbooksScreen({super.key});

  @override
  State<ConnectQuickbooksScreen> createState() =>
      _ConnectQuickbooksScreenState();
}

class _ConnectQuickbooksScreenState extends State<ConnectQuickbooksScreen> {
  bool _isLoading = false;

  void _onBackPressed() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _handleConnect() async {
    setState(() => _isLoading = true);
    try {
      final authUrl = await ApiService().getQuickbooksAuthUrl();
      if (!mounted) return;
      setState(() => _isLoading = false);

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => InAppWebViewScreen(
            url: authUrl,
            title: 'Connect QuickBooks',
            onDeepLink: (uri) {
              debugPrint('[ConnectQuickbooksScreen] Deep link caught: $uri');
              Navigator.of(ctx).pop();
            },
            onPageFinished: (url) {
              debugPrint('[ConnectQuickbooksScreen] WebView loaded: $url');
              if (url.contains('/quickbooks/callback') ||
                  url.contains('quickbooks/success') ||
                  url.contains('connected')) {
                Future.delayed(const Duration(milliseconds: 1500), () {
                  if (ctx.mounted) {
                    Navigator.of(ctx).pop();
                  }
                });
              }
            },
          ),
        ),
      );

      // Verify connection after returning from WebView
      if (!mounted) return;
      await _verifyConnection();
    } catch (e) {
      if (!mounted) return;
      final msg = e is ApiException
          ? e.message
          : 'Failed to start QuickBooks connection.';
      CustomToast.showError(context, msg);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _verifyConnection() async {
    setState(() => _isLoading = true);
    try {
      final user = await ApiService().getAuthMe();
      if (!mounted) return;

      if (user.quickbooksConnected) {
        CustomToast.showSuccess(
          context,
          'QuickBooks connected successfully!',
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      } else {
        CustomToast.showError(
          context,
          'QuickBooks is not connected yet. Please try again.',
        );
      }
    } catch (e) {
      if (!mounted) return;
      final msg = e is ApiException ? e.message : 'Failed to verify connection.';
      CustomToast.showError(context, msg);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _onBackPressed();
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Background teal gradient matching the provided design
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0.0, -0.15),
                    radius: 1.15,
                    colors: [
                      Color(0xFF00A896),
                      Color(0xFF028090),
                      Color(0xFF005F56),
                      Color(0xFF023E38),
                      Color(0xFF012522),
                    ],
                    stops: [0.0, 0.35, 0.65, 0.85, 1.0],
                  ),
                ),
              ),
            ),

            // Top-left Back button to return to login
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 12),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: _onBackPressed,
                    tooltip: 'Back to Login',
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withValues(alpha: 0.2),
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10),
                    ),
                  ),
                ),
              ),
            ),

            // Centered Glassmorphic Modal Card
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 380),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 26,
                            vertical: 34,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.22),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                blurRadius: 28,
                                spreadRadius: 2,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Title
                              Text(
                                'Connect QuickBooks',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.headline.copyWith(
                                  color: Colors.white,
                                  fontSize: 21,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Subtitle
                              Text(
                                'Securely link your QuickBooks account',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.body.copyWith(
                                  color: const Color(0xFF8CECDA),
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 22),

                              // Description Paragraph
                              Text(
                                'Connect your QuickBooks account to sync financial data and unlock real-time insights inside LightSignal.',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.body.copyWith(
                                  color: Colors.white.withValues(alpha: 0.90),
                                  fontSize: 13.5,
                                  height: 1.45,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 28),

                              // Connect QuickBooks Button
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _handleConnect,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1BD8C4),
                                    foregroundColor: const Color(0xFF032824),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    shadowColor: const Color(0xFF1BD8C4)
                                        .withValues(alpha: 0.4),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              Color(0xFF032824),
                                            ),
                                          ),
                                        )
                                      : const Text(
                                          'Connect QuickBooks',
                                          style: TextStyle(
                                            color: Color(0xFF032824),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.2,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
