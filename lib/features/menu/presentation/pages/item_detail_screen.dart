import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';

class ItemDetailScreen extends StatelessWidget {
  const ItemDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsivePadding = AppDimensions.getResponsivePadding(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.itemDetail),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primaryText,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: responsivePadding,
          child: Text(
            AppStrings.itemDetailContent,
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
