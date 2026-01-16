import 'package:foodora/features/menu/domain/entities/favorite_entity.dart';

class RemoveFavoriteResponseModel extends FavoriteEntity {
  RemoveFavoriteResponseModel({
    required String message,
  }) : super(
          menuItemId: 0, // Not relevant for delete response
          message: message,
        );

  factory RemoveFavoriteResponseModel.fromJson(Map<String, dynamic> json) {
    return RemoveFavoriteResponseModel(
      message: json['message'] as String,
    );
  }
}
