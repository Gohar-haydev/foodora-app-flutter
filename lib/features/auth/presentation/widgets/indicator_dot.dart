import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';

/// Indicator dot widget for splash screen
class IndicatorDot extends StatelessWidget {
  final bool active;

  const IndicatorDot({
    super.key,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimensions.spacing8,
      height: AppDimensions.spacing8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? AppColors.primaryText : AppColors.inactiveDot,
      ),
    );
  }
}

