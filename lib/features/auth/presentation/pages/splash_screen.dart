import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'package:provider/provider.dart';
import 'package:foodora/core/utils/token_storage.dart';
import 'package:foodora/core/widgets/widgets.dart';
import 'package:foodora/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:foodora/features/menu/presentation/pages/main_layout.dart';
import 'package:foodora/features/auth/presentation/widgets/widgets.dart';

import 'login_screen.dart';
import 'package:foodora/core/extensions/context_extensions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isCheckingAuth = true; // Track if we're checking authentication

  // Define your onboarding pages data
  List<OnboardingPage> _getPages(BuildContext context) {
    return [
      OnboardingPage(
        image: 'assets/images/splash_bg.png',
        title: context.tr('onboarding_title_1'),
        description: context.tr('onboarding_desc_1'),
      ),
      OnboardingPage(
        image: 'assets/images/splash_bg.png', // Replace with your second image
        title: context.tr('onboarding_title_2'),
        description: context.tr('onboarding_desc_2'),
      ),
      OnboardingPage(
        image: 'assets/images/splash_bg.png', // Replace with your third image
        title: context.tr('onboarding_title_3'),
        description: context.tr('onboarding_desc_3'),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  // Check if user is already authenticated
  Future<void> _checkAuthStatus() async {
    // Check if user has a valid token
    final isAuthenticated = await TokenStorage.isAuthenticated();
    
    if (!mounted) return;
    
    if (isAuthenticated) {
      // User is authenticated with valid token
      // Initialize AuthViewModel to load user data (name)
      await context.read<AuthViewModel>().checkAuthStatus();
      
      if (!mounted) return;
      
      // Navigate to main layout
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainLayout()),
      );
    } else {
      // Check if token exists but is expired
      final token = await TokenStorage.getToken();
      final isTokenValid = await TokenStorage.isTokenValid();
      
      if (!mounted) return;
      
      if (token != null && !isTokenValid) {
        // Token exists but is expired, show session expired dialog
        _showSessionExpiredDialog();
      }
      
      // Check if user has seen onboarding
      final hasSeenOnboarding = await TokenStorage.hasSeenOnboarding();
      if (hasSeenOnboarding) {
        // User has already seen onboarding, navigate to login
        if (mounted) {
           _navigateToLogin();
        }
      } else {
        // Show onboarding carousel
        if (mounted) {
          setState(() {
            _isCheckingAuth = false;
          });
        }
      }
    }
  }

  // Show session expired dialog
  void _showSessionExpiredDialog() {
    context.showError(
      title: context.tr('session_expired'),
      message: context.tr('session_expired_message'),
      buttonText: context.tr('please_login_again'),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToLogin() async {
    await TokenStorage.saveHasSeenOnboarding();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  void _nextPage() {
    final pages = _getPages(context);
    if (_currentPage < pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading screen while checking authentication
    if (_isCheckingAuth) {
      return const SplashLoadingWidget();
    }

    // Show onboarding carousel
    final pages = _getPages(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Layer 1: Full-screen PageView for gestures and images
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: pages.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    // The sliding image part
                    Expanded(
                      flex: 6,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        child: Image.asset(
                          pages[index].image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppColors.grey300,
                              alignment: Alignment.center,
                              child: const Icon(Icons.image, size: 50, color: AppColors.grey),
                            );
                          },
                        ),
                      ),
                    ),
                    // Empty space for the text section to allow gestures to pass if needed
                    // (Actually PageView treats the whole area as slidable)
                    const Expanded(flex: 5, child: SizedBox.shrink()),
                  ],
                );
              },
            ),

            // Layer 2: Static Overlay (Indicators, Text, Buttons)
            Column(
              children: [
                // Top placeholder for images (gestures pass to PageView)
                Expanded(
                  flex: 6,
                  child: Stack(
                    children: [
                      // Page Indicator overlay (Static but reflects state)
                      Positioned(
                        bottom: 30,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                pages.length,
                                (index) => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 3),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    width: 16,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: index == _currentPage 
                                          ? AppColors.primaryAccent 
                                          : AppColors.grey300,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom Section: Static Text and Buttons
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.spacing24),
                    child: Column(
                      children: [
                        // Wrap text in IgnorePointer so swipes here go to the PageView behind it
                        Expanded(
                          child: IgnorePointer(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  pages[_currentPage].title,
                                  style: const TextStyle(
                                    fontSize: AppDimensions.fontSize32,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryText,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: AppDimensions.spacing16),
                                Text(
                                  pages[_currentPage].description,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: AppDimensions.fontSize16,
                                    color: AppColors.grey600,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        // Buttons (Interaction kept)
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _nextPage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.backgroundLight,
                              foregroundColor: AppColors.primaryText,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              _currentPage == pages.length - 1 ? context.tr('get_started') : context.tr('next'),
                              style: const TextStyle(
                                fontSize: AppDimensions.fontSize18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Model class for onboarding pages
class OnboardingPage {
  final String image;
  final String title;
  final String description;

  OnboardingPage({
    required this.image,
    required this.title,
    required this.description,
  });
}
