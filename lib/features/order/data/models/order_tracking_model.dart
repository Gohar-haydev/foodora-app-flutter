import 'package:foodora/features/order/data/models/branch_info_model.dart';
import '../../domain/entities/order_tracking_entity.dart';

class OrderTrackingResponseModel {
  final bool success;
  final String message;
  final OrderTrackingModel data;

  OrderTrackingResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory OrderTrackingResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderTrackingResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: OrderTrackingModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class OrderTrackingModel {
  final String orderNumber;
  final String status;
  final String statusLabel;
  final String deliveryType;
  final BranchInfoModel branch;
  final TrackingTimelineModel timeline;
  final String? cancellationReason;

  OrderTrackingModel({
    required this.orderNumber,
    required this.status,
    required this.statusLabel,
    required this.deliveryType,
    required this.branch,
    required this.timeline,
    this.cancellationReason,
  });

  factory OrderTrackingModel.fromJson(Map<String, dynamic> json) {
    return OrderTrackingModel(
      orderNumber: json['order_number'] as String,
      status: json['status'] as String,
      statusLabel: json['status_label'] as String,
      deliveryType: json['delivery_type'] as String,
      branch: BranchInfoModel.fromJson(json['branch'] as Map<String, dynamic>),
      timeline: TrackingTimelineModel.fromJson(json['timeline'] as Map<String, dynamic>),
      cancellationReason: json['cancellation_reason'] as String?,
    );
  }

  OrderTrackingEntity toEntity() {
    return OrderTrackingEntity(
      orderNumber: orderNumber,
      status: status,
      statusLabel: statusLabel,
      deliveryType: deliveryType,
      branch: branch,
      timeline: timeline.toEntity(),
      cancellationReason: cancellationReason,
    );
  }
}

class TrackingTimelineModel {
  final String? placedAt;
  final String? confirmedAt;
  final String? preparingAt;
  final String? readyAt;
  final String? deliveredAt;
  final String? cancelledAt;

  TrackingTimelineModel({
    this.placedAt,
    this.confirmedAt,
    this.preparingAt,
    this.readyAt,
    this.deliveredAt,
    this.cancelledAt,
  });

  factory TrackingTimelineModel.fromJson(Map<String, dynamic> json) {
    return TrackingTimelineModel(
      placedAt: json['placed_at'] as String?,
      confirmedAt: json['confirmed_at'] as String?,
      preparingAt: json['preparing_at'] as String?,
      readyAt: json['ready_at'] as String?,
      deliveredAt: json['delivered_at'] as String?,
      cancelledAt: json['cancelled_at'] as String?,
    );
  }

  TrackingTimelineEntity toEntity() {
    return TrackingTimelineEntity(
      placedAt: placedAt != null ? DateTime.parse(placedAt!) : null,
      confirmedAt: confirmedAt != null ? DateTime.parse(confirmedAt!) : null,
      preparingAt: preparingAt != null ? DateTime.parse(preparingAt!) : null,
      readyAt: readyAt != null ? DateTime.parse(readyAt!) : null,
      deliveredAt: deliveredAt != null ? DateTime.parse(deliveredAt!) : null,
      cancelledAt: cancelledAt != null ? DateTime.parse(cancelledAt!) : null,
    );
  }
}
