import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';

/// Reusable widget for auth screen bottom links like "Don't have account?" or "Already have account?"
class AuthBottomLink extends StatelessWidget {
  final String prefixText;
  final String linkText;
  final VoidCallback onPressed;

  const AuthBottomLink({
    super.key,
    required this.prefixText,
    required this.linkText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacing24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            prefixText,
            style: const TextStyle(
              fontSize: AppDimensions.fontSize14,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(width: 3),
          TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              linkText,
              style: const TextStyle(
                fontSize: AppDimensions.fontSize14,
                color: AppColors.primaryAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
