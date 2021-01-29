class MealModel {
  int id;
  String name;
  int status;
  String details;
  int duration;
  int menuId;
  String subtitle;
  int type;
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
      this.type,
      this.menuId,
      this.picture,
      this.price,
      this.status});

  factory MealModel.fromMap(Map item) {
    return MealModel(
        id: item['id'],
        name: item['name'],
        details: item['details'],
        duration: item['duration'],
        subtitle: item['subtitle'],
        picture: item['picture'],
        menuId: item['menu_id'],
        price: item['price'],
        salePrice: item['sale_price'],
        status: item['status'],
        type: item['type']);
  }
  show() {
    print('id: $id');
    print('name: $name');
    print('status: $status');
    print('details: $details');
    print('duration: $duration');
    print('subtitle: $subtitle');
    print('picture: $picture');
    print('menuId: $menuId');
    print('price: $price');
    print('salePrice: $salePrice');
    print('type: $type');
  }
}
