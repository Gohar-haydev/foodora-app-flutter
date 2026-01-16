import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'nav_item.dart';

/// Bottom navigation bar widget
class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final List<NavItemData> items;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = AppDimensions.getResponsiveHorizontalPadding(context);

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.backgroundLight,
            width: 1,
          ),
        ),
        color: AppColors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              AppDimensions.spacing8,
              horizontalPadding,
              AppDimensions.spacing12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return Expanded(
                  child: NavItem(
                    icon: item.icon,
                    label: item.label,
                    isSelected: selectedIndex == index,
                    onTap: () => onItemTapped(index),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

/// Data class for navigation items
class NavItemData {
  final IconData icon;
  final String label;

  const NavItemData({
    required this.icon,
    required this.label,
  });
}

