import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/app_theme.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/customToast.dart';
import '../../widgets/gradient_background.dart';
import '../../widgets/customElevatedbutton.dart';
import '../dashboard/dashboard_screen.dart';
import 'forgot_password_screen.dart';
import 'providers/auth_providers.dart';
import 'providers/login_provider.dart';
import 'signup_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _goToSignUp() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SignUpScreen()));
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
    return null;
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final success = await ref
        .read(loginControllerProvider.notifier)
        .login(
          email: _emailController.text,
          password: _passwordController.text,
        );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
      return;
    }

    final errorMessage = ref.read(loginControllerProvider).errorMessage;
    CustomToast.showError(context, errorMessage ?? 'Login failed.');
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loginControllerProvider).isLoading;
    final isPasswordVisible = ref.watch(loginPasswordVisibleProvider);

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
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppLogo(),
                          const SizedBox(height: 32),
                          Text(
                            'WELCOME BACK',
                            style: AppTextStyles.eyebrow,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Sign in to LightSignal.',
                            style: AppTextStyles.headline,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Your business has been busy. Let\'s see what changed.',
                            style: AppTextStyles.body,
                          ),
                          const SizedBox(height: 28),
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
                            hintText: 'Your password',
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
                                          .read(
                                            loginPasswordVisibleProvider
                                                .notifier,
                                          )
                                          .state =
                                      !isPasswordVisible,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.accent,
                                padding: EdgeInsets.zero,
                              ),
                              child: const Text(
                                'Forgot password?',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          PrimaryButton(
                            label: 'Sign in',
                            onPressed: isLoading ? null : _submit,
                            isLoading: isLoading,
                          ),
                          const SizedBox(height: 20),
                          const Spacer(),
                          Center(
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              children: [
                                Text(
                                  'New here? ',
                                  style: AppTextStyles.body,
                                ),
                                GestureDetector(
                                  onTap: _goToSignUp,
                                  child: const Text(
                                    'Start your free trial',
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
