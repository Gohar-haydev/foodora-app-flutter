import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'package:foodora/features/menu/presentation/pages/menu_screen.dart';
import 'package:foodora/features/menu/presentation/widgets/widgets.dart';
import 'package:foodora/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:foodora/features/menu/presentation/viewmodels/menu_viewmodel.dart';
import 'package:foodora/core/constants/app_strings.dart';
import 'package:foodora/core/widgets/primary_button.dart';
import 'package:foodora/features/auth/presentation/pages/login_screen.dart';

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
      return AppStrings.goodMorning;
    } else if (hour >= 12 && hour < 17) {
      return AppStrings.goodAfternoon;
    } else if (hour >= 17 && hour < 21) {
      return AppStrings.goodEvening;
    } else {
      return AppStrings.goodNight;
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
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.all(24.0),
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
                            size: 20,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _getGreeting(),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // User Name
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Select Branch Title
                  const Text(
                    AppStrings.selectBranchTitle,
                    style: TextStyle(
                      fontSize: 30,
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
                          Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            viewModel.error!,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 16),
                          PrimaryButton(
                            text: AppStrings.retry,
                            width: 120,
                            height: 40,
                            onPressed: () => viewModel.fetchBranches(),
                          ),
                        ],
                      ),
                    );
                  }

                  if (viewModel.branches.isEmpty) {
                    return Center(
                      child: Text(
                        AppStrings.noBranchesAvailable,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.only(
                      top: 24.0,
                      left: 24.0,
                      right: 24.0,
                      bottom: 50.0, // Add bottom padding to avoid cart button overlap
                    ),
                    itemCount: viewModel.branches.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
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
    );
  }
}
