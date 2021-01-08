class ConsultationModel {
  int id;
  String name;
  int status;
  String details;
  int duration;
  int order;
  String subtitle;
  String picture;
  String price;
  String salePrice;

  ConsultationModel(
      {this.id,
      this.name,
      this.status,
      this.details,
      this.duration,
      this.order,
      this.subtitle,
      this.picture,
      this.price,
      this.salePrice});

  factory ConsultationModel.fromMap(Map item) {
    return ConsultationModel(
        id: item['id'],
        name: item['name'],
        status: item['status'],
        details: item['details'],
        duration: item['duration'],
        order: item['order'],
        subtitle: item['subtitle'],
        picture: item['picture'],
        price: item['price'],
        salePrice: item['sale_price']);
  }
  show() {
    print('id: $id');
    print('name: $name');
    print('status: $status');
    print('details: $details');
    print('duration: $duration');
    print('order: $order');
    print('subtitle: $subtitle');
    print('picture: $picture');
    print('price: $price');
    print('salePrice: $salePrice');
  }
}
