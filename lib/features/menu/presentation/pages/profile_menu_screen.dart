import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'package:foodora/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:foodora/features/auth/presentation/pages/login_screen.dart';
import 'package:foodora/features/menu/presentation/pages/profile_view_screen.dart';
import 'package:foodora/features/order/presentation/pages/order_history_screen.dart';

import 'package:foodora/features/menu/presentation/widgets/widgets.dart';
import '../../../../core/widgets/logout_button.dart';
import 'package:foodora/features/menu/presentation/pages/branch_selection_screen.dart';
import 'package:foodora/features/menu/presentation/pages/language_selection_screen.dart';
import 'package:foodora/features/menu/presentation/pages/currency_selection_screen.dart';
import 'package:foodora/core/extensions/context_extensions.dart';

class ProfileMenuScreen extends StatelessWidget {
  const ProfileMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          context.tr('profile'),
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: AppDimensions.getH3Size(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: AppDimensions.getMaxContentWidth(context),
          ),
          child: Padding(
            padding: EdgeInsets.all(
              AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.responsiveSpacing(context, mobile: 20, tablet: 28),
                      vertical: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20),
                    ),
                    children: [
                      // Profile Menu Item
                      ProfileMenuItem(
                        imagePath: 'assets/images/user.png',
                        iconColor: AppColors.primaryAccent,
                        iconBackground: AppColors.successLight,
                        title: context.tr('profile'),
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
                        color: AppColors.divider,
                      ),
                      // Orders Menu Item
                      ProfileMenuItem(
                        imagePath: 'assets/images/order.png',
                        iconColor: AppColors.primaryAccent,
                        iconBackground: AppColors.successLight,
                        title: context.tr('orders'),
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
                        color: AppColors.divider,
                      ),
                      // Change Branch Menu Item
                      ProfileMenuItem(
                        icon: Icons.store_outlined,
                        iconColor: AppColors.primaryAccent,
                        iconBackground: AppColors.successLight,
                        title: context.tr('change_branch'),
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
                        color: AppColors.divider,
                      ),
                      
                      // Language Menu Item
                      ProfileMenuItem(
                        icon: Icons.language,
                        iconColor: AppColors.primaryAccent,
                        iconBackground: AppColors.successLight,
                        title: context.tr('language'),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const LanguageSelectionScreen(),
                            ),
                          );
                        },
                      ),

                      // Divider after Language
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.divider,
                      ),

                      // Currency Menu Item
                      ProfileMenuItem(
                        icon: Icons.attach_money,
                        iconColor: AppColors.primaryAccent,
                        iconBackground: AppColors.successLight,
                        title: context.tr('currency'),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const CurrencySelectionScreen(),
                            ),
                          );
                        },
                      ),

                      // Divider after Currency
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.divider,
                      ),

                      // Delete Account Menu Item
                      ProfileMenuItem(
                        icon: Icons.delete_outline,
                        iconColor: AppColors.error,
                        iconBackground: AppColors.errorLight,
                        title: context.tr('delete_account'),
                        onTap: () async {
                          final shouldDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                context.tr('delete_account_confirm_title'),
                                style: TextStyle(
                                  fontSize: AppDimensions.getH3Size(context),
                                ),
                              ),
                              content: Text(
                                context.tr('delete_account_confirm_message'),
                                style: TextStyle(
                                  fontSize: AppDimensions.getBodySize(context),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: Text(context.tr('cancel')),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: Text(
                                    context.tr('delete_account'),
                                    style: const TextStyle(color: AppColors.error),
                                  ),
                                ),
                              ],
                            ),
                          );

                          if (shouldDelete == true && context.mounted) {
                            // TODO: Implement actual delete account API call
                            await context.read<AuthViewModel>().logout();
                            if (context.mounted) {
                              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                                (route) => false,
                              );
                            }
                          }
                        },
                      ),
                      
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.divider,
                      ),
                  ]),
                ),
                // Logout Button
                LogoutButton(
                  text: context.tr('logout_button'),
                  onPressed: () async {
                    // Show confirmation dialog
                    final shouldLogout = await showDialog<bool>(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: Text(
                          context.tr('logout_confirm_title'),
                          style: TextStyle(
                            fontSize: AppDimensions.getH3Size(context),
                          ),
                        ),
                        content: Text(
                          context.tr('logout_confirm_message'),
                          style: TextStyle(
                            fontSize: AppDimensions.getBodySize(context),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(dialogContext).pop(false),
                            child: Text(context.tr('cancel')),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(dialogContext).pop(true),
                            child: Text(
                              context.tr('logout'),
                              style: const TextStyle(color: AppColors.error),
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
                  height: AppDimensions.responsiveSpacing(context, mobile: 25, tablet: 32),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
