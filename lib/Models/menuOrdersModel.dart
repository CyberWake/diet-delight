import 'package:diet_delight/services/apiCalls.dart';

class MenuOrderModel {
  int id;
  int foodItemId;
  int foodItemCategoryId;
  int mealPurchaseId;
  int status;
  String menuItemDate;
  int menuItemDay;
  String foodItemName;
  String note;
  String deliveryAddress;

  MenuOrderModel(
      {this.id,
      this.foodItemId,
      this.foodItemCategoryId,
      this.mealPurchaseId,
      this.status = 0,
      this.menuItemDay,
      this.menuItemDate,
      this.foodItemName,
      this.note,
      this.deliveryAddress});

  factory MenuOrderModel.fromMap(Map item) {
    return MenuOrderModel(
        id: item['id'],
        foodItemId: item['menu_item_id'],
        foodItemCategoryId: item['menu_category_id'],
        mealPurchaseId: item['meal_purchase_id'],
        status: item['status'],
        menuItemDay: item['menu_item_day'],
        menuItemDate: item['menu_item_date'],
        foodItemName: item['menu_item_name'],
        deliveryAddress: item['delivery_address']);
  }
  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'user_id': Api.userInfo.id,
      'menu_item_id': this.foodItemId,
      'menu_category_id': this.foodItemCategoryId,
      'meal_purchase_id': this.mealPurchaseId,
      'status': this.status,
      'menu_item_date': this.menuItemDate,
      'menu_item_day': this.menuItemDay,
      'menu_item_name': this.foodItemName,
      'first_name': Api.userInfo.firstName,
      'last_name': Api.userInfo.lastName,
      'mobile': Api.userInfo.mobile,
      'delivery_address': this.deliveryAddress,
      'notes': this.note
    } as Map<String, dynamic>;
  }
}
