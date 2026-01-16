import 'package:flutter/material.dart';

/// Application dimension constants for responsive design
class AppDimensions {
  // Spacing
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing48 = 48.0;
  static const double spacing60 = 60.0;
  static const double spacing100 = 100.0;

  // Border Radius
  static const double borderRadius8 = 8.0;
  static const double borderRadius24 = 24.0;

  // Icon Sizes
  static const double iconSize16 = 16.0;
  static const double iconSize24 = 24.0;
  static const double iconSize80 = 80.0;

  // Button Heights
  static const double buttonHeight40 = 40.0;
  static const double buttonHeight48 = 48.0;

  // Text Sizes
  static const double fontSize12 = 12.0;
  static const double fontSize14 = 14.0;
  static const double fontSize16 = 16.0;
  static const double fontSize18 = 18.0;
  static const double fontSize28 = 28.0;
  static const double fontSize32 = 32.0;

  // Image Heights
  static const double heroImageHeight = 218.0;
  static const double menuItemImageSize = 56.0;

  // Responsive breakpoints
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;

  // Helper methods for responsive sizing
  static double getResponsiveWidth(BuildContext context, double mobileWidth, double tabletWidth) {
    final width = MediaQuery.of(context).size.width;
    if (width >= tabletBreakpoint) {
      return tabletWidth;
    } else if (width >= mobileBreakpoint) {
      return mobileWidth;
    }
    return mobileWidth;
  }

  static double getResponsiveFontSize(BuildContext context, double mobileSize, double tabletSize) {
    final width = MediaQuery.of(context).size.width;
    if (width >= tabletBreakpoint) {
      return tabletSize;
    }
    return mobileSize;
  }

  static EdgeInsets getResponsivePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= tabletBreakpoint) {
      return const EdgeInsets.symmetric(horizontal: 32.0);
    } else if (width >= mobileBreakpoint) {
      return const EdgeInsets.symmetric(horizontal: 24.0);
    }
    return const EdgeInsets.symmetric(horizontal: 16.0);
  }

  static double getResponsiveHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= tabletBreakpoint) {
      return 32.0;
    } else if (width >= mobileBreakpoint) {
      return 24.0;
    }
    return 16.0;
  }
}

