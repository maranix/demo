import 'package:demo/src/core/constants/app_strings.dart';
import 'package:demo/src/features/auth/auth.dart';
import 'package:demo/src/features/selfie/selfie.dart';
import 'package:demo/src/features/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp(
      title: AppStrings.APP_TITLE,
      theme: ShadThemeData(
        colorScheme: const ShadSlateColorScheme.light(),
        brightness: Brightness.light,
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthProvider>().state;

    return switch (state) {
      AuthState.initial => const SplashScreen(),
      AuthState.signedOut => const LogInScreen(),
      AuthState.signedIn => const SelfieScreen(),
    };
  }
}
