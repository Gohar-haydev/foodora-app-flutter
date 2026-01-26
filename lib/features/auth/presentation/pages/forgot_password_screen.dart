import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'package:foodora/core/widgets/custom_text_field.dart';
import 'package:foodora/core/extensions/context_extensions.dart';
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
        title: Text(
          context.tr('forgot_password'),
          style: const TextStyle(
            color: AppColors.primaryText,
            fontSize: AppDimensions.fontSize18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryText, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              
              Center(
                child: Text(
                  context.tr('forgot_password_title'),
                  style: const TextStyle(
                    fontSize: AppDimensions.fontSize32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                    height: 1.2,
                  ),
                ),
              ),
              
              const SizedBox(height: AppDimensions.spacing16),

              Center(
                child: Text(
                  context.tr('forgot_password_subtitle'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: AppDimensions.fontSize16,
                    color: AppColors.grey,
                    height: 1.5,
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              CustomTextField(
                controller: _emailController,
                hintText: context.tr('email_address'),
                keyboardType: TextInputType.emailAddress,
              ),
              
              const SizedBox(height: AppDimensions.spacing24),
              
              Consumer<AuthViewModel>(
                builder: (context, viewModel, child) {
                  return PrimaryButton(
                    text: context.tr('reset_password'),
                    isLoading: viewModel.isLoading,
                    onPressed: () async {
                      final email = _emailController.text.trim();
                      if (email.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(context.tr('please_enter_email'))),
                        );
                        return;
                      }

                      final success = await viewModel.forgotPassword(email);

                      if (!mounted) return;

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(context.tr('send_reset_instructions'))),
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => CreateNewPasswordScreen(email: email)),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(viewModel.errorMessage ?? context.tr('failed_to_send_reset_email'))),
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
