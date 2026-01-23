import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'package:foodora/features/menu/presentation/pages/branch_selection_screen.dart';
import 'package:foodora/features/menu/presentation/pages/profile_menu_screen.dart';
import 'package:foodora/features/menu/presentation/pages/search_screen.dart';
import 'package:foodora/features/menu/presentation/pages/notification_screen.dart';
import 'package:foodora/features/menu/presentation/widgets/widgets.dart';


import 'package:foodora/features/cart/presentation/pages/cart_screen.dart';
import 'package:foodora/core/extensions/context_extensions.dart';

import '../widgets/bottom_nav_clipper.dart';
import '../widgets/bottom_nav_item.dart';

class MainLayout extends StatefulWidget {
  final int initialIndex;

  const MainLayout({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int _currentIndex;
  
  // Keys for each tab's navigator
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabTapped(int index) {
    if (_currentIndex == index) {
      // If tapping the same tab, pop to root of that tab
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  // Helper function to build a navigator for a tab
  Widget _buildTabNavigator(int index, Widget child) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        
        final NavigatorState? currentNavigator = _navigatorKeys[_currentIndex].currentState;
        if (currentNavigator != null && currentNavigator.canPop()) {
          currentNavigator.pop();
        } else if (_currentIndex != 0) {
          // If not in home tab and can't pop anymore, switch to home tab
          setState(() {
            _currentIndex = 0;
          });
        }
      },
      child: Scaffold(

        body: IndexedStack(
          index: _currentIndex,
          children: [
            _buildTabNavigator(0, const BranchSelectionScreen()),
            _buildTabNavigator(1, const SearchScreen()),
            _buildTabNavigator(2, const CartScreen()),
            _buildTabNavigator(3, const NotificationScreen()),
            _buildTabNavigator(4, const ProfileMenuScreen()),
          ],
        ),
        floatingActionButton: SizedBox(
          width: 70, // Slightly larger to accommodate text if needed, or standard 56
          height: 70,
          child: FloatingActionButton(
            onPressed: () => _onTabTapped(2),
            backgroundColor: const Color(0xFF1E3A2E), // Dark green
            shape: const CircleBorder(),
            elevation: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                  size: _currentIndex == 2 ? 26 : 24,
                ),
                const SizedBox(height: 2),
                Text(
                  context.tr('cart'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: _currentIndex == 2 ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8.0,
          color: const Color(0xFF4CAF50), // Green background
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            height: 70, // Adjusted height
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                 BottomNavItem(
                    imagePath: 'assets/images/home.png',
                    label: context.tr('home'),
                    isActive: _currentIndex == 0,
                    onTap: () => _onTabTapped(0),
                  ),
                  BottomNavItem(
                    imagePath: 'assets/images/search.png',
                    label: context.tr('search'),
                    isActive: _currentIndex == 1,
                    onTap: () => _onTabTapped(1),
                  ),
                  const SizedBox(width: 48), // Gap for FAB
                  BottomNavItem(
                    imagePath: 'assets/images/notification.png',
                    label: context.tr('notification'),
                    isActive: _currentIndex == 3,
                    onTap: () => _onTabTapped(3),
                  ),
                  BottomNavItem(
                    imagePath: 'assets/images/profile.png',
                    label: context.tr('profile'),
                    isActive: _currentIndex == 4,
                    onTap: () => _onTabTapped(4),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final IconData? icon;
  final String? imagePath;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const BottomNavItem({
    Key? key,
    this.icon,
    this.imagePath,
    required this.label,
    required this.isActive,
    required this.onTap,
  }) : assert(icon != null || imagePath != null, 'Either icon or imagePath must be provided'),
       super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagePath != null)
              Image.asset(
                imagePath!,
                width: 24,
                height: 24,
                color: isActive ? Colors.white : Colors.white.withOpacity(0.6),
              )
            else
              Icon(
                icon,
                color: isActive ? Colors.white : Colors.white.withOpacity(0.6),
                size: 24,
              ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white.withOpacity(0.6),
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
