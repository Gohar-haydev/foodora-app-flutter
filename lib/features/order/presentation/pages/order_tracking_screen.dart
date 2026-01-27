import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:foodora/core/constants/app_constants.dart';
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
          style: TextStyle(
            color: AppColors.primaryText,
            fontWeight: FontWeight.w600,
            fontSize: AppDimensions.getH3Size(context),
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.primaryText,
            size: AppDimensions.responsiveIconSize(context, mobile: 24, tablet: 28),
          ),
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
                      Icon(
                        Icons.error_outline,
                        size: AppDimensions.responsiveIconSize(context, mobile: 48, tablet: 60),
                        color: AppColors.error,
                      ),
                      SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
                      Text(
                        viewModel.errorMessage!,
                        style: TextStyle(
                          color: AppColors.error,
                          fontSize: AppDimensions.getBodySize(context),
                        ),
                      ),
                      SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
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
                return Center(
                  child: Text(
                    context.tr('no_tracking_data'),
                    style: TextStyle(
                      fontSize: AppDimensions.getBodySize(context),
                    ),
                  ),
                );
              }

              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: AppDimensions.getMaxContentWidth(context),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(
                      AppDimensions.getResponsiveHorizontalPadding(context),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Order Number and Status
                        Center(
                          child: Column(
                            children: [
                              Text(
                                '${context.tr('order_number')} #${trackingData.orderNumber}',
                                style: TextStyle(
                                  fontSize: AppDimensions.getH3Size(context),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 8, tablet: 10)),
                              Text(
                                trackingData.statusLabel,
                                style: TextStyle(
                                  fontSize: AppDimensions.getBodySize(context),
                                  color: AppColors.primaryAccent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 32, tablet: 40)),

                        // Horizontal Stepper
                        _buildHorizontalStepper(context, trackingData.status),
                        
                        SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 32, tablet: 40)),

                        // Estimated Delivery or Current Status Info
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(
                            AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryText.withValues(alpha: 0.05),
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
                                style: TextStyle(
                                  fontSize: AppDimensions.getBodySize(context),
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryText,
                                ),
                              ),
                              SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
                              _buildTimelineItem(
                                context,
                                context.tr('timeline_placed'),
                                trackingData.timeline.placedAt,
                                isCompleted: trackingData.timeline.placedAt != null,
                                isLast: false,
                              ),
                              _buildTimelineItem(
                                context,
                                context.tr('status_confirmed'),
                                trackingData.timeline.confirmedAt,
                                isCompleted: trackingData.timeline.confirmedAt != null,
                                isLast: false,
                              ),
                              _buildTimelineItem(
                                context,
                                context.tr('status_preparing'),
                                trackingData.timeline.preparingAt,
                                isCompleted: trackingData.timeline.preparingAt != null,
                                isLast: false,
                              ),
                              _buildTimelineItem(
                                context,
                                context.tr('status_ready'),
                                trackingData.timeline.readyAt,
                                isCompleted: trackingData.timeline.readyAt != null,
                                isLast: false,
                              ),
                              _buildTimelineItem(
                                context,
                                trackingData.deliveryType == 'pickup' ? context.tr('timeline_ready_pickup') : context.tr('status_out_for_delivery'),
                                trackingData.deliveryType == 'pickup' ? trackingData.timeline.readyAt : null, // Logic might differ
                                isCompleted: trackingData.status == 'delivered' || trackingData.status == 'out_for_delivery',
                                isLast: false,
                              ),
                              _buildTimelineItem(
                                context,
                                context.tr('status_delivered'),
                                trackingData.timeline.deliveredAt,
                                isCompleted: trackingData.timeline.deliveredAt != null,
                                isLast: true,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 24, tablet: 32)),

                        // Branch Info
                        Text(
                          context.tr('branch_information'),
                          style: TextStyle(
                            fontSize: AppDimensions.getH3Size(context),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 12, tablet: 16)),
                        Container(
                          padding: EdgeInsets.all(
                            AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryText.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                               Container(
                                width: AppDimensions.responsive(context, mobile: 50, tablet: 60),
                                height: AppDimensions.responsive(context, mobile: 50, tablet: 60),
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
                                    ? Icon(
                                        Icons.store,
                                        color: AppColors.primaryAccent,
                                        size: AppDimensions.responsiveIconSize(context, mobile: 24, tablet: 28),
                                      )
                                    : null,
                              ),
                              SizedBox(width: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      trackingData.branch.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: AppDimensions.getBodySize(context),
                                      ),
                                    ),
                                    if (trackingData.branch.address != null) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        trackingData.branch.address!,
                                        style: TextStyle(
                                          color: AppColors.grey600,
                                          fontSize: AppDimensions.getSmallSize(context),
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
                  ),
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
                    width: AppDimensions.responsive(context, mobile: 30, tablet: 36),
                    height: AppDimensions.responsive(context, mobile: 30, tablet: 36),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted ? AppColors.primaryAccent : AppColors.grey300,
                    ),
                    child: Icon(
                      _getStepIcon(steps[index]),
                      color: AppColors.white,
                      size: AppDimensions.responsiveIconSize(context, mobile: 16, tablet: 20),
                    ),
                  ),
                  SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 8, tablet: 10)),
                  Text(
                    labels[index],
                    style: TextStyle(
                      fontSize: AppDimensions.responsive(context, mobile: 10, tablet: 12),
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

  Widget _buildTimelineItem(BuildContext context, String title, DateTime? time, {required bool isCompleted, required bool isLast}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: AppDimensions.responsive(context, mobile: 12, tablet: 16),
              height: AppDimensions.responsive(context, mobile: 12, tablet: 16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? AppColors.primaryAccent : AppColors.grey300,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: AppDimensions.responsive(context, mobile: 40, tablet: 48),
                color: AppColors.grey200,
              ),
          ],
        ),
        SizedBox(width: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: AppDimensions.getSmallSize(context),
                  fontWeight: isCompleted ? FontWeight.w600 : FontWeight.normal,
                  color: isCompleted ? AppColors.primaryText : AppColors.grey,
                ),
              ),
              if (time != null)
                Text(
                  DateFormat('MMM d, h:mm a').format(time),
                  style: TextStyle(
                    fontSize: AppDimensions.responsive(context, mobile: 12, tablet: 14),
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
