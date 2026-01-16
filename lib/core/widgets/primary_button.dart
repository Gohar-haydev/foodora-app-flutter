import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';

/// Primary button widget with consistent styling
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double? height;
  final bool showBorder;
  final Color? borderColor;
  final double? borderWidth;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
    this.showBorder = true,
    this.borderColor,
    this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? AppDimensions.buttonHeight48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryAccent,
          foregroundColor: AppColors.backgroundLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: showBorder
                ? BorderSide(
              color: borderColor ?? AppColors.backgroundLight,
              width: borderWidth ?? 1.5,
            )
                : BorderSide.none,
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
          width: AppDimensions.iconSize24,
          height: AppDimensions.iconSize24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.backgroundLight,
          ),
        )
            : Text(
          text,
          style: const TextStyle(
            fontSize: AppDimensions.fontSize16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}