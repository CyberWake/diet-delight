import 'package:diet_delight/Models/foodItemModel.dart';

class AddFavouritesModel {
  int id;
  int userId;
  int menuItemId;
  FoodItemModel menuItem;

  AddFavouritesModel({this.id, this.userId, this.menuItemId, this.menuItem});

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'user_id': this.userId,
      'menu_item_id': this.menuItemId,
      'menu_item': this.menuItem
    } as Map<String, dynamic>;
  }

  factory AddFavouritesModel.fromMap(Map item) {
    return AddFavouritesModel(
        id: item['id'],
        userId: item['user_id'],
        menuItemId: item['menu_item_id'],
        menuItem: FoodItemModel.fromMap(item['menu_item']));
  }

  show() {
    print('id: $id');
    print('userId: $userId');
    print('menuItemId: $menuItemId');
    print('menuItem: $menuItem');
  }
}
