class FoodItemModel {
  bool isVeg;
  String foodName;
  bool isSelected;
  FoodItemModel({this.foodName, this.isVeg, this.isSelected});
  change(bool isSel) {
    this.isSelected = isSel;
  }
}
