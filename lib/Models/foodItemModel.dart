class FoodItemModel {
  bool isVeg;
  String foodName;
  bool isSelected;
  int id;
  int categoryId;
  int menuId;
  String picture;
  FoodItemModel(
      {this.foodName,
      this.isVeg = true,
      this.isSelected = false,
      this.id,
      this.categoryId,
      this.menuId,
      this.picture});
  factory FoodItemModel.fromMap(Map item) {
    return FoodItemModel(
      id: item['id'],
      foodName: item['name'],
      categoryId: item['categoryId'],
      menuId: item['menuId'],
      picture: item['picture'],
    );
  }

  change(bool isSel) {
    this.isSelected = isSel;
  }
}
