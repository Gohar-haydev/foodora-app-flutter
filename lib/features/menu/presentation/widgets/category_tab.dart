import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';

/// Category tab widget for menu filtering
class CategoryTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryTab({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacing16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.primaryText : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.primaryText : AppColors.mutedText,
            fontSize: AppDimensions.fontSize14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.21,
          ),
        ),
      ),
    );
  }
}

