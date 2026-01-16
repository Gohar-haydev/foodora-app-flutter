import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'package:provider/provider.dart';
import 'package:foodora/core/utils/token_storage.dart';
import 'package:foodora/core/widgets/widgets.dart';
import 'package:foodora/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:foodora/features/menu/presentation/pages/main_layout.dart';

import 'login_screen.dart';

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
  final List<OnboardingPage> _pages = [
    OnboardingPage(
      image: 'assets/images/splash_bg.png',
      title: 'Foodora',
      description:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard',
    ),
    OnboardingPage(
      image: 'assets/images/splash_bg.png', // Replace with your second image
      title: 'Fast Delivery',
      description:
          'Get your favorite food delivered to your doorstep in minutes. Fresh and hot, just the way you like it.',
    ),
    OnboardingPage(
      image: 'assets/images/splash_bg.png', // Replace with your third image
      title: 'Easy Payment',
      description:
          'Multiple payment options available. Pay with cash, card, or digital wallets. Safe and secure transactions.',
    ),
  ];

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
      title: AppStrings.sessionExpired,
      message: AppStrings.sessionExpiredMessage,
      buttonText: AppStrings.pleaseLoginAgain,
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
    if (_currentPage < _pages.length - 1) {
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
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Foodora',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4CAF50),
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(height: 24),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
              ),
            ],
          ),
        ),
      );
    }

    // Show onboarding carousel
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),

            // Bottom button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: SizedBox(
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
                    _currentPage == _pages.length - 1 ? 'Get started' : 'Next',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Column(
      children: [
        // Top Section: Image with visual appeal
        Expanded(
          flex: 6,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Image.asset(
                  page.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      alignment: Alignment.center,
                      child: const Icon(Icons.image, size: 50, color: Colors.grey),
                    );
                  },
                ),
              ),
              // Page Indicator overlay
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        _pages.length,
                        (index) => _buildIndicatorDot(isActive: index == _currentPage),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Bottom Section: Content
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  page.title,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  page.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIndicatorDot({required bool isActive}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: 16,
      height: 6,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF4CAF50) : Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
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


