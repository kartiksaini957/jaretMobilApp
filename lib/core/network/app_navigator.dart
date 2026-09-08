import 'package:flutter/material.dart';

/// Global Navigation Key and helper to allow navigation from anywhere
/// (such as API interceptors and retry handlers) without requiring BuildContext.
class AppNavigator {
  AppNavigator._();

  /// Global key to access NavigatorState
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Current BuildContext of the app
  static BuildContext? get currentContext => navigatorKey.currentContext;

  /// Current NavigatorState
  static NavigatorState? get currentState => navigatorKey.currentState;

  /// Push a route
  static Future<T?>? push<T extends Object?>(Route<T> route) {
    return navigatorKey.currentState?.push<T>(route);
  }

  /// Push named route
  static Future<T?>? pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return navigatorKey.currentState?.pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  /// Pop current route
  static void pop<T extends Object?>([T? result]) {
    if (navigatorKey.currentState?.canPop() ?? false) {
      navigatorKey.currentState?.pop<T>(result);
    }
  }
}
