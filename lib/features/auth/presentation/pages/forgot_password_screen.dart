import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'package:foodora/core/constants/app_strings.dart';
import 'package:foodora/core/widgets/custom_text_field.dart';
import 'package:foodora/core/widgets/primary_button.dart';
import 'package:provider/provider.dart';
import 'package:foodora/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'create_new_password_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(
          AppStrings.forgotPassword,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              
              const Center(
                child: Text(
                  AppStrings.forgotPasswordTitle,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.2,
                  ),
                ),
              ),
              
              const SizedBox(height: 16),

              const Center(
                child: Text(
                  AppStrings.forgotPasswordSubtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              CustomTextField(
                controller: _emailController,
                hintText: AppStrings.emailAddressPlaceholder,
                keyboardType: TextInputType.emailAddress,
              ),
              
              const SizedBox(height: 24),
              
              Consumer<AuthViewModel>(
                builder: (context, viewModel, child) {
                  return PrimaryButton(
                    text: AppStrings.resetPassword,
                    isLoading: viewModel.isLoading,
                    onPressed: () async {
                      final email = _emailController.text.trim();
                      if (email.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text(AppStrings.pleaseEnterEmail)),
                        );
                        return;
                      }

                      final success = await viewModel.forgotPassword(email);

                      if (!mounted) return;

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text(AppStrings.sendResetInstructions)),
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => CreateNewPasswordScreen(email: email)),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(viewModel.errorMessage ?? AppStrings.failedToSendResetEmail)),
                        );
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
