import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'package:foodora/core/widgets/widgets.dart';
import 'package:foodora/features/menu/presentation/pages/main_layout.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../widgets/widgets.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignupPressed() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final phone = _phoneController.text;
    final password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      context.showError(
        title: 'Missing Information',
        message: AppStrings.pleaseFillAllFields,
      );
      return;
    }

    // Show loading overlay
    context.showLoading(message: 'Creating your account...');

    // Call ViewModel register method
    final success = await context.read<AuthViewModel>().register(
      name: name,
      email: email,
      password: password,
      phone: phone,
    );

    if (!mounted) return;

    // Hide loading overlay
    context.hideLoading();

    if (success) {
      // Navigate to MainLayout on successful registration
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainLayout()),
        (route) => false,
      );
    } else {
      final error = context.read<AuthViewModel>().errorMessage;
      context.showError(
        title: 'Registration Failed',
        message: error ?? 'Registration Failed',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                
                // Header with back button and "SIGN UP" title
                const AuthHeader(title: AppStrings.signUp),

                const SizedBox(height: 40),

                // Create Account heading
                const Text(
                  AppStrings.createAccount,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 12),

                // Subtitle
                Text(
                  AppStrings.signUpSubtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 40),

                // Full Name input field
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _nameController,
                  builder: (context, value, child) {
                    return AuthTextField(
                      controller: _nameController,
                      hintText: AppStrings.fullNamePlaceholder,
                      suffixIcon: value.text.isNotEmpty
                          ? const Icon(
                              Icons.check,
                              color: Color(0xFFFF9800),
                              size: 20,
                            )
                          : null,
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Email input field
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _emailController,
                  builder: (context, value, child) {
                    return AuthTextField(
                      controller: _emailController,
                      hintText: AppStrings.emailAddressPlaceholder,
                      keyboardType: TextInputType.emailAddress,
                      suffixIcon: value.text.isNotEmpty
                          ? const Icon(
                              Icons.check,
                              color: Color(0xFFFF9800),
                              size: 20,
                            )
                          : null,
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Phone input field
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _phoneController,
                  builder: (context, value, child) {
                    return AuthTextField(
                      controller: _phoneController,
                      hintText: AppStrings.phone,
                      keyboardType: TextInputType.phone,
                      suffixIcon: value.text.isNotEmpty
                          ? const Icon(
                              Icons.check,
                              color: Color(0xFFFF9800),
                              size: 20,
                            )
                          : null,
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Password input field with visibility toggle
                PasswordTextField(
                  controller: _passwordController,
                  hintText: '******',
                ),

                const SizedBox(height: 32),

                // Sign Up button
                AuthButton(
                  text: AppStrings.signUp,
                  onPressed: _onSignupPressed,
                ),

                const SizedBox(height: 24),

                // Already have account link
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    AppStrings.alreadyHaveAccount,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4CAF50),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // Terms and Conditions
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Text(
                    AppStrings.termsAndConditions,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.5,
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
