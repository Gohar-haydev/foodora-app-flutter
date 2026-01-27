import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';

class PastOrderCard extends StatelessWidget {
  final String title;
  final String price;
  final String imageUrl; // For now we might just use a placeholder or asset
  final VoidCallback? onCancel;

  const PastOrderCard({
    super.key,
    required this.title,
    required this.price,
    required this.imageUrl,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacing16),
      padding: const EdgeInsets.all(AppDimensions.spacing12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryText.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: AppColors.grey.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          // Order Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.grey200,
              image: imageUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageUrl.isEmpty
                ? const Icon(
                    Icons.restaurant,
                    color: AppColors.grey,
                    size: 30,
                  )
                : null,
          ),
          const SizedBox(width: AppDimensions.spacing16),
          // Order Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: AppDimensions.fontSize16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department_outlined, // Using a flame icon similar to the design
                      size: 14,
                      color: AppColors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: AppDimensions.fontSize14,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (onCancel != null)
             IconButton(
              onPressed: onCancel,
              icon: const Icon(Icons.cancel_outlined, color: AppColors.error),
              tooltip: 'Cancel Order',
            ),
        ],
      ),
    );
  }
}
