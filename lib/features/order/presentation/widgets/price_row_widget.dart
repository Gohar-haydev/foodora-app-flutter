import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';

class PriceRowWidget extends StatelessWidget {
  final String label;
  final double amount;
  final bool isBold;

  const PriceRowWidget({
    Key? key,
    required this.label,
    required this.amount,
    this.isBold = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppDimensions.fontSize16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: AppDimensions.fontSize16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),
      ],
    );
  }
}
