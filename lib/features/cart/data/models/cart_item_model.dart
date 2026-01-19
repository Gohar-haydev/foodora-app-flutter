import 'package:foodora/features/cart/domain/entities/cart_item_entity.dart';
import 'package:foodora/features/menu/data/models/menu_item_model.dart';
import 'package:foodora/features/menu/data/models/addon_model.dart';

class CartItemModel {
  final String id;
  final MenuItemModel menuItem;
  final int quantity;
  final List<AddonModel> selectedAddons;
  final double totalPrice;

  const CartItemModel({
    required this.id,
    required this.menuItem,
    required this.quantity,
    required this.selectedAddons,
    required this.totalPrice,
  });

  // Convert from Entity
  factory CartItemModel.fromEntity(CartItemEntity entity) {
    return CartItemModel(
      id: entity.id,
      menuItem: MenuItemModel(
        id: entity.menuItem.id,
        branchId: entity.menuItem.branchId,
        categoryId: entity.menuItem.categoryId,
        name: entity.menuItem.name,
        slug: entity.menuItem.slug,
        description: entity.menuItem.description,
        price: entity.menuItem.price,
        image: entity.menuItem.image,
        isActive: entity.menuItem.isActive,
        sortOrder: entity.menuItem.sortOrder,
        categoryName: entity.menuItem.categoryName,
        ingredients: entity.menuItem.ingredients,
        addons: entity.menuItem.addons?.map((addon) => AddonModel(
          id: addon.id,
          name: addon.name,
          price: addon.price,
          isActive: addon.isActive,
          sortOrder: addon.sortOrder,
          formattedPrice: addon.formattedPrice,
        )).toList(),
      ),
      quantity: entity.quantity,
      selectedAddons: entity.selectedAddons.map((addon) => AddonModel(
        id: addon.id,
        name: addon.name,
        price: addon.price,
        isActive: addon.isActive,
        sortOrder: addon.sortOrder,
        formattedPrice: addon.formattedPrice,
      )).toList(),
      totalPrice: entity.totalPrice,
    );
  }

  // Convert to Entity
  CartItemEntity toEntity() {
    return CartItemEntity(
      id: id,
      menuItem: menuItem,
      quantity: quantity,
      selectedAddons: selectedAddons,
      totalPrice: totalPrice,
    );
  }

  // From JSON
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as String,
      menuItem: MenuItemModel.fromJson(json['menu_item'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      selectedAddons: (json['selected_addons'] as List<dynamic>)
          .map((addon) => AddonModel.fromJson(addon as Map<String, dynamic>))
          .toList(),
      totalPrice: (json['total_price'] as num).toDouble(),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'menu_item': menuItem.toJson(),
      'quantity': quantity,
      'selected_addons': selectedAddons.map((addon) => addon.toJson()).toList(),
      'total_price': totalPrice,
    };
  }
}
