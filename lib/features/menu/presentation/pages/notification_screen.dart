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
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: AppDimensions.getH3Size(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: AppDimensions.getMaxContentWidth(context),
          ),
          child: ListView(
            padding: EdgeInsets.all(
              AppDimensions.getResponsiveHorizontalPadding(context),
            ),
            children: [
              // Today Section
              _buildSectionHeader(context, context.tr('today'), () {}),
              SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
              _NotificationCard(
                type: NotificationType.delivery,
                title: context.tr('order_delivered'),
                description: context.tr('order_delivered_desc'),
                time: '1h',
              ),
              SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
              _NotificationCard(
                type: NotificationType.cancel,
                title: context.tr('order_cancelled'),
                description: context.tr('order_cancelled_desc'),
                time: '3h',
              ),

              SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 32, tablet: 40)),

              // Yesterday Section
              _buildSectionHeader(context, context.tr('yesterday'), () {}),
              SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
              _NotificationCard(
                type: NotificationType.delivery,
                title: context.tr('order_delivered'),
                description: context.tr('order_delivered_desc'),
                time: '1d',
              ),
              SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
              _NotificationCard(
                type: NotificationType.cancel,
                title: context.tr('order_cancelled'),
                description: context.tr('order_cancelled_desc'),
                time: '1d',
              ),
              SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 24, tablet: 32)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, VoidCallback onMarkRead) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: AppDimensions.getBodySize(context),
            fontWeight: FontWeight.w600,
            color: AppColors.grey,
          ),
        ),
        GestureDetector(
          onTap: onMarkRead,
          child: Text(
            context.tr('mark_all_read'),
            style: TextStyle(
              fontSize: AppDimensions.getSmallSize(context),
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
      padding: EdgeInsets.all(
        AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20),
      ),
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
            padding: EdgeInsets.all(
              AppDimensions.responsiveSpacing(context, mobile: 12, tablet: 16),
            ),
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
              size: AppDimensions.responsiveIconSize(context, mobile: 24, tablet: 28),
            ),
          ),
          SizedBox(width: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
          
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
                      style: TextStyle(
                        fontSize: AppDimensions.getBodySize(context),
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryText,
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: AppDimensions.responsive(context, mobile: 12, tablet: 14),
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: AppDimensions.getSmallSize(context),
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
