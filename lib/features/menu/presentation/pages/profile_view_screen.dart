import 'package:flutter/material.dart';
import 'package:foodora/features/order/presentation/pages/order_history_screen.dart';
import 'package:foodora/features/auth/presentation/pages/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:foodora/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:foodora/core/constants/app_strings.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'package:foodora/core/widgets/widgets.dart';
import 'package:foodora/features/auth/presentation/widgets/widgets.dart';
import 'package:foodora/core/extensions/context_extensions.dart';


class ProfileViewScreen extends StatefulWidget {
  const ProfileViewScreen({super.key});

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();

    // Initialize with existing data if available
    final authViewModel = context.read<AuthViewModel>();
    if (authViewModel.user != null) {
      _nameController.text = authViewModel.user!.name;
      _emailController.text = authViewModel.user!.email;
      _phoneController.text = authViewModel.user!.phone;
    }

    // Fetch profile and populate
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authViewModel.fetchUserProfile().then((_) {
        // Update controllers if fetch succeeded and user didn't start typing significantly (simple overwrite for now)
        if (mounted && authViewModel.user != null) {
          // We can check if controllers are empty to avoid overwriting user input,
          // but normally profile fetch is fast and initial.
          // For safety, let's overwrite to ensure fresh data.
          _nameController.text = authViewModel.user!.name;
          _emailController.text = authViewModel.user!.email;
          _phoneController.text = authViewModel.user!.phone;
        }
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          context.tr('profile_title'),
          style: TextStyle(
            color: Colors.black,
            fontSize: AppDimensions.getH3Size(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<AuthViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(
                child: CircularProgressIndicator(color: Color(0xFF4CAF50)));
          }

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: AppDimensions.getMaxContentWidth(context),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(
                  AppDimensions.getResponsiveHorizontalPadding(context),
                ),
                child: Column(
                  children: [
                    // Profile Image Section

                    Center(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: AppDimensions.responsive(context, mobile: 100, tablet: 120),
                                height: AppDimensions.responsive(context, mobile: 100, tablet: 120),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.person,
                                  size: AppDimensions.responsiveIconSize(context, mobile: 60, tablet: 72),
                                  color: Colors.grey,
                                ),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  padding: EdgeInsets.all(
                                    AppDimensions.responsiveSpacing(context, mobile: 4, tablet: 6),
                                  ),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF4CAF50), // Green color
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: AppDimensions.responsiveIconSize(context, mobile: 16, tablet: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
                          Text(
                            viewModel.user?.name ?? context.tr('user'),
                            style: TextStyle(
                              fontSize: AppDimensions.getH2Size(context),
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            viewModel.user?.phone ?? '',
                            style: TextStyle(
                              fontSize: AppDimensions.getSmallSize(context),
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 32, tablet: 40)),

                    // Form Fields
                    AuthTextField(
                      controller: _nameController,
                      hintText: context.tr('full_name'),
                      suffixIcon: Icon(
                        Icons.edit,
                        color: Colors.grey,
                        size: AppDimensions.responsiveIconSize(context, mobile: 20, tablet: 24),
                      ),
                    ),
                    SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
                    AuthTextField(
                      controller: _emailController,
                      hintText: context.tr('email'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
                    AuthTextField(
                      controller: _phoneController,
                      hintText: context.tr('phone'),
                      keyboardType: TextInputType.phone,
                      suffixIcon: Icon(
                        Icons.edit,
                        color: Colors.grey,
                        size: AppDimensions.responsiveIconSize(context, mobile: 20, tablet: 24),
                      ),
                    ),
                    SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
                    PasswordTextField(
                      controller: _oldPasswordController,
                      hintText: context.tr('old_password'),
                    ),
                    SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
                    PasswordTextField(
                      controller: _newPasswordController,
                      hintText: context.tr('new_password'),
                    ),
                    SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
                    PasswordTextField(
                      controller: _confirmPasswordController,
                      hintText: context.tr('confirm_password'),
                    ),

                    SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 32, tablet: 40)),

                    // Save Button
                    PrimaryButton(
                      text: context.tr('save'),
                      isLoading: viewModel.isLoading,
                      onPressed: () async {
                        final name = _nameController.text.trim();
                        final phone = _phoneController.text.trim();

                        final currentPassword = _oldPasswordController.text;
                        final newPassword = _newPasswordController.text;
                        final confirmPassword = _confirmPasswordController.text;

                        bool profileSuccess = true;
                        bool passwordSuccess = true;

                        // 1. Update Profile if needed
                        if (name.isNotEmpty && phone.isNotEmpty) {
                          profileSuccess = await viewModel.updateProfile(
                              name: name, phone: phone);
                        }

                        // 2. Update Password if fields are filled
                        if (currentPassword.isNotEmpty ||
                            newPassword.isNotEmpty ||
                            confirmPassword.isNotEmpty) {
                          if (newPassword != confirmPassword) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(context.tr('passwords_do_not_match'))),
                            );
                            return;
                          }

                          if (currentPassword.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(context.tr('enter_current_password'))),
                            );
                            return;
                          }

                          passwordSuccess = await viewModel.updatePassword(
                            currentPassword: currentPassword,
                            newPassword: newPassword,
                            confirmPassword: confirmPassword,
                          );
                        }

                        // 3. Feedback
                        if (profileSuccess && passwordSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(context.tr('profile_updated_success'))),
                          );
                          // Clear password fields on success
                          _oldPasswordController.clear();
                          _newPasswordController.clear();
                          _confirmPasswordController.clear();
                        } else if (viewModel.errorMessage != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(viewModel.errorMessage!)),
                          );
                        }
                      },
                    ),

                    // Bottom padding for scrolling comfort
                    SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 24, tablet: 32)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
