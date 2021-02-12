class FoodItemModel {
  int orderItemId;
  bool isVeg;
  String foodName;
  bool isSelected;
  int id;
  int categoryId;
  int menuId;
  String picture;
  String date;
  int day;
  String des;
  FoodItemModel(
      {this.foodName,
      this.orderItemId,
      this.isVeg = true,
      this.isSelected = false,
      this.id,
      this.categoryId,
      this.menuId,
      this.day,
      this.date,
      this.des,
      this.picture});
  factory FoodItemModel.fromMap(Map item) {
    return FoodItemModel(
      id: item['id'],
      foodName: item['name'],
      categoryId: item['menu_category_id'],
      menuId: item['menu_Id'],
      picture: item['picture'],
      isVeg: item['veg'] == 1 ? true : false,
      day: item['day'],
      date: item['date'],
    );
  }

  change(bool isSel) {
    this.isSelected = isSel;
  }

  updateOrderItemId(int id) {
    this.orderItemId = id;
  }
}
