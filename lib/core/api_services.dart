import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/features/dashboard/model/dashboardModel.dart';
import 'package:flutter_application_1/features/dashboard/model/dashboardTabsModel.dart';
import 'package:http/http.dart' as http;

import 'api_endpoints.dart';

/// Thrown when the API responds with a non-2xx status or an unexpected
/// body shape.
class ApiException implements Exception {
  ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// The signed-in user, as returned by `/auth/login`.
class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.createdAt,
    required this.quickbooksConnected,
    required this.xeroConnected,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      role: json['role'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      quickbooksConnected: json['quickbooks_connected'] as bool? ?? false,
      xeroConnected: json['xero_connected'] as bool? ?? false,
    );
  }

  final String id;
  final String email;
  final String name;
  final String role;
  final String createdAt;
  final bool quickbooksConnected;
  final bool xeroConnected;

  @override
  String toString() =>
      'AppUser(id: $id, email: $email, name: $name, role: $role, '
      'createdAt: $createdAt, quickbooksConnected: $quickbooksConnected, '
      'xeroConnected: $xeroConnected)';
}

/// Everything `/auth/login` hands back: the user plus the token pair.
class AuthSession {
  const AuthSession({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      user: AppUser.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['access_token'] as String? ?? '',
      refreshToken: json['refresh_token'] as String? ?? '',
    );
  }

  final AppUser user;
  final String accessToken;
  final String refreshToken;

  @override
  String toString() =>
      'AuthSession(user: $user, accessToken: $accessToken, refreshToken: $refreshToken)';
}

/// What `/api/signup` hands back: whether the account was created, the
/// Stripe Checkout URL to send the user to next (when there is one), and
/// a status message — e.g. "already registered but not verified" has no
/// checkout URL, just a message to show.
class SignUpResult {
  const SignUpResult({
    required this.success,
    required this.checkoutUrl,
    required this.message,
  });

  factory SignUpResult.fromJson(Map<String, dynamic> json) {
    return SignUpResult(
      success: json['success'] as bool? ?? false,
      checkoutUrl: json['checkout_url'] as String? ?? '',
      message: json['message'] as String? ?? '',
    );
  }

  final bool success;
  final String checkoutUrl;
  final String message;

  @override
  String toString() =>
      'SignUpResult(success: $success, checkoutUrl: $checkoutUrl, message: $message)';
}

/// Thin wrapper around the LightSignal HTTP API. Every request/response
/// (and failure) is logged via [debugPrint] so the full round trip is
/// visible in the console while the app is being built out.
class ApiService {
  // POST /auth/login
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse(ApiConstants.login);
    final body = jsonEncode({'email': email, 'password': password});

    debugPrint('[ApiService] POST ${uri.toString()}');
    debugPrint('[ApiService] request body: $body');

    late final http.Response response;
    try {
      response = await http
          .post(
            uri,
            headers: const {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(const Duration(seconds: 20));
    } catch (e) {
      debugPrint('[ApiService] network error: $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('[ApiService] response status: ${response.statusCode}');
    debugPrint('[ApiService] response body: ${response.body}');

    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('[ApiService] failed to decode response JSON: $e');
      throw ApiException(
        'Unexpected response from server.',
        statusCode: response.statusCode,
      );
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message =
          decoded['message'] as String? ??
          decoded['error'] as String? ??
          'Login failed.';
      debugPrint('[ApiService] login failed: $message');
      throw ApiException(message, statusCode: response.statusCode);
    }

    final data = decoded['data'] as Map<String, dynamic>? ?? decoded;
    final session = AuthSession.fromJson(data);
    debugPrint('[ApiService] login succeeded: $session');
    return session;
  }

  // POST /auth/forgot-password
  Future<String> forgotPassword({required String email}) async {
    final uri = Uri.parse(ApiConstants.forgotPassword);
    final body = jsonEncode({'email': email});

    debugPrint('[ApiService] POST ${uri.toString()}');
    debugPrint('[ApiService] request body: $body');

    late final http.Response response;
    try {
      response = await http
          .post(
            uri,
            headers: const {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(const Duration(seconds: 20));
    } catch (e) {
      debugPrint('[ApiService] network error: $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('[ApiService] response status: ${response.statusCode}');
    debugPrint('[ApiService] response body: ${response.body}');

    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('[ApiService] failed to decode response JSON: $e');
      throw ApiException(
        'Unexpected response from server.',
        statusCode: response.statusCode,
      );
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message =
          decoded['message'] as String? ??
          decoded['error'] as String? ??
          'Could not send reset link.';
      debugPrint('[ApiService] forgot-password failed: $message');
      throw ApiException(message, statusCode: response.statusCode);
    }

    final message =
        decoded['message'] as String? ??
        'If an account exists with this email, a password reset link has '
            'been sent.';
    debugPrint('[ApiService] forgot-password succeeded: $message');
    return message;
  }

  // POST /api/signup
  Future<SignUpResult> signUp({
    required String name,
    required String company,
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse(ApiConstants.signup);
    final body = jsonEncode({
      'name': name,
      'company': company,
      'email': email,
      'password': password,
    });

    debugPrint('[ApiService] POST ${uri.toString()}');
    debugPrint('[ApiService] request body: $body');

    late final http.Response response;
    try {
      response = await http
          .post(
            uri,
            headers: const {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(const Duration(seconds: 20));
    } catch (e) {
      debugPrint('[ApiService] network error: $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('[ApiService] response status: ${response.statusCode}');
    debugPrint('[ApiService] response body: ${response.body}');

    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('[ApiService] failed to decode response JSON: $e');
      throw ApiException(
        'Unexpected response from server.',
        statusCode: response.statusCode,
      );
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message =
          decoded['message'] as String? ??
          decoded['error'] as String? ??
          'Sign up failed.';
      debugPrint('[ApiService] signup failed: $message');
      throw ApiException(message, statusCode: response.statusCode);
    }

    final result = SignUpResult.fromJson(decoded);
    debugPrint('[ApiService] signup succeeded: $result');
    return result;
  }
  // dashboard remainders

  Future<List<ActionItem>> getDashboardReminders({
    required String accessToken,
  }) async {
    final uri = Uri.parse(ApiConstants.dashboardReminders);

    debugPrint('[ApiService] GET ${uri.toString()}');

    late final http.Response response;

    try {
      response = await http
          .get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
          )
          .timeout(const Duration(seconds: 20));
    } catch (e) {
      debugPrint('[ApiService] network error: $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('[ApiService] response status: ${response.statusCode}');
    debugPrint('[ApiService] response body: ${response.body}');

    Map<String, dynamic> decoded;

    try {
      decoded = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      throw ApiException(
        'Unexpected response from server.',
        statusCode: response.statusCode,
      );
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        decoded['message'] ?? decoded['error'] ?? 'Failed to load reminders.',
        statusCode: response.statusCode,
      );
    }

    final result = ActionItemsResponse.fromJson(decoded);

    debugPrint('[ApiService] reminders loaded: ${result.data.length} items');

    return result.data;
  }

  // dashboard api
  Future<BusinessHealthResponse> getDashboardInsights({
    required String accessToken,
  }) async {
    final uri = Uri.parse(ApiConstants.dashboard);

    debugPrint('================ Dashboard Insights API ================');
    debugPrint('POST : ${uri.toString()}');
    debugPrint('TOKEN : $accessToken');

    late final http.Response response;

    try {
      response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
          )
          .timeout(const Duration(seconds: 20));
    } catch (e) {
      debugPrint('Network Error : $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('Status Code : ${response.statusCode}');
    debugPrint('Response : ${response.body}');

    final Map<String, dynamic> decoded = jsonDecode(response.body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        decoded['message'] ??
            decoded['error'] ??
            'Failed to load dashboard insights.',
        statusCode: response.statusCode,
      );
    }

    final result = BusinessHealthResponse.fromJson(decoded);

    debugPrint('================ Parsed Response ================');
    debugPrint('Success : ${result.success}');
    debugPrint('Summary : ${result.data.summary}');

    debugPrint('\n----------- Alerts -----------');
    for (final alert in result.data.alerts) {
      debugPrint('Severity : ${alert.severity}');
      debugPrint('Message  : ${alert.message}');
      debugPrint('Icon     : ${alert.icon}');
      debugPrint('Type     : ${alert.type}');
      debugPrint('--------------------------------');
    }

    debugPrint('\n----------- Insight Pairs -----------');
    for (final item in result.data.insightPairs) {
      debugPrint('Problem  : ${item.problem}');
      debugPrint('Solution : ${item.solution}');
      debugPrint('--------------------------------');
    }

    debugPrint('\n----------- Opportunities -----------');
    for (final item in result.data.opportunities) {
      debugPrint(item);
    }

    debugPrint('\n----------- What Changed -----------');
    for (final item in result.data.whatChanged) {
      debugPrint(item);
    }

    debugPrint('================ End =================');

    return result;
  }
}
