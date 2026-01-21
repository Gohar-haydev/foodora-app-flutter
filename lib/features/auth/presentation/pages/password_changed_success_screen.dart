import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_colors.dart';
import 'package:foodora/core/constants/app_strings.dart';
import 'package:foodora/core/widgets/primary_button.dart';
import 'package:foodora/features/auth/presentation/widgets/auth_header.dart';
import 'package:foodora/features/auth/presentation/pages/login_screen.dart';

class PasswordChangedSuccessScreen extends StatelessWidget {
  const PasswordChangedSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const AuthHeader(
              title: AppStrings.forgotPasswordTitle,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),
                    
                    // Success Icon
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4CAF50), // Green color
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    const Text(
                      AppStrings.passwordChangedTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    const Text(
                      AppStrings.passwordChangedSubtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
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
