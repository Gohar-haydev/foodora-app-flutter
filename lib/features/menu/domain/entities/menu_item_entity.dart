import 'package:foodora/features/menu/domain/entities/addon_entity.dart';

class MenuItemEntity {
  final int id;
  final int branchId;
  final int categoryId;
  final String name;
  final String slug;
  final String description;
  final String price;
  final String? image;
  final bool isActive;
  final int sortOrder;
  final String? categoryName;

  MenuItemEntity({
    required this.id,
    required this.branchId,
    required this.categoryId,
    required this.name,
    required this.slug,
    required this.description,
    required this.price,
    this.image,
    required this.isActive,
    required this.sortOrder,
    this.categoryName,
    this.ingredients,
    this.addons,
  });

  final List<String>? ingredients;
  final List<AddonEntity>? addons;
}
