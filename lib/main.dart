import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/network/app_navigator.dart';
import 'package:flutter_application_1/core/network/internet_checker.dart';
import 'package:flutter_application_1/splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  InternetChecker.startMonitoring();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AppNavigator.navigatorKey,
      title: 'LightSignal',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: SplashScreen(),
      // const OnboardingScreen(),
    );
  }
}
