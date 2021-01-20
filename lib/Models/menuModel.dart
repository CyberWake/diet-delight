class MenuModel {
  int id;
  String name;

  MenuModel({this.id, this.name});

  factory MenuModel.fromMap(Map item) {
    return MenuModel(id: item['id'], name: item['name']);
  }
  show() {
    print('id: $id');
    print('name: $name');
  }
}
