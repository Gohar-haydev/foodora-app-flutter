import 'package:foodora/features/menu/domain/entities/favorite_entity.dart';

class FavoriteResponseModel extends FavoriteEntity {
  FavoriteResponseModel({
    required super.menuItemId,
    required super.message,
  });

  factory FavoriteResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return FavoriteResponseModel(
      menuItemId: data['menu_item_id'] as int,
      message: data['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menu_item_id': menuItemId,
      'message': message,
    };
  }
}
