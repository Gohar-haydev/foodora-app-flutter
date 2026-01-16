class FavoriteRequestModel {
  final int menuItemId;

  FavoriteRequestModel({required this.menuItemId});

  Map<String, dynamic> toJson() {
    return {
      'menu_item_id': menuItemId,
    };
  }
}
