import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'package:foodora/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:foodora/features/auth/presentation/pages/login_screen.dart';
import 'package:foodora/features/menu/presentation/pages/profile_view_screen.dart';
import 'package:foodora/features/order/presentation/pages/order_history_screen.dart';
import 'package:foodora/features/auth/presentation/viewmodels/auth_viewmodel.dart';

import 'package:foodora/features/menu/presentation/widgets/widgets.dart';
import '../../../../core/widgets/logout_button.dart';
import 'package:foodora/features/menu/presentation/pages/branch_selection_screen.dart';

class ProfileMenuScreen extends StatelessWidget {
  const ProfileMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          AppStrings.profile,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                children: [
                  // Profile Menu Item
                  ProfileMenuItem(
                    imagePath: 'assets/images/user.png',
                    iconColor: const Color(0xFF4CAF50),
                    iconBackground: const Color(0xFFE8F5E9),
                    title: AppStrings.profile,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ProfileViewScreen(),
                        ),
                      );
                    },
                  ),

                  // Divider after Profile
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0XFFD8D8D8),
                  ),
                  // Orders Menu Item
                  ProfileMenuItem(
                    imagePath: 'assets/images/order.png',
                    iconColor: const Color(0xFF4CAF50),
                    iconBackground: const Color(0xFFE8F5E9),
                    title: AppStrings.orders,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const OrderHistoryScreen(),
                        ),
                      );
                    },
                  ),

                  // Divider after Orders
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0XFFD8D8D8),
                  ),
                  // Change Branch Menu Item
                  ProfileMenuItem(
                    icon: Icons.store_outlined,
                    iconColor: const Color(0xFF4CAF50),
                    iconBackground: const Color(0xFFE8F5E9),
                    title: AppStrings.changeBranch,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const BranchSelectionScreen(),
                        ),
                      );
                    },
                  ),

                  // Divider after Change Branch
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0XFFD8D8D8),
                  ),
                ],
              ),
            ),

            // Logout Button at Bottom
            // Padding(
            //   padding: const EdgeInsets.all(20.0),
            //   child: SizedBox(
            //     width: double.infinity,
            //     height: 56,
            //     child: ElevatedButton.icon(
            //       onPressed: () async {
            //         // Show confirmation dialog
            //         final shouldLogout = await showDialog<bool>(
            //           context: context,
            //           builder: (context) => AlertDialog(
            //             title: const Text('Logout'),
            //             content: const Text('Are you sure you want to logout?'),
            //             actions: [
            //               TextButton(
            //                 onPressed: () => Navigator.pop(context, false),
            //                 child: const Text('Cancel'),
            //               ),
            //               TextButton(
            //                 onPressed: () => Navigator.pop(context, true),
            //                 child: const Text(
            //                   'Logout',
            //                   style: TextStyle(color: Colors.red),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         );
            //
            //         if (shouldLogout == true && context.mounted) {
            //           await context.read<AuthViewModel>().logout();
            //           if (context.mounted) {
            //             Navigator.of(context).pushAndRemoveUntil(
            //               MaterialPageRoute(
            //                 builder: (_) => const LoginScreen(),
            //               ),
            //               (route) => false,
            //             );
            //           }
            //         }
            //       },
            //       icon: const Icon(Icons.logout, size: 20),
            //       label: const Text(
            //         'LOGOUT',
            //         style: TextStyle(
            //           fontSize: 16,
            //           fontWeight: FontWeight.bold,
            //           letterSpacing: 1.2,
            //         ),
            //       ),
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: const Color(0xFF8B3A3A),
            //         foregroundColor: Colors.white,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(28),
            //         ),
            //         elevation: 2,
            //       ),
            //     ),
            //   ),
            // ),
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
            LogoutButton(
              text: AppStrings.logoutButton,
              onPressed: () async {
                // Show confirmation dialog
                final shouldLogout = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text(AppStrings.logoutConfirmTitle),
                    content: const Text(AppStrings.logoutConfirmMessage),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text(AppStrings.cancel),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text(
                          AppStrings.logout,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );

                if (shouldLogout == true) {
                  await context.read<AuthViewModel>().logout();
                  if (!context.mounted) return;

                  // Navigate to login screen and clear navigation stack
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                }
              },
            ),
            SizedBox(
              height: 25,
            )
          ],
        ),
      ),
    );
  }
}
