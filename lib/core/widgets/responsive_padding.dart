import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';

/// Widget that provides responsive padding to its child
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final bool symmetric;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.padding,
    this.symmetric = false,
  });

  @override
  Widget build(BuildContext context) {
    if (padding != null) {
      return Padding(padding: padding!, child: child);
    }

    final horizontalPadding = AppDimensions.getResponsiveHorizontalPadding(context);
    final defaultPadding = symmetric
        ? EdgeInsets.symmetric(horizontal: horizontalPadding)
        : EdgeInsets.fromLTRB(
            horizontalPadding,
            AppDimensions.spacing12,
            horizontalPadding,
            AppDimensions.spacing12,
          );

    return Padding(padding: defaultPadding, child: child);
  }
}

