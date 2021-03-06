import 'package:cached_network_image/cached_network_image.dart';
import 'package:diet_delight/Models/addFavouritesModel.dart';
import 'package:diet_delight/Models/foodItemModel.dart';
import 'package:diet_delight/Models/menuCategoryModel.dart';
import 'package:diet_delight/Models/menuModel.dart';
import 'package:diet_delight/konstants.dart';
import 'package:diet_delight/services/apiCalls.dart';
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
  bool favEnabled = true;

  get pageViewTabSelected => null;
  ScrollController _scrollCon = new ScrollController();
  var height;
  var _isAppBarExpanded = true;
  void initState() {
    super.initState();

    // _scrollCon = ScrollController()
    //   ..addListener(() {
    //     setState(() {
    //       height = _scrollCon.offset;
    //       print(height);
    //     });
    //
    //     if (_scrollController.hasClients &&
    //         _scrollController.offset > ((MediaQuery.of(context).size.height * 3 / 13) - kToolbarHeight)) {
    //       setState(() {
    //         _isAppBarExpanded = true;
    //         print(_isAppBarExpanded);
    //       });
    //     } else {
    //       setState(() {
    //         _isAppBarExpanded = false;
    //         print(_isAppBarExpanded);
    //       });
    //     }
    //
    //   });
    menuId = widget.menu.id;
    _pageController = TabController(length: categoryItems.length, vsync: this);
    getData();
  }

  getData() async {
    await getFavourites();
    setState(() {
      favPressed = favourites[0];
      print('favPressed: $favPressed');
    });
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
        height: MediaQuery.of(context).size.width * 0.275,
        child: Row(
          children: [
            Expanded(
              flex: 8,
              child: Container(
                height: MediaQuery.of(context).size.width * 0.275,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.0375,
                      left: 45.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 15,
                        width: 15,
                        child: Image.asset(
                          foodItem.isVeg
                              ? 'images/veg.png'
                              : 'images/nonVeg.png',
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
                      foodItem.featured == 1
                          ? Padding(
                              padding: EdgeInsets.only(left: 5.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Icon(Icons.star,
                                      color: featuredColor, size: 12),
                                  Text(
                                    'Featured',
                                    style: appBarTextStyle.copyWith(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: featuredColor),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                      // SizedBox(
                      //   height: 4,
                      // ),
                      Spacer(),
                      Container(
                        alignment: Alignment.bottomRight,
                        padding: EdgeInsets.only(right: 10),
                        child: favPressed.contains(foodItem.id) ||
                                favourites[0].contains(foodItem.id)
                            ? IconButton(
                                onPressed: favEnabled == false
                                    ? null
                                    : () async {
                                        favEnabled = false;
                                        int removeIndex =
                                            favourites[0].indexOf(foodItem.id);
                                        setState(() {
                                          print(favourites[0]
                                              .indexOf(foodItem.id));
                                          favPressed.remove(foodItem.id);
                                          print('favPressed: $favPressed');
                                          print(favourites[0]);
                                          print(foodItem.id);
                                          print(favourites[0]
                                              .indexOf(foodItem.id));
                                        });
                                        await _apiCall.deleteFavourites(
                                            favourites[1][removeIndex]);
                                        setState(() {
                                          getFavourites();
                                          print('favPressed: $favPressed');
                                          favEnabled = true;
                                          print('deleted');
                                        });
                                      },
                                icon: Icon(Icons.favorite,
                                    size: 18, color: defaultPurple))
                            : IconButton(
                                onPressed: favEnabled == false ||
                                        favPressed.contains(foodItem.id)
                                    ? null
                                    : () async {
                                        setState(() {
                                          favEnabled = false;
                                          favPressed.add(foodItem.id);
                                        });
                                        int userId = int.parse(Api.userInfo.id);
                                        AddFavouritesModel details =
                                            AddFavouritesModel(
                                          menuItemId: foodItem.id,
                                          userId: userId,
                                        );
                                        await _apiCall.addFavourites(details);
                                        setState(() {
                                          getFavourites();
                                          favEnabled = true;
                                        });
                                      },
                                icon: Icon(
                                  Icons.favorite_border,
                                  size: 18,
                                  color: defaultPurple,
                                )),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                margin: EdgeInsets.only(right: 20),
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: CachedNetworkImage(
                    imageUrl: foodItem.picture ??
                        "http://via.placeholder.com/350x150",
                    imageBuilder: (context, imageProvider) => Container(
                      height: MediaQuery.of(context).size.width * 0.2,
                      constraints: BoxConstraints(),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => SpinKitChasingDots(
                      color: defaultPurple,
                      size: 32,
                    ),
                    errorWidget: (context, url, error) => FlutterLogo(
                      size: 60,
                    ),
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
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: white,
        body: Theme(
          data: Theme.of(context).copyWith(
            accentColor:  Color.fromRGBO(144, 144, 144, 1),
          ),
          child: CustomScrollView(
           // controller: _scrollCon,
            slivers: <Widget>[
              SliverAppBar(
                automaticallyImplyLeading:  true,
                leading: GestureDetector(onTap : (){
                  Navigator.pop(context);
                },child: Icon(Icons.keyboard_backspace,color: defaultGreen,size: 30,)),
                expandedHeight: MediaQuery.of(context).size.height * 3 / 13,
                backgroundColor: Colors.white,
                title: Text(widget.menu.name,
                    style: selectedTab.copyWith(fontSize: 18,color: Colors.black)),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 10.0, top: 45, bottom: 5, left: 35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 7,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  SizedBox(
                                    height: 10,
                                  ),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 6.0, right: 10.0),
                                      child: Text(
                                        widget.menu.description,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'RobotoCondensedReg',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        maxLines: 6,
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
                                                color: Color(0x26000000), blurRadius: 5)
                                          ],
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                  placeholder: (context, url) => SpinKitChasingDots(
                                    color: defaultPurple,
                                    size: 32,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate(<Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.9 / 13,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: white,
                    boxShadow: [BoxShadow(color: Color(0x26000000), blurRadius: 5)],
                  ),
                  child: Center(
                    child: TabBar(
                      controller: _pageController,
                      isScrollable: true,
                      onTap: (index) async {},
                      //     labelStyle: tabBarLabelStyle,
                      indicatorColor: defaultGreen,
                      indicatorWeight: 3.0,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorPadding: EdgeInsets.symmetric(horizontal: 35.0),
                      labelColor: defaultPurple,
                      labelPadding: mainCategoryItems.length == 2 ? EdgeInsets.symmetric(horizontal: 60) : EdgeInsets.symmetric(horizontal: 40),
                      //          unselectedLabelStyle:
                      //    tabBarLabelStyle.copyWith(color: inactiveTime),
                      unselectedLabelColor: Colors.grey,
                      tabs: List.generate(mainCategoryItems.length, (index) {
                        return Tab(
                          text: mainCategoryItems[index].name,
                        );
                      }),
                    ),
                  ),
                ),
                isLoaded
                    ? Container(
                  height: MediaQuery.of(context).size.height*11.4/13-kTextTabBarHeight,
                      child: TabBarView(
                          controller: _pageController,
                          children: List.generate(mainCategoryItems.length, (index) {
                            return Container(
                              margin: index == 0
                                  ? EdgeInsets.only(top: 0)
                                  : EdgeInsets.zero,
                              child: foodItems[index] == null || foodItems[index].length == 0 ?
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom : 58.0),
                                  child: Text("Nothing to display",style: TextStyle(
                                      color: Color.fromRGBO(144, 144, 144, 1),
                                      fontFamily: 'MontserratMed',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14),),
                                ),
                              ) :
                              menuUi(
                                  foodItems[index], categoryItems[index].parent),
                            );
                          })),
                    )
                    : Center(
                        child: SpinKitThreeBounce(color: defaultPurple, size: 32))
              ]))
            ],
          ),
        ),
      ),
    );
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
