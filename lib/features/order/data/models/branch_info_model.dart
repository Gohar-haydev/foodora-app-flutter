import 'package:equatable/equatable.dart';

class BranchInfoModel extends Equatable {
  final int id;
  final String name;
  final String? address;
  final String? phone;
  final String? imageUrl;

  const BranchInfoModel({
    required this.id,
    required this.name,
    this.address,
    this.phone,
    this.imageUrl,
  });

  factory BranchInfoModel.fromJson(Map<String, dynamic> json) {
    return BranchInfoModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? 'Unknown Branch',
      address: json['address']?.toString(),
      phone: json['phone']?.toString(),
      imageUrl: json['image_url']?.toString(),
    );
  }

  @override
  List<Object?> get props => [id, name, address, phone, imageUrl];
}
