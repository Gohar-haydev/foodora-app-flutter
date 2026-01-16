import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';

/// Reusable section title widget
class SectionTitle extends StatelessWidget {
  final String text;
  final EdgeInsets? padding;
  final TextAlign textAlign;

  const SectionTitle({
    super.key,
    required this.text,
    this.padding,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = AppDimensions.getResponsiveHorizontalPadding(context);
    final titleFontSize = AppDimensions.getResponsiveFontSize(
      context,
      AppDimensions.fontSize28,
      AppDimensions.fontSize28 * 1.1,
    );
    final defaultPadding = EdgeInsets.fromLTRB(
      horizontalPadding,
      AppDimensions.spacing20,
      horizontalPadding,
      AppDimensions.spacing12,
    );

    return Padding(
      padding: padding ?? defaultPadding,
      child: Text(
        text,
        textAlign: textAlign,
        style: TextStyle(
          color: AppColors.primaryText,
          fontSize: titleFontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

