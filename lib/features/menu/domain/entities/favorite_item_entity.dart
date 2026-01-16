class CategoryInfo {
  final int id;
  final String name;

  CategoryInfo({
    required this.id,
    required this.name,
  });
}

class BranchInfo {
  final int id;
  final String name;
  final String code;

  BranchInfo({
    required this.id,
    required this.name,
    required this.code,
  });
}

class FavoriteItemEntity {
  final int id;
  final String name;
  final String slug;
  final String description;
  final String price;
  final String? formattedPrice;
  final String? image;
  final String? imageUrl;
  final CategoryInfo category;
  final BranchInfo branch;
  final DateTime addedAt;

  FavoriteItemEntity({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.price,
    this.formattedPrice,
    this.image,
    this.imageUrl,
    required this.category,
    required this.branch,
    required this.addedAt,
  });
}
