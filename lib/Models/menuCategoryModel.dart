class MenuCategoryModel {
  int id;
  int menuId;
  int maxBuy;
  int parent;
  String name;

  MenuCategoryModel(
      {this.id, this.name, this.menuId, this.parent, this.maxBuy});

  factory MenuCategoryModel.fromMap(Map item) {
    return MenuCategoryModel(
      id: item['id'],
      name: item['name'],
      menuId: item['menu_id'],
      parent: item['parent'],
      maxBuy: item['max_buy'],
    );
  }
  show() {
    print('id: $id');
    print('name: $name');
    print('menuId: $menuId');
    print('parent: $parent');
    print('maxBuy: $maxBuy');
  }

  showNew() {
    print(
        'id: $id\tname: $name\tmenuId: $menuId\tparent: $parent\tmaxBuy: $maxBuy');
  }
}
