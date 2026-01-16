import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';

class MenuListingScreen extends StatelessWidget {
  const MenuListingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsivePadding = AppDimensions.getResponsivePadding(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.menuListing),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primaryText,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: responsivePadding,
          child: Text(
            AppStrings.menuListingContent,
            style: const TextStyle(
              color: AppColors.mutedText,
              fontSize: AppDimensions.fontSize16,
            ),
          ),
        ),
      ),
    );
  }
}
