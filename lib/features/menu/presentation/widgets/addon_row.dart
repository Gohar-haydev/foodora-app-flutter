import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_colors.dart';

class AddonRow extends StatelessWidget {
  final String name;
  final String price;
  final int count;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const AddonRow({
    Key? key,
    required this.name,
    required this.price,
    required this.count,
    required this.onAdd,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.fastfood, color: Colors.orange, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                     fontWeight: FontWeight.bold,
                     fontSize: 16,
                     color: AppColors.primaryText,
                  ),
                ),
                Text(
                  price, 
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _buildCounterIcon(Icons.remove, onRemove),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.primaryText,
                  ),
                ),
              ),
              _buildCounterIcon(Icons.add, onAdd, isPlus: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCounterIcon(IconData icon, VoidCallback onTap, {bool isPlus = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: isPlus 
            ? Border.all(color: AppColors.primaryAccent) 
            : Border.all(color: Colors.grey.withOpacity(0.4)),
          color: AppColors.white,
        ),
        child: Icon(
          icon, 
          size: 16, 
          color: isPlus ? AppColors.primaryAccent : Colors.grey[600]
        ),
      ),
    );
  }
}
