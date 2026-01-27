import 'package:foodora/features/menu/domain/entities/menu_item_entity.dart';
import 'package:foodora/features/menu/data/models/addon_model.dart';

class MenuItemModel extends MenuItemEntity {
  MenuItemModel({
    required super.id,
    required super.branchId,
    required super.categoryId,
    required super.name,
    required super.slug,
    required super.description,
    required super.price,
    super.image,
    required super.isActive,
    required super.sortOrder,
    super.categoryName,
    super.ingredients,
    List<AddonModel>? super.addons,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id'] as int,
      branchId: (json['branch_id'] as int?) ?? 0,
      categoryId: (json['category_id'] as int?) ?? 0,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: (json['description'] as String?) ?? '',
      price: json['price']?.toString() ?? '0.00',
      image: json['image'] as String?,
      isActive: (json['is_active'] as bool?) ?? true,
      sortOrder: (json['sort_order'] as int?) ?? 0,
      categoryName: json['category'] != null ? json['category']['name'] as String? : null,
      ingredients: (json['ingredients'] as List<dynamic>?)?.map((e) => e as String).toList(),
      addons: (json['addons'] as List<dynamic>?)
          ?.map((e) => AddonModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branchId,
      'category_id': categoryId,
      'name': name,
      'slug': slug,
      'description': description,
      'price': price,
      'image': image,
      'is_active': isActive,
      'sort_order': sortOrder,
      'category_name': categoryName,
      'ingredients': ingredients,
      'addons': addons?.map((addon) => (addon as AddonModel).toJson()).toList(),
    };
  }
}
