import 'package:equatable/equatable.dart';
import '../../data/models/branch_info_model.dart';

class OrderTrackingEntity extends Equatable {
  final String orderNumber;
  final String status;
  final String statusLabel;
  final String deliveryType;
  final BranchInfoModel branch;
  final TrackingTimelineEntity timeline;
  final String? cancellationReason;

  const OrderTrackingEntity({
    required this.orderNumber,
    required this.status,
    required this.statusLabel,
    required this.deliveryType,
    required this.branch,
    required this.timeline,
    this.cancellationReason,
  });

  @override
  List<Object?> get props => [
        orderNumber,
        status,
        statusLabel,
        deliveryType,
        branch,
        timeline,
        cancellationReason,
      ];
}

class TrackingTimelineEntity extends Equatable {
  final DateTime? placedAt;
  final DateTime? confirmedAt;
  final DateTime? preparingAt;
  final DateTime? readyAt;
  final DateTime? deliveredAt;
  final DateTime? cancelledAt;

  const TrackingTimelineEntity({
    this.placedAt,
    this.confirmedAt,
    this.preparingAt,
    this.readyAt,
    this.deliveredAt,
    this.cancelledAt,
  });

  @override
  List<Object?> get props => [
        placedAt,
        confirmedAt,
        preparingAt,
        readyAt,
        deliveredAt,
        cancelledAt,
      ];
}
