import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () {
        //     final navigator = Navigator.of(context);
        //     if (navigator.canPop()) {
        //       navigator.pop();
        //     } else {
        //       Navigator.of(context).maybePop();
        //     }
        //   },
        // ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          // Today Section
          _buildSectionHeader('Today', () {}),
          const SizedBox(height: 16),
          _NotificationCard(
            type: NotificationType.delivery,
            title: 'Order Deliver',
            description: 'Lorem Ipsum is simply dummy text of the printing and industry.',
            time: '1h',
          ),
          const SizedBox(height: 16),
          _NotificationCard(
            type: NotificationType.cancel,
            title: 'Order cancel',
            description: 'Lorem Ipsum is simply dummy text of the printing and industry.',
            time: '3h',
          ),

          const SizedBox(height: 32),

          // Yesterday Section
          _buildSectionHeader('Yesterday', () {}),
          const SizedBox(height: 16),
          _NotificationCard(
            type: NotificationType.delivery,
            title: 'Order Deliver',
            description: 'Lorem Ipsum is simply dummy text of the printing and industry.',
            time: '1d',
          ),
          const SizedBox(height: 16),
          _NotificationCard(
            type: NotificationType.cancel,
            title: 'Order cancel',
            description: 'Lorem Ipsum is simply dummy text of the printing and industry.',
            time: '1d',
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onMarkRead) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[500],
          ),
        ),
        GestureDetector(
          onTap: onMarkRead,
          child: const Text(
            'Mark all as Read',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4CAF50), // Green color
            ),
          ),
        ),
      ],
    );
  }
}

enum NotificationType { delivery, cancel }

class _NotificationCard extends StatelessWidget {
  final NotificationType type;
  final String title;
  final String description;
  final String time;

  const _NotificationCard({
    required this.type,
    required this.title,
    required this.description,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: type == NotificationType.delivery
                  ? const Color(0xFFE8F5E9) // Light green
                  : const Color(0xFFFFEBEE), // Light red
              shape: BoxShape.circle,
            ),
            child: Icon(
              type == NotificationType.delivery
                  ? Icons.restaurant // Using restaurant icon as placeholder for bottle/utensils
                  : Icons.inventory_2_outlined, // Using solid box icon placeholder
              color: type == NotificationType.delivery
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFFEF5350),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[500],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
