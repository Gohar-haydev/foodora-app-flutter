import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_dimensions.dart';

/// A widget that builds different layouts based on screen size
/// This provides a clean way to create responsive UIs
class ResponsiveBuilder extends StatelessWidget {
  /// Builder for mobile layout (required)
  final Widget Function(BuildContext context, BoxConstraints constraints) mobile;
  
  /// Builder for tablet layout (optional, falls back to mobile)
  final Widget Function(BuildContext context, BoxConstraints constraints)? tablet;
  
  /// Builder for desktop layout (optional, falls back to tablet or mobile)
  final Widget Function(BuildContext context, BoxConstraints constraints)? desktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceType = AppDimensions.getDeviceType(context);
        
        switch (deviceType) {
          case DeviceType.desktopLarge:
          case DeviceType.desktop:
            if (desktop != null) {
              return desktop!(context, constraints);
            }
            if (tablet != null) {
              return tablet!(context, constraints);
            }
            return mobile(context, constraints);
            
          case DeviceType.tablet:
            if (tablet != null) {
              return tablet!(context, constraints);
            }
            return mobile(context, constraints);
            
          case DeviceType.mobileSmall:
          case DeviceType.mobile:
            return mobile(context, constraints);
        }
      },
    );
  }
}

/// A widget that adapts its child for different screen sizes
/// Provides maximum width constraints for larger screens
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final bool centerContent;
  final Color? backgroundColor;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
    this.centerContent = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveMaxWidth = maxWidth ?? AppDimensions.getMaxContentWidth(context);
    final effectivePadding = padding ?? AppDimensions.getHorizontalPadding(context);
    
    Widget content = child;
    
    // Apply max width constraint for larger screens
    if (effectiveMaxWidth != double.infinity) {
      content = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
        child: child,
      );
      
      if (centerContent) {
        content = Center(child: content);
      }
    }
    
    // Apply padding
    content = Padding(
      padding: effectivePadding,
      child: content,
    );
    
    // Apply background color if provided
    if (backgroundColor != null) {
      content = ColoredBox(
        color: backgroundColor!,
        child: content,
      );
    }
    
    return content;
  }
}

/// A scrollable container with responsive padding and max width
class ResponsiveScrollView extends StatelessWidget {
  final List<Widget> children;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final Axis scrollDirection;
  final ScrollController? controller;
  final bool reverse;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;

  const ResponsiveScrollView({
    super.key,
    required this.children,
    this.maxWidth,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
    this.controller,
    this.reverse = false,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveMaxWidth = maxWidth ?? AppDimensions.getMaxContentWidth(context);
    final effectivePadding = padding ?? AppDimensions.getScreenPadding(context);
    
    Widget content = SingleChildScrollView(
      controller: controller,
      physics: physics,
      scrollDirection: scrollDirection,
      reverse: reverse,
      child: scrollDirection == Axis.vertical
          ? Column(
              crossAxisAlignment: crossAxisAlignment,
              mainAxisAlignment: mainAxisAlignment,
              children: children,
            )
          : Row(
              crossAxisAlignment: crossAxisAlignment,
              mainAxisAlignment: mainAxisAlignment,
              children: children,
            ),
    );
    
    // Apply max width constraint for larger screens
    if (effectiveMaxWidth != double.infinity) {
      content = Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
          child: content,
        ),
      );
    }
    
    return Padding(
      padding: effectivePadding,
      child: content,
    );
  }
}

/// Adaptive grid view that adjusts columns based on screen size
class ResponsiveGridView extends StatelessWidget {
  final List<Widget> children;
  final int? mobileCols;
  final int? tabletCols;
  final int? desktopCols;
  final double? mainAxisSpacing;
  final double? crossAxisSpacing;
  final double childAspectRatio;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final ScrollController? controller;

  const ResponsiveGridView({
    super.key,
    required this.children,
    this.mobileCols,
    this.tabletCols,
    this.desktopCols,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.childAspectRatio = 1.0,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final columns = AppDimensions.getGridCrossAxisCount(
      context,
      mobileCols: mobileCols,
      tabletCols: tabletCols,
      desktopCols: desktopCols,
    );
    final spacing = AppDimensions.getGridSpacing(context);
    
    return GridView.builder(
      controller: controller,
      padding: padding ?? AppDimensions.getHorizontalPadding(context),
      shrinkWrap: shrinkWrap,
      physics: physics,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: mainAxisSpacing ?? spacing,
        crossAxisSpacing: crossAxisSpacing ?? spacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

/// Sliver version of the responsive grid
class ResponsiveSliverGrid extends StatelessWidget {
  final List<Widget> children;
  final int? mobileCols;
  final int? tabletCols;
  final int? desktopCols;
  final double? mainAxisSpacing;
  final double? crossAxisSpacing;
  final double childAspectRatio;

  const ResponsiveSliverGrid({
    super.key,
    required this.children,
    this.mobileCols,
    this.tabletCols,
    this.desktopCols,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.childAspectRatio = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final columns = AppDimensions.getGridCrossAxisCount(
      context,
      mobileCols: mobileCols,
      tabletCols: tabletCols,
      desktopCols: desktopCols,
    );
    final spacing = AppDimensions.getGridSpacing(context);
    
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: mainAxisSpacing ?? spacing,
        crossAxisSpacing: crossAxisSpacing ?? spacing,
        childAspectRatio: childAspectRatio,
      ),
      delegate: SliverChildListDelegate(children),
    );
  }
}

/// A row that becomes a column on mobile devices
class ResponsiveRowColumn extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final double? spacing;
  final bool forceColumn;

  const ResponsiveRowColumn({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.spacing,
    this.forceColumn = false,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = AppDimensions.isMobile(context);
    final useColumn = forceColumn || isMobile;
    final effectiveSpacing = spacing ?? AppDimensions.spacing16;
    
    // Add spacing between children
    final spacedChildren = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      if (i < children.length - 1) {
        spacedChildren.add(
          useColumn
              ? SizedBox(height: effectiveSpacing)
              : SizedBox(width: effectiveSpacing),
        );
      }
    }
    
    if (useColumn) {
      return Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: spacedChildren,
      );
    }
    
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: spacedChildren,
    );
  }
}

/// Responsive visibility widget that shows/hides based on device type
class ResponsiveVisibility extends StatelessWidget {
  final Widget child;
  final bool visibleOnMobile;
  final bool visibleOnTablet;
  final bool visibleOnDesktop;
  final Widget? replacement;

  const ResponsiveVisibility({
    super.key,
    required this.child,
    this.visibleOnMobile = true,
    this.visibleOnTablet = true,
    this.visibleOnDesktop = true,
    this.replacement,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = AppDimensions.getDeviceType(context);
    
    bool isVisible;
    switch (deviceType) {
      case DeviceType.mobileSmall:
      case DeviceType.mobile:
        isVisible = visibleOnMobile;
        break;
      case DeviceType.tablet:
        isVisible = visibleOnTablet;
        break;
      case DeviceType.desktop:
      case DeviceType.desktopLarge:
        isVisible = visibleOnDesktop;
        break;
    }
    
    if (isVisible) {
      return child;
    }
    
    return replacement ?? const SizedBox.shrink();
  }
}

/// Widget that provides responsive spacing
class ResponsiveSpacing extends StatelessWidget {
  final double mobile;
  final double? tablet;
  final double? desktop;
  final bool horizontal;

  const ResponsiveSpacing({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.horizontal = false,
  });

  /// Vertical spacing shortcut
  const ResponsiveSpacing.vertical({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  }) : horizontal = false;

  /// Horizontal spacing shortcut
  const ResponsiveSpacing.horizontal({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  }) : horizontal = true;

  @override
  Widget build(BuildContext context) {
    final size = AppDimensions.responsiveSpacing(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
    
    return SizedBox(
      width: horizontal ? size : null,
      height: horizontal ? null : size,
    );
  }
}

/// Responsive text widget that scales font size
class ResponsiveText extends StatelessWidget {
  final String text;
  final double mobileSize;
  final double? tabletSize;
  final double? desktopSize;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ResponsiveText(
    this.text, {
    super.key,
    required this.mobileSize,
    this.tabletSize,
    this.desktopSize,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = AppDimensions.responsiveFontSize(
      context,
      mobile: mobileSize,
      tablet: tabletSize,
      desktop: desktopSize,
    );
    
    return Text(
      text,
      style: (style ?? const TextStyle()).copyWith(fontSize: fontSize),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
