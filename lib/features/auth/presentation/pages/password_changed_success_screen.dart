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
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: AppDimensions.getMaxContentWidth(context),
            ),
            child: Column(
              children: [
                const AuthHeader(
                  title: AppStrings.forgotPasswordTitle,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.getResponsiveHorizontalPadding(context),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(flex: 2),
                        
                        // Success Icon
                        const SuccessIcon(),
                        
                        SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 32, tablet: 40)),
                        
                        Text(
                          AppStrings.passwordChangedTitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: AppDimensions.getH2Size(context),
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryText,
                          ),
                        ),
                        
                        SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 12, tablet: 16)),
                        
                        Text(
                          AppStrings.passwordChangedSubtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: AppDimensions.getBodySize(context),
                            color: AppColors.grey,
                            height: 1.5,
                          ),
                        ),
                        
                        const Spacer(flex: 3),
                        
                        SizedBox(
                          width: double.infinity,
                          child: PrimaryButton(
                            text: AppStrings.backToLogin,
                            height: AppDimensions.getButtonHeight(context),
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
        ),
      ),
    );
  }
}
