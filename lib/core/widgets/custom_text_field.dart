import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';

/// Reusable custom text field widget with consistent styling
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    // this.onChanged,
    this.suffixIcon
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      // onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: AppColors.mutedText,
        ),
        filled: true,
        fillColor: AppColors.backgroundLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(AppDimensions.spacing16),
      ),
      style: const TextStyle(
        color: AppColors.primaryText,
        fontSize: AppDimensions.fontSize16,
      ),
    );
  }
}

