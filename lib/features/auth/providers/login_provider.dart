import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api_services.dart';
import '../../../utils/pref_utils.dart';

/// Snapshot of the login flow: loading state, the signed-in user/tokens
/// once it succeeds, or an error message once it fails.
class LoginState {
  const LoginState({
    this.isLoading = false,
    this.user,
    this.accessToken,
    this.refreshToken,
    this.errorMessage,
  });

  final bool isLoading;
  final AppUser? user;
  final String? accessToken;
  final String? refreshToken;
  final String? errorMessage;

  bool get isLoggedIn => user != null && (accessToken?.isNotEmpty ?? false);
}

/// Calls the real `/auth/login` endpoint via [ApiService] and keeps the
/// resulting session in state. Every step of the flow is logged with
/// [debugPrint] — validation, the request going out, and the outcome.
class LoginController extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  final ApiService _api = ApiService();

  Future<bool> login({required String email, required String password}) async {
    debugPrint('[LoginController] login() called with email=$email');

    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty || password.isEmpty) {
      debugPrint('[LoginController] validation failed: empty email/password');
      state = LoginState(errorMessage: 'Please fill in both fields.');
      return false;
    }

    debugPrint('[LoginController] state -> loading');
    state = const LoginState(isLoading: true);

    try {
      final session = await _api.login(email: trimmedEmail, password: password);
      debugPrint(
        '[LoginController] login succeeded — user: ${session.user}, '
        'accessToken: ${session.accessToken}, refreshToken: ${session.refreshToken}',
      );

      await PrefUtils.saveTokens(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
      );
      await PrefUtils.saveUserName(session.user.name);
      debugPrint('[LoginController] tokens and user name saved to SharedPreferences');

      state = LoginState(
        isLoading: false,
        user: session.user,
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
      );
      return true;
    } on ApiException catch (e) {
      debugPrint('[LoginController] login failed: ${e.message}');
      state = LoginState(errorMessage: e.message);
      return false;
    } catch (e) {
      debugPrint('[LoginController] unexpected error: $e');
      state = const LoginState(
        errorMessage: 'Something went wrong. Please try again.',
      );
      return false;
    }
  }

  Future<void> logout() async {
    debugPrint('[LoginController] logout() called');
    await PrefUtils.clearTokens();
    debugPrint('[LoginController] tokens cleared from SharedPreferences');
    state = const LoginState();
  }
}

final loginControllerProvider =
    NotifierProvider<LoginController, LoginState>(LoginController.new);
