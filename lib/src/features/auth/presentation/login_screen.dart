import 'package:demo/src/core/constants/app_strings.dart';
import 'package:demo/src/features/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => LogInScreen());

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final subHeadingTextStyle = textTheme.displayMedium?.copyWith(
      fontWeight: FontWeight.w900,
    );

    final subHeadingContentTextStyle = textTheme.headlineSmall;

    return Selector<AuthProvider, String?>(
      selector: (context, provider) => provider.errorMessage,
      shouldRebuild: (prev, next) => prev != next,
      builder: (context, errorMessage, child) {
        if (errorMessage != null) {
          ShadToaster.of(context).show(
            ShadToast(
              title: Text(AppStrings.SOMETHING_WENT_WRONG_ERROR_TITLE),
              description: Text(errorMessage),
            ),
          );
        }

        return child!;
      },
      child: Material(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 12.0,
              children: [
                const Spacer(flex: 4),
                Text(AppStrings.WELCOME, style: subHeadingTextStyle),
                Text(
                  AppStrings.SIGN_IN_TO_CONTINUE,
                  style: subHeadingContentTextStyle,
                ),
                const Spacer(),
                const _LoginWithGoogleButton(),
                const Spacer(flex: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginWithGoogleButton extends StatelessWidget {
  const _LoginWithGoogleButton();

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return ShadButton(
      onPressed:
          isLoading
              ? null
              : () => context.read<AuthProvider>().signInWithGoogle(),
      leading:
          isLoading
              ? SizedBox.square(
                dimension: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: ShadTheme.of(context).colorScheme.primaryForeground,
                ),
              )
              : null,
      child: Text(AppStrings.LOGIN_WITH_GOOGLE),
    );
  }
}
