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

  Widget _buildValidatedTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
  }) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        return AuthTextField(
          controller: controller,
          hintText: hintText,
          keyboardType: keyboardType,
          suffixIcon: value.text.isNotEmpty
              ? Icon(
                  Icons.check,
                  color: AppColors.orange,
                  size: AppDimensions.responsiveIconSize(context, mobile: 20, tablet: 24),
                )
              : null,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: AppDimensions.getMaxContentWidth(context),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.getResponsiveHorizontalPadding(context),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 24)),

                // Header with back button and "SIGN UP" title
                AuthHeader(title: context.tr('sign_up')),

                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 40, tablet: 56)),

                // Create Account heading
                Text(
                  context.tr('create_account'),
                  style: TextStyle(
                    fontSize: AppDimensions.getH1Size(context),
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),

                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 12, tablet: 16)),

                // Subtitle
                Text(
                  context.tr('sign_up_subtitle'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppDimensions.getBodySize(context),
                    color: AppColors.grey600,
                    height: 1.5,
                  ),
                ),

                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 40, tablet: 56)),

                // Full Name input field
                _buildValidatedTextField(
                  controller: _nameController,
                  hintText: context.tr('full_name_placeholder'),
                ),

                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),

                // Email input field
                _buildValidatedTextField(
                  controller: _emailController,
                  hintText: context.tr('email_address'),
                  keyboardType: TextInputType.emailAddress,
                ),

                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),

                // Phone input field
                _buildValidatedTextField(
                  controller: _phoneController,
                  hintText: context.tr('phone'),
                  keyboardType: TextInputType.phone,
                ),

                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),

                // Password input field with visibility toggle
                PasswordTextField(
                  controller: _passwordController,
                  hintText: context.tr('new_password'),
                  hintTextColor: AppColors.primaryText,
                ),

                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),

                // Confirm Password input field
                PasswordTextField(
                  controller: _confirmPasswordController,
                  hintText: context.tr('confirm_password'),
                  hintTextColor: AppColors.primaryText,
                ),

                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 32, tablet: 40)),

                // Sign Up button
                AuthButton(
                  text: context.tr('sign_up'),
                  onPressed: _onSignupPressed,
                ),

                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 10, tablet: 16)),

                // Already have account link
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    context.tr('already_have_account'),
                    style: TextStyle(
                      fontSize: AppDimensions.getBodySize(context),
                      color: AppColors.primaryAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 15, tablet: 20)),

                // Terms and Conditions
                Padding(
                  padding: EdgeInsets.only(
                    bottom: AppDimensions.responsiveSpacing(context, mobile: 24, tablet: 32),
                    left: AppDimensions.responsiveSpacing(context, mobile: 25, tablet: 40),
                    right: AppDimensions.responsiveSpacing(context, mobile: 25, tablet: 40),
                  ),
                  child: Text(
                    context.tr('terms_and_conditions'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppDimensions.getSmallSize(context),
                      color: AppColors.grey600,
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
