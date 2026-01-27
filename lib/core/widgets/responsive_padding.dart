import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_dimensions.dart';

/// Widget that provides responsive padding to its child
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final bool symmetric;
  final bool horizontal;
  final bool vertical;
  final bool screen;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.padding,
    this.symmetric = false,
    this.horizontal = false,
    this.vertical = false,
    this.screen = false,
  });

  /// Creates a responsive padding with only horizontal padding
  const ResponsivePadding.horizontal({
    super.key,
    required this.child,
  })  : padding = null,
        symmetric = false,
        horizontal = true,
        vertical = false,
        screen = false;

  /// Creates a responsive padding with only vertical padding
  const ResponsivePadding.vertical({
    super.key,
    required this.child,
  })  : padding = null,
        symmetric = false,
        horizontal = false,
        vertical = true,
        screen = false;

  /// Creates a responsive padding suitable for screen content
  const ResponsivePadding.screen({
    super.key,
    required this.child,
  })  : padding = null,
        symmetric = false,
        horizontal = false,
        vertical = false,
        screen = true;

  @override
  Widget build(BuildContext context) {
    if (padding != null) {
      return Padding(padding: padding!, child: child);
    }

    EdgeInsets effectivePadding;
    
    if (screen) {
      effectivePadding = AppDimensions.getScreenPadding(context);
    } else if (horizontal) {
      effectivePadding = AppDimensions.getHorizontalPadding(context);
    } else if (vertical) {
      effectivePadding = EdgeInsets.symmetric(
        vertical: AppDimensions.getResponsiveVerticalPadding(context),
      );
    } else if (symmetric) {
      effectivePadding = EdgeInsets.symmetric(
        horizontal: AppDimensions.getResponsiveHorizontalPadding(context),
      );
    } else {
      final horizontalPadding = AppDimensions.getResponsiveHorizontalPadding(context);
      effectivePadding = EdgeInsets.fromLTRB(
        horizontalPadding,
        AppDimensions.spacing12,
        horizontalPadding,
        AppDimensions.spacing12,
      );
    }

    return Padding(padding: effectivePadding, child: child);
  }
}

/// Widget that provides a max-width constrained container for larger screens
class ResponsiveMaxWidth extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final Alignment alignment;

  const ResponsiveMaxWidth({
    super.key,
    required this.child,
    this.maxWidth,
    this.alignment = Alignment.topCenter,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveMaxWidth = maxWidth ?? AppDimensions.getMaxContentWidth(context);
    
    if (effectiveMaxWidth == double.infinity) {
      return child;
    }
    
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
        child: child,
      ),
    );
  }
}
