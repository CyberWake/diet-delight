class MealModel {
  int id;
  String name;
  int status;
  String details;
  int duration;
  int menuId;
  String subtitle;
  String picture;
  String price;
  String salePrice;

  MealModel(
      {this.id,
      this.name,
      this.subtitle,
      this.salePrice,
      this.details,
      this.duration,
      this.menuId,
      this.picture,
      this.price});

  factory MealModel.fromMap(Map item) {
    return MealModel(
        id: item['id'],
        name: item['name'],
        details: item['details'],
        duration: item['duration'],
        subtitle: item['subtitle'],
        picture: item['picture'],
        price: item['price'],
        salePrice: item['sale_price']);
  }
  show() {
    print('id: $id');
    print('name: $name');
    print('details: $details');
    print('duration: $duration');
    print('subtitle: $subtitle');
    print('picture: $picture');
    print('price: $price');
    print('salePrice: $salePrice');
  }
}
