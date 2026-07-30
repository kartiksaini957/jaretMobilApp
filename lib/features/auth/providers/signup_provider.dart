import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api_services.dart';

/// Snapshot of the sign-up flow: loading state, the Stripe checkout URL
/// and/or status message once it succeeds (some success responses — e.g.
/// "already registered but not verified" — have a message but no
/// checkout URL), or an error message once it fails.
class SignUpState {
  const SignUpState({
    this.isLoading = false,
    this.checkoutUrl,
    this.message,
    this.errorMessage,
  });

  final bool isLoading;
  final String? checkoutUrl;
  final String? message;
  final String? errorMessage;
}

/// Calls the real `/api/signup` endpoint via [ApiService] and keeps the
/// returned Stripe Checkout URL in state — the screen opens it in an
/// in-app WebView. Every step is logged with [debugPrint] — validation,
/// the request, and the outcome.
class SignUpController extends Notifier<SignUpState> {
  @override
  SignUpState build() => const SignUpState();

  final ApiService _api = ApiService();

  Future<bool> signUp({
    required String name,
    required String company,
    required String email,
    required String password,
  }) async {
    debugPrint('[SignUpController] signUp() called for email=$email');

    if (name.trim().isEmpty ||
        company.trim().isEmpty ||
        email.trim().isEmpty ||
        password.isEmpty) {
      debugPrint('[SignUpController] validation failed: missing fields');
      state = const SignUpState(errorMessage: 'Please fill in all fields.');
      return false;
    }
    if (!_isValidEmail(email)) {
      debugPrint('[SignUpController] validation failed: invalid email');
      state = const SignUpState(errorMessage: 'Enter a valid email address.');
      return false;
    }
    if (password.length < 8) {
      debugPrint('[SignUpController] validation failed: short password');
      state = const SignUpState(
        errorMessage: 'Password should be at least 8 characters.',
      );
      return false;
    }

    debugPrint('[SignUpController] state -> loading');
    state = const SignUpState(isLoading: true);

    try {
      final result = await _api.signUp(
        name: name.trim(),
        company: company.trim(),
        email: email.trim(),
        password: password,
      );
      debugPrint('[SignUpController] signup succeeded: $result');

      state = SignUpState(
        isLoading: false,
        checkoutUrl: result.checkoutUrl,
        message: result.message,
      );
      return true;
    } on ApiException catch (e) {
      debugPrint('[SignUpController] signup failed: ${e.message}');
      state = SignUpState(errorMessage: e.message);
      return false;
    } catch (e) {
      debugPrint('[SignUpController] unexpected error: $e');
      state = const SignUpState(
        errorMessage: 'Something went wrong. Please try again.',
      );
      return false;
    }
  }

  bool _isValidEmail(String email) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim());
}

final signUpControllerProvider =
    NotifierProvider<SignUpController, SignUpState>(SignUpController.new);
