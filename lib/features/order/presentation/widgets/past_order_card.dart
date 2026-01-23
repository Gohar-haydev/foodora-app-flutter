import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_colors.dart';
// If needed for text styles or dimensions
// import 'package:foodora/core/constants/app_dimensions.dart';

class PastOrderCard extends StatelessWidget {
  final String title;
  final String price;
  final String imageUrl; // For now we might just use a placeholder or asset
  final VoidCallback? onCancel;

  const PastOrderCard({
    Key? key,
    required this.title,
    required this.price,
    required this.imageUrl,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          // Order Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
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
                    color: Colors.grey,
                    size: 30,
                  )
                : null,
          ),
          const SizedBox(width: 16),
          // Order Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A), // Dark text color
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department_outlined, // Using a flame icon similar to the design
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
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
              icon: const Icon(Icons.cancel_outlined, color: Colors.red),
              tooltip: 'Cancel Order',
            ),
        ],
      ),
    );
  }
}
