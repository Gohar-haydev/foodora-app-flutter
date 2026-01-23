import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'package:foodora/core/widgets/widgets.dart';
import 'package:foodora/features/menu/presentation/pages/main_layout.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../widgets/widgets.dart';
import 'package:foodora/core/extensions/context_extensions.dart';

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
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSignupPressed() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final phone = _phoneController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      context.showError(
        title: context.tr('missing_information'),
        message: context.tr('please_fill_all_fields'),
      );
      return;
    }

    if (password != confirmPassword) {
      context.showError(
        title: context.tr('validation_error'),
        message: context.tr('passwords_do_not_match'),
      );
      return;
    }

    // Show loading overlay
    context.showLoading(message: context.tr('creating_account'));

    // Call ViewModel register method
    final success = await context.read<AuthViewModel>().register(
      name: name,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
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
        title: context.tr('registration_failed'),
        message: error ?? context.tr('registration_failed'),
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
                AuthHeader(title: context.tr('sign_up')),

                const SizedBox(height: 40),

                // Create Account heading
                Text(
                  context.tr('create_account'),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 12),

                // Subtitle
                Text(
                  context.tr('sign_up_subtitle'),
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
                      hintText: context.tr('full_name_placeholder'),
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
                      hintText: context.tr('email_address'),
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
                      hintText: context.tr('phone'),
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
                  hintText: context.tr('new_password'),
                  hintTextColor: Colors.black, // Set hint color to black
                ),

                const SizedBox(height: 16),

                // Confirm Password input field
                PasswordTextField(
                  controller: _confirmPasswordController,
                  hintText: context.tr('confirm_password'),
                  hintTextColor: Colors.black, // Set hint color to black
                ),

                const SizedBox(height: 32),

                // Sign Up button
                AuthButton(
                  text: context.tr('sign_up'),
                  onPressed: _onSignupPressed,
                ),

                const SizedBox(height: 10),

                // Already have account link
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    context.tr('already_have_account'),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4CAF50),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // Terms and Conditions
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0,left: 25,right: 25),
                  child: Text(
                    context.tr('terms_and_conditions'),
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
