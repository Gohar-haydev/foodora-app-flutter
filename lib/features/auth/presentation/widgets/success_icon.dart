import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';

/// Circular success icon widget with a checkmark
class SuccessIcon extends StatelessWidget {
  final double size;
  final double iconSize;

  const SuccessIcon({
    super.key,
    this.size = 100,
    this.iconSize = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.primaryAccent,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.check,
        color: AppColors.white,
        size: iconSize,
      ),
    );
  }
}
