import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'api_retry_handler.dart';

/// Service to check device internet connection status.
/// Combines network interface check (via [Connectivity]) with real DNS/Host probe
/// (via [InternetAddress.lookup]) to ensure actual data connectivity.
class InternetChecker {
  InternetChecker._internal();

  static final InternetChecker instance = InternetChecker._internal();

  final Connectivity _connectivity = Connectivity();
  static StreamSubscription<List<ConnectivityResult>>? _subscription;
  static bool _isMonitoring = false;

  /// Default host to probe for real internet connectivity
  static const String lookupHost = 'google.com';

  /// Timeout duration for DNS lookup probe (kept snappy for fast UX)
  static const Duration lookupTimeout = Duration(seconds: 3);

  /// Check whether real internet connection is currently available.
  /// 1. Verifies that at least one network interface (WiFi, Mobile, Ethernet, VPN) is active.
  /// 2. Performs a real DNS lookup on [lookupHost] to ensure packets actually flow.
  static Future<bool> hasConnection({String host = lookupHost}) async {
    try {
      // 1. Interface check
      final connectivityResult = await Connectivity().checkConnectivity();
      final hasActiveInterface = connectivityResult.any(
        (result) => result != ConnectivityResult.none,
      );

      if (!hasActiveInterface) {
        return false;
      }

      // On Flutter Web, InternetAddress is not supported, connectivity interface is sufficient
      if (kIsWeb) {
        return true;
      }

      // 2. Real host lookup probe with timeout
      final List<InternetAddress> addresses = await InternetAddress.lookup(host)
          .timeout(lookupTimeout);

      if (addresses.isNotEmpty && addresses[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on SocketException catch (_) {
      return false;
    } on TimeoutException catch (_) {
      return false;
    } catch (e) {
      debugPrint('[InternetChecker] Connectivity check error: $e');
      return false;
    }
  }

  /// Real-time stream of internet connectivity changes.
  /// Emits `true` when internet is connected and `false` when disconnected.
  Stream<bool> get onStatusChange async* {
    yield await hasConnection();
    await for (final _ in _connectivity.onConnectivityChanged) {
      yield await hasConnection();
    }
  }

  /// Starts global background monitoring for network state changes.
  /// If network drops at any time while using the app, it automatically prompts [TryAgainScreen].
  static void startMonitoring() {
    if (_isMonitoring) return;
    _isMonitoring = true;

    _subscription?.cancel();
    _subscription = Connectivity().onConnectivityChanged.listen((results) async {
      final hasActiveInterface = results.any(
        (result) => result != ConnectivityResult.none,
      );

      if (!hasActiveInterface) {
        debugPrint('[InternetChecker] Interface disconnected. Prompting No Internet screen...');
        ApiRetryHandler.showNoInternetScreen();
      } else {
        final isConnected = await hasConnection();
        if (!isConnected) {
          debugPrint('[InternetChecker] Interface connected but no internet flow. Prompting No Internet screen...');
          ApiRetryHandler.showNoInternetScreen();
        }
      }
    });
  }

  /// Stops global background monitoring
  static void stopMonitoring() {
    _subscription?.cancel();
    _subscription = null;
    _isMonitoring = false;
  }
}
