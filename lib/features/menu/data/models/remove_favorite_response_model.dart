import 'package:foodora/features/menu/domain/entities/favorite_entity.dart';

class RemoveFavoriteResponseModel extends FavoriteEntity {
  RemoveFavoriteResponseModel({
    required super.message,
  }) : super(
          menuItemId: 0,
        );

  factory RemoveFavoriteResponseModel.fromJson(Map<String, dynamic> json) {
    return RemoveFavoriteResponseModel(
      message: json['message'] as String,
    );
  }
}
