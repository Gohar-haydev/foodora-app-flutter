import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'package:foodora/core/extensions/context_extensions.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          context.tr('notifications_title'),
          style: const TextStyle(
            color: AppColors.primaryText,
            fontSize: AppDimensions.fontSize18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spacing24),
        children: [
          // Today Section
          _buildSectionHeader(context, context.tr('today'), () {}),
          const SizedBox(height: AppDimensions.spacing16),
          _NotificationCard(
            type: NotificationType.delivery,
            title: context.tr('order_delivered'),
            description: context.tr('order_delivered_desc'),
            time: '1h',
          ),
          const SizedBox(height: AppDimensions.spacing16),
          _NotificationCard(
            type: NotificationType.cancel,
            title: context.tr('order_cancelled'),
            description: context.tr('order_cancelled_desc'),
            time: '3h',
          ),

          const SizedBox(height: AppDimensions.spacing32),

          // Yesterday Section
          _buildSectionHeader(context, context.tr('yesterday'), () {}),
          const SizedBox(height: AppDimensions.spacing16),
          _NotificationCard(
            type: NotificationType.delivery,
            title: context.tr('order_delivered'),
            description: context.tr('order_delivered_desc'),
            time: '1d',
          ),
          const SizedBox(height: AppDimensions.spacing16),
          _NotificationCard(
            type: NotificationType.cancel,
            title: context.tr('order_cancelled'),
            description: context.tr('order_cancelled_desc'),
            time: '1d',
          ),
          const SizedBox(height: AppDimensions.spacing24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, VoidCallback onMarkRead) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: AppDimensions.fontSize16,
            fontWeight: FontWeight.w600,
            color: AppColors.grey,
          ),
        ),
        GestureDetector(
          onTap: onMarkRead,
          child: Text(
            context.tr('mark_all_read'),
            style: const TextStyle(
              fontSize: AppDimensions.fontSize14,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryAccent, // Green color
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
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryText.withOpacity(0.05),
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
            padding: const EdgeInsets.all(AppDimensions.spacing12),
            decoration: BoxDecoration(
              color: type == NotificationType.delivery
                  ? AppColors.successLight // Light green
                  : AppColors.errorLight, // Light red
              shape: BoxShape.circle,
            ),
            child: Icon(
              type == NotificationType.delivery
                  ? Icons.restaurant // Using restaurant icon as placeholder for bottle/utensils
                  : Icons.inventory_2_outlined, // Using solid box icon placeholder
              color: type == NotificationType.delivery
                  ? AppColors.primaryAccent
                  : AppColors.error,
              size: 24,
            ),
          ),
          const SizedBox(width: AppDimensions.spacing16),
          
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
                        fontSize: AppDimensions.fontSize16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryText,
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: AppDimensions.fontSize12,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.grey,
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
