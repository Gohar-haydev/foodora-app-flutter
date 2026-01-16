import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';

/// Reusable app header widget
class AppHeader extends StatelessWidget {
  final String title;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsets? padding;

  const AppHeader({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = AppDimensions.getResponsiveHorizontalPadding(context);
    final defaultPadding = EdgeInsets.fromLTRB(
      horizontalPadding,
      AppDimensions.spacing16,
      horizontalPadding,
      AppDimensions.spacing8,
    );

    return Padding(
      padding: padding ?? defaultPadding,
      child: Row(
        children: [
          leading ?? SizedBox(width: AppDimensions.spacing48),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.primaryText,
                fontSize: AppDimensions.fontSize18,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.27,
              ),
            ),
          ),
          trailing ?? SizedBox(width: AppDimensions.spacing48),
        ],
      ),
    );
  }
}

