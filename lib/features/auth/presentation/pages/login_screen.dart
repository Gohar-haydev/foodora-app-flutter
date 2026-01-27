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
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: AppDimensions.getMaxContentWidth(context),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.getResponsiveHorizontalPadding(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 24)),
                  // Header with back button and title
                  AuthHeader(
                    title: context.tr('sign_in'),
                    showBackButton: false,
                  ),
                  SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 40, tablet: 56)),
                  // Welcome back heading
                  Center(
                    child: Text(
                      context.tr('welcome_back'),
                      style: TextStyle(
                        fontSize: AppDimensions.getH1Size(context),
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ),
                  SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 40, tablet: 56)),
                  // Email input field
                  AuthTextField(
                    controller: _emailController,
                    hintText: context.tr('email_address'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
                  // Password input field with visibility toggle
                  PasswordTextField(
                    controller: _passwordController,
                    hintText: context.tr('password_placeholder'),
                  ),
                  SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 8, tablet: 12)),
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
                        style: TextStyle(
                          fontSize: AppDimensions.getBodySize(context),
                          color: AppColors.primaryText,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 24, tablet: 32)),
                  // Sign In button
                  AuthButton(
                    text: context.tr('sign_in'),
                    onPressed: _onLoginPressed,
                  ),
                  SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
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
        ),
      ),
    );
  }
}
