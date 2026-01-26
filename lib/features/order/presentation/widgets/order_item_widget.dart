import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';

class OrderItemWidget extends StatelessWidget {
  final String name;
  final String code;
  final double price;
  final String imageUrl;

  const OrderItemWidget({
    Key? key,
    required this.name,
    required this.code,
    required this.price,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.spacing12),
          child: Container(
            width: 60,
            height: 60,
            color: AppColors.grey300,
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.grey300,
                        child: const Icon(Icons.fastfood, color: AppColors.grey),
                      );
                    },
                  )
                : const Icon(Icons.fastfood, color: AppColors.grey),
          ),
        ),
        const SizedBox(width: AppDimensions.spacing12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: AppDimensions.fontSize16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                code,
                style: const TextStyle(
                  fontSize: AppDimensions.fontSize14,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
        ),
        Text(
          '\$${price.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: AppDimensions.fontSize16,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),
      ],
    );
  }
}
