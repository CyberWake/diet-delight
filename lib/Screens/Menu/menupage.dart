import 'package:cached_network_image/cached_network_image.dart';
import 'package:diet_delight/Models/export_models.dart';
import 'package:diet_delight/Screens/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Menu extends StatefulWidget {
  final MenuModel menu;
  Menu({this.menu});
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _scrollController = new ScrollController();
  TabController _pageController;
  List<MenuModel> menuItems = List();
  List<MenuCategoryModel> categoryItems = List();
  List<MenuCategoryModel> mainCategoryItems = List();
  List<MenuCategoryModel> tempCategoryItems = List();
  List<List<MenuCategoryModel>> subCategoryItems = List();
  List<List<FoodItemModel>> foodItems = List();
  List<FoodItemModel> expansionFoodItems = List();
  List<List> favourites = List();
  List<int> favPressed = List();
  final _apiCall = Api.instance;
  int menuId = 0;
  bool isLoaded = false;
  int itemIndex = 0;

  get pageViewTabSelected => null;

  void initState() {
    super.initState();
    menuId = widget.menu.id;
    _pageController = TabController(length: categoryItems.length, vsync: this);
    getData();
  }

  getData() async {
    await getFavourites();
    await getMenuCategories(menuId);
  }

  getMenuCategories(int menuId) async {
    categoryItems = [];
    foodItems = [];
    setState(() {
      isLoaded = false;
    });
    categoryItems = await _apiCall.getMenuCategories(menuId);
    for (int i = 0; i < categoryItems.length; i++) {
      categoryItems[i].showNew();
      if (categoryItems[i].parent == 0) {
        mainCategoryItems.add(categoryItems[i]);
        tempCategoryItems = [];
        if (i + 1 < categoryItems.length) {
          if (categoryItems[i + 1].parent == 0) {
            subCategoryItems.add(tempCategoryItems);
          }
        }
        if (i + 1 == categoryItems.length) {
          subCategoryItems.add(tempCategoryItems);
        }
      } else {
        tempCategoryItems.add(categoryItems[i]);
        if (i + 1 < categoryItems.length) {
          if (categoryItems[i].parent != categoryItems[i + 1].parent) {
            subCategoryItems.add(tempCategoryItems);
            tempCategoryItems = [];
          } else {
            continue;
          }
        }
        if (i + 1 == categoryItems.length) {
          subCategoryItems.add(tempCategoryItems);
          tempCategoryItems = [];
        }
      }
    }
    _pageController =
        TabController(length: mainCategoryItems.length, vsync: this);
    if (categoryItems.isNotEmpty) {
      for (int i = 0; i < categoryItems.length;) {
        foodItems.add(await _apiCall
            .getMenuCategoryFoodItems(
                menuId.toString(), categoryItems[i].id.toString())
            .whenComplete(() => i++));
      }
    }
    print('subCategoryItems.length: ${subCategoryItems.length}');
    print('mainCategoryItems.length: ${mainCategoryItems.length}');
    print('categoryItems.length: ${categoryItems.length}');
    subCategoryItems.forEach((element) {
      print(element.length);
    });
    if (mounted) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  getFoodItems(int categoryId) async {
    expansionFoodItems = await _apiCall.getMenuCategoryFoodItems(
        menuId.toString(), categoryId.toString());
  }

  getFavourites() async {
    favourites = await _apiCall.getFavourites();
  }

  Widget item(FoodItemModel foodItem) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 125,
        child: Row(
          children: [
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.only(left: 45.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      child: Image.asset(
                        foodItem.isVeg ? 'images/veg.png' : 'images/nonVeg.png',
                        fit: BoxFit.fitHeight,
                        scale: 0.5,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      foodItem.foodName,
                      style: appBarTextStyle.copyWith(
                          fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      padding: EdgeInsets.only(right: 10),
                      child: IconButton(
                          onPressed: () async {
                            setState(() {
                              favPressed.add(foodItem.id);
                            });
                            int userId = int.parse(Api.userInfo.id);
                            AddFavouritesModel details = AddFavouritesModel(
                              menuItemId: foodItem.id,
                              userId: userId,
                            );
                            await _apiCall.addFavourites(details);
                          },
                          icon: favourites[0].contains(foodItem.id) ||
                                  favPressed.contains(foodItem.id)
                              ? Icon(
                                  Icons.favorite,
                                  size: 13,
                                  color: defaultPurple,
                                )
                              : Icon(
                                  Icons.favorite_border,
                                  size: 13,
                                  color: defaultPurple,
                                )),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                margin: EdgeInsets.only(right: 20),
                child: CachedNetworkImage(
                  imageUrl:
                      foodItem.picture ?? "http://via.placeholder.com/350x150",
                  imageBuilder: (context, imageProvider) => Container(
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => FlutterLogo(
                    size: 60,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: white,
          centerTitle: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.keyboard_backspace,
              size: 30.0,
              color: defaultGreen,
            ),
          ),
          title: Text('Menu Packages', style: appBarTextStyle),
        ),
        body: Container(
          child: isLoaded
              ? Column(children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 10.0, top: 5, bottom: 5, left: 35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 7,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Text(widget.menu.name,
                                        style:
                                            selectedTab.copyWith(fontSize: 18)),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                      child: Text(
                                        widget.menu.description +
                                            widget.menu.description,
                                        style: TextStyle(
                                          fontFamily: 'RobotoCondensedReg',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        maxLines: 3,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 3,
                              child: CircleAvatar(
                                radius: 45,
                                backgroundColor: white,
                                child: CachedNetworkImage(
                                  imageUrl: widget.menu.picture ??
                                      "http://via.placeholder.com/350x150",
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color(0x26000000),
                                            blurRadius: 5)
                                      ],
//                                      boxShadow: [
//                                        BoxShadow(
//                                          blurRadius: 4,
//                                          color: Colors.grey[500],
//                                          spreadRadius: 0,
//                                          offset: const Offset(0.0, 0.0),
//                                        )
//                                      ],
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: white,
                        boxShadow: [
                          BoxShadow(color: Color(0x26000000), blurRadius: 5)
                        ],
//                        boxShadow: [
//                          BoxShadow(
//                            blurRadius: 4,
//                            color: Colors.black.withOpacity(0.25),
//                            spreadRadius: 0,
//                            offset: const Offset(0.0, 0.0),
//                          )
//                        ],
                      ),
                      child: Center(
                        child: TabBar(
                          controller: _pageController,
                          isScrollable: true,
                          onTap: (index) async {},
                          labelStyle: pageViewTabSelected,
                          indicatorColor: defaultGreen,
                          indicatorWeight: 2.0,
                          indicatorSize: TabBarIndicatorSize.label,
                          labelColor: defaultPurple,
                          labelPadding: EdgeInsets.symmetric(horizontal: 30),
                          unselectedLabelStyle: pageViewTabSelected,
                          unselectedLabelColor: Colors.grey,
                          tabs:
                              List.generate(mainCategoryItems.length, (index) {
                            return Tab(
                              text: mainCategoryItems[index].name,
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: TabBarView(
                        controller: _pageController,
                        children:
                            List.generate(mainCategoryItems.length, (index) {
                          return Container(
                            margin: index == 0
                                ? EdgeInsets.only(top: 10)
                                : EdgeInsets.zero,
                            child: menuUi(
                                foodItems[index], categoryItems[index].parent),
                          );
                        })),
                  )
                ])
              : Center(child: SpinKitDoubleBounce(color: defaultGreen)),
        ));
  }

  Widget menuUi(List<FoodItemModel> foodItem, int parentId) {
    return subCategoryItems.isNotEmpty
        ? subCategoryItems[parentId].length != 0
            ? ListView.builder(
                controller: _scrollController,
                itemCount: subCategoryItems[parentId].length,
                itemBuilder: (BuildContext context, int index) {
                  if (parentId == 2 && index == 0) {
                    expansionFoodItems = foodItems[4];
                  } else if (parentId == 2 && index == 1) {
                    expansionFoodItems = foodItems[5];
                  } else if (parentId == 4 && index == 0) {
                    expansionFoodItems = foodItems[7];
                  } else if (parentId == 4 && index == 1) {
                    expansionFoodItems = foodItems[8];
                  } else {
                    expansionFoodItems = foodItems[parentId];
                  }
                  return ExpansionTile(
                    onExpansionChanged: (bool expanded) {
                      print(parentId + index);
                    },
                    initiallyExpanded: true,
                    tilePadding: EdgeInsets.all(0),
                    title: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(subCategoryItems[parentId][index].name,
                          style: selectedTab.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black)),
                    ),
                    children:
                        List.generate(expansionFoodItems.length, (int index) {
                      return item(expansionFoodItems[index]);
                    }),
                  );
                })
            : ListView.builder(
                controller: _scrollController,
                itemCount: foodItem.length,
                itemBuilder: (BuildContext context, int index) {
                  return item(foodItem[index]);
                })
        : ListView.builder(
            controller: _scrollController,
            itemCount: foodItem.length,
            itemBuilder: (BuildContext context, int index) {
              return item(foodItem[index]);
            });
  }
}
