import 'package:flutter/material.dart';
import 'package:foodora/features/order/presentation/pages/order_history_screen.dart';
import 'package:foodora/features/auth/presentation/pages/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:foodora/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:foodora/core/constants/app_strings.dart';
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
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () {
        //     // Logic to go back or switch to home tab if at root
        //     final navigator = Navigator.of(context);
        //     if (navigator.canPop()) {
        //       navigator.pop();
        //     } else {
        //       // Assuming MainLayout state logic, but we can't access it easily without a provider or global key.
        //       // For now, standard behavior. If this is a root tab, back button visually exists per requirement.
        //       // We could try specific logic if needed, but let's stick to standard pop first.
        //       // If it does nothing, user might rely on bottom nav.
        //       // Alternatively, find MainLayoutState? No, too complex.
        //       // Just Pop.
        //       Navigator.of(context).maybePop();
        //     }
        //   },
        // ),
        title: Text(
          context.tr('profile_title'),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
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

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Profile Image Section

                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.grey,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFF4CAF50), // Green color
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        viewModel.user?.name ?? context.tr('user'),
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        viewModel.user?.phone ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Form Fields
                AuthTextField(
                  controller: _nameController,
                  hintText: context.tr('full_name'),
                  suffixIcon:
                      const Icon(Icons.edit, color: Colors.grey, size: 20),
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  controller: _emailController,
                  hintText: context.tr('email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  controller: _phoneController,
                  hintText: context.tr('phone'),
                  keyboardType: TextInputType.phone,
                  suffixIcon:
                      const Icon(Icons.edit, color: Colors.grey, size: 20),
                ),
                const SizedBox(height: 16),
                PasswordTextField(
                  controller: _oldPasswordController,
                  hintText: context.tr('old_password'),
                ),
                const SizedBox(height: 16),
                PasswordTextField(
                  controller: _newPasswordController,
                  hintText: context.tr('new_password'),
                ),
                const SizedBox(height: 16),
                PasswordTextField(
                  controller: _confirmPasswordController,
                  hintText: context.tr('confirm_password'),
                ),

                const SizedBox(height: 32),

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

                const SizedBox(height: 16),

                // Order History Link
                // ListTile(
                //   contentPadding: EdgeInsets.zero,
                //   leading: const Icon(Icons.history, color: Colors.black),
                //   title: const Text(
                //     AppStrings.orderHistory,
                //     style: TextStyle(
                //       fontSize: 16,
                //       fontWeight: FontWeight.w500,
                //       color: Colors.black,
                //     ),
                //   ),
                //   trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                //   onTap: () {
                //     // Navigate to Order History
                //     Navigator.of(context).push(
                //       MaterialPageRoute(
                //         builder: (context) => const OrderHistoryScreen(),
                //       ),
                //     );
                //   },
                // ),
                // const Divider(), // Visual separator
                // const SizedBox(height: 16),

                // Logout Button
                // LogoutButton(
                //   text: AppStrings.logoutButton,
                //   onPressed: () async {
                //     // Show confirmation dialog
                //     final shouldLogout = await showDialog<bool>(
                //       context: context,
                //       builder: (context) => AlertDialog(
                //         title: const Text(AppStrings.logoutConfirmTitle),
                //         content: const Text(AppStrings.logoutConfirmMessage),
                //         actions: [
                //           TextButton(
                //             onPressed: () => Navigator.of(context).pop(false),
                //             child: const Text(AppStrings.cancel),
                //           ),
                //           TextButton(
                //             onPressed: () => Navigator.of(context).pop(true),
                //             child: const Text(
                //               AppStrings.logout,
                //               style: TextStyle(color: Colors.red),
                //             ),
                //           ),
                //         ],
                //       ),
                //     );
                //
                //     if (shouldLogout == true) {
                //       await viewModel.logout();
                //       if (!context.mounted) return;
                //
                //       // Navigate to login screen and clear navigation stack
                //       Navigator.of(context).pushAndRemoveUntil(
                //         MaterialPageRoute(
                //           builder: (context) => const LoginScreen(),
                //         ),
                //         (route) => false,
                //       );
                //     }
                //   },
                // ),

                // Bottom padding for scrolling comfort
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
