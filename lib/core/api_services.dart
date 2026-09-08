import 'dart:async';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/features/FINANCIAL_Overview/model/financialOverviewModel.dart';
import 'package:flutter_application_1/features/business_health/model/businessHealthOverviewModel.dart';
import 'package:flutter_application_1/features/dashboard/model/dashboardAskAIhistoryModel.dart';
import 'package:flutter_application_1/features/dashboard/model/dashboardAskAImodel.dart';
import 'package:flutter_application_1/features/dashboard/model/dashboardModel.dart';
import 'package:flutter_application_1/features/dashboard/model/dashboardNumber.dart';
import 'package:flutter_application_1/features/dashboard/model/dashboardNumberDetail.dart'
    as kpi_detail;
import 'package:flutter_application_1/features/dashboard/model/dashboardTabsModel.dart';
import 'package:flutter_application_1/features/demand_Forecast/model/demandForecastModel.dart';
import 'package:flutter_application_1/features/opportunity/model/oportunityModel.dart';
import 'package:flutter_application_1/features/opportunity/ScenarioLab/model/scenario_lab_model.dart';
import 'package:flutter_application_1/features/business_profile/data/owner_notes_data.dart';
import 'package:flutter_application_1/features/business_profile/model/business_profile_onboarding_model.dart';
import 'package:flutter_application_1/features/business_profile/model/business_profile_richness_model.dart';
import 'package:flutter_application_1/features/business_profile/model/document_api_model.dart';
import 'package:flutter_application_1/features/business_profile/model/document_review_model.dart';
import 'package:flutter_application_1/features/setting/model/accountDeleteModel.dart';
import 'package:flutter_application_1/features/setting/model/aiCorrectionsApiModel.dart';
import 'package:flutter_application_1/features/setting/model/living_summary_model.dart';
import 'package:flutter_application_1/features/setting/model/consentHistoryModel.dart';
import 'package:flutter_application_1/features/setting/model/dataPrivacyModel.dart';
import 'package:flutter_application_1/features/setting/model/diagnosticsExportModel.dart';
import 'package:flutter_application_1/features/setting/model/generalSettingsModel.dart';
import 'package:flutter_application_1/features/setting/model/integrationsStatusModel.dart';
import 'package:flutter_application_1/features/setting/model/notificationTestModel.dart';
import 'package:flutter_application_1/features/setting/model/notificationsModel.dart';
import 'package:flutter_application_1/features/setting/model/securityTeamApiModel.dart';
import 'package:flutter_application_1/features/setting/model/billing_invoices_model.dart';
import 'package:flutter_application_1/features/setting/model/billing_summary_model.dart';
import 'package:flutter_application_1/features/setting/model/billing_portal_model.dart';
import 'package:flutter_application_1/features/setting/model/unified_snapshots_model.dart';
import 'package:flutter_application_1/features/notification/model/alert_notification_model.dart';
import 'package:flutter_application_1/utils/pref_utils.dart';

import 'package:http/http.dart' as http;
import 'api_endpoints.dart';
import 'network/api_retry_handler.dart';

class ApiException implements Exception {
  ApiException(dynamic rawMessage, {this.statusCode})
      : message = cleanErrorMessage(rawMessage);

  final String message;
  final int? statusCode;

  /// Intelligent error message parser that extracts human-friendly messages from
  /// raw server strings, Python dictionaries, Anthropic/OpenAI quota limits, etc.
  static String cleanErrorMessage(dynamic raw) {
    if (raw == null) return 'An unexpected server error occurred.';
    if (raw is List && raw.isNotEmpty) {
      return cleanErrorMessage(raw.first);
    }
    if (raw is Map) {
      if (raw['message'] is String) return cleanErrorMessage(raw['message']);
      if (raw['error'] is Map && raw['error']['message'] is String) {
        return cleanErrorMessage(raw['error']['message']);
      }
      if (raw['error'] is String) return cleanErrorMessage(raw['error']);
      if (raw['detail'] is String) return cleanErrorMessage(raw['detail']);
      if (raw['detail'] is List && (raw['detail'] as List).isNotEmpty) {
        return cleanErrorMessage((raw['detail'] as List).first);
      }
      if (raw['msg'] is String) {
        String msg = raw['msg'];
        if (msg.startsWith('Value error, ')) {
          msg = msg.substring('Value error, '.length).trim();
        }
        return msg;
      }
    }

    String text = raw.toString();

    // 1. Anthropic / Claude / OpenAI credit limit & quota errors
    if (text.contains('credit balance is too low') ||
        text.contains('insufficient_quota') ||
        text.contains('invalid_request_error')) {
      return 'AI Credit Balance is too low (Anthropic API). Please upgrade or purchase credits in Plans & Billing.';
    }

    // 2. Extract nested 'message': '...' or "message": "..."
    final match = RegExp(r'''['"]message['"]\s*:\s*['"]([^'"]+)['"]''')
        .firstMatch(text);
    if (match != null && match.group(1) != null) {
      return match.group(1)!;
    }

    // 3. Extract nested 'detail': '...'
    final detailMatch =
        RegExp(r'''['"]detail['"]\s*:\s*['"]([^'"]+)['"]''').firstMatch(text);
    if (detailMatch != null && detailMatch.group(1) != null) {
      return detailMatch.group(1)!;
    }

    // 4. Extract nested 'msg': '...'
    final msgMatch =
        RegExp(r'''['"]msg['"]\s*:\s*['"]([^'"]+)['"]''').firstMatch(text);
    if (msgMatch != null && msgMatch.group(1) != null) {
      String msg = msgMatch.group(1)!;
      if (msg.startsWith('Value error, ')) {
        msg = msg.substring('Value error, '.length).trim();
      }
      return msg;
    }

    // 4. Strip ugly braces/json formatting if raw string dump
    text = text.replaceAll(RegExp(r"[{}]"), '').trim();
    if (text.startsWith('Error code:')) {
      final parts = text.split(' - ');
      if (parts.length > 1) {
        text = parts.sublist(1).join(' - ').trim();
      }
    }

    return text.isNotEmpty ? text : 'An unexpected server error occurred.';
  }

  @override
  String toString() => message;
}

class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.createdAt,
    required this.quickbooksConnected,
    required this.xeroConnected,
    this.isDemo = false,
    this.needsPasswordSetup = false,
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
      isDemo: json['is_demo'] as bool? ?? false,
      needsPasswordSetup: json['needs_password_setup'] as bool? ?? false,
    );
  }

  final String id;
  final String email;
  final String name;
  final String role;
  final String createdAt;
  final bool quickbooksConnected;
  final bool xeroConnected;
  final bool isDemo;
  final bool needsPasswordSetup;

  @override
  String toString() =>
      'AppUser(id: $id, email: $email, name: $name, role: $role, '
      'createdAt: $createdAt, quickbooksConnected: $quickbooksConnected, '
      'xeroConnected: $xeroConnected, isDemo: $isDemo, needsPasswordSetup: $needsPasswordSetup)';
}

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

class RefreshTokenResponse {
  const RefreshTokenResponse({
    required this.success,
    required this.accessToken,
    required this.refreshToken,
  });

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return RefreshTokenResponse(
      success: json['success'] as bool? ?? false,
      accessToken: data['access_token'] as String? ?? '',
      refreshToken: data['refresh_token'] as String? ?? '',
    );
  }

  final bool success;
  final String accessToken;
  final String refreshToken;

  @override
  String toString() {
    return 'RefreshTokenResponse(success: $success)';
  }
}

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

class ApiService {
  static Future<RefreshTokenResponse>? _refreshFuture;

  Future<RefreshTokenResponse> _getOrRefreshTokens(String savedRefreshToken) async {
    if (_refreshFuture != null) {
      debugPrint('[ApiService] Refresh token already in progress. Awaiting existing refresh...');
      return _refreshFuture!;
    }
    final completer = Completer<RefreshTokenResponse>();
    _refreshFuture = completer.future;
    try {
      final res = await refreshToken(refreshToken: savedRefreshToken);
      if (res.accessToken.isNotEmpty) {
        await PrefUtils.saveTokens(
          accessToken: res.accessToken,
          refreshToken: res.refreshToken.isNotEmpty ? res.refreshToken : savedRefreshToken,
        );
        debugPrint('[ApiService] New tokens saved to PrefUtils.');
      }
      completer.complete(res);
      return res;
    } catch (e, st) {
      completer.completeError(e, st);
      rethrow;
    } finally {
      _refreshFuture = null;
    }
  }

  Future<http.Response> _authorizedRequest({
    required Future<http.Response> Function(String accessToken) request,
  }) async {
    return executeWithRetry<http.Response>(() async {
      final savedAccessToken = await PrefUtils.getAccessToken();
      if (savedAccessToken == null || savedAccessToken.isEmpty) {
        throw ApiException('Access token not found. Please login again.');
      }
      http.Response response;
      try {
        response = await request(savedAccessToken);
      } catch (e) {
        debugPrint('[ApiService] Authorized request error: $e');
        throw ApiException('Could not reach the server: $e');
      }
      debugPrint('[ApiService] Authorized API status: ${response.statusCode}');
      if (response.statusCode != 401) {
        return response;
      }
      debugPrint('[ApiService] 401 received. Access token expired/invalid.');
      final savedRefreshToken = await PrefUtils.getRefreshToken();
      if (savedRefreshToken == null || savedRefreshToken.isEmpty) {
        throw ApiException(
          'Refresh token not found. Please login again.',
          statusCode: 401,
        );
      }
      debugPrint('[ApiService] Calling refresh token API...');
      late final RefreshTokenResponse refreshResponse;
      try {
        refreshResponse = await _getOrRefreshTokens(savedRefreshToken);
      } catch (e) {
        debugPrint('[ApiService] Refresh token failed: $e');
        throw ApiException(
          'Session expired. Please login again.',
          statusCode: 401,
        );
      }
      final newAccessToken = refreshResponse.accessToken;
      if (newAccessToken.isEmpty) {
        throw ApiException(
          'Refresh API did not return a new access token.',
          statusCode: 401,
        );
      }
      debugPrint('[ApiService] Retrying request with new access token...');
      try {
        response = await request(newAccessToken);
      } catch (e) {
        debugPrint('[ApiService] Retry request error: $e');
        throw ApiException('Could not reach the server: $e');
      }
      debugPrint('[ApiService] Retry response status: ${response.statusCode}');
      if (response.statusCode == 401) {
        debugPrint('[ApiService] Retry also returned 401. Session expired.');
        throw ApiException(
          'Session expired. Please login again.',
          statusCode: 401,
        );
      }
      return response;
    });
  }

  Future<http.Response> _authorizedMultipartRequest({
    required Future<http.MultipartRequest> Function(String accessToken)
    createRequest,
    Duration timeout = const Duration(seconds: 90),
  }) async {
    return executeWithRetry<http.Response>(() async {
      final savedAccessToken = await PrefUtils.getAccessToken();
      if (savedAccessToken == null || savedAccessToken.isEmpty) {
        throw ApiException('Access token not found. Please login again.');
      }

      http.Response response;
      try {
        final req = await createRequest(savedAccessToken);
        final streamed = await req.send().timeout(timeout);
        response = await http.Response.fromStream(streamed);
      } catch (e) {
        debugPrint('[ApiService] Authorized multipart request error: $e');
        throw ApiException('Could not reach the server: $e');
      }

      debugPrint(
        '[ApiService] Authorized multipart API status: ${response.statusCode}',
      );
      if (response.statusCode != 401) {
        return response;
      }

      debugPrint(
        '[ApiService] 401 received on multipart. Access token expired/invalid.',
      );
      final savedRefreshToken = await PrefUtils.getRefreshToken();
      if (savedRefreshToken == null || savedRefreshToken.isEmpty) {
        throw ApiException(
          'Refresh token not found. Please login again.',
          statusCode: 401,
        );
      }

      debugPrint('[ApiService] Calling refresh token API...');
      late final RefreshTokenResponse refreshResponse;
      try {
        refreshResponse = await _getOrRefreshTokens(savedRefreshToken);
      } catch (e) {
        debugPrint('[ApiService] Refresh token failed: $e');
        throw ApiException(
          'Session expired. Please login again.',
          statusCode: 401,
        );
      }

      final newAccessToken = refreshResponse.accessToken;
      if (newAccessToken.isEmpty) {
        throw ApiException(
          'Refresh API did not return a new access token.',
          statusCode: 401,
        );
      }

      debugPrint(
        '[ApiService] Retrying multipart request with new access token...',
      );
      try {
        final req = await createRequest(newAccessToken);
        final streamed = await req.send().timeout(timeout);
        response = await http.Response.fromStream(streamed);
      } catch (e) {
        debugPrint('[ApiService] Retry multipart request error: $e');
        throw ApiException('Could not reach the server: $e');
      }

      debugPrint(
        '[ApiService] Retry multipart response status: ${response.statusCode}',
      );
      if (response.statusCode == 401) {
        debugPrint('[ApiService] Retry also returned 401. Session expired.');
        throw ApiException(
          'Session expired. Please login again.',
          statusCode: 401,
        );
      }

      return response;
    });
  }

  // POST /auth/login
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    return executeWithRetry<AuthSession>(() async {
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
      await PrefUtils.saveTokens(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
      );

      debugPrint('[ApiService] Login tokens saved successfully.');
      debugPrint('[ApiService] login succeeded: $session');
      return session;
    });
  }

  // GET /auth/me
  Future<AppUser> getAuthMe() async {
    final uri = Uri.parse(ApiConstants.authMe);

    debugPrint('================ Auth Me API ================');
    debugPrint('GET : ${uri.toString()}');

    late final http.Response response;

    try {
      response = await _authorizedRequest(
        request: (token) {
          return http
              .get(
                uri,
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer $token',
                },
              )
              .timeout(const Duration(seconds: 15));
        },
      );
    } catch (e) {
      debugPrint('[ApiService] Auth Me error: $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('Status Code : ${response.statusCode}');
    debugPrint('Response : ${response.body}');

    final Map<String, dynamic> decoded = jsonDecode(response.body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        ApiException.cleanErrorMessage(decoded),
        statusCode: response.statusCode,
      );
    }

    final userData = decoded['data'] as Map<String, dynamic>? ?? decoded;
    final user = AppUser.fromJson(userData);

    if (user.name.isNotEmpty) {
      await PrefUtils.saveUserName(user.name);
    }

    return user;
  }

  // GET /quickbooks/login
  Future<String> getQuickbooksAuthUrl() async {
    final uri = Uri.parse(ApiConstants.quickbooksLogin);

    debugPrint('================ QuickBooks Login API ================');
    debugPrint('GET : ${uri.toString()}');

    late final http.Response response;

    try {
      response = await _authorizedRequest(
        request: (token) {
          return http
              .get(
                uri,
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer $token',
                },
              )
              .timeout(const Duration(seconds: 20));
        },
      );
    } catch (e) {
      debugPrint('[ApiService] QuickBooks Login API error: $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('Status Code : ${response.statusCode}');
    debugPrint('Response : ${response.body}');

    final Map<String, dynamic> decoded = jsonDecode(response.body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        ApiException.cleanErrorMessage(decoded),
        statusCode: response.statusCode,
      );
    }

    final data = decoded['data'] as Map<String, dynamic>? ?? decoded;
    final authUrl = data['auth_url'] as String? ?? '';

    if (authUrl.isEmpty) {
      throw ApiException('QuickBooks authorization URL not found.');
    }

    return authUrl;
  }

  // POST /auth/forgot-password
  Future<String> forgotPassword({required String email}) async {
    return executeWithRetry<String>(() async {
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
    });
  }

  // POST /api/signup
  Future<SignUpResult> signUp({
    required String name,
    required String company,
    required String email,
    required String password,
  }) async {
    return executeWithRetry<SignUpResult>(() async {
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
    });
  }

  //  refresh token
  Future<RefreshTokenResponse> refreshToken({
    required String refreshToken,
  }) async {
    return executeWithRetry<RefreshTokenResponse>(() async {
      final uri = Uri.parse(ApiConstants.refreshToken);
      final body = jsonEncode({'refresh_token': refreshToken});

      debugPrint('================ Refresh Token API ================');
      debugPrint('POST : ${uri.toString()}');

      late final http.Response response;

      try {
        response = await http
            .post(
              uri,
              headers: const {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
              body: body,
            )
            .timeout(const Duration(seconds: 20));
      } catch (e) {
        debugPrint('[ApiService] refresh token network error: $e');
        throw ApiException('Could not reach the server: $e');
      }

      debugPrint('[ApiService] refresh token status: ${response.statusCode}');
      debugPrint('[ApiService] refresh token response: ${response.body}');

      Map<String, dynamic> decoded;

      try {
        decoded = jsonDecode(response.body) as Map<String, dynamic>;
      } catch (e) {
        debugPrint('[ApiService] failed to decode refresh response: $e');
        throw ApiException(
          'Unexpected response from server.',
          statusCode: response.statusCode,
        );
      }

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final message =
            decoded['message'] as String? ??
            decoded['error'] as String? ??
            'Failed to refresh access token.';

        debugPrint('[ApiService] refresh token failed: $message');
        throw ApiException(message, statusCode: response.statusCode);
      }

      final result = RefreshTokenResponse.fromJson(decoded);
      if (result.accessToken.isNotEmpty) {
        await PrefUtils.saveTokens(
          accessToken: result.accessToken,
          refreshToken: result.refreshToken.isNotEmpty
              ? result.refreshToken
              : refreshToken,
        );
        debugPrint('[ApiService] Refreshed tokens persisted to PrefUtils.');
      }
      debugPrint(
        '[ApiService] refresh token succeeded: '
        'success=${result.success}',
      );
      return result;
    });
  }

  // dashboard remainders
  Future<List<ActionItem>> getDashboardReminders({
    required String accessToken,
  }) async {
    final uri = Uri.parse(ApiConstants.dashboardReminders);

    debugPrint('[ApiService] GET ${uri.toString()}');

    late final http.Response response;

    try {
      response = await _authorizedRequest(
        request: (token) {
          return http
              .get(
                uri,
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer $token',
                },
              )
              .timeout(const Duration(seconds: 20));
        },
      );
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
        ApiException.cleanErrorMessage(decoded),
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
      response = await _authorizedRequest(
        request: (token) {
          return http
              .post(
                uri,
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer $token',
                },
              )
              .timeout(const Duration(seconds: 20));
        },
      );
    } catch (e) {
      debugPrint('Network Error : $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('Status Code : ${response.statusCode}');
    debugPrint('Response : ${response.body}');

    final Map<String, dynamic> decoded = jsonDecode(response.body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        ApiException.cleanErrorMessage(decoded),
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

  // dashboard number
  Future<DashboardKpiResponse> getDashboardKpis({
    required String accessToken,
  }) async {
    final uri = Uri.parse(ApiConstants.dashboardNumber);

    debugPrint('================ Dashboard Number API ================');
    debugPrint('GET : ${uri.toString()}');
    debugPrint('TOKEN : $accessToken');

    late final http.Response response;

    try {
      response = await _authorizedRequest(
        request: (token) {
          return http
              .get(
                uri,
                headers: {
                  'Authorization': 'Bearer $token',
                  'Accept': 'application/json',
                },
              )
              .timeout(const Duration(seconds: 40));
        },
      );
    } catch (e) {
      debugPrint('Network Error : $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('Status Code : ${response.statusCode}');
    debugPrint('Response : ${response.body}');

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
        ApiException.cleanErrorMessage(decoded),
        statusCode: response.statusCode,
      );
    }

    final result = DashboardKpiResponse.fromJson(decoded);

    debugPrint('================ API numbers start  ================');
    debugPrint('Success : ${result.success}');
    debugPrint('Revenue MTD : ${result.data.kpis.revenueMtd.value}');
    debugPrint('Revenue Prior : ${result.data.kpis.revenueMtd.priorValue}');
    debugPrint('Net Margin : ${result.data.kpis.netMarginPct.value}');
    debugPrint(
      'Net Margin Prior : ${result.data.kpis.netMarginPct.priorValue}',
    );
    debugPrint('Cash : ${result.data.kpis.cash.value}');
    debugPrint('Cash Prior : ${result.data.kpis.cash.priorValue}');
    debugPrint('Runway : ${result.data.kpis.runwayMonths.value}');
    debugPrint('Runway Prior : ${result.data.kpis.runwayMonths.priorValue}');
    debugPrint('AI Health Score : ${result.data.kpis.aiHealthScore.value}');
    debugPrint(
      'AI Health Score Prior : ${result.data.kpis.aiHealthScore.priorValue}',
    );
    debugPrint('================ End =================');

    return result;
  }

  // dashboard number detail (KPI explain) — powers the metric bottom sheet
  Future<kpi_detail.dashboardNumberDetail> getKpiExplain({
    required String accessToken,
    required String kpiName,
    required num currentValue,
    required num priorValue,
    required String formatType,
    Map<String, dynamic> optionalContext = const {},
  }) async {
    final uri = Uri.parse(ApiConstants.dashboardNumberdetail);
    final body = {
      'kpi_name': kpiName,
      'current_value': currentValue,
      'prior_value': priorValue,
      'format_type': formatType,
      'optional_context': optionalContext,
    };

    debugPrint('================ KPI Explain API ================');
    debugPrint('POST : ${uri.toString()}');
    debugPrint('BODY : ${jsonEncode(body)}');

    late final http.Response response;

    try {
      response = await _authorizedRequest(
        request: (token) {
          return http
              .post(
                uri,
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer $token',
                },
                body: jsonEncode(body),
              )
              .timeout(const Duration(seconds: 30));
        },
      );
    } catch (e) {
      debugPrint('Network Error : $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('Status Code : ${response.statusCode}');
    debugPrint('Response : ${response.body}');

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
        ApiException.cleanErrorMessage(decoded),
        statusCode: response.statusCode,
      );
    }

    final result = kpi_detail.dashboardNumberDetail.fromJson(decoded);

    debugPrint('================ KPI Explain parsed ================');
    debugPrint('Verdict : ${result.data.verdict}');
    debugPrint('Status  : ${result.data.status}');
    debugPrint('Change  : ${result.data.comparison.vsLastPeriod.changeText}');
    debugPrint('Drivers : ${result.data.drivers.length}');
    debugPrint('Actions : ${result.data.actions.length}');
    debugPrint(
      'Confidence : ${result.data.dataConfidence.label} '
      '(${result.data.dataConfidence.score})',
    );
    debugPrint('================ End =================');

    return result;
  }

  // dashboard ask ai
  // dashboard ask — chat-style Q&A
  Future<DashboardAskResponse> askDashboard({
    required String accessToken,
    required String question,
    String surface = 'dashboard_ask',
    String? chatId,
  }) async {
    final uri = Uri.parse(ApiConstants.dashboardAsk);
    final body = jsonEncode({
      'question': question,
      'surface': surface,
      if (chatId != null && chatId.isNotEmpty) 'chat_id': chatId,
    });

    debugPrint('================ Dashboard Ask API ================');
    debugPrint('POST : ${uri.toString()}');
    debugPrint('BODY : $body');

    late final http.Response response;

    try {
      response = await _authorizedRequest(
        request: (token) {
          return http
              .post(
                uri,
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer $token',
                },
                body: body,
              )
              .timeout(const Duration(seconds: 60));
        },
      );
    } catch (e) {
      debugPrint('Network Error : $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('Status Code : ${response.statusCode}');
    debugPrint('Response : ${response.body}');

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
        decoded['message'] ?? decoded['error'] ?? 'Failed to get AI answer.',
        statusCode: response.statusCode,
      );
    }

    final result = DashboardAskResponse.fromJson(decoded);

    debugPrint('================ Ask parsed ================');
    debugPrint('Chat ID : ${result.data.chatId}');
    debugPrint('Answer  : ${result.data.answer}');
    debugPrint('================ End =================');

    return result;
  }

  // list of chats + search
  Future<ChatListResponse> getDashboardChats({
    required String accessToken,
    String? query,
    int limit = 50,
  }) async {
    final params = <String, String>{'limit': '$limit'};
    if (query != null && query.trim().isNotEmpty) params['q'] = query.trim();
    final uri = Uri.parse(
      ApiConstants.dashboardChats,
    ).replace(queryParameters: params);

    debugPrint('[ApiService] GET ${uri.toString()}');

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http
            .get(
              uri,
              headers: {
                'Authorization': 'Bearer $token',
                'Accept': 'application/json',
              },
            )
            .timeout(const Duration(seconds: 20)),
      );
    } catch (e) {
      throw ApiException('Could not reach the server: $e');
    }

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
        decoded['message'] ?? decoded['error'] ?? 'Failed to load chats.',
        statusCode: response.statusCode,
      );
    }

    return ChatListResponse.fromJson(decoded);
  }

  // single chat with full message history
  Future<ChatDetail> getDashboardChatDetail({
    required String accessToken,
    required String chatId,
  }) async {
    final uri = Uri.parse(ApiConstants.dashboardChatDetail(chatId));

    debugPrint('[ApiService] GET ${uri.toString()}');

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http
            .get(
              uri,
              headers: {
                'Authorization': 'Bearer $token',
                'Accept': 'application/json',
              },
            )
            .timeout(const Duration(seconds: 20)),
      );
    } catch (e) {
      throw ApiException('Could not reach the server: $e');
    }

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
        decoded['message'] ?? decoded['error'] ?? 'Failed to load chat.',
        statusCode: response.statusCode,
      );
    }

    return ChatDetail.fromJson(decoded);
  }

  // opportunities
  // Active Opportunities API
  // Future<ActiveOpportunitiesModel> getActiveOpportunities({
  //   required String accessToken,
  // }) async {
  //   final uri = Uri.parse(ApiConstants.opportunities);

  //   debugPrint('================ Active Opportunities API ================');
  //   debugPrint('GET : ${uri.toString()}');

  //   late final http.Response response;

  //   try {
  //     response = await _authorizedRequest(
  //       request: (token) {
  //         return http
  //             .get(
  //               uri,
  //               headers: {
  //                 'Authorization': 'Bearer $token',
  //                 'Accept': 'application/json',
  //               },
  //             )
  //             .timeout(const Duration(seconds: 40));
  //       },
  //     );
  //   } catch (e) {
  //     debugPrint('[ApiService] Active Opportunities error: $e');
  //     throw ApiException('Could not reach the server: $e');
  //   }

  //   debugPrint('Status Code : ${response.statusCode}');
  //   debugPrint('Response : ${response.body}');
  //   Map<String, dynamic> decoded;

  //   try {
  //     decoded = jsonDecode(response.body) as Map<String, dynamic>;
  //   } catch (e) {
  //     debugPrint(
  //       '[ApiService] Failed to decode active opportunities response: $e',
  //     );

  //     throw ApiException(
  //       'Unexpected response from server.',
  //       statusCode: response.statusCode,
  //     );
  //   }

  //   if (response.statusCode < 200 || response.statusCode >= 300) {
  //     throw ApiException(
  //       decoded['message'] ??
  //           decoded['error'] ??
  //           'Failed to load active opportunities.',
  //       statusCode: response.statusCode,
  //     );
  //   }

  //   final result = ActiveOpportunitiesModel.fromJson(decoded);

  //   debugPrint('Active Opportunity Count : ${result.activeOpportunityCount}');

  //   debugPrint('Total Potential Value : ${result.totalPotentialValue}');

  //   debugPrint('Average Fit Score : ${result.averageFitScore}');

  //   debugPrint('Event Readiness Index : ${result.eventReadinessIndex}');

  //   debugPrint('Historical ROI : ${result.historicalRoi}');
  //   debugPrint('AI Notes : ${result.aiNotes}');
  //   for (final opportunity in result.activeOpportunities) {
  //     debugPrint('---------------- Opportunity ----------------');
  //     debugPrint('Title : ${opportunity.title}');
  //     debugPrint('Type : ${opportunity.type}');
  //     debugPrint('Location : ${opportunity.location}');
  //     debugPrint('Potential Value : ${opportunity.potentialValue}');
  //     debugPrint('Fit Score : ${opportunity.fitScore}');
  //     debugPrint('Readiness Score : ${opportunity.readinessScore}');
  //     debugPrint('Expected ROI : ${opportunity.expectedRoi}');
  //   }

  //   debugPrint('================ End =================');

  //   return result;
  // }

  // Demand Forecast API
  // Future<demand_forecast.DemandForecastModel> getDemandForecast({
  //   required String accessToken,
  // }) async {
  //   final uri = Uri.parse(ApiConstants.demandForecast);

  //   debugPrint('================ Demand Forecast API ================');
  //   debugPrint('GET : ${uri.toString()}');
  //   debugPrint('TOKEN : $accessToken');

  //   late final http.Response response;

  //   try {
  //     response = await _authorizedRequest(
  //       request: (token) {
  //         return http
  //             .get(
  //               uri,
  //               headers: {
  //                 'Authorization': 'Bearer $token',
  //                 'Accept': 'application/json',
  //               },
  //             )
  //             .timeout(const Duration(seconds: 300)); // 3 minutes
  //       },
  //     );
  //   } catch (e) {
  //     debugPrint('[ApiService] Demand Forecast error: $e');
  //     throw ApiException('Could not reach the server: $e');
  //   }

  //   debugPrint('Status Code : ${response.statusCode}');
  //   debugPrint('Response : ${response.body}');

  //   Map<String, dynamic> decoded;

  //   try {
  //     decoded = jsonDecode(response.body) as Map<String, dynamic>;
  //   } catch (e) {
  //     debugPrint('[ApiService] Failed to decode demand forecast response: $e');

  //     throw ApiException(
  //       'Unexpected response from server.',
  //       statusCode: response.statusCode,
  //     );
  //   }

  //   if (response.statusCode < 200 || response.statusCode >= 300) {
  //     throw ApiException(
  //       decoded['message'] ??
  //           decoded['error'] ??
  //           decoded['detail'] ??
  //           'Failed to load demand forecast.',
  //       statusCode: response.statusCode,
  //     );
  //   }

  //   final result = demand_forecast.DemandForecastModel.fromJson(decoded);

  //   debugPrint('================ Demand Forecast Parsed ================');

  //   debugPrint('Tab Label : ${result.agentOutput?.tabLabel}');

  //   debugPrint('Demand Unit : ${result.agentOutput?.demandUnit}');

  //   debugPrint('Windows : ${result.agentOutput?.windows?.length ?? 0}');

  //   debugPrint('Model Type : ${result.metrics?.modelType}');

  //   debugPrint('Forecast Next 30 Days : ${result.metrics?.forecastNext30d}');

  //   debugPrint('Confidence Score : ${result.metrics?.confidenceScore}');

  //   debugPrint('========================================================');

  //   return result;
  // }

  // GET /api/settings/general
  Future<GeneralSettingsData> getGeneralSettings({
    required String accessToken,
  }) async {
    final uri = Uri.parse(ApiConstants.settingsGeneral);

    debugPrint('[ApiService] GET ${uri.toString()}');

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http
            .get(
              uri,
              headers: {
                'Authorization': 'Bearer $token',
                'Accept': 'application/json',
              },
            )
            .timeout(const Duration(seconds: 20)),
      );
    } catch (e) {
      throw ApiException('Could not reach the server: $e');
    }

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
        decoded['message'] ?? decoded['error'] ?? 'Failed to load settings.',
        statusCode: response.statusCode,
      );
    }

    return GeneralSettingsResponse.fromJson(decoded).data;
  }

  // PATCH /api/settings/general — only sends the fields that changed
  Future<GeneralSettingsData> updateGeneralSettings({
    required String accessToken,
    Map<String, dynamic> changes = const {},
  }) async {
    final uri = Uri.parse(ApiConstants.settingsGeneral);
    final body = jsonEncode(changes);

    debugPrint('[ApiService] PATCH ${uri.toString()}');
    debugPrint('[ApiService] body: $body');

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http
            .patch(
              uri,
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
              body: body,
            )
            .timeout(const Duration(seconds: 20)),
      );
    } catch (e) {
      throw ApiException('Could not reach the server: $e');
    }

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
        decoded['message'] ?? decoded['error'] ?? 'Failed to save settings.',
        statusCode: response.statusCode,
      );
    }

    return GeneralSettingsResponse.fromJson(decoded).data;
  }

  // GET /api/settings/privacy
  Future<DataPrivacyData> getDataPrivacySettings({
    required String accessToken,
  }) async {
    final uri = Uri.parse(ApiConstants.settingsPrivacy);

    debugPrint('[ApiService] GET ${uri.toString()}');

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http
            .get(
              uri,
              headers: {
                'Authorization': 'Bearer $token',
                'Accept': 'application/json',
              },
            )
            .timeout(const Duration(seconds: 20)),
      );
    } catch (e) {
      throw ApiException('Could not reach the server: $e');
    }

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
        decoded['message'] ??
            decoded['error'] ??
            'Failed to load privacy settings.',
        statusCode: response.statusCode,
      );
    }

    return DataPrivacyResponse.fromJson(decoded).data;
  }

  // PATCH /api/settings/privacy — only sends the fields that changed
  Future<DataPrivacyData> updateDataPrivacySettings({
    required String accessToken,
    Map<String, dynamic> changes = const {},
  }) async {
    final uri = Uri.parse(ApiConstants.settingsPrivacy);
    final body = jsonEncode(changes);

    debugPrint('[ApiService] PATCH ${uri.toString()}');
    debugPrint('[ApiService] body: $body');

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http
            .patch(
              uri,
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
              body: body,
            )
            .timeout(const Duration(seconds: 20)),
      );
    } catch (e) {
      throw ApiException('Could not reach the server: $e');
    }

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
        decoded['message'] ??
            decoded['error'] ??
            'Failed to save privacy settings.',
        statusCode: response.statusCode,
      );
    }

    return DataPrivacyResponse.fromJson(decoded).data;
  }

  // POST /api/account/delete — starts the 14-day grace-period deletion
  Future<AccountDeleteData> deleteAccount({required String accessToken}) async {
    final uri = Uri.parse(ApiConstants.accountDelete);

    debugPrint('[ApiService] POST ${uri.toString()}');

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http
            .post(
              uri,
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
            )
            .timeout(const Duration(seconds: 20)),
      );
    } catch (e) {
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('[ApiService] status: ${response.statusCode}');
    debugPrint('[ApiService] body: ${response.body}');

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
        decoded['message'] ??
            decoded['error'] ??
            'Failed to start account deletion.',
        statusCode: response.statusCode,
      );
    }

    return AccountDeleteResponse.fromJson(decoded).data;
  }

  // GET /api/diagnostics/export
  Future<DiagnosticsExportData> getDiagnosticsExport({
    required String accessToken,
  }) async {
    final uri = Uri.parse(ApiConstants.diagnosticsExport);

    debugPrint('[ApiService] GET ${uri.toString()}');

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http
            .get(
              uri,
              headers: {
                'Authorization': 'Bearer $token',
                'Accept': 'application/json',
              },
            )
            .timeout(const Duration(seconds: 20)),
      );
    } catch (e) {
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('[ApiService] status: ${response.statusCode}');
    debugPrint('[ApiService] body: ${response.body}');

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
        decoded['message'] ??
            decoded['error'] ??
            'Failed to export diagnostics.',
        statusCode: response.statusCode,
      );
    }

    return DiagnosticsExportResponse.fromJson(decoded).data;
  }

  // GET /api/consents
  Future<List<ConsentEntry>> getConsentHistory({
    required String accessToken,
  }) async {
    final uri = Uri.parse(ApiConstants.consents);

    debugPrint('[ApiService] GET ${uri.toString()}');

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http
            .get(
              uri,
              headers: {
                'Authorization': 'Bearer $token',
                'Accept': 'application/json',
              },
            )
            .timeout(const Duration(seconds: 20)),
      );
    } catch (e) {
      throw ApiException('Could not reach the server: $e');
    }

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
        decoded['message'] ??
            decoded['error'] ??
            'Failed to load consent history.',
        statusCode: response.statusCode,
      );
    }

    return ConsentHistoryResponse.fromJson(decoded).data;
  }

  // GET /api/settings/notifications
  Future<NotificationsData> getNotificationSettings({
    required String accessToken,
  }) async {
    final uri = Uri.parse(ApiConstants.settingsNotifications);

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http
            .get(
              uri,
              headers: {
                'Authorization': 'Bearer $token',
                'Accept': 'application/json',
              },
            )
            .timeout(const Duration(seconds: 20)),
      );
    } catch (e) {
      throw ApiException('Could not reach the server: $e');
    }

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
        decoded['message'] ??
            decoded['error'] ??
            'Failed to load notification settings.',
        statusCode: response.statusCode,
      );
    }

    return NotificationsResponse.fromJson(decoded).data;
  }

  // PATCH /api/settings/notifications — only sends the fields that changed
  Future<NotificationsData> updateNotificationSettings({
    required String accessToken,
    Map<String, dynamic> changes = const {},
  }) async {
    final uri = Uri.parse(ApiConstants.settingsNotifications);
    final body = jsonEncode(changes);

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http
            .patch(
              uri,
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
              body: body,
            )
            .timeout(const Duration(seconds: 20)),
      );
    } catch (e) {
      throw ApiException('Could not reach the server: $e');
    }

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
        decoded['message'] ??
            decoded['error'] ??
            'Failed to save notification settings.',
        statusCode: response.statusCode,
      );
    }

    return NotificationsResponse.fromJson(decoded).data;
  }

  // POST /api/notifications/test
  Future<NotificationTestResponse> sendTestNotification({
    required String accessToken,
  }) async {
    final uri = Uri.parse(ApiConstants.notificationsTest);

    debugPrint('[ApiService] POST ${uri.toString()}');

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http
            .post(
              uri,
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
            )
            .timeout(const Duration(seconds: 20)),
      );
    } catch (e) {
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('[ApiService] status: ${response.statusCode}');
    debugPrint('[ApiService] body: ${response.body}');

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
        decoded['message'] ??
            decoded['error'] ??
            'Failed to send test notification.',
        statusCode: response.statusCode,
      );
    }

    return NotificationTestResponse.fromJson(decoded);
  }

  // GET /api/sessions — list active sessions
  Future<List<SessionItemDto>> getSessions({
    required String accessToken,
  }) async {
    final uri = Uri.parse(ApiConstants.sessions);
    debugPrint('====================================================');
    debugPrint('[ApiService] GET Sessions URL: $uri');

    final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http
            .get(
              uri,
              headers: {
                'Authorization': 'Bearer $token',
                'Accept': 'application/json',
              },
            )
            .timeout(const Duration(seconds: 20)),
      );
    } catch (e) {
      debugPrint('[ApiService] Sessions error: $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('Status Code : ${response.statusCode}');
    debugPrint('Response : ${response.body}');
    debugPrint('====================================================');

    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      throw ApiException(
        'Unexpected response from server.',
        statusCode: response.statusCode,
      );
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final list = (decoded['data'] as List<dynamic>? ?? [])
          .map((e) => SessionItemDto.fromJson(e as Map<String, dynamic>))
          .toList();
      return list;
    }

    throw ApiException(
      decoded['message'] ?? decoded['error'] ?? 'Failed to fetch sessions.',
      statusCode: response.statusCode,
    );
  }

  // DELETE /api/sessions/{id} — sign out one session
  Future<void> revokeSession({
    required String accessToken,
    required String sessionId,
  }) async {
    final uri = Uri.parse(ApiConstants.sessionRevoke(sessionId));

    debugPrint('[ApiService] DELETE ${uri.toString()}');

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http
            .delete(
              uri,
              headers: {
                'Authorization': 'Bearer $token',
                'Accept': 'application/json',
              },
            )
            .timeout(const Duration(seconds: 20)),
      );
    } catch (e) {
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('[ApiService] status: ${response.statusCode}');
    debugPrint('[ApiService] body: ${response.body}');

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
        decoded['message'] ??
            decoded['detail'] ??
            decoded['error'] ??
            'Failed to sign out session.',
        statusCode: response.statusCode,
      );
    }
  }

  // POST /api/sessions/revoke-all — sign out everywhere except current
  Future<int> revokeAllSessions({required String accessToken}) async {
    final uri = Uri.parse(ApiConstants.sessionsRevokeAll);

    debugPrint('[ApiService] POST ${uri.toString()}');

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http
            .post(
              uri,
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
            )
            .timeout(const Duration(seconds: 20)),
      );
    } catch (e) {
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('[ApiService] status: ${response.statusCode}');
    debugPrint('[ApiService] body: ${response.body}');

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
        decoded['message'] ??
            decoded['detail'] ??
            decoded['error'] ??
            'Failed to sign out other sessions.',
        statusCode: response.statusCode,
      );
    }

    final data = decoded['data'] as Map<String, dynamic>? ?? {};
    return data['revoked_count'] as int? ?? 0;
  }

  // GET /api/team
  Future<List<TeamMemberDto>> getTeam({required String accessToken}) async {
    final uri = Uri.parse(ApiConstants.team);

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http
            .get(
              uri,
              headers: {
                'Authorization': 'Bearer $token',
                'Accept': 'application/json',
              },
            )
            .timeout(const Duration(seconds: 20)),
      );
    } catch (e) {
      throw ApiException('Could not reach the server: $e');
    }

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
        decoded['message'] ?? decoded['error'] ?? 'Failed to load team.',
        statusCode: response.statusCode,
      );
    }

    return TeamListResponse.fromJson(decoded).data;
  }

  // POST /api/team/invite
  Future<TeamMemberDto> inviteTeamMember({
    required String accessToken,
    required String email,
    required String role,
  }) async {
    final uri = Uri.parse(ApiConstants.teamInvite);
    final body = jsonEncode({'email': email, 'role': role});

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http
            .post(
              uri,
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
              body: body,
            )
            .timeout(const Duration(seconds: 20)),
      );
    } catch (e) {
      throw ApiException('Could not reach the server: $e');
    }

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
        decoded['message'] ?? decoded['error'] ?? 'Failed to send invite.',
        statusCode: response.statusCode,
      );
    }

    return TeamMemberDto.fromJson(
      decoded['data'] as Map<String, dynamic>? ?? {},
    );
  }

  // DELETE /api/team/{id}
  Future<void> removeTeamMember({
    required String accessToken,
    required String memberId,
  }) async {
    final uri = Uri.parse(ApiConstants.teamRemove(memberId));

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http
            .delete(
              uri,
              headers: {
                'Authorization': 'Bearer $token',
                'Accept': 'application/json',
              },
            )
            .timeout(const Duration(seconds: 20)),
      );
    } catch (e) {
      throw ApiException('Could not reach the server: $e');
    }

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
        decoded['message'] ??
            decoded['error'] ??
            'Failed to remove team member.',
        statusCode: response.statusCode,
      );
    }
  }

  // POST /api/share-links — creates the advisor read-only link
  Future<ShareLinkDto> createShareLink({
    required String accessToken,
    String scope = 'fo+bh', // Financial Overview + Business Health
  }) async {
    final uri = Uri.parse(ApiConstants.shareLinks);
    final body = jsonEncode({'scope': scope});

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http
            .post(
              uri,
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
              body: body,
            )
            .timeout(const Duration(seconds: 20)),
      );
    } catch (e) {
      throw ApiException('Could not reach the server: $e');
    }

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
        decoded['message'] ??
            decoded['error'] ??
            'Failed to create share link.',
        statusCode: response.statusCode,
      );
    }

    return ShareLinkDto.fromJson(
      decoded['data'] as Map<String, dynamic>? ?? {},
    );
  }

  // POST /api/classifier/run
  Future<ClassifierRunResponse> runClassifier({
    required String accessToken,
  }) async {
    final uri = Uri.parse(ApiConstants.classifierRun);

    debugPrint('[ApiService] POST ${uri.toString()}');

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http
            .post(
              uri,
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
            )
            .timeout(const Duration(seconds: 20)),
      );
    } catch (e) {
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('[ApiService] status: ${response.statusCode}');
    debugPrint('[ApiService] body: ${response.body}');

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
        decoded['message'] ?? decoded['error'] ?? 'Failed to run classifier.',
        statusCode: response.statusCode,
      );
    }

    return ClassifierRunResponse.fromJson(decoded);
  }

  // POST /api/corrections/{id}/undo — toggles a correction's applied state
  Future<CorrectionUndoResponse> undoCorrection({
    required String accessToken,
    required String correctionId,
  }) async {
    final uri = Uri.parse(ApiConstants.correctionUndo(correctionId));

    debugPrint('[ApiService] POST ${uri.toString()}');

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http
            .post(
              uri,
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
            )
            .timeout(const Duration(seconds: 20)),
      );
    } catch (e) {
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('[ApiService] status: ${response.statusCode}');
    debugPrint('[ApiService] body: ${response.body}');

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
        decoded['message'] ??
            decoded['error'] ??
            'Failed to update correction.',
        statusCode: response.statusCode,
      );
    }

    return CorrectionUndoResponse.fromJson(decoded);
  }

  // GET /api/living-summary
  Future<LivingSummaryData> getLivingSummary({
    required String accessToken,
  }) async {
    final uri = Uri.parse(ApiConstants.livingSummary);

    debugPrint('[ApiService] GET ${uri.toString()}');

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http
            .get(
              uri,
              headers: {
                'Authorization': 'Bearer $token',
                'Accept': 'application/json',
              },
            )
            .timeout(const Duration(seconds: 20)),
      );
    } catch (e) {
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('[ApiService] status: ${response.statusCode}');
    debugPrint('[ApiService] body: ${response.body}');

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
        decoded['message'] ??
            decoded['error'] ??
            'Failed to load business summary.',
        statusCode: response.statusCode,
      );
    }

    final model = LivingSummaryResponse.fromJson(decoded);
    if (model.data == null) {
      throw ApiException('Living summary data not found.');
    }
    return model.data!;
  }

  // Demand Forecast API
  Future<DemandForecastResponse> getDemandForecast({
    required String accessToken,
  }) async {
    final uri = Uri.parse(ApiConstants.demandForecast);

    debugPrint('================ Demand Forecast API ================');
    debugPrint('GET : ${uri.toString()}');

    late final http.Response response;

    try {
      response = await _authorizedRequest(
        request: (token) {
          return http
              .get(
                uri,
                headers: {
                  'Authorization': 'Bearer $token',
                  'Accept': 'application/json',
                },
              )
              .timeout(const Duration(seconds: 60));
        },
      );
    } catch (e) {
      debugPrint('[ApiService] Demand Forecast error: $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('Status Code : ${response.statusCode}');
    debugPrint('Response : ${response.body}');

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
        decoded['message'] ??
            decoded['error'] ??
            decoded['detail'] ??
            'Failed to load demand forecast.',
        statusCode: response.statusCode,
      );
    }

    final result = DemandForecastResponse.fromJson(decoded);

    debugPrint('================ Demand Forecast Parsed ================');
    debugPrint('Tab Label : ${result.agentOutput.tabLabel}');
    debugPrint('Windows : ${result.agentOutput.windows.length}');
    debugPrint('========================================================');

    return result;
  }

  // Financial Overview API
  Future<FinancialOverviewResponse> getFinancialOverview({
    required String accessToken,
    bool forceRefresh = false,
  }) async {
    final uri = Uri.parse(
      ApiConstants.financialOverview,
    ).replace(queryParameters: {'force_refresh': '$forceRefresh'});

    debugPrint('================ Financial Overview API ================');
    debugPrint('GET : ${uri.toString()}');

    late final http.Response response;

    try {
      response = await _authorizedRequest(
        request: (token) {
          return http
              .get(
                uri,
                headers: {
                  'Authorization': 'Bearer $token',
                  'Accept': 'application/json',
                },
              )
              .timeout(const Duration(seconds: 40));
        },
      );
    } catch (e) {
      debugPrint('[ApiService] Financial Overview error: $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('Status Code : ${response.statusCode}');
    debugPrint('Response : ${response.body}');

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
        decoded['message'] ??
            decoded['error'] ??
            'Failed to load financial overview.',
        statusCode: response.statusCode,
      );
    }

    final result = FinancialOverviewResponse.fromJson(decoded);

    debugPrint('================ Financial Overview Parsed ================');
    debugPrint('Revenue MTD : ${result.kpis.revenueMtd}');
    debugPrint('KPI Tiles : ${result.kpiTiles.length}');
    debugPrint('Insight Items : ${result.insights.items.length}');
    debugPrint('===========================================================');

    return result;
  }

  // 🔧 NEW: GET /api/demand-forecast/actions/complete
  // Response: { "success": true, "completed_actions": ["act_tony_1", ...] }
  Future<List<String>> getCompletedActions({
    required String accessToken,
  }) async {
    final uri = Uri.parse(ApiConstants.demandForecastActionsComplete);

    debugPrint('[ApiService] GET ${uri.toString()}');

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http
            .get(
              uri,
              headers: {
                'Authorization': 'Bearer $token',
                'Accept': 'application/json',
              },
            )
            .timeout(const Duration(seconds: 20)),
      );
    } catch (e) {
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('[ApiService] status: ${response.statusCode}');
    debugPrint('[ApiService] body: ${response.body}');

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
        decoded['message'] ??
            decoded['error'] ??
            'Failed to load completed actions.',
        statusCode: response.statusCode,
      );
    }

    final ids = decoded['completed_actions'] as List? ?? [];
    return ids.map((e) => e.toString()).toList();
  }

  // 🔧 NEW: PATCH /api/demand-forecast/actions/complete
  // Body: {"action_id": "act_xxx", "completed": true}
  Future<void> updateActionCompletion({
    required String accessToken,
    required String actionId,
    required bool completed,
  }) async {
    final uri = Uri.parse(ApiConstants.demandForecastActionsComplete);
    final body = jsonEncode({'action_id': actionId, 'completed': completed});

    debugPrint('[ApiService] PATCH ${uri.toString()}');
    debugPrint('[ApiService] body: $body');

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http
            .patch(
              uri,
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
              body: body,
            )
            .timeout(const Duration(seconds: 20)),
      );
    } catch (e) {
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('[ApiService] status: ${response.statusCode}');
    debugPrint('[ApiService] body: ${response.body}');

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
        decoded['message'] ?? decoded['error'] ?? 'Failed to update action.',
        statusCode: response.statusCode,
      );
    }
  }

  Future<BusinessHealthOverviewResponse> getBusinessHealthOverview({
    required String accessToken,
  }) async {
    final uri = Uri.parse(ApiConstants.businessHealthOverview);

    debugPrint(
      '================ Business Health Overview API ================',
    );
    debugPrint('GET : ${uri.toString()}');

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) {
          return http
              .get(
                uri,
                headers: {
                  'Authorization': 'Bearer $token',
                  'Accept': 'application/json',
                },
              )
              .timeout(const Duration(seconds: 40));
        },
      );
    } catch (e) {
      debugPrint('[ApiService] Business Health Overview error: $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('Status Code : ${response.statusCode}');
    debugPrint('Response : ${response.body}');

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
        decoded['message'] ??
            decoded['error'] ??
            'Failed to load business health.',
        statusCode: response.statusCode,
      );
    }

    final result = BusinessHealthOverviewResponse.fromJson(decoded);

    debugPrint('================ Business Health Parsed ================');
    debugPrint('Overall Score : ${result.data.overall.score}');
    debugPrint(
      'Categories : financial=${result.data.categories.financial.score}, '
      'operational=${result.data.categories.operational.score}, '
      'customer=${result.data.categories.customer.score}, '
      'risk=${result.data.categories.risk.score}, '
      'growth=${result.data.categories.growth.score}',
    );
    debugPrint('Watch Areas : ${result.data.watchAreas.length}');
    debugPrint('Active Alerts : ${result.data.activeAlerts.length}');
    debugPrint('===========================================================');

    return result;
  }

  // POST /api/ai/health/refresh
  Future<HealthRefreshResponse> refreshBusinessHealth({
    required String accessToken,
  }) async {
    final uri = Uri.parse(ApiConstants.healthRefresh);

    debugPrint('================ Health Refresh API ================');
    debugPrint('POST : ${uri.toString()}');

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) {
          return http
              .post(
                uri,
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer $token',
                },
              )
              .timeout(const Duration(seconds: 60));
        },
      );
    } catch (e) {
      debugPrint('[ApiService] Health Refresh error: $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('Status Code : ${response.statusCode}');
    debugPrint('Response : ${response.body}');

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
        decoded['message'] ??
            decoded['error'] ??
            'Failed to refresh health data.',
        statusCode: response.statusCode,
      );
    }

    final result = HealthRefreshResponse.fromJson(decoded);
    debugPrint('Refresh success: ${result.success} · mode: ${result.mode}');
    debugPrint('=======================================================');

    return result;
  }

  Future<OpportunitiesOverviewResponse> getOpportunitiesOverview({
    required String accessToken,
    List<String>? types,
    int? maxDriveTimeMinutes,
    List<String>? riskLevels,
  }) async {
    final queryParams = <String, dynamic>{};
    if (types != null && types.isNotEmpty) queryParams['type'] = types;
    if (maxDriveTimeMinutes != null) {
      queryParams['max_drive_time_minutes'] = '$maxDriveTimeMinutes';
    }
    if (riskLevels != null && riskLevels.isNotEmpty) {
      queryParams['risk_level'] = riskLevels;
    }

    final uri = Uri.parse(
      ApiConstants.opportunitiesOverview,
    ).replace(queryParameters: queryParams.isEmpty ? null : queryParams);

    debugPrint('================ Opportunities Overview API ================');
    debugPrint('GET : ${uri.toString()}');

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) {
          return http
              .get(
                uri,
                headers: {
                  'Authorization': 'Bearer $token',
                  'Accept': 'application/json',
                },
              )
              .timeout(const Duration(seconds: 40));
        },
      );
    } catch (e) {
      debugPrint('[ApiService] Opportunities Overview error: $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('Status Code : ${response.statusCode}');
    debugPrint('Response : ${response.body}');

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
        decoded['message'] ??
            decoded['error'] ??
            'Failed to load opportunities overview.',
        statusCode: response.statusCode,
      );
    }

    final result = OpportunitiesOverviewResponse.fromJson(decoded);

    debugPrint(
      '================ Opportunities Overview Parsed ================',
    );
    debugPrint('Hero : ${result.data.recommendedHero?.title}');
    debugPrint('More Matches : ${result.data.moreMatches.length}');
    debugPrint(
      '===============================================================',
    );

    return result;
  }

  // >>> PASTE THIS METHOD inside class ApiService (right after
  // >>> getOpportunitiesOverview), same file: api_services.dart
  //
  // PATCH /api/opportunities/{id}/status  -> body: {"status": "Tracked"}
  // Matches your existing pattern exactly (uses _authorizedRequest, same
  // error handling style as updateActionCompletion / updateGeneralSettings).

  Future<Map<String, dynamic>> updateOpportunityStatus({
    required String accessToken,
    required String opportunityId,
    required String status, // e.g. "Tracked"
  }) async {
    final uri = Uri.parse(ApiConstants.opportunityStatus(opportunityId));
    final body = jsonEncode({'status': status});

    debugPrint(
      '================ Update Opportunity Status API ================',
    );
    debugPrint('PATCH : ${uri.toString()}');
    debugPrint('BODY : $body');

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http
            .patch(
              uri,
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
              body: body,
            )
            .timeout(const Duration(seconds: 20)),
      );
    } catch (e) {
      debugPrint('[ApiService] Update Opportunity Status error: $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('Status Code : ${response.statusCode}');
    debugPrint('Response : ${response.body}');

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
        decoded['message'] ??
            decoded['error'] ??
            'Failed to update opportunity status.',
        statusCode: response.statusCode,
      );
    }

    debugPrint(
      '================ Update Opportunity Status Parsed ================',
    );
    debugPrint('success : ${decoded['success']}');
    debugPrint('status  : ${decoded['status']}');
    debugPrint(
      '===================================================================',
    );

    return decoded; // caller only needs success/status, no dedicated model needed
  }

  // Financial Overview - Snooze Insight API
  Future<Map<String, dynamic>> snoozeFinancialInsight({
    required String accessToken,
    required String insightId,
  }) async {
    final uri = Uri.parse(ApiConstants.financialInsightSnooze(insightId));

    debugPrint('================ Snooze Financial Insight API ================');
    debugPrint('POST : ${uri.toString()}');

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http
            .post(
              uri,
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
                'Accept': 'application/json',
              },
            )
            .timeout(const Duration(seconds: 20)),
      );
    } catch (e) {
      debugPrint('[ApiService] Snooze Financial Insight error: $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('Status Code : ${response.statusCode}');
    debugPrint('Response : ${response.body}');

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
        decoded['message'] ??
            decoded['error'] ??
            'Failed to snooze insight.',
        statusCode: response.statusCode,
      );
    }

    debugPrint('================ Snooze Financial Insight Parsed ================');
    debugPrint('success : ${decoded['success']}');
    debugPrint('data    : ${decoded['data']}');
    debugPrint('================================================================');

    return decoded;
  }

  // Financial Overview - Acknowledge Insight API (Draft / Done)
  Future<Map<String, dynamic>> acknowledgeFinancialInsight({
    required String accessToken,
    required String insightId,
  }) async {
    final uri = Uri.parse(ApiConstants.financialInsightAcknowledge(insightId));

    debugPrint('================ Acknowledge Financial Insight API ================');
    debugPrint('POST : ${uri.toString()}');

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http
            .post(
              uri,
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
                'Accept': 'application/json',
              },
            )
            .timeout(const Duration(seconds: 20)),
      );
    } catch (e) {
      debugPrint('[ApiService] Acknowledge Financial Insight error: $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('Status Code : ${response.statusCode}');
    debugPrint('Response : ${response.body}');

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
        decoded['message'] ??
            decoded['error'] ??
            'Failed to acknowledge insight.',
        statusCode: response.statusCode,
      );
    }

    debugPrint('================ Acknowledge Financial Insight Parsed ================');
    debugPrint('success : ${decoded['success']}');
    debugPrint('data    : ${decoded['data']}');
    debugPrint('====================================================================');

    return decoded;
  }

  // ===========================================================================
  // BUSINESS PROFILE NOTES APIS
  // ===========================================================================

  Future<List<OwnerNote>> getBusinessProfileNotes({
    required String accessToken,
  }) async {
    final uri = Uri.parse(ApiConstants.businessProfileNotes);

    debugPrint('================ Business Profile Notes GET API ================');
    debugPrint('GET : ${uri.toString()}');

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http.get(
          uri,
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ).timeout(const Duration(seconds: 20)),
      );
    } catch (e) {
      debugPrint('[ApiService] Get Business Profile Notes error: $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('Status Code : ${response.statusCode}');
    debugPrint('Response : ${response.body}');

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
        decoded['message'] ??
            decoded['error'] ??
            'Failed to load notes.',
        statusCode: response.statusCode,
      );
    }

    final rawList = decoded['data'] as List<dynamic>? ?? [];
    final list = rawList
        .map((e) => OwnerNote.fromJson(e as Map<String, dynamic>))
        .toList();

    debugPrint('================ Business Profile Notes Parsed ================');
    debugPrint('Count: ${list.length}');
    debugPrint('===============================================================');

    return list;
  }

  Future<OwnerNote> addBusinessProfileNote({
    required String accessToken,
    required String text,
  }) async {
    final uri = Uri.parse(ApiConstants.businessProfileNotes);
    final body = jsonEncode({'text': text});

    debugPrint('================ Business Profile Notes POST API ================');
    debugPrint('POST : ${uri.toString()}');
    debugPrint('BODY : $body');

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http.post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
          body: body,
        ).timeout(const Duration(seconds: 20)),
      );
    } catch (e) {
      debugPrint('[ApiService] Add Business Profile Note error: $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('Status Code : ${response.statusCode}');
    debugPrint('Response : ${response.body}');

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
        decoded['message'] ??
            decoded['error'] ??
            'Failed to save note.',
        statusCode: response.statusCode,
      );
    }

    final data = decoded['data'] as Map<String, dynamic>? ?? {};
    final note = OwnerNote.fromJson(data);

    debugPrint('================ Business Profile Note Created ================');
    debugPrint('ID: ${note.id}, text: ${note.body}');
    debugPrint('================================================================');

    return note;
  }

  Future<bool> deleteBusinessProfileNote({
    required String accessToken,
    required String noteId,
  }) async {
    if (noteId.isEmpty) return true;
    final uri = Uri.parse(ApiConstants.businessProfileNoteDelete(noteId));

    debugPrint('================ Business Profile Note DELETE API ================');
    debugPrint('DELETE : ${uri.toString()}');

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http.delete(
          uri,
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ).timeout(const Duration(seconds: 20)),
      );
    } catch (e) {
      debugPrint('[ApiService] Delete Business Profile Note error: $e');
      return true;
    }

    debugPrint('Status Code : ${response.statusCode}');
    debugPrint('Response : ${response.body}');
    return response.statusCode >= 200 && response.statusCode < 300;
  }

  Future<BusinessProfileRichness> getBusinessProfileRichness({
    required String accessToken,
  }) async {
    final uri = Uri.parse(ApiConstants.businessProfileRichness);

    debugPrint('================ Business Profile Richness GET API ================');
    debugPrint('GET : ${uri.toString()}');

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http.get(
          uri,
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ).timeout(const Duration(seconds: 20)),
      );
    } catch (e) {
      debugPrint('[ApiService] Get Business Profile Richness error: $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('Status Code : ${response.statusCode}');
    debugPrint('Response : ${response.body}');

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
        decoded['message'] ??
            decoded['error'] ??
            'Failed to load richness data.',
        statusCode: response.statusCode,
      );
    }

    final data = decoded['data'] as Map<String, dynamic>? ?? {};
    final richness = BusinessProfileRichness.fromJson(data);

    debugPrint('================ Business Profile Richness Parsed ================');
    debugPrint('Score: ${richness.score}, Band: ${richness.band}, Complete: ${richness.sectionsComplete}/${richness.totalSections}');
    debugPrint('==================================================================');

    return richness;
  }

  Future<BusinessProfileOnboardingData> getBusinessProfileOnboarding({
    required String accessToken,
  }) async {
    final uri = Uri.parse(ApiConstants.businessProfileOnboarding);

    debugPrint('================ Business Profile Onboarding GET API ================');
    debugPrint('GET : ${uri.toString()}');

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http.get(
          uri,
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ).timeout(const Duration(seconds: 20)),
      );
    } catch (e) {
      debugPrint('[ApiService] Get Business Profile Onboarding error: $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('Status Code : ${response.statusCode}');
    debugPrint('Response : ${response.body}');

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
        decoded['message'] ??
            decoded['error'] ??
            'Failed to load onboarding data.',
        statusCode: response.statusCode,
      );
    }

    final data = decoded['data'] as Map<String, dynamic>? ?? {};
    final onboarding = BusinessProfileOnboardingData.fromJson(data);

    final onboardingMap =
        (data['onboarding_data'] as Map<String, dynamic>?) ?? {};

    debugPrint('====================================================================');
    debugPrint('📥 [GET ONBOARDING DATA] - Section by Section Received (${onboardingMap.keys.length} sections):');
    onboardingMap.forEach((sectionKey, sectionContent) {
      debugPrint('--------------------------------------------------');
      debugPrint('🔹 Section: $sectionKey');
      if (sectionContent is Map) {
        sectionContent.forEach((k, v) {
          debugPrint('   • $k: $v');
        });
      } else {
        debugPrint('   $sectionContent');
      }
    });
    debugPrint('====================================================================');

    return onboarding;
  }

  Future<bool> saveBusinessProfileOnboarding({
    required Map<String, dynamic> onboardingData,
    required String accessToken,
  }) async {
    final uri = Uri.parse(ApiConstants.businessProfileOnboarding);

    debugPrint('====================================================================');
    debugPrint('📤 [POST ONBOARDING DATA] - Section by Section Sent (${onboardingData.keys.length} sections):');
    debugPrint('POST URL: ${uri.toString()}');
    onboardingData.forEach((sectionKey, sectionContent) {
      debugPrint('--------------------------------------------------');
      debugPrint('🔹 Section: $sectionKey');
      if (sectionContent is Map) {
        sectionContent.forEach((k, v) {
          debugPrint('   • $k: $v');
        });
      } else {
        debugPrint('   $sectionContent');
      }
    });
    debugPrint('====================================================================');

    final payload = {
      'onboarding_data': onboardingData,
    };

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http.post(
          uri,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode(payload),
        ).timeout(const Duration(seconds: 25)),
      );
    } catch (e) {
      debugPrint('[ApiService] Save Business Profile Onboarding error: $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('Status Code : ${response.statusCode}');
    debugPrint('Response : ${response.body}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true;
    }

    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      decoded = {};
    }

    throw ApiException(
      decoded['message'] ??
          decoded['error'] ??
          'Failed to save onboarding data (${response.statusCode})',
      statusCode: response.statusCode,
    );
  }

  /// GET /documents/
  Future<List<DocumentApiModel>> getDocuments() async {
    final url = Uri.parse(ApiConstants.documents);

    debugPrint('====================================================');
    debugPrint('[ApiService] GET Documents URL: $url');
    debugPrint('====================================================');

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ).timeout(const Duration(seconds: 20)),
      );
    } catch (e) {
      debugPrint('[ApiService] GET Documents error: $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('Status Code : ${response.statusCode}');
    debugPrint('Response : ${response.body}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          return DocumentApiModel.fromJsonList(decoded);
        } else if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
          return DocumentApiModel.fromJsonList(decoded['data']);
        }
      } catch (e) {
        debugPrint('[ApiService] GET Documents parse error: $e');
      }
      return [];
    }

    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      decoded = {};
    }

    throw ApiException(
      decoded['message'] ??
          decoded['error'] ??
          'Failed to load documents (${response.statusCode})',
      statusCode: response.statusCode,
    );
  }

  /// GET /documents/{documentId}/review
  Future<DocumentReviewModel> getDocumentReview(String documentId) async {
    final url = Uri.parse(ApiConstants.documentReview(documentId));

    debugPrint('====================================================');
    debugPrint('[ApiService] GET Document Review URL: $url');
    debugPrint('====================================================');

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ).timeout(const Duration(seconds: 20)),
      );
    } catch (e) {
      debugPrint('[ApiService] GET Document Review error: $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('Status Code : ${response.statusCode}');
    debugPrint('Response : ${response.body}');

    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      decoded = {};
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = decoded.containsKey('data') && decoded['data'] is Map<String, dynamic>
          ? decoded['data'] as Map<String, dynamic>
          : decoded;
      return DocumentReviewModel.fromJson(data);
    }

    throw ApiException(
      decoded['message'] ??
          decoded['error'] ??
          'Failed to load document review (${response.statusCode})',
      statusCode: response.statusCode,
    );
  }

  /// GET /documents/{documentId}/download?version=original
  Future<List<int>> downloadDocument(
    String documentId, {
    String version = 'original',
  }) async {
    final url = Uri.parse(
      ApiConstants.documentDownload(documentId, version: version),
    );

    debugPrint('====================================================');
    debugPrint('[ApiService] GET Download Document URL: $url');
    debugPrint('====================================================');

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http.get(
          url,
          headers: {
            'Authorization': 'Bearer $token',
          },
        ).timeout(const Duration(seconds: 30)),
      );
    } catch (e) {
      debugPrint('[ApiService] GET Download Document error: $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('Status Code : ${response.statusCode}');
    debugPrint('Downloaded Bytes length : ${response.bodyBytes.length}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.bodyBytes;
    }

    throw ApiException(
      'Failed to download document (${response.statusCode})',
      statusCode: response.statusCode,
    );
  }

  /// DELETE /documents/{documentId}
  Future<bool> deleteDocument(String documentId) async {
    final url = Uri.parse(ApiConstants.documentDelete(documentId));

    debugPrint('====================================================');
    debugPrint('[ApiService] DELETE Document URL: $url');
    debugPrint('====================================================');

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http.delete(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ).timeout(const Duration(seconds: 20)),
      );
    } catch (e) {
      debugPrint('[ApiService] DELETE Document error: $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('Status Code : ${response.statusCode}');
    debugPrint('Response : ${response.body}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true;
    }

    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      decoded = {};
    }

    throw ApiException(
      decoded['message'] ??
          decoded['detail'] ??
          decoded['error'] ??
          'Failed to delete document (${response.statusCode})',
      statusCode: response.statusCode,
    );
  }

  /// POST /documents/upload
  Future<Map<String, dynamic>> uploadDocuments({
    required List<PlatformFile> files,
    String? docTypeHint,
  }) async {
    final url = Uri.parse(ApiConstants.documentUpload);

    debugPrint('====================================================');
    debugPrint('[ApiService] POST Upload Documents URL: $url');
    debugPrint('[ApiService] Files count: ${files.length}');
    debugPrint('====================================================');

    Future<http.MultipartRequest> buildRequest(String token) async {
      final request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $token';

      if (docTypeHint != null && docTypeHint.trim().isNotEmpty) {
        request.fields['hint'] = docTypeHint.trim();
        request.fields['doc_type_hint'] = docTypeHint.trim();
      }

      for (final file in files) {
        if (file.path != null && file.path!.isNotEmpty) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'files',
              file.path!,
              filename: file.name,
            ),
          );
        } else if (file.bytes != null) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'files',
              file.bytes!,
              filename: file.name,
            ),
          );
        }
      }
      return request;
    }

    final response = await _authorizedMultipartRequest(
      createRequest: buildRequest,
      timeout: const Duration(seconds: 90),
    );

    debugPrint('Status Code : ${response.statusCode}');
    debugPrint('Response : ${response.body}');

    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      decoded = {};
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    throw ApiException(
      decoded['message'] ??
          decoded['detail'] ??
          decoded['error'] ??
          'Failed to upload documents (${response.statusCode})',
      statusCode: response.statusCode,
    );
  }

  /// Fetches integrations status from `GET /api/integrations/status`
  Future<IntegrationsStatusData> getIntegrationsStatus({
    required String accessToken,
  }) async {
    final uri = Uri.parse(ApiConstants.integrationsStatus);

    debugPrint('====================================================');
    debugPrint('[ApiService] GET Integrations Status URL: ${ApiConstants.integrationsStatus}');

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http
            .get(
              uri,
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
            )
            .timeout(const Duration(seconds: 20)),
      );
    } catch (e) {
      debugPrint('[ApiService] GET Integrations Status error: $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('Status Code : ${response.statusCode}');
    debugPrint('Response : ${response.body}');
    debugPrint('====================================================');

    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      throw ApiException(
        'Unexpected response from server.',
        statusCode: response.statusCode,
      );
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final res = IntegrationsStatusResponse.fromJson(decoded);
      return res.data;
    }

    throw ApiException(
      decoded['message'] ??
          decoded['detail'] ??
          decoded['error'] ??
          'Failed to fetch integrations status (${response.statusCode})',
      statusCode: response.statusCode,
    );
  }

  /// Connects integration provider via `POST /api/integrations/connect`
  /// Returns the `redirect_url` on success.
  Future<String> connectIntegration({
    required String accessToken,
    required String provider,
    String? shop,
  }) async {
    final uri = Uri.parse(ApiConstants.integrationsConnect);
    final payload = <String, dynamic>{
      'provider': provider,
      if (shop != null && shop.trim().isNotEmpty) 'shop': shop.trim(),
    };
    final body = jsonEncode(payload);

    debugPrint('====================================================');
    debugPrint('[ApiService] POST Connect Integration URL: ${ApiConstants.integrationsConnect}');
    debugPrint('Body : $body');

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http
            .post(
              uri,
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
              body: body,
            )
            .timeout(const Duration(seconds: 20)),
      );
    } catch (e) {
      debugPrint('[ApiService] Connect Integration error: $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('Status Code : ${response.statusCode}');
    debugPrint('Response : ${response.body}');
    debugPrint('====================================================');

    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      throw ApiException(
        'Unexpected response from server.',
        statusCode: response.statusCode,
      );
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final redirectUrl = decoded['redirect_url'] as String?;
      if (redirectUrl != null && redirectUrl.isNotEmpty) {
        return redirectUrl;
      }
      throw ApiException('No redirect URL returned from server.');
    }

    throw ApiException(
      decoded['detail'] ??
          decoded['message'] ??
          decoded['error'] ??
          'Failed to connect integration.',
      statusCode: response.statusCode,
    );
  }

  /// Disconnects integration provider via `POST /api/integrations/disconnect`
  Future<bool> disconnectIntegration({
    required String accessToken,
    required String provider,
  }) async {
    final uri = Uri.parse(ApiConstants.integrationsDisconnect);
    final body = jsonEncode({'provider': provider});

    debugPrint('====================================================');
    debugPrint('[ApiService] POST Disconnect Integration URL: ${ApiConstants.integrationsDisconnect}');
    debugPrint('Body : $body');

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http
            .post(
              uri,
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
              body: body,
            )
            .timeout(const Duration(seconds: 20)),
      );
    } catch (e) {
      debugPrint('[ApiService] Disconnect Integration error: $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('Status Code : ${response.statusCode}');
    debugPrint('Response : ${response.body}');
    debugPrint('====================================================');

    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      throw ApiException(
        'Unexpected response from server.',
        statusCode: response.statusCode,
      );
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded['success'] == true;
    }

    throw ApiException(
      decoded['message'] ??
          decoded['detail'] ??
          decoded['error'] ??
          'Failed to disconnect integration (${response.statusCode})',
      statusCode: response.statusCode,
    );
  }

  Future<ScenarioResponse> runScenario({
    required String question,
    List<Map<String, dynamic>> history = const [],
  }) async {
    final uri = Uri.parse(ApiConstants.scenario);
    final body = jsonEncode({
      'question': question,
      'history': history,
    });

    debugPrint('====================================================');
    debugPrint('[ApiService] POST Scenario URL: ${ApiConstants.scenario}');
    debugPrint('Body : $body');

    late final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http
            .post(
              uri,
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
                'Accept': 'application/json',
              },
              body: body,
            )
            .timeout(const Duration(seconds: 45)),
      );
    } catch (e) {
      debugPrint('[ApiService] Scenario error: $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('Status Code : ${response.statusCode}');
    debugPrint('Response : ${response.body}');
    debugPrint('====================================================');

    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      throw ApiException(
        'Unexpected response from server.',
        statusCode: response.statusCode,
      );
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ScenarioResponse.fromJson(decoded);
    }

    throw ApiException(
      decoded['message'] ??
          decoded['detail'] ??
          decoded['error'] ??
          'Failed to run scenario (${response.statusCode})',
      statusCode: response.statusCode,
    );
  }

  // ===========================================================================
  // BILLING INVOICES
  // ===========================================================================

  Future<BillingInvoicesResponse> getBillingInvoices() async {
    debugPrint('====================================================');
    debugPrint('[ApiService] GET Billing Invoices URL: ${ApiConstants.billingInvoices}');

    final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http.get(
          Uri.parse(ApiConstants.billingInvoices),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
    } catch (e) {
      debugPrint('[ApiService] Billing Invoices error: $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('Status Code : ${response.statusCode}');
    debugPrint('Response : ${response.body}');
    debugPrint('====================================================');

    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      throw ApiException(
        'Unexpected response from server.',
        statusCode: response.statusCode,
      );
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return BillingInvoicesResponse.fromJson(decoded);
    }

    throw ApiException(
      decoded['message'] ??
          decoded['detail'] ??
          decoded['error'] ??
          'Failed to fetch billing invoices (${response.statusCode})',
      statusCode: response.statusCode,
    );
  }

  // ===========================================================================
  // BILLING SUMMARY
  // ===========================================================================

  Future<BillingSummaryResponse> getBillingSummary() async {
    debugPrint('====================================================');
    debugPrint('[ApiService] GET Billing Summary URL: ${ApiConstants.billingSummary}');

    final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http.get(
          Uri.parse(ApiConstants.billingSummary),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
    } catch (e) {
      debugPrint('[ApiService] Billing Summary error: $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('Status Code : ${response.statusCode}');
    debugPrint('Response : ${response.body}');
    debugPrint('====================================================');

    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      throw ApiException(
        'Unexpected response from server.',
        statusCode: response.statusCode,
      );
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return BillingSummaryResponse.fromJson(decoded);
    }

    throw ApiException(
      decoded['message'] ??
          decoded['detail'] ??
          decoded['error'] ??
          'Failed to fetch billing summary (${response.statusCode})',
      statusCode: response.statusCode,
    );
  }

  // ===========================================================================
  // BILLING PORTAL
  // ===========================================================================

  Future<BillingPortalResponse> getBillingPortalUrl() async {
    debugPrint('====================================================');
    debugPrint('[ApiService] GET Billing Portal URL: ${ApiConstants.billingPortal}');

    final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http.get(
          Uri.parse(ApiConstants.billingPortal),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
    } catch (e) {
      debugPrint('[ApiService] Billing Portal error: $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('Status Code : ${response.statusCode}');
    debugPrint('Response : ${response.body}');
    debugPrint('====================================================');

    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      throw ApiException(
        'Unexpected response from server.',
        statusCode: response.statusCode,
      );
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return BillingPortalResponse.fromJson(decoded);
    }

    throw ApiException(
      decoded['message'] ??
          decoded['detail'] ??
          decoded['error'] ??
          'Failed to fetch billing portal URL (${response.statusCode})',
      statusCode: response.statusCode,
    );
  }

  // ===========================================================================
  // BACKUP EXPORT
  // ===========================================================================

  Future<Map<String, dynamic>> createBackupExport({String format = 'json'}) async {
    final uri = Uri.parse('${ApiConstants.backupExport}?format=$format');
    debugPrint('====================================================');
    debugPrint('[ApiService] POST Backup Export URL: $uri');

    final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http.post(
          uri,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
    } catch (e) {
      debugPrint('[ApiService] Backup export error: $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('Status Code : ${response.statusCode}');
    debugPrint('Response : ${response.body}');
    debugPrint('====================================================');

    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'data': response.body,
        };
      }
      throw ApiException(
        'Unexpected response from server.',
        statusCode: response.statusCode,
      );
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    throw ApiException(
      decoded['message'] ??
          decoded['detail'] ??
          decoded['error'] ??
          'Failed to export backup (${response.statusCode})',
      statusCode: response.statusCode,
    );
  }

  // ===========================================================================
  // UNIFIED SNAPSHOTS
  // ===========================================================================

  Future<UnifiedSnapshotsResponse> getUnifiedSnapshots() async {
    debugPrint('====================================================');
    debugPrint('[ApiService] GET Unified Snapshots URL: ${ApiConstants.snapshotsUnified}');

    final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http.get(
          Uri.parse(ApiConstants.snapshotsUnified),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
    } catch (e) {
      debugPrint('[ApiService] Unified Snapshots error: $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('Status Code : ${response.statusCode}');
    debugPrint('Response : ${response.body}');
    debugPrint('====================================================');

    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      throw ApiException(
        'Unexpected response from server.',
        statusCode: response.statusCode,
      );
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return UnifiedSnapshotsResponse.fromJson(decoded);
    }

    throw ApiException(
      decoded['message'] ??
          decoded['detail'] ??
          decoded['error'] ??
          'Failed to fetch snapshots (${response.statusCode})',
      statusCode: response.statusCode,
    );
  }

  // ===========================================================================
  // DASHBOARD ALERTS / NOTIFICATIONS
  // ===========================================================================

  Future<AlertNotificationsResponse> getDashboardAlerts() async {
    final uri = Uri.parse(ApiConstants.dashboardAlerts);
    debugPrint('====================================================');
    debugPrint('[ApiService] GET Dashboard Alerts URL: $uri');

    final http.Response response;
    try {
      response = await _authorizedRequest(
        request: (token) => http.get(
          uri,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
    } catch (e) {
      debugPrint('[ApiService] Dashboard Alerts error: $e');
      throw ApiException('Could not reach the server: $e');
    }

    debugPrint('Status Code : ${response.statusCode}');
    debugPrint('Response : ${response.body}');
    debugPrint('====================================================');

    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      throw ApiException(
        'Unexpected response from server.',
        statusCode: response.statusCode,
      );
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return AlertNotificationsResponse.fromJson(decoded);
    }

    throw ApiException(
      decoded['message'] ??
          decoded['detail'] ??
          decoded['error'] ??
          'Failed to fetch alerts (${response.statusCode})',
      statusCode: response.statusCode,
    );
  }
}
