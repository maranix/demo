import 'package:demo/src/core/constants/app_strings.dart';
import 'package:demo/src/features/auth/auth.dart';
import 'package:demo/src/features/home/home.dart';
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
      home: Selector<AuthProvider, AuthState>(
        builder: (context, state, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final navigator = Navigator.of(context);

            Future.delayed(const Duration(milliseconds: 400), () {
              if (state == AuthState.signedOut) {
                navigator.pushAndRemoveUntil(LogInScreen.route(), (_) => false);
              } else if (state == AuthState.signedIn) {
                navigator.pushAndRemoveUntil(HomeScreen.route(), (_) => false);
              }
            });
          });

          return child!;
        },
        selector: (context, provider) => provider.state,
        child: SplashScreen(),
      ),
    );
  }
}
