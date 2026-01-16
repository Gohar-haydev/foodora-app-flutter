import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';

/// Hero banner widget for menu screen
class HeroBanner extends StatelessWidget {
  final String imageUrl;
  final EdgeInsets? margin;

  const HeroBanner({
    super.key,
    required this.imageUrl,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = AppDimensions.getResponsiveHorizontalPadding(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= AppDimensions.tabletBreakpoint;
    final heroImageHeight = isTablet
        ? AppDimensions.heroImageHeight * 1.3
        : AppDimensions.heroImageHeight;

    final defaultMargin = EdgeInsets.symmetric(
      horizontal: horizontalPadding,
      vertical: AppDimensions.spacing12,
    );

    return Container(
      margin: margin ?? defaultMargin,
      height: heroImageHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius8),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

