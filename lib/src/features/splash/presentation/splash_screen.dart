import 'package:demo/src/core/constants/app_strings.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => SplashScreen());

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(
      context,
    ).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.w900);

    return Material(
      child: Center(child: Text(AppStrings.APP_TITLE, style: textStyle)),
    );
  }
}
