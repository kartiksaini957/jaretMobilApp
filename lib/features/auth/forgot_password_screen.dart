import 'package:flutter/material.dart';

import '../../core/api_services.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/customElevatedbutton.dart';
import '../../widgets/customToast.dart';
import '../../widgets/gradient_background.dart';

/// Forgot password — email in, a generic "check your inbox" confirmation
/// out (deliberately vague about whether the account exists — standard
/// security practice). Calls the real `/auth/forgot-password` endpoint.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isSubmitting = false;
  bool _submitted = false;
  String? _resultMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Email is required.';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSubmitting = true);

    try {
      final message = await ApiService().forgotPassword(
        email: _emailController.text.trim(),
      );
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _submitted = true;
        _resultMessage = message;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      CustomToast.showError(context, e.message);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      CustomToast.showError(context, 'Something went wrong. Please try again.');
    }
  }

  void _backToSignIn() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const AppLogo(),
                            const Spacer(),
                            GestureDetector(
                              onTap: _backToSignIn,
                              child: const Text(
                                'Back to sign in',
                                style: TextStyle(
                                  color: AppColors.accent,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.accent,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 7,
                                    height: 7,
                                    decoration: const BoxDecoration(
                                      color: AppColors.goodText,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'PASSWORD RESET',
                                    style: AppTextStyles.eyebrow,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Forgot your password?',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.headline,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Enter your email and we\'ll send you a link to reset it.',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.body,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.glassDark,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.glassBorder),
                          ),
                          child: _submitted
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppTextField(
                                      label: 'Work email',
                                      controller: _emailController,
                                      hintText: 'you@yourbusiness.com',
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                    const SizedBox(height: 16),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: AppColors.glassLight,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: AppColors.glassBorderSoft,
                                        ),
                                      ),
                                      child: Text(
                                        _resultMessage ??
                                            'If that email has a LightSignal '
                                                'account, a reset link is on '
                                                'its way. Check your inbox.',
                                        style: AppTextStyles.small,
                                      ),
                                    ),
                                  ],
                                )
                              : Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppTextField(
                                        label: 'Work email',
                                        controller: _emailController,
                                        hintText: 'you@yourbusiness.com',
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.done,
                                        required: true,
                                        validator: _validateEmail,
                                      ),
                                      const SizedBox(height: 16),
                                      PrimaryButton(
                                        label: 'Send reset link',
                                        onPressed: _isSubmitting
                                            ? null
                                            : _submit,
                                        isLoading: _isSubmitting,
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                        const SizedBox(height: 20),
                        const Spacer(),
                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              const Text(
                                'Remembered it? ',
                                style: AppTextStyles.body,
                              ),
                              GestureDetector(
                                onTap: _backToSignIn,
                                child: const Text(
                                  'Back to sign in',
                                  style: TextStyle(
                                    color: AppColors.accent,
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.accent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
