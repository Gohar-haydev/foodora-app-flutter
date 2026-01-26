import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'package:foodora/features/cart/domain/entities/cart_item_entity.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemEntity cartItem;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const CartItemWidget({
    Key? key,
    required this.cartItem,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacing12),
      child: Dismissible(
        key: Key(cartItem.id),
        direction: DismissDirection.endToStart,
        background: Container(
          decoration: BoxDecoration(
            color: AppColors.error,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(Icons.delete, color: AppColors.white),
        ),
        onDismissed: (_) => onRemove(),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.spacing12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryText.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Item Image
              ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.spacing12),
                child: Container(
                  width: 60,
                  height: 60,
                  color: AppColors.grey300,
                  child: cartItem.menuItem.image != null
                      ? Image.network(
                          cartItem.menuItem.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => const Icon(Icons.fastfood, color: AppColors.grey),
                        )
                      : const Icon(Icons.fastfood, color: AppColors.grey),
                ),
              ),
              const SizedBox(width: AppDimensions.spacing12),

              // Item Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cartItem.menuItem.name,
                      style: const TextStyle(
                        fontSize: AppDimensions.fontSize16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (cartItem.selectedAddons.isEmpty)
                      Text(
                        '01', // Default or variant label
                        style: TextStyle(
                          fontSize: AppDimensions.fontSize14,
                          color: AppColors.grey,
                        ),
                      )
                    else
                      Wrap(
                        spacing: 4,
                        children: cartItem.selectedAddons.map((adn) => Text(
                          '+${adn.name}',
                          style: TextStyle(fontSize: AppDimensions.fontSize12, color: AppColors.grey),
                        )).toList(),
                      ),
                  ],
                ),
              ),

              // Quantity Actions
              Container(
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 18),
                      onPressed: onDecrement,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                      color: AppColors.primaryText,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        '${cartItem.quantity}'.padLeft(2, '0'),
                        style: const TextStyle(
                          fontSize: AppDimensions.fontSize14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryText,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 18),
                      onPressed: onIncrement,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                      color: AppColors.primaryText,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
