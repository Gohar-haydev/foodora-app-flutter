import 'package:equatable/equatable.dart';
import 'package:foodora/features/menu/domain/entities/menu_item_entity.dart';
import 'package:foodora/features/menu/domain/entities/addon_entity.dart';

class CartItemEntity extends Equatable {
  final String id;
  final MenuItemEntity menuItem;
  final int quantity;
  final List<AddonEntity> selectedAddons;
  final double totalPrice;

  const CartItemEntity({
    required this.id,
    required this.menuItem,
    required this.quantity,
    required this.selectedAddons,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [id, menuItem, quantity, selectedAddons, totalPrice];

  CartItemEntity copyWith({
    String? id,
    MenuItemEntity? menuItem,
    int? quantity,
    List<AddonEntity>? selectedAddons,
    double? totalPrice,
  }) {
    return CartItemEntity(
      id: id ?? this.id,
      menuItem: menuItem ?? this.menuItem,
      quantity: quantity ?? this.quantity,
      selectedAddons: selectedAddons ?? this.selectedAddons,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}
