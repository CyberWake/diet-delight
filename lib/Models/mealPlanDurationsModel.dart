class DurationModel {
  int id;
  String title;
  int duration;
  int order;
  String subTitle;
  String details;
  String picture;

  DurationModel(
      {this.id,
      this.title,
      this.duration,
      this.order,
      this.subTitle,
      this.details,
      this.picture});

  factory DurationModel.fromMap(Map item) {
    return DurationModel(
      id: item['id'],
      title: item['title'],
      duration: item['duration'],
      subTitle: item['subtitle'],
      details: item['details'],
      order: item['order'],
      picture: item['picture'],
    );
  }

  show() {
    print('id: $id');
    print('title: $title');
    print('duration: $duration');
    print('details: $details');
    print('subTitle: $subTitle');
    print('picture: $picture');
    print('order: $order');
  }
}
