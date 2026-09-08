import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/network/internet_checker.dart';
import 'package:flutter_application_1/theme/app_theme.dart';
import 'package:flutter_application_1/widgets/customToast.dart';
import 'package:flutter_application_1/widgets/gradient_background.dart';

/// Full-screen "No Internet Connection" UI.
/// Displays an illustration/icon, clear message, and an interactive "Try Again" button.
/// Returns `true` when popped upon successful internet recovery.
class TryAgainScreen extends StatefulWidget {
  const TryAgainScreen({
    super.key,
    this.message = 'Please check your internet connection and try again.',
  });

  final String message;

  @override
  State<TryAgainScreen> createState() => _TryAgainScreenState();
}

class _TryAgainScreenState extends State<TryAgainScreen> {
  bool _isChecking = false;

  Future<void> _checkAndRetry() async {
    if (_isChecking) return;

    setState(() {
      _isChecking = true;
    });

    // Probe internet connectivity
    final bool isConnected = await InternetChecker.hasConnection();

    if (!mounted) return;

    if (isConnected) {
      // Return true to signal that internet is back and API can retry
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _isChecking = false;
      });

      // Show toast/snackbar feedback to user
      try {
        CustomToast.showError(
          context,
          'Please check your internet connection',
        );
      } catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please check your internet connection'),
            backgroundColor: AppColors.urgent,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // If user forces back navigation, pop with false so caller knows it wasn't resolved
        Navigator.of(context).pop(false);
      },
      child: Scaffold(
        backgroundColor: AppColors.baseDeep,
        body: GradientBackground(
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Illustration / Icon with glass container glow
                    Container(
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.glassLight.withValues(alpha: 0.08),
                        border: Border.all(
                          color: AppColors.glassBorder.withValues(alpha: 0.25),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.blobCyan.withValues(alpha: 0.15),
                            blurRadius: 36,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/no_internet.png',
                        width: 110,
                        height: 110,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.wifi_off_rounded,
                            size: 74,
                            color: AppColors.accent,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Heading
                    Text(
                      'No Internet Connection',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.headline.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Description text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        widget.message,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.faintText,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Try Again Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.gotoTop,
                              AppColors.gotoBottom,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.blobCyan.withValues(alpha: 0.3),
                              blurRadius: 18,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: _isChecking ? null : _checkAndRetry,
                            child: Center(
                              child: _isChecking
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          AppColors.ink,
                                        ),
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.refresh_rounded,
                                          color: AppColors.ink,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Try Again',
                                          style: AppTextStyles.buttonLabel
                                              .copyWith(
                                            color: AppColors.ink,
                                            fontSize: 15.5,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
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
    );
  }
}
