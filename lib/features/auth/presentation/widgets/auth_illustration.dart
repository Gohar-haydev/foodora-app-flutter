import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';

/// Auth illustration widget for login/signup screens
class AuthIllustration extends StatelessWidget {
  final IconData icon;
  final double? height;

  const AuthIllustration({
    super.key,
    this.icon = Icons.restaurant_menu,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final illustrationHeight = height ?? (screenWidth * (320 / 390));

    return Container(
      width: double.infinity,
      height: illustrationHeight,
      decoration: const BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.zero,
      ),
      child: Center(
        child: Icon(
          icon,
          size: AppDimensions.iconSize80,
          color: AppColors.mutedText,
        ),
      ),
    );
  }
}

