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
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      imageUrl: json['image_url'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, name, address, phone, imageUrl];
}
