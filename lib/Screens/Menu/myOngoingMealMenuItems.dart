import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:diet_delight/Models/mealModel.dart';
import 'package:diet_delight/Models/mealPurchaseModel.dart';
import 'package:diet_delight/Models/menuCategoryModel.dart';
import 'package:diet_delight/Models/menuModel.dart';
import 'package:diet_delight/Models/menuOrdersModel.dart';
import 'package:diet_delight/Screens/Menu/editMyMealPlanMenuItems.dart';
import 'package:diet_delight/konstants.dart';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PresentMealMenu extends StatefulWidget {
  final MealPurchaseModel purchaseDetails;
  final MealModel plan;
  PresentMealMenu({this.purchaseDetails, this.plan});
  @override
  _PresentMealMenuState createState() => _PresentMealMenuState();
}

class _PresentMealMenuState extends State<PresentMealMenu>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _scrollController = new ScrollController();
  final _apiCall = Api.instance;
  TabController _pageController;
  FocusNode addressFocus = FocusNode();
  List<String> dates = [];
  List<String> format = [dd, ' ', 'M', ', ', yyyy];
  bool isLoaded = false;
  int menuId = 0;
  List<MenuModel> menuItems = List();
  List<MenuCategoryModel> categoryItems = List();
  List<MenuCategoryModel> mainCategoryItems = List();
  List<MenuCategoryModel> tempCategoryItems = List();
  List<List<MenuCategoryModel>> subCategoryItems = List();
  List<List<MenuOrderModel>> foodItems = List();
  List<MenuOrderModel> itemsFood = List();
  List<MenuOrderModel> expansionFoodItems = List();

  @override
  void initState() {
    super.initState();
    menuId = widget.plan.menuId;
    getDates();
    getData();
    _pageController = TabController(
        length: int.parse(widget.purchaseDetails.mealPlanDuration),
        vsync: this);
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
    if (categoryItems.isNotEmpty) {
      for (int i = 0; i < categoryItems.length;) {
        foodItems.add(await _apiCall
            .getCurrentMealCategoryOrdersFoodItems(
                categoryItems[i].id.toString(), widget.purchaseDetails.id)
            .whenComplete(() => i++));
      }
    }
    print('subCategoryItems.length: ${subCategoryItems.length}');
    print('mainCategoryItems.length: ${mainCategoryItems.length}');
    print('categoryItems.length: ${categoryItems.length}');
    print('foodCategories.length: ${foodItems.length}');
    setState(() {
      isLoaded = true;
    });
  }

  getDates() {
    dates = [];
    int count = 0;
    print(widget.purchaseDetails.weekdays);
    DateTime startDate = DateTime.parse(widget.purchaseDetails.startDate);
    List days = widget.purchaseDetails.weekdays;
    if (days.contains('Thu')) {
      days.remove('Thu');
      days.add('Thur');
    }
    for (int i = 0;
        i < int.parse(widget.purchaseDetails.mealPlanDuration);
        i++) {
      DateTime date = startDate.add(Duration(days: (count)));
      while (!days.contains(formatDate(date, [D]))) {
        count++;
        date = startDate.add(Duration(days: count));
      }
      dates.insert(i, formatDate(date, [dd, '/', mm]));
      print('i: $i date: ${formatDate(date, [
        d,
        '/',
        m
      ])} day: ${formatDate(date, [D])}');
      count++;
    }
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
          title: Text('Meal Plan', style: appBarTextStyle),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 10),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 7,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        widget.purchaseDetails.mealPlanName,
                                        style: TextStyle(
                                          fontFamily: 'RobotoCondensedReg',
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          widget.plan.details,
                                          style: authInputTextStyle.copyWith(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
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
                                      backgroundColor: Colors.white,
                                      child: CachedNetworkImage(
                                        imageUrl: widget.plan.picture ??
                                            "http://via.placeholder.com/350x150",
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
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
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              "${widget.purchaseDetails.mealPlanDuration} day meal plan • " +
                                  (widget.plan.type == 0
                                      ? "With Weekends"
                                      : "Without Weekends"),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Text(
                              "${widget.purchaseDetails.kCal} Calorie",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              'Start Date - ${formatDate(DateTime.parse(widget.purchaseDetails.startDate), format)}',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    )),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {},
                          child: Text(
                            'Breaks',
                            style: TextStyle(
                              color: darkGreen,
                              decoration: TextDecoration.underline,
                            ),
                          )),
                    ],
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Align(
                        alignment: Alignment.center,
                        child: Text('${widget.purchaseDetails.kCal} Calorie'))),
                Expanded(
                  flex: 2,
                  child: Container(
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
                    child: TabBar(
                      isScrollable: true,
                      controller: _pageController,
                      onTap: (index) {},
                      labelStyle: selectedTab.copyWith(
                          color: Colors.black, fontSize: 14),
                      indicatorColor: Colors.transparent,
                      indicatorWeight: 3.0,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelColor: Colors.black,
                      labelPadding: EdgeInsets.symmetric(horizontal: 10),
                      unselectedLabelStyle:
                          unSelectedTab.copyWith(color: Colors.grey),
                      unselectedLabelColor: Colors.grey,
                      tabs: List.generate(
                          int.parse(widget.purchaseDetails.mealPlanDuration),
                          (index) {
                        return Tab(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Day ${(index + 1).toString()}'),
                              Text(dates[index])
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                Expanded(
                  flex: 18,
                  child: isLoaded
                      ? TabBarView(
                          controller: _pageController,
                          children: List.generate(
                              int.parse(
                                  widget.purchaseDetails.mealPlanDuration),
                              (index) {
                            return Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: menuUi(day: index + 1),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (BuildContext context) =>
                                                EditMealMenu(
                                                    plan: widget.plan,
                                                    purchaseDetails: widget
                                                        .purchaseDetails)));
                                  },
                                  child: Container(
                                    height: 50,
                                    margin: EdgeInsets.only(top: 20),
                                    color: defaultGreen,
                                    child: Center(
                                        child: Text(
                                      'Edit Menu',
                                      style: selectedTab.copyWith(color: white),
                                    )),
                                  ),
                                ),
                              ],
                            );
                          }))
                      : Center(child: CircularProgressIndicator()),
                )
              ]),
        ));
  }

  Widget foodItemCard(MenuOrderModel item) {
    return Container(
      height: 123,
      margin: EdgeInsets.symmetric(horizontal: 10),
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
                  Text(
                    item.foodItemName ?? "Food Name",
                    style: appBarTextStyle.copyWith(fontSize: 20),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.only(right: 10),
                    child: IconButton(
                        onPressed: () {}, icon: Icon(Icons.favorite_border)),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Positioned(
                    top: 0.0,
                    left: 0.0,
                    child: Container(
                      margin: EdgeInsets.only(right: 20),
                      height: 85,
                      width: 82,
                      decoration: authFieldDecoration,
                      child: CachedNetworkImage(
                        imageUrl: "http://via.placeholder.com/350x150",
                        imageBuilder: (context, imageProvider) => Container(
                          height: 60,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => FlutterLogo(
                          size: 60,
                        ),
                      ),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget menuUi({int day}) {
    return ListView.separated(
      controller: _scrollController,
      shrinkWrap: true,
      itemCount: mainCategoryItems.length,
      itemBuilder: (BuildContext context, int indexMajor) {
        itemsFood = foodItems[indexMajor];
        return ExpansionTile(
            title: Text(
              mainCategoryItems[indexMajor].name,
              style: selectedTab.copyWith(fontSize: 28),
            ),
            initiallyExpanded: indexMajor == 0 ? true : false,
            children: subCategoryItems[indexMajor].length == 0
                ? List.generate(itemsFood.length, (index) {
                    if (itemsFood[index].menuItemDay == day) {
                      return foodItemCard(itemsFood[index]);
                    }
                    return Container();
                  })
                : List.generate(subCategoryItems[indexMajor].length,
                    (int indexMinor) {
                    if (indexMajor == 2 && indexMinor == 0) {
                      itemsFood = foodItems[4];
                    } else if (indexMajor == 2 && indexMinor == 1) {
                      itemsFood = foodItems[5];
                    } else if (indexMajor == 4 && indexMinor == 0) {
                      itemsFood = foodItems[7];
                    } else if (indexMajor == 4 && indexMinor == 1) {
                      itemsFood = foodItems[8];
                    }
                    return ExpansionTile(
                        title: Text(
                          subCategoryItems[indexMajor][indexMinor].name,
                          style: selectedTab.copyWith(fontSize: 20),
                        ),
                        initiallyExpanded: indexMinor == 0 ? true : false,
                        children: List.generate(itemsFood.length, (index) {
                          if (itemsFood[index].menuItemDay == day) {
                            return foodItemCard(itemsFood[index]);
                          }
                          return Container();
                        }));
                  }));
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          thickness: 1.5,
          color: Colors.black12,
        );
      },
    );
  }
}
