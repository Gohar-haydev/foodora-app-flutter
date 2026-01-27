import 'package:foodora/features/menu/domain/entities/favorite_item_entity.dart';

class CategoryInfoModel extends CategoryInfo {
  CategoryInfoModel({
    required super.id,
    required super.name,
  });

  factory CategoryInfoModel.fromJson(Map<String, dynamic> json) {
    return CategoryInfoModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class BranchInfoModel extends BranchInfo {
  BranchInfoModel({
    required super.id,
    required super.name,
    required super.code,
  });

  factory BranchInfoModel.fromJson(Map<String, dynamic> json) {
    return BranchInfoModel(
      id: json['id'] as int,
      name: json['name'] as String,
      code: json['code'] as String,
    );
  }
}

class FavoriteItemModel extends FavoriteItemEntity {
  FavoriteItemModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.description,
    required super.price,
    super.formattedPrice,
    super.image,
    super.imageUrl,
    required super.category,
    required super.branch,
    required super.addedAt,
  });

  factory FavoriteItemModel.fromJson(Map<String, dynamic> json) {
    return FavoriteItemModel(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: (json['description'] as String?) ?? '',
      price: json['price']?.toString() ?? '0.00',
      formattedPrice: json['formatted_price'] as String?,
      image: json['image'] as String?,
      imageUrl: json['image_url'] as String?,
      category: CategoryInfoModel.fromJson(json['category'] as Map<String, dynamic>),
      branch: BranchInfoModel.fromJson(json['branch'] as Map<String, dynamic>),
      addedAt: DateTime.parse(json['added_at'] as String),
    );
  }
}
