import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'package:foodora/core/constants/app_strings.dart';
import 'package:foodora/features/order/domain/entities/order_tracking_entity.dart';
import 'package:foodora/features/order/presentation/viewmodels/order_viewmodel.dart';
import 'package:foodora/core/extensions/context_extensions.dart';

class OrderTrackingScreen extends StatelessWidget {
  final int orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          context.tr('track_order'),
          style: const TextStyle(
            color: AppColors.primaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder(
        future: Provider.of<OrderViewModel>(context, listen: false).trackOrder(orderId),
        builder: (context, snapshot) {
          return Consumer<OrderViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (viewModel.errorMessage != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                      const SizedBox(height: AppDimensions.spacing16),
                      Text(
                        viewModel.errorMessage!,
                        style: const TextStyle(color: AppColors.error),
                      ),
                      const SizedBox(height: AppDimensions.spacing16),
                      ElevatedButton(
                        onPressed: () => viewModel.trackOrder(orderId),
                        child: Text(context.tr('retry')),
                      ),
                    ],
                  ),
                );
              }

              final trackingData = viewModel.orderTracking;
              if (trackingData == null) {
                return Center(child: Text(context.tr('no_tracking_data')));
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.spacing24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Number and Status
                    Center(
                      child: Column(
                        children: [
                          Text(
                            '${context.tr('order_number')} #${trackingData.orderNumber}',
                            style: const TextStyle(
                              fontSize: AppDimensions.fontSize18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spacing8),
                          Text(
                            trackingData.statusLabel,
                            style: const TextStyle(
                              fontSize: AppDimensions.fontSize16,
                              color: AppColors.primaryAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacing32),

                    // Horizontal Stepper
                    _buildHorizontalStepper(context, trackingData.status),
                    
                    const SizedBox(height: AppDimensions.spacing32),

                    // Estimated Delivery or Current Status Info
                    Container(
                      width: double.infinity,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr('delivery_status'),
                            style: const TextStyle(
                              fontSize: AppDimensions.fontSize16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryText,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spacing16),
                          _buildTimelineItem(
                            context.tr('timeline_placed'),
                            trackingData.timeline.placedAt,
                            isCompleted: trackingData.timeline.placedAt != null,
                            isLast: false,
                          ),
                          _buildTimelineItem(
                            context.tr('status_confirmed'),
                            trackingData.timeline.confirmedAt,
                            isCompleted: trackingData.timeline.confirmedAt != null,
                            isLast: false,
                          ),
                          _buildTimelineItem(
                            context.tr('status_preparing'),
                            trackingData.timeline.preparingAt,
                            isCompleted: trackingData.timeline.preparingAt != null,
                            isLast: false,
                          ),
                          _buildTimelineItem(
                            context.tr('status_ready'),
                            trackingData.timeline.readyAt,
                            isCompleted: trackingData.timeline.readyAt != null,
                            isLast: false,
                          ),
                          _buildTimelineItem(
                            trackingData.deliveryType == 'pickup' ? context.tr('timeline_ready_pickup') : context.tr('status_out_for_delivery'),
                            trackingData.deliveryType == 'pickup' ? trackingData.timeline.readyAt : null, // Logic might differ
                            isCompleted: trackingData.status == 'delivered' || trackingData.status == 'out_for_delivery',
                            isLast: false,
                          ),
                          _buildTimelineItem(
                            context.tr('status_delivered'),
                            trackingData.timeline.deliveredAt,
                            isCompleted: trackingData.timeline.deliveredAt != null,
                            isLast: true,
                          ),
                        ],
                      ),
                    ),

                     const SizedBox(height: AppDimensions.spacing24),

                    // Branch Info
                    Text(
                      context.tr('branch_information'),
                      style: const TextStyle(
                        fontSize: AppDimensions.fontSize18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacing12),
                    Container(
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
                        children: [
                           Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.successLight,
                              borderRadius: BorderRadius.circular(AppDimensions.spacing12),
                              image: trackingData.branch.imageUrl != null
                                  ? DecorationImage(
                                      image: NetworkImage(trackingData.branch.imageUrl!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: trackingData.branch.imageUrl == null
                                ? const Icon(Icons.store, color: AppColors.primaryAccent)
                                : null,
                          ),
                          const SizedBox(width: AppDimensions.spacing16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  trackingData.branch.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: AppDimensions.fontSize16,
                                  ),
                                ),
                                if (trackingData.branch.address != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    trackingData.branch.address!,
                                    style: const TextStyle(
                                      color: AppColors.grey600,
                                      fontSize: AppDimensions.fontSize14,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHorizontalStepper(BuildContext context, String currentStatus) {
    final steps = ['pending', 'confirmed', 'preparing', 'ready', 'out_for_delivery', 'delivered'];
    final labels = [
      context.tr('status_pending'),
      context.tr('status_confirmed'),
      context.tr('stepper_cooking'),
      context.tr('status_ready'),
      context.tr('stepper_on_way'),
      context.tr('status_delivered')
    ];
    
    int currentIndex = steps.indexOf(currentStatus);
    if (currentIndex == -1) currentIndex = 0; // Default or cancelled

    return Row(
      children: List.generate(steps.length, (index) {
        final isCompleted = index <= currentIndex;
        final isLast = index == steps.length - 1;

        return Expanded(
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted ? AppColors.primaryAccent : AppColors.grey300,
                    ),
                    child: Icon(
                      _getStepIcon(steps[index]),
                      color: AppColors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacing8),
                  Text(
                    labels[index],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
                      color: isCompleted ? AppColors.primaryText : AppColors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    height: 2,
                    color: index < currentIndex ? AppColors.primaryAccent : AppColors.grey300,
                    margin: const EdgeInsets.only(bottom: 20, left: 4, right: 4),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  IconData _getStepIcon(String status) {
    switch (status) {
      case 'pending': return Icons.access_time;
      case 'confirmed': return Icons.check_circle_outline;
      case 'preparing': return Icons.soup_kitchen;
      case 'ready': return Icons.inventory_2_outlined;
      case 'out_for_delivery': return Icons.delivery_dining;
      case 'delivered': return Icons.home;
      default: return Icons.circle;
    }
  }

  Widget _buildTimelineItem(String title, DateTime? time, {required bool isCompleted, required bool isLast}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? AppColors.primaryAccent : AppColors.grey300,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: AppColors.grey200,
              ),
          ],
        ),
        const SizedBox(width: AppDimensions.spacing16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: AppDimensions.fontSize14,
                  fontWeight: isCompleted ? FontWeight.w600 : FontWeight.normal,
                  color: isCompleted ? AppColors.primaryText : AppColors.grey,
                ),
              ),
              if (time != null)
                Text(
                  DateFormat('MMM d, h:mm a').format(time),
                  style: const TextStyle(
                    fontSize: AppDimensions.fontSize12,
                    color: AppColors.grey,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
