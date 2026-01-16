import 'package:equatable/equatable.dart';

class AddonEntity extends Equatable {
  final int id;
  final String name;
  final String price;
  final bool isActive;
  final int sortOrder;
  final String formattedPrice;

  const AddonEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.isActive,
    required this.sortOrder,
    required this.formattedPrice,
  });

  @override
  List<Object?> get props => [id, name, price, isActive, sortOrder, formattedPrice];
}
