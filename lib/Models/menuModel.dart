class MenuModel {
  int id;
  String name;
  String description;
  String picture;

  MenuModel(
      {this.id,
      this.name,
      this.description =
          'Some description Some description Some description Some description',
      this.picture});

  factory MenuModel.fromMap(Map item) {
    return MenuModel(
        id: item['id'],
        name: item['name'],
        description: item['details'] ??
            'Some description Some description Some description Some description',
        picture: item['picture']);
  }
  show() {
    print('id: $id');
    print('name: $name');
    print('description: $description');
    print('picture: $picture');
  }
}
