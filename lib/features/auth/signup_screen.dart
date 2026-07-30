import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/app_theme.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/customToast.dart';
import '../../widgets/gradient_background.dart';
import '../../widgets/customElevatedbutton.dart';
import '../../widgets/in_app_webview_screen.dart';
import 'login_screen.dart';
import 'providers/auth_providers.dart';
import 'providers/signup_provider.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _businessNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Your name is required.';
    return null;
  }

  String? _validateBusinessName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Business name is required.';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Email is required.';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required.';
    if (value.length < 8) return 'Password should be at least 8 characters.';
    return null;
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final success = await ref
        .read(signUpControllerProvider.notifier)
        .signUp(
          name: _nameController.text,
          company: _businessNameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        );

    if (!mounted) return;
    if (success) {
      final signUpState = ref.read(signUpControllerProvider);
      final checkoutUrl = signUpState.checkoutUrl;
      if (checkoutUrl != null && checkoutUrl.isNotEmpty) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => InAppWebViewScreen(
              url: checkoutUrl,
              title: 'Checkout',
              onDeepLink: _handleCheckoutDeepLink,
            ),
          ),
        );
      } else if (signUpState.message != null &&
          signUpState.message!.isNotEmpty) {
        _clearForm();
        _showResultDialog(
          icon: Icons.mark_email_read_rounded,
          tone: AppColors.goodText,
          title: 'Check your email',
          message: signUpState.message!,
          buttonLabel: 'Go to login',
          onButtonPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          ),
        );
      } else {
        CustomToast.showSuccess(context, 'Signed up successfully.');
      }
      return;
    }

    final errorMessage = ref.read(signUpControllerProvider).errorMessage;
    CustomToast.showError(context, errorMessage ?? 'Sign up failed.');
  }

  void _clearForm() {
    _nameController.clear();
    _businessNameController.clear();
    _emailController.clear();
    _passwordController.clear();
  }

  // Stripe redirects here once checkout finishes: `lightsignal://success`
  // on a completed payment, `lightsignal://cancel` (or anything else)
  // when the user backs out or the payment fails.
  void _handleCheckoutDeepLink(Uri uri) {
    Navigator.of(context).pop();
    if (uri.host == 'success') {
      final email = _emailController.text.trim();
      _clearForm();
      _showResultDialog(
        icon: Icons.check_circle_rounded,
        tone: AppColors.goodText,
        title: 'Payment successful',
        message:
            'Your payment was successful. We\'ve sent a verification email '
            'to $email — please check your inbox to verify your account '
            'before logging in.',
        buttonLabel: 'Go to login',
        onButtonPressed: () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        ),
      );
    } else {
      _showResultDialog(
        icon: Icons.error_rounded,
        tone: AppColors.urgent,
        title: 'Payment failed',
        message:
            'Your payment could not be completed. Please try signing up again.',
        buttonLabel: 'Sign up again',
        onButtonPressed: () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const SignUpScreen()),
        ),
      );
    }
  }

  void _showResultDialog({
    required IconData icon,
    required Color tone,
    required String title,
    required String message,
    required String buttonLabel,
    required VoidCallback onButtonPressed,
  }) {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierLabel: title,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      transitionDuration: const Duration(milliseconds: 320),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final fade = CurvedAnimation(
          parent: animation,
          curve: const Interval(0, 0.6, curve: Curves.easeOut),
        );
        final scale = Tween<double>(begin: 0.82, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
        );
        return FadeTransition(
          opacity: fade,
          child: ScaleTransition(scale: scale, child: child),
        );
      },
      pageBuilder: (dialogContext, animation, secondaryAnimation) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.white.withValues(alpha: 0.16),
                    AppColors.glassDark,
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: tone.withValues(alpha: 0.45),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: tone.withValues(alpha: 0.25),
                    blurRadius: 30,
                    spreadRadius: -6,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: tone.withValues(alpha: 0.16),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: tone, size: 28),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.mutedText,
                    ),
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    label: buttonLabel,
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      onButtonPressed();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(signUpControllerProvider).isLoading;
    final isPasswordVisible = ref.watch(signUpPasswordVisibleProvider);

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppLogo(),
                  const SizedBox(height: 24),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Start knowing what\'s\n',
                          style: AppTextStyles.headline,
                        ),
                        TextSpan(
                          text: 'really going on.',
                          style: AppTextStyles.headlineAccent,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Create your account, connect the tools you already use, '
                    'and get your first read this session.',
                    style: AppTextStyles.body,
                  ),
                  const SizedBox(height: 24),
                  AppTextField(
                    label: 'Your name',
                    controller: _nameController,
                    hintText: 'Jordan Rivera',
                    textInputAction: TextInputAction.next,
                    required: true,
                    validator: _validateName,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Business name',
                    controller: _businessNameController,
                    hintText: 'Rivera & Co.',
                    textInputAction: TextInputAction.next,
                    required: true,
                    validator: _validateBusinessName,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Email',
                    controller: _emailController,
                    hintText: 'you@yourbusiness.com',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    required: true,
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Password',
                    controller: _passwordController,
                    hintText: 'At least 8 characters',
                    obscureText: !isPasswordVisible,
                    textInputAction: TextInputAction.done,
                    required: true,
                    validator: _validatePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.faintText,
                      ),
                      onPressed: () =>
                          ref
                                  .read(signUpPasswordVisibleProvider.notifier)
                                  .state =
                              !isPasswordVisible,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.glassDark,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.glassBorder),
                    ),
                    child: const Text.rich(
                      TextSpan(
                        style: AppTextStyles.small,
                        children: [
                          TextSpan(text: 'Free for 14 days, then '),
                          TextSpan(
                            text: '\$249/month.',
                            style: TextStyle(color: AppColors.goodText),
                          ),
                          TextSpan(
                            text:
                                ' You\'ll enter a card on the next step to '
                                'start, but ',
                          ),
                          TextSpan(
                            text: 'you won\'t be charged today.',
                            style: TextStyle(color: AppColors.goodText),
                          ),
                          TextSpan(
                            text:
                                ' Cancel anytime before day 14 and you\'re '
                                'never charged.',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    label: 'Start your free trial',
                    onPressed: _submit,
                    isLoading: isLoading,
                  ),
                  const SizedBox(height: 14),
                  Text.rich(
                    TextSpan(
                      style: AppTextStyles.small,
                      children: [
                        const TextSpan(text: 'By continuing you agree to the '),
                        TextSpan(
                          text: 'Terms of Service',
                          style: AppTextStyles.small.copyWith(
                            color: AppColors.accent,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.accent,
                          ),
                        ),
                        const TextSpan(
                          text: ' and Privacy Policy — hands off to Stripe.',
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
