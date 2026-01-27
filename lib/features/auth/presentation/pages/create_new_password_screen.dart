import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'package:foodora/core/widgets/custom_text_field.dart';
import 'package:foodora/core/widgets/primary_button.dart';
import 'package:foodora/core/extensions/context_extensions.dart';
import 'package:provider/provider.dart';
import 'package:foodora/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:foodora/features/auth/presentation/pages/password_changed_success_screen.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  final String? email; // Email passed from previous screen
  const CreateNewPasswordScreen({super.key, this.email});

  @override
  State<CreateNewPasswordScreen> createState() => _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final TextEditingController _tokenController = TextEditingController(); // Temp token field
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void dispose() {
    _tokenController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          context.tr('create_new_password_title'),
           style: TextStyle(
            color: AppColors.primaryText,
            fontSize: AppDimensions.getH3Size(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.primaryText,
            size: AppDimensions.responsiveIconSize(context, mobile: 20, tablet: 24),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 40, tablet: 56)),

                Center(
                  child: Text(
                    context.tr('create_new_password_title'),
                    style: TextStyle(
                      fontSize: AppDimensions.getH2Size(context),
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                      height: 1.2,
                    ),
                  ),
                ),

                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),

                Center(
                  child: Text(
                    context.tr('enter_reset_token'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppDimensions.getBodySize(context),
                      color: AppColors.grey,
                      height: 1.5,
                    ),
                  ),
                ),

                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 40, tablet: 56)),

                // Token Field (Temporary/Required by API)
                CustomTextField(
                  controller: _tokenController,
                  hintText: context.tr('reset_token'),
                ),

                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),

                // New Password Field
                CustomTextField(
                  controller: _newPasswordController,
                  obscureText: !_newPasswordVisible,
                  hintText: context.tr('new_password'),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _newPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.grey,
                      size: AppDimensions.responsiveIconSize(context, mobile: 20, tablet: 24),
                    ),
                    onPressed: () {
                      setState(() {
                         _newPasswordVisible = !_newPasswordVisible;
                      });
                    },
                  ),
                ),

                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),

                // Confirm Password Field
                CustomTextField(
                  controller: _confirmPasswordController,
                  obscureText: !_confirmPasswordVisible,
                  hintText: context.tr('confirm_password'),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.grey,
                      size: AppDimensions.responsiveIconSize(context, mobile: 20, tablet: 24),
                    ),
                    onPressed: () {
                      setState(() {
                         _confirmPasswordVisible = !_confirmPasswordVisible;
                      });
                    },
                  ),
                ),

                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 24, tablet: 32)),

                Consumer<AuthViewModel>(
                  builder: (context, viewModel, child) {
                    return PrimaryButton(
                      text: context.tr('reset'),
                      isLoading: viewModel.isLoading,
                      height: AppDimensions.getButtonHeight(context),
                      onPressed: () async {
                        final token = _tokenController.text.trim();
                        final newPass = _newPasswordController.text;
                        final confirmPass = _confirmPasswordController.text;
                        final email = widget.email ?? '';

                        if (token.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
                           ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(context.tr('please_fill_all_fields'))),
                          );
                          return;
                        }

                        if (email.isEmpty) {
                           ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(context.tr('email_not_found'))),
                          );
                          return;
                        }

                        if (newPass != confirmPass) {
                            ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(context.tr('passwords_do_not_match'))),
                          );
                          return;
                        }

                        final success = await viewModel.resetPassword(
                          otp: token,
                          email: email,
                          password: newPass,
                          confirmPassword: confirmPass,
                        );

                        if (!mounted) return;

                        if (success) {
                           ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(context.tr('password_reset_success'))),
                          );
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const PasswordChangedSuccessScreen()),
                          );
                        } else {
                           ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(viewModel.errorMessage ?? context.tr('reset_failed'))),
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
      ),
    );
  }
}
