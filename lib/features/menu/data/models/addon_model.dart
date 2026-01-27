import 'package:foodora/features/menu/domain/entities/addon_entity.dart';

class AddonModel extends AddonEntity {
  const AddonModel({
    required super.id,
    required super.name,
    required super.price,
    required super.isActive,
    required super.sortOrder,
    required super.formattedPrice,
  });

  factory AddonModel.fromJson(Map<String, dynamic> json) {
    return AddonModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      isActive: json['is_active'] ?? false,
      sortOrder: json['sort_order'] ?? 0,
       formattedPrice: json['formatted_price'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'is_active': isActive,
      'sort_order': sortOrder,
      'formatted_price': formattedPrice,
    };
  }
}
