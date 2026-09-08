import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'app_navigator.dart';
import 'internet_checker.dart';
import '../../widgets/customToast.dart';
import '../../widgets/try_again_screen.dart';

/// Handles automatic retry, displays the "TryAgainScreen" when network connectivity is lost,
/// and shows user-friendly toast messages on server/API errors.
class ApiRetryHandler {
  ApiRetryHandler._();

  // Concurrency guard to prevent multiple screens from opening simultaneously
  static bool _isShowing = false;
  static Completer<bool>? _pendingCompleter;

  /// Executes an API call with automatic network check and retry mechanism.
  ///
  /// [apiCall]: The asynchronous function making the HTTP/API request.
  /// [checkConnectivityBefore]: If true, checks internet before invoking [apiCall].
  /// [showToastOnError]: If true, displays a clean toast when server errors occur.
  static Future<T> executeWithRetry<T>(
    Future<T> Function() apiCall, { 
    bool checkConnectivityBefore = true,
    bool showToastOnError = true,
  }) async {
    // 1. Initial connectivity pre-check
    if (checkConnectivityBefore) {
      final bool hasNet = await InternetChecker.hasConnection();
      if (!hasNet) {
        final bool recovered = await showNoInternetScreen();
        if (!recovered) {
          throw const SocketException('No active internet connection');
        }
      }
    }

    // 2. Execution loop with auto-retry on network errors
    while (true) {
      try {
        return await apiCall();
      } catch (error) {
        if (_isNetworkError(error)) {
          debugPrint('[ApiRetryHandler] Network error caught: $error. Prompting retry screen...');
          final bool recovered = await showNoInternetScreen();
          if (!recovered) {
            // User backed out or failed to restore connection
            rethrow;
          }
          // If recovered, the loop will retry apiCall() automatically
        } else {
          // Server error (e.g. 500 AI credit low, 400 Bad Request)
          if (showToastOnError) {
            _showErrorToast(error);
          }
          rethrow;
        }
      }
    }
  }

  /// Automatically shows a clean error toast to the user
  static void _showErrorToast(dynamic error) {
    try {
      final context = AppNavigator.currentContext;
      if (context != null && context.mounted) {
        String msg = error.toString();
        if (msg.startsWith('Exception: ')) {
          msg = msg.replaceFirst('Exception: ', '');
        }
        if (msg.startsWith('ApiException: ')) {
          msg = msg.replaceFirst('ApiException: ', '');
        }
        CustomToast.showError(context, msg);
      }
    } catch (e) {
      debugPrint('[ApiRetryHandler] Error while displaying toast: $e');
    }
  }

  /// Opens the [TryAgainScreen] if not already opened.
  /// Returns `true` if internet was restored and user tapped Try Again, `false` otherwise.
  static Future<bool> showNoInternetScreen() async {
    // If a TryAgainScreen is already open, queue behind its result
    if (_isShowing && _pendingCompleter != null) {
      return _pendingCompleter!.future;
    }

    _isShowing = true;
    _pendingCompleter = Completer<bool>();

    try {
      var navigatorState = AppNavigator.currentState;
      // If navigator is not ready yet during app startup, wait up to 1 second
      if (navigatorState == null) {
        for (int i = 0; i < 10; i++) {
          await Future.delayed(const Duration(milliseconds: 100));
          navigatorState = AppNavigator.currentState;
          if (navigatorState != null) break;
        }
      }

      if (navigatorState == null) {
        debugPrint('[ApiRetryHandler] NavigatorState is null. Ensure AppNavigator.navigatorKey is assigned in MaterialApp.');
        final bool hasNet = await InternetChecker.hasConnection();
        _pendingCompleter?.complete(hasNet);
        return hasNet;
      }

      // Navigate to TryAgainScreen
      final result = await navigatorState.push<bool>(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => const TryAgainScreen(),
        ),
      );

      final bool isRecovered = result ?? false;
      if (!_pendingCompleter!.isCompleted) {
        _pendingCompleter!.complete(isRecovered);
      }
      return isRecovered;
    } catch (e) {
      debugPrint('[ApiRetryHandler] Error while displaying TryAgainScreen: $e');
      if (!_pendingCompleter!.isCompleted) {
        _pendingCompleter!.complete(false);
      }
      return false;
    } finally {
      _isShowing = false;
      _pendingCompleter = null;
    }
  }

  /// Helper to determine if an error is network/connectivity related.
  static bool _isNetworkError(dynamic error) {
    if (error is SocketException) return true;
    if (error is TimeoutException) return true;
    if (error is http.ClientException) return true;
    if (error is HandshakeException) return true;
    if (error is TlsException) return true;

    final String errorStr = error.toString().toLowerCase();
    return errorStr.contains('socketexception') ||
        errorStr.contains('clientexception') ||
        errorStr.contains('network is unreachable') ||
        errorStr.contains('connection refused') ||
        errorStr.contains('connection timed out') ||
        errorStr.contains('connection reset') ||
        errorStr.contains('failed host lookup') ||
        errorStr.contains('could not reach the server') ||
        errorStr.contains('handshake') ||
        errorStr.contains('no internet') ||
        errorStr.contains('os error');
  }
}

/// Top-level convenience wrapper for [ApiRetryHandler.executeWithRetry].
Future<T> executeWithRetry<T>(
  Future<T> Function() apiCall, {
  bool checkConnectivityBefore = true,
  bool showToastOnError = true,
}) {
  return ApiRetryHandler.executeWithRetry<T>(
    apiCall,
    checkConnectivityBefore: checkConnectivityBefore,
    showToastOnError: showToastOnError,
  );
}
