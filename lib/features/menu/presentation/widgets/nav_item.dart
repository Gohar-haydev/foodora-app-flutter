import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';

/// Navigation item widget for bottom navigation
class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primaryText : AppColors.mutedText;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.borderRadius24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: AppDimensions.spacing32,
            child: Icon(
              icon,
              color: color,
              size: AppDimensions.iconSize24,
            ),
          ),
          SizedBox(height: AppDimensions.spacing4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: AppDimensions.fontSize12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.18,
            ),
          ),
        ],
      ),
    );
  }
}

