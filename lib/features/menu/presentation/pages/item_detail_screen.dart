import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';

class ItemDetailScreen extends StatelessWidget {
  const ItemDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.itemDetail,
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
              AppStrings.itemDetailContent,
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
