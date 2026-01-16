import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';

/// Menu item tile widget
class MenuItemTile extends StatelessWidget {
  final String name;
  final String description;
  final String imageUrl;
  final VoidCallback onTap;

  const MenuItemTile({
    super.key,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= AppDimensions.tabletBreakpoint;
    final imageSize = isTablet
        ? AppDimensions.menuItemImageSize * 1.5
        : AppDimensions.menuItemImageSize;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing16,
          vertical: AppDimensions.spacing8,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius8),
              child: Image.network(
                imageUrl,
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: imageSize,
                    height: imageSize,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(AppDimensions.borderRadius8),
                    ),
                    child: const Icon(
                      Icons.restaurant,
                      color: AppColors.mutedText,
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: AppDimensions.spacing16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: AppColors.primaryText,
                      fontSize: AppDimensions.fontSize16,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: AppDimensions.spacing4),
                  Text(
                    description,
                    style: const TextStyle(
                      color: AppColors.mutedText,
                      fontSize: AppDimensions.fontSize14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

