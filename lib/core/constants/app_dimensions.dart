import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Application dimension constants for responsive design
/// Supports mobile, tablet, and desktop layouts
class AppDimensions {
  // Private constructor to prevent instantiation
  AppDimensions._();

  // ==========================================================================
  // DEVICE BREAKPOINTS
  // ==========================================================================
  
  /// Compact mobile devices (small phones)
  static const double mobileSmallBreakpoint = 360.0;
  
  /// Regular mobile devices
  static const double mobileBreakpoint = 600.0;
  
  /// Tablet devices (portrait and small landscape)
  static const double tabletBreakpoint = 900.0;
  
  /// Large tablets and small desktops
  static const double desktopBreakpoint = 1200.0;
  
  /// Large desktop screens
  static const double desktopLargeBreakpoint = 1440.0;

  // ==========================================================================
  // SPACING VALUES
  // ==========================================================================
  
  static const double spacing2 = 2.0;
  static const double spacing4 = 4.0;
  static const double spacing6 = 6.0;
  static const double spacing8 = 8.0;
  static const double spacing10 = 10.0;
  static const double spacing12 = 12.0;
  static const double spacing14 = 14.0;
  static const double spacing16 = 16.0;
  static const double spacing18 = 18.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing28 = 28.0;
  static const double spacing32 = 32.0;
  static const double spacing36 = 36.0;
  static const double spacing40 = 40.0;
  static const double spacing48 = 48.0;
  static const double spacing56 = 56.0;
  static const double spacing60 = 60.0;
  static const double spacing64 = 64.0;
  static const double spacing72 = 72.0;
  static const double spacing80 = 80.0;
  static const double spacing96 = 96.0;
  static const double spacing100 = 100.0;
  static const double spacing120 = 120.0;

  // ==========================================================================
  // BORDER RADIUS VALUES
  // ==========================================================================
  
  static const double borderRadius4 = 4.0;
  static const double borderRadius6 = 6.0;
  static const double borderRadius8 = 8.0;
  static const double borderRadius10 = 10.0;
  static const double borderRadius12 = 12.0;
  static const double borderRadius16 = 16.0;
  static const double borderRadius20 = 20.0;
  static const double borderRadius24 = 24.0;
  static const double borderRadius28 = 28.0;
  static const double borderRadius32 = 32.0;

  // ==========================================================================
  // ICON SIZES
  // ==========================================================================
  
  static const double iconSize12 = 12.0;
  static const double iconSize14 = 14.0;
  static const double iconSize16 = 16.0;
  static const double iconSize18 = 18.0;
  static const double iconSize20 = 20.0;
  static const double iconSize24 = 24.0;
  static const double iconSize28 = 28.0;
  static const double iconSize32 = 32.0;
  static const double iconSize40 = 40.0;
  static const double iconSize48 = 48.0;
  static const double iconSize56 = 56.0;
  static const double iconSize64 = 64.0;
  static const double iconSize80 = 80.0;
  static const double iconSize96 = 96.0;

  // ==========================================================================
  // BUTTON HEIGHTS
  // ==========================================================================
  
  static const double buttonHeight32 = 32.0;
  static const double buttonHeight36 = 36.0;
  static const double buttonHeight40 = 40.0;
  static const double buttonHeight44 = 44.0;
  static const double buttonHeight48 = 48.0;
  static const double buttonHeight52 = 52.0;
  static const double buttonHeight56 = 56.0;

  // ==========================================================================
  // FONT SIZES
  // ==========================================================================
  
  static const double fontSize10 = 10.0;
  static const double fontSize11 = 11.0;
  static const double fontSize12 = 12.0;
  static const double fontSize13 = 13.0;
  static const double fontSize14 = 14.0;
  static const double fontSize15 = 15.0;
  static const double fontSize16 = 16.0;
  static const double fontSize17 = 17.0;
  static const double fontSize18 = 18.0;
  static const double fontSize20 = 20.0;
  static const double fontSize22 = 22.0;
  static const double fontSize24 = 24.0;
  static const double fontSize26 = 26.0;
  static const double fontSize28 = 28.0;
  static const double fontSize30 = 30.0;
  static const double fontSize32 = 32.0;
  static const double fontSize36 = 36.0;
  static const double fontSize40 = 40.0;
  static const double fontSize48 = 48.0;

  // ==========================================================================
  // IMAGE / COMPONENT HEIGHTS
  // ==========================================================================
  
  static const double heroImageHeight = 218.0;
  static const double menuItemImageSize = 56.0;
  static const double avatarSizeSmall = 32.0;
  static const double avatarSizeMedium = 48.0;
  static const double avatarSizeLarge = 64.0;
  static const double avatarSizeXLarge = 96.0;
  static const double cardImageHeight = 180.0;
  static const double appBarHeight = 56.0;
  static const double bottomNavHeight = 70.0;

  // ==========================================================================
  // DEVICE TYPE DETECTION
  // ==========================================================================
  
  /// Returns the current device type based on screen width
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < mobileBreakpoint) {
      return width < mobileSmallBreakpoint 
          ? DeviceType.mobileSmall 
          : DeviceType.mobile;
    } else if (width < tabletBreakpoint) {
      return DeviceType.tablet;
    } else if (width < desktopBreakpoint) {
      return DeviceType.desktop;
    } else {
      return DeviceType.desktopLarge;
    }
  }
  
  /// Returns true if the current device is a mobile phone
  static bool isMobile(BuildContext context) {
    final type = getDeviceType(context);
    return type == DeviceType.mobile || type == DeviceType.mobileSmall;
  }
  
  /// Returns true if the current device is a tablet
  static bool isTablet(BuildContext context) {
    return getDeviceType(context) == DeviceType.tablet;
  }
  
  /// Returns true if the current device is a desktop
  static bool isDesktop(BuildContext context) {
    final type = getDeviceType(context);
    return type == DeviceType.desktop || type == DeviceType.desktopLarge;
  }
  
  /// Returns true if the device is in landscape orientation
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  // ==========================================================================
  // RESPONSIVE SIZING UTILITIES
  // ==========================================================================
  
  /// Get a responsive value based on device type
  /// Uses linear interpolation for smooth scaling
  static double responsive(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    final tabletValue = tablet ?? mobile * 1.15;
    final desktopValue = desktop ?? tabletValue * 1.1;
    
    if (width < mobileBreakpoint) {
      // Scale down for very small devices
      if (width < mobileSmallBreakpoint) {
        return mobile * (width / mobileSmallBreakpoint).clamp(0.85, 1.0);
      }
      return mobile;
    } else if (width < tabletBreakpoint) {
      // Interpolate between mobile and tablet
      final t = (width - mobileBreakpoint) / (tabletBreakpoint - mobileBreakpoint);
      return _lerp(mobile, tabletValue, t);
    } else if (width < desktopBreakpoint) {
      // Interpolate between tablet and desktop
      final t = (width - tabletBreakpoint) / (desktopBreakpoint - tabletBreakpoint);
      return _lerp(tabletValue, desktopValue, t);
    } else {
      return desktopValue;
    }
  }
  
  /// Get responsive font size with proper scaling
  static double responsiveFontSize(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    // Apply text scaler for accessibility
    final textScaler = MediaQuery.of(context).textScaler;
    final textScaleFactor = textScaler.scale(1.0).clamp(0.8, 1.4);
    final baseSize = responsive(
      context,
      mobile: mobile,
      tablet: tablet ?? mobile * 1.1,
      desktop: desktop ?? mobile * 1.15,
    );
    return baseSize * textScaleFactor;
  }
  
  /// Get responsive spacing value
  static double responsiveSpacing(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    return responsive(
      context,
      mobile: mobile,
      tablet: tablet ?? mobile * 1.25,
      desktop: desktop ?? mobile * 1.5,
    );
  }
  
  /// Get responsive icon size
  static double responsiveIconSize(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    return responsive(
      context,
      mobile: mobile,
      tablet: tablet ?? mobile * 1.15,
      desktop: desktop ?? mobile * 1.25,
    );
  }
  
  /// Get responsive width value based on screen percentage
  static double widthPercent(BuildContext context, double percent) {
    return MediaQuery.of(context).size.width * (percent / 100);
  }
  
  /// Get responsive height value based on screen percentage
  static double heightPercent(BuildContext context, double percent) {
    return MediaQuery.of(context).size.height * (percent / 100);
  }
  
  /// Get the smaller of width or height percentage for square elements
  static double minScreenPercent(BuildContext context, double percent) {
    final size = MediaQuery.of(context).size;
    return math.min(size.width, size.height) * (percent / 100);
  }

  // ==========================================================================
  // RESPONSIVE PADDING & MARGIN
  // ==========================================================================
  
  /// Get horizontal padding based on device type
  static double getResponsiveHorizontalPadding(BuildContext context) {
    return responsive(
      context,
      mobile: spacing16,
      tablet: spacing24,
      desktop: spacing32,
    );
  }
  
  /// Get vertical padding based on device type
  static double getResponsiveVerticalPadding(BuildContext context) {
    return responsive(
      context,
      mobile: spacing16,
      tablet: spacing20,
      desktop: spacing24,
    );
  }
  
  /// Get responsive padding EdgeInsets
  static EdgeInsets getResponsivePadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: getResponsiveHorizontalPadding(context),
      vertical: getResponsiveVerticalPadding(context),
    );
  }
  
  /// Get responsive horizontal-only padding
  static EdgeInsets getHorizontalPadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: getResponsiveHorizontalPadding(context),
    );
  }
  
  /// Get responsive screen padding (for main content areas)
  static EdgeInsets getScreenPadding(BuildContext context) {
    final horizontal = getResponsiveHorizontalPadding(context);
    return EdgeInsets.fromLTRB(
      horizontal,
      spacing12,
      horizontal,
      spacing24,
    );
  }
  
  /// Get page margin for content containers
  static EdgeInsets getPageMargin(BuildContext context) {
    if (isDesktop(context)) {
      // Center content on desktop with max width
      final screenWidth = MediaQuery.of(context).size.width;
      final maxContentWidth = 1200.0;
      final horizontalMargin = ((screenWidth - maxContentWidth) / 2).clamp(spacing32, double.infinity);
      return EdgeInsets.symmetric(horizontal: horizontalMargin);
    }
    return EdgeInsets.symmetric(
      horizontal: getResponsiveHorizontalPadding(context),
    );
  }

  // ==========================================================================
  // GRID & LAYOUT HELPERS
  // ==========================================================================
  
  /// Get the number of grid columns based on device type
  static int getGridColumns(BuildContext context) {
    final type = getDeviceType(context);
    switch (type) {
      case DeviceType.mobileSmall:
        return 1;
      case DeviceType.mobile:
        return 2;
      case DeviceType.tablet:
        return 3;
      case DeviceType.desktop:
        return 4;
      case DeviceType.desktopLarge:
        return 5;
    }
  }
  
  /// Get cross-axis count for grid views
  static int getGridCrossAxisCount(BuildContext context, {int? mobileCols, int? tabletCols, int? desktopCols}) {
    final type = getDeviceType(context);
    switch (type) {
      case DeviceType.mobileSmall:
        return mobileCols ?? 1;
      case DeviceType.mobile:
        return mobileCols ?? 2;
      case DeviceType.tablet:
        return tabletCols ?? 3;
      case DeviceType.desktop:
      case DeviceType.desktopLarge:
        return desktopCols ?? 4;
    }
  }
  
  /// Get grid aspect ratio based on device type
  static double getGridAspectRatio(BuildContext context, {double? mobile, double? tablet, double? desktop}) {
    return responsive(
      context,
      mobile: mobile ?? 0.75,
      tablet: tablet ?? 0.8,
      desktop: desktop ?? 0.85,
    );
  }
  
  /// Get grid spacing based on device type
  static double getGridSpacing(BuildContext context) {
    return responsive(
      context,
      mobile: spacing12,
      tablet: spacing16,
      desktop: spacing20,
    );
  }
  
  /// Get max content width for centering on large screens
  static double getMaxContentWidth(BuildContext context) {
    final type = getDeviceType(context);
    switch (type) {
      case DeviceType.mobileSmall:
      case DeviceType.mobile:
        return double.infinity;
      case DeviceType.tablet:
        return 720.0;
      case DeviceType.desktop:
        return 960.0;
      case DeviceType.desktopLarge:
        return 1200.0;
    }
  }
  
  /// Get constrained box widget for max width on large screens
  static BoxConstraints getContentConstraints(BuildContext context) {
    return BoxConstraints(
      maxWidth: getMaxContentWidth(context),
    );
  }

  // ==========================================================================
  // COMPONENT-SPECIFIC RESPONSIVE VALUES
  // ==========================================================================
  
  /// Get responsive button height
  static double getButtonHeight(BuildContext context) {
    return responsive(
      context,
      mobile: buttonHeight48,
      tablet: buttonHeight52,
      desktop: buttonHeight56,
    );
  }
  
  /// Get responsive button border radius
  static double getButtonBorderRadius(BuildContext context) {
    return responsive(
      context,
      mobile: borderRadius24,
      tablet: borderRadius28,
      desktop: borderRadius32,
    );
  }
  
  /// Get responsive input field height
  static double getInputHeight(BuildContext context) {
    return responsive(
      context,
      mobile: 52.0,
      tablet: 56.0,
      desktop: 60.0,
    );
  }
  
  /// Get responsive card border radius
  static double getCardBorderRadius(BuildContext context) {
    return responsive(
      context,
      mobile: borderRadius12,
      tablet: borderRadius16,
      desktop: borderRadius20,
    );
  }
  
  /// Get responsive avatar size
  static double getAvatarSize(BuildContext context) {
    return responsive(
      context,
      mobile: avatarSizeMedium,
      tablet: avatarSizeLarge,
      desktop: avatarSizeXLarge,
    );
  }
  
  /// Get responsive hero/banner image height
  static double getHeroHeight(BuildContext context) {
    return responsive(
      context,
      mobile: 200.0,
      tablet: 280.0,
      desktop: 360.0,
    );
  }
  
  /// Get responsive card height
  static double getCardHeight(BuildContext context) {
    return responsive(
      context,
      mobile: 180.0,
      tablet: 220.0,
      desktop: 260.0,
    );
  }
  
  /// Get responsive bottom navigation height
  static double getBottomNavHeight(BuildContext context) {
    return responsive(
      context,
      mobile: bottomNavHeight,
      tablet: bottomNavHeight + 10,
      desktop: bottomNavHeight + 16,
    );
  }
  
  /// Get responsive app bar height
  static double getAppBarHeight(BuildContext context) {
    return responsive(
      context,
      mobile: appBarHeight,
      tablet: appBarHeight + 8,
      desktop: appBarHeight + 16,
    );
  }

  // ==========================================================================
  // TYPOGRAPHY-SPECIFIC RESPONSIVE VALUES
  // ==========================================================================
  
  /// Get responsive heading 1 size
  static double getH1Size(BuildContext context) {
    return responsiveFontSize(
      context,
      mobile: fontSize32,
      tablet: fontSize36,
      desktop: fontSize40,
    );
  }
  
  /// Get responsive heading 2 size
  static double getH2Size(BuildContext context) {
    return responsiveFontSize(
      context,
      mobile: fontSize24,
      tablet: fontSize28,
      desktop: fontSize32,
    );
  }
  
  /// Get responsive heading 3 size
  static double getH3Size(BuildContext context) {
    return responsiveFontSize(
      context,
      mobile: fontSize20,
      tablet: fontSize22,
      desktop: fontSize24,
    );
  }
  
  /// Get responsive body text size
  static double getBodySize(BuildContext context) {
    return responsiveFontSize(
      context,
      mobile: fontSize14,
      tablet: fontSize15,
      desktop: fontSize16,
    );
  }
  
  /// Get responsive small text size
  static double getSmallSize(BuildContext context) {
    return responsiveFontSize(
      context,
      mobile: fontSize12,
      tablet: fontSize13,
      desktop: fontSize14,
    );
  }
  
  /// Get responsive caption text size
  static double getCaptionSize(BuildContext context) {
    return responsiveFontSize(
      context,
      mobile: fontSize10,
      tablet: fontSize11,
      desktop: fontSize12,
    );
  }

  // ==========================================================================
  // LEGACY METHODS (for backward compatibility)
  // ==========================================================================
  
  /// Legacy method - use responsive() instead
  @Deprecated('Use responsive() instead for more flexibility')
  static double getResponsiveWidth(BuildContext context, double mobileWidth, double tabletWidth) {
    final width = MediaQuery.of(context).size.width;
    if (width >= tabletBreakpoint) {
      return tabletWidth;
    } else if (width >= mobileBreakpoint) {
      return mobileWidth;
    }
    return mobileWidth;
  }

  /// Legacy method - use responsiveFontSize() instead
  @Deprecated('Use responsiveFontSize() instead for more flexibility')
  static double getResponsiveFontSize(BuildContext context, double mobileSize, double tabletSize) {
    final width = MediaQuery.of(context).size.width;
    if (width >= tabletBreakpoint) {
      return tabletSize;
    }
    return mobileSize;
  }

  // ==========================================================================
  // PRIVATE HELPERS
  // ==========================================================================
  
  /// Linear interpolation between two values
  static double _lerp(double a, double b, double t) {
    return a + (b - a) * t.clamp(0.0, 1.0);
  }
}

/// Device type enumeration for responsive layouts
enum DeviceType {
  /// Small mobile devices (width < 360px)
  mobileSmall,
  
  /// Regular mobile devices (360px <= width < 600px)
  mobile,
  
  /// Tablet devices (600px <= width < 900px)
  tablet,
  
  /// Desktop screens (900px <= width < 1200px)
  desktop,
  
  /// Large desktop screens (width >= 1200px)
  desktopLarge,
}

/// Extension to easily access AppDimensions through BuildContext
extension ResponsiveContext on BuildContext {
  /// Get AppDimensions responsive values
  double responsive({
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    return AppDimensions.responsive(
      this,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }
  
  /// Get the current device type
  DeviceType get deviceType => AppDimensions.getDeviceType(this);
  
  /// Check if the device is mobile
  bool get isMobile => AppDimensions.isMobile(this);
  
  /// Check if the device is tablet
  bool get isTablet => AppDimensions.isTablet(this);
  
  /// Check if the device is desktop
  bool get isDesktop => AppDimensions.isDesktop(this);
  
  /// Check if the device is in landscape mode
  bool get isLandscape => AppDimensions.isLandscape(this);
  
  /// Get screen width
  double get screenWidth => MediaQuery.of(this).size.width;
  
  /// Get screen height
  double get screenHeight => MediaQuery.of(this).size.height;
  
  /// Get responsive horizontal padding
  double get horizontalPadding => AppDimensions.getResponsiveHorizontalPadding(this);
  
  /// Get responsive vertical padding
  double get verticalPadding => AppDimensions.getResponsiveVerticalPadding(this);
  
  /// Get responsive padding EdgeInsets
  EdgeInsets get responsivePadding => AppDimensions.getResponsivePadding(this);
  
  /// Get grid column count
  int get gridColumns => AppDimensions.getGridColumns(this);
  
  /// Get max content width
  double get maxContentWidth => AppDimensions.getMaxContentWidth(this);
}
