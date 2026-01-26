import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';

/// Loading widget shown during splash screen authentication check
class SplashLoadingWidget extends StatelessWidget {
  final String appName;

  const SplashLoadingWidget({
    super.key,
    this.appName = 'Foodora',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              appName,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryAccent,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing24),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryAccent),
            ),
          ],
        ),
      ),
    );
  }
}
