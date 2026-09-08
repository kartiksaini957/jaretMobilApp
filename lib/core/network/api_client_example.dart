import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_retry_handler.dart';

/// Example showing how to use [executeWithRetry] in your API calls / Repository layer.
///
/// If internet is disconnected, [executeWithRetry] will:
/// 1. Intercept the call and pause execution.
/// 2. Automatically navigate to [TryAgainScreen].
/// 3. Once internet is restored and user taps "Try Again", auto-retry the request.
/// 4. Return the parsed model or response seamlessly without losing state.
class ExampleApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  /// Example 1: Basic GET request with auto-retry
  Future<Map<String, dynamic>> fetchUserProfile(String userId) async {
    return executeWithRetry<Map<String, dynamic>>(() async {
      final uri = Uri.parse('$baseUrl/users/$userId');
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw HttpException('Failed to load user profile: ${response.statusCode}');
      }
    });
  }

  /// Example 2: POST request with auto-retry
  Future<bool> updateUserData(Map<String, dynamic> data) async {
    return executeWithRetry<bool>(() async {
      final uri = Uri.parse('$baseUrl/posts');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw HttpException('Failed to update data: ${response.statusCode}');
      }
    });
  }
}
