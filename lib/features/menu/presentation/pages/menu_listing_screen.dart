import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';

class MenuListingScreen extends StatelessWidget {
  const MenuListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.menuListing,
          style: TextStyle(
            fontSize: AppDimensions.getH3Size(context),
          ),
        ),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primaryText,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: AppDimensions.getMaxContentWidth(context),
          ),
          child: Padding(
            padding: EdgeInsets.all(
              AppDimensions.getResponsiveHorizontalPadding(context),
            ),
            child: Text(
              AppStrings.menuListingContent,
              style: TextStyle(
                color: AppColors.mutedText,
                fontSize: AppDimensions.getBodySize(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
