import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'package:foodora/features/menu/presentation/pages/menu_screen.dart';
import 'package:foodora/features/menu/presentation/widgets/widgets.dart';
import 'package:foodora/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:foodora/features/menu/presentation/viewmodels/menu_viewmodel.dart';
import 'package:foodora/core/widgets/primary_button.dart';
import 'package:foodora/core/extensions/context_extensions.dart';

import '../widgets/branch_card.dart';

class BranchSelectionScreen extends StatefulWidget {
  const BranchSelectionScreen({super.key});

  @override
  State<BranchSelectionScreen> createState() => _BranchSelectionScreenState();
}

class _BranchSelectionScreenState extends State<BranchSelectionScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch branches when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MenuViewModel>().fetchBranches();
    });
  }

  // Get greeting based on current time
  String _getGreeting() {
    final hour = DateTime.now().hour;
    
    if (hour >= 5 && hour < 12) {
      return context.tr('good_morning');
    } else if (hour >= 12 && hour < 17) {
      return context.tr('good_afternoon');
    } else if (hour >= 17 && hour < 21) {
      return context.tr('good_evening');
    } else {
      return context.tr('good_night');
    }
  }

  // Get greeting icon based on current time
  IconData _getGreetingIcon() {
    final hour = DateTime.now().hour;
    
    if (hour >= 5 && hour < 17) {
      return Icons.wb_sunny_outlined;
    } else if (hour >= 17 && hour < 21) {
      return Icons.wb_twilight_outlined;
    } else {
      return Icons.nightlight_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get user name from auth
    final userName = context.watch<AuthViewModel>().userName ?? "Foodie";
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: AppDimensions.getMaxContentWidth(context),
            ),
            child: Column(
              children: [
                // Header Section
                Padding(
                  padding: EdgeInsets.all(
                    AppDimensions.getResponsiveHorizontalPadding(context),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Greeting
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _getGreetingIcon(),
                                size: AppDimensions.responsiveIconSize(context, mobile: 20, tablet: 24),
                                color: Colors.grey[600],
                              ),
                              SizedBox(width: AppDimensions.responsiveSpacing(context, mobile: 8, tablet: 10)),
                              Text(
                                _getGreeting(),
                                style: TextStyle(
                                  fontSize: AppDimensions.getBodySize(context),
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 8, tablet: 10)),
                      
                      // User Name
                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: AppDimensions.getH1Size(context),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      
                      SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 24, tablet: 32)),
                      
                      // Select Branch Title
                      Text(
                        context.tr('select_branch_title'),
                        style: TextStyle(
                          fontSize: AppDimensions.getH1Size(context),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                // Branch List
                Expanded(
                  child: Consumer<MenuViewModel>(
                    builder: (context, viewModel, child) {
                      if (viewModel.isLoading) {
                        return const Center(child: CircularProgressIndicator(color: Color(0xFF4CAF50)));
                      }

                      if (viewModel.error != null) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: AppDimensions.responsiveIconSize(context, mobile: 48, tablet: 60),
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
                              Text(
                                viewModel.error!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: AppDimensions.getBodySize(context),
                                ),
                              ),
                              SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
                              PrimaryButton(
                                text: context.tr('retry'),
                                width: AppDimensions.responsive(context, mobile: 120, tablet: 140),
                                height: AppDimensions.responsive(context, mobile: 40, tablet: 48),
                                onPressed: () => viewModel.fetchBranches(),
                              ),
                            ],
                          ),
                        );
                      }

                      if (viewModel.branches.isEmpty) {
                        return Center(
                          child: Text(
                            context.tr('no_branches_available'),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: AppDimensions.getBodySize(context),
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: EdgeInsets.only(
                          top: AppDimensions.responsiveSpacing(context, mobile: 24, tablet: 32),
                          left: AppDimensions.getResponsiveHorizontalPadding(context),
                          right: AppDimensions.getResponsiveHorizontalPadding(context),
                          bottom: AppDimensions.responsiveSpacing(context, mobile: 50, tablet: 60), // Add bottom padding to avoid cart button overlap
                        ),
                        itemCount: viewModel.branches.length,
                        separatorBuilder: (context, index) => SizedBox(
                          height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20),
                        ),
                        itemBuilder: (context, index) {
                          final branch = viewModel.branches[index];
                          return BranchCard(
                            name: branch.name,
                            address: branch.address,
                            imageUrl: 'assets/images/branch_placeholder.jpg',
                            onSelect: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => MenuScreen(branchId: branch.id),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
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
