class MenuModel {
  int id;
  String name;
  String description;

  MenuModel(
      {this.id,
      this.name,
      this.description =
          'Some description Some description Some description Some description'});

  factory MenuModel.fromMap(Map item) {
    return MenuModel(id: item['id'], name: item['name']);
  }
  show() {
    print('id: $id');
    print('name: $name');
  }
}
