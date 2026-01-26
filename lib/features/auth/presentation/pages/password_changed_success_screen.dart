import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'package:foodora/core/widgets/primary_button.dart';
import 'package:foodora/features/auth/presentation/widgets/widgets.dart';
import 'package:foodora/features/auth/presentation/pages/login_screen.dart';

class PasswordChangedSuccessScreen extends StatelessWidget {
  const PasswordChangedSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const AuthHeader(
              title: AppStrings.forgotPasswordTitle,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),
                    
                    // Success Icon
                    const SuccessIcon(),
                    
                    const SizedBox(height: AppDimensions.spacing32),
                    
                    const Text(
                      AppStrings.passwordChangedTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppDimensions.spacing24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    
                    const SizedBox(height: AppDimensions.spacing12),
                    
                    const Text(
                      AppStrings.passwordChangedSubtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppDimensions.fontSize16,
                        color: AppColors.grey,
                        height: 1.5,
                      ),
                    ),
                    
                    const Spacer(flex: 3),
                    
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        text: AppStrings.backToLogin,
                        onPressed: () {
                           Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                            (route) => false,
                          );
                        },
                      ),
                    ),
                    
                    const Spacer(flex: 1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
