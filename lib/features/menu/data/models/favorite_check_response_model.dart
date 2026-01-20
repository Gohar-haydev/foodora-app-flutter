class FavoriteCheckResponseModel {
  final bool success;
  final String message;
  final FavoriteStatusData data;

  FavoriteCheckResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory FavoriteCheckResponseModel.fromJson(Map<String, dynamic> json) {
    return FavoriteCheckResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: FavoriteStatusData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class FavoriteStatusData {
  final bool isFavorite;
  final int menuItemId;

  FavoriteStatusData({
    required this.isFavorite,
    required this.menuItemId,
  });

  factory FavoriteStatusData.fromJson(Map<String, dynamic> json) {
    return FavoriteStatusData(
      isFavorite: json['is_favorite'] as bool,
      menuItemId: json['menu_item_id'] as int,
    );
  }
}
