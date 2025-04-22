import 'package:demo/src/core/constants/app_strings.dart';
import 'package:demo/src/features/splash/splash.dart';
import 'package:flutter/material.dart';
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
      home: SplashScreen(),
    );
  }
}
