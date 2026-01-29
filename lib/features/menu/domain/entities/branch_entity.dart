class BranchEntity {
  final int id;
  final String name;
  final String code;
  final String address;
  final String phone;
  final String? imageUrl;

  BranchEntity({
    required this.id,
    required this.name,
    required this.code,
    required this.address,
    required this.phone,
    this.imageUrl,
  });
}
