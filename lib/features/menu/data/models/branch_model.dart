import 'package:foodora/features/menu/domain/entities/branch_entity.dart';

class BranchModel extends BranchEntity {
  BranchModel({
    required super.id,
    required super.name,
    required super.code,
    required super.address,
    required super.phone,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      address: json['address'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'address': address,
      'phone': phone,
    };
  }
}
