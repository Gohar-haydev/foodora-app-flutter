import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'package:foodora/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:foodora/features/auth/presentation/pages/login_screen.dart';
import 'package:foodora/features/menu/presentation/pages/profile_view_screen.dart';
import 'package:foodora/features/order/presentation/pages/order_history_screen.dart';
import 'package:foodora/features/auth/presentation/viewmodels/auth_viewmodel.dart';

import '../../../../core/widgets/logout_button.dart';

class ProfileMenuScreen extends StatelessWidget {
  const ProfileMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Profile',
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
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                // Profile Menu Item
                _ProfileMenuItem(
                  icon: Icons.person_outline,
                  iconColor: const Color(0xFF4CAF50),
                  iconBackground: const Color(0xFFE8F5E9),
                  title: 'Profile',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ProfileViewScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),

                // Orders Menu Item
                _ProfileMenuItem(
                  icon: Icons.shopping_bag_outlined,
                  iconColor: const Color(0xFF4CAF50),
                  iconBackground: const Color(0xFFE8F5E9),
                  title: 'Orders',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const OrderHistoryScreen(),
                      ),
                    );
                  },
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
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (route) => false,
                );
              }
            },
          ),
          SizedBox(height: 25,)
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}
