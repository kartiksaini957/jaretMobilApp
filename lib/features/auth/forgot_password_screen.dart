import 'package:flutter/material.dart';

import '../../core/api_services.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/customElevatedbutton.dart';
import '../../widgets/customToast.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_background.dart';

/// Forgot password — email in, a generic "check your inbox" confirmation
/// out (deliberately vague about whether the account exists — standard
/// security practice). Calls the real `/auth/forgot-password` endpoint.
///
/// Once sent, the reference keeps the email visible but disabled, hides the
/// button and reveals the confirmation note in its place.
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

  /// The reference caps the form column at 460px so it stays a readable
  /// card on iPad instead of stretching edge to edge.
  static const double _shellMaxWidth = 460;
  static const double _headerMaxWidth = 1100;

  /// `@media(max-width:520px){ .h1{font-size:26px} }`
  static const double _compactBreakpoint = 520;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Email is required.';
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$').hasMatch(email)) {
      return 'That email doesn’t look right. Mind checking it?';
    }
    return null;
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();
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
    final isCompact = MediaQuery.sizeOf(context).width <= _compactBreakpoint;

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                // `body{padding:32px 20px 48px}`
                padding: const EdgeInsets.fromLTRB(20, 32, 20, 48),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 80,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: _headerMaxWidth,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const AppLogo(),
                                // Yields first at small widths / large text
                                // scales so the brand stays intact.
                                Flexible(
                                  child: _BackToSignInLink(
                                    onTap: _backToSignIn,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(height: 40),
                        Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: _shellMaxWidth,
                            ),
                            child: _buildShell(isCompact),
                          ),
                        ),
                        const Spacer(),
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

  Widget _buildShell(bool isCompact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _Eyebrow(label: 'PASSWORD RESET'),
        const SizedBox(height: 14),
        Text(
          'Forgot your password?',
          textAlign: TextAlign.center,
          style: isCompact
              ? AppTextStyles.headline
              : AppTextStyles.headline.copyWith(fontSize: 30),
        ),
        const SizedBox(height: 10),
        Text(
          'Enter your email and we\'ll send you a link to reset it.',
          textAlign: TextAlign.center,
          style: AppTextStyles.body,
        ),
        const SizedBox(height: 26),
        GlassCard(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  label: 'Work email',
                  controller: _emailController,
                  hintText: 'you@yourbusiness.com',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  enabled: !_submitted,
                  validator: _validateEmail,
                ),
                const SizedBox(height: 16),
                if (_submitted)
                  _SentNote(
                    message:
                        _resultMessage ??
                        'If that email has a LightSignal account, a reset '
                            'link is on its way. Check your inbox.',
                  )
                else
                  PrimaryButton(
                    label: 'Send reset link',
                    onPressed: _isSubmitting ? null : _submit,
                    isLoading: _isSubmitting,
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 22),
        _RememberedItFooter(onTap: _backToSignIn),
      ],
    );
  }
}

/// `.eyebrow` — a glowing status dot beside a spaced-out uppercase label.
class _Eyebrow extends StatelessWidget {
  const _Eyebrow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: const BoxDecoration(
            color: AppColors.good,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: AppColors.good, blurRadius: 8, spreadRadius: 1),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: AppTextStyles.eyebrow),
      ],
    );
  }
}

/// `.sentnote` — the confirmation panel that replaces the button once the
/// reset link has been sent.
class _SentNote extends StatelessWidget {
  const _SentNote({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: AppColors.glassLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.glassBorderSoft),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: AppTextStyles.small.copyWith(
          color: AppColors.goodText,
          fontSize: 13.5,
          height: 1.5,
        ),
      ),
    );
  }
}

/// `.backlink` — the quiet return link in the header.
class _BackToSignInLink extends StatelessWidget {
  const _BackToSignInLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Text(
          'Back to sign in',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.end,
          style: AppTextStyles.body.copyWith(
            color: AppColors.soft,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// `.signin` — "Remembered it? Back to sign in" beneath the card.
class _RememberedItFooter extends StatelessWidget {
  const _RememberedItFooter({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          'Remembered it? ',
          style: AppTextStyles.body.copyWith(
            color: AppColors.soft,
            fontSize: 14,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              'Back to sign in',
              style: AppTextStyles.body.copyWith(
                color: AppColors.accent,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
