import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'package:foodora/core/widgets/widgets.dart';
import 'package:foodora/features/menu/presentation/pages/main_layout.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../widgets/widgets.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import 'package:foodora/core/extensions/context_extensions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      context.showError(
        title: context.tr('missing_information'),
        message: context.tr('please_fill_all_fields'),
      );
      return;
    }

    // Show loading overlay
    context.showLoading(message: context.tr('signing_in'));

    // Call ViewModel
    final success = await context.read<AuthViewModel>().login(email, password);

    if (!mounted) return;

    // Hide loading overlay
    context.hideLoading();

    if (success) {
      // Navigate to Main Layout
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainLayout()),
        (route) => false,
      );
    } else {
      final error = context.read<AuthViewModel>().errorMessage;
      context.showError(
        title: context.tr('login_failed'),
        message: error ?? context.tr('login_failed'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppDimensions.spacing16),
              // Header with back button and title
              AuthHeader(
                title: context.tr('sign_in'),
                showBackButton: false,
              ),
              const SizedBox(height: 40),
              // Welcome back heading
              Center(
                child: Text(
                  context.tr('welcome_back'),
                  style: const TextStyle(
                    fontSize: AppDimensions.fontSize32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Email input field
              AuthTextField(
                controller: _emailController,
                hintText: context.tr('email_address'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppDimensions.spacing16),
              // Password input field with visibility toggle
              PasswordTextField(
                controller: _passwordController,
                hintText: context.tr('password_placeholder'),
              ),
              const SizedBox(height: AppDimensions.spacing8),
              // Forget Password link
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const ForgotPasswordScreen()),
                    );
                  },
                  child: Text(
                    context.tr('forgot_password'),
                    style: const TextStyle(
                      fontSize: AppDimensions.fontSize14,
                      color: AppColors.primaryText,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacing24),
              // Sign In button
              AuthButton(
                text: context.tr('sign_in'),
                onPressed: _onLoginPressed,
              ),
              const SizedBox(height: AppDimensions.spacing16),
              // Bottom text links
              AuthBottomLink(
                prefixText: context.tr('dont_have_account'),
                linkText: context.tr('create_account'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SignupScreen()),
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
