import 'package:diet_delight/Models/foodItemModel.dart';
import 'package:diet_delight/Models/menuCategoryModel.dart';
import 'package:diet_delight/Models/menuModel.dart';
import 'package:diet_delight/konstants.dart';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:flutter/material.dart';

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
  List<List<FoodItemModel>> foodItems = List();
  final _apiCall = Api.instance;
  int menuId = 0;
  bool isLoaded = false;

  void initState() {
    super.initState();
    menuId = widget.menu.id;
    _pageController = TabController(length: categoryItems.length, vsync: this);
    getData();
  }

  getData() async {
    await getMenuCategories(menuId);
  }

  getMenuCategories(int menuId) async {
    categoryItems = [];
    foodItems = [];
    setState(() {
      isLoaded = false;
    });
    categoryItems = await _apiCall.getCategories(menuId);
    _pageController = TabController(length: categoryItems.length, vsync: this);
    if (categoryItems.isNotEmpty) {
      for (int i = 0; i < categoryItems.length;) {
        foodItems.add(await _apiCall
            .getCategoryFoodItems(
                menuId.toString(), categoryItems[i].id.toString())
            .whenComplete(() => i++));
      }
    }
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: white,
          centerTitle: true,
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
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 7,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.menu.name,
                                    style: selectedTab.copyWith(fontSize: 28)),
                                Text(
                                    'sgasdfjijadfigfadjfvadsfiluHFIUDSBFS\nADIUAGFIGF')
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4,
                                    color: Colors.grey[500],
                                    spreadRadius: 0,
                                    offset: const Offset(0.0, 0.0),
                                  )
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 45,
                              ),
                            ))
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4,
                            color: Colors.black.withOpacity(0.25),
                            spreadRadius: 0,
                            offset: const Offset(0.0, 0.0),
                          )
                        ],
                      ),
                      child: Center(
                        child: TabBar(
                          controller: _pageController,
                          isScrollable: true,
                          onTap: (index) async {},
                          labelStyle: selectedTab.copyWith(
                              fontSize: 24, color: Colors.black),
                          indicatorColor: Colors.transparent,
                          indicatorWeight: 3.0,
                          indicatorSize: TabBarIndicatorSize.label,
                          labelColor: Colors.black,
                          labelPadding: EdgeInsets.symmetric(horizontal: 13),
                          unselectedLabelStyle: unSelectedTab.copyWith(
                              fontSize: 20, color: Colors.grey),
                          unselectedLabelColor: Colors.grey,
                          tabs: List.generate(categoryItems.length, (index) {
                            return Tab(
                              text: categoryItems[index].name,
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
                        children: List.generate(categoryItems.length, (index) {
                          return Container(
                            margin: index == 0
                                ? EdgeInsets.only(top: 10)
                                : EdgeInsets.zero,
                            child: menuUi(foodItems[index]),
                          );
                        })),
                  )
                ])
              : Center(child: CircularProgressIndicator()),
        ));
  }

  Widget menuUi(List<FoodItemModel> foodItem) {
    return ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        itemCount: foodItem.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {},
            child: Container(
              height: 125,
              child: Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 15,
                            width: 15,
                            child: Image.asset(
                              foodItem[index].isVeg
                                  ? 'images/veg.png'
                                  : 'images/nonVeg.png',
                              fit: BoxFit.fitHeight,
                              scale: 0.5,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            foodItem[index].foodName,
                            style: appBarTextStyle.copyWith(fontSize: 20),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            padding: EdgeInsets.only(right: 10),
                            child: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.favorite_border)),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                        margin: EdgeInsets.only(right: 20),
                        decoration: authFieldDecoration,
                        child: FlutterLogo(
                          size: 60,
                        )),
                  )
                ],
              ),
            ),
          );
        });
  }
}
