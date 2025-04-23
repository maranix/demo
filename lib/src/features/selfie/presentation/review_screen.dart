import 'dart:io';

import 'package:demo/src/core/constants/app_strings.dart';
import 'package:demo/src/features/home/home.dart';
import 'package:demo/src/features/selfie/providers/selfie_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final titleTextStyle = textTheme.titleLarge;

    final selfieProvider = context.read<SelfieProvider>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 12.0,
              children: [
                Text(
                  AppStrings.REVIEW_SELFIE_SCREEN_TITLE,
                  style: titleTextStyle,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1 / 1.2,
                    ),
                    itemCount: selfieProvider.capturedSelfies.length,
                    itemBuilder: (context, index) {
                      final selfie = selfieProvider.capturedSelfies[index];
                      if (selfie != null) {
                        return Column(
                          spacing: 8,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Image.file(
                                File(selfie.path),
                                fit: BoxFit.contain,
                                height: 400,
                                width: double.infinity,
                              ),
                            ),
                            ShadIconButton.destructive(
                              onPressed:
                                  () => selfieProvider.deleteSelfieAt(index),
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        );
                      }

                      return SizedBox.shrink();
                    },
                  ),
                ),
                ShadButton(
                  onPressed:
                      () => Navigator.of(
                        context,
                      ).pushAndRemoveUntil(HomeScreen.route(), (_) => false),
                  child: Text(AppStrings.REVIEW_SELFIE_SCREEN_CONFIRM_BUTTON),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
