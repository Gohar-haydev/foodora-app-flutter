class CategoryEntity {
  final int id;
  final String name;
  final String description;
  final String? image;

  CategoryEntity({
    required this.id,
    required this.name,
    required this.description,
    this.image,
  });
}
