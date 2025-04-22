import 'package:demo/src/core/constants/app_strings.dart';
import 'package:demo/src/features/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => SplashScreen());
  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthProvider>().state;
    final textStyle = Theme.of(
      context,
    ).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.w900);

    return switch (authState) {
      AuthState.initial => Material(
        child: Center(child: Text(AppStrings.APP_TITLE, style: textStyle)),
      ),
      AuthState.signedOut => LogInScreen(),
      AuthState.signedIn => Scaffold(
        body: Center(child: Text('Selfie Screen', style: textStyle)),
      ),
    };
  }
}
