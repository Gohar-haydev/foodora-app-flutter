import 'package:foodora/features/menu/domain/entities/addon_entity.dart';

class AddonModel extends AddonEntity {
  const AddonModel({
    required int id,
    required String name,
    required String price,
    required bool isActive,
    required int sortOrder,
    required String formattedPrice,
  }) : super(
          id: id,
          name: name,
          price: price,
          isActive: isActive,
          sortOrder: sortOrder,
          formattedPrice: formattedPrice,
        );

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
