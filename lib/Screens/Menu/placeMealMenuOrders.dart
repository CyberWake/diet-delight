import 'dart:convert' as convert;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:diet_delight/Models/foodItemModel.dart';
import 'package:diet_delight/Models/mealModel.dart';
import 'package:diet_delight/Models/mealPurchaseModel.dart';
import 'package:diet_delight/Models/menuCategoryModel.dart';
import 'package:diet_delight/Models/menuModel.dart';
import 'package:diet_delight/Models/menuOrdersModel.dart';
import 'package:diet_delight/Widgets/getAddressModalSheet.dart';
import 'package:diet_delight/konstants.dart';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:flutter/material.dart';

class PlaceMealMenuOrders extends StatefulWidget {
  final MealPurchaseModel purchaseDetails;
  final MealModel plan;
  PlaceMealMenuOrders({this.purchaseDetails, this.plan});
  @override
  _PlaceMealMenuOrdersState createState() => _PlaceMealMenuOrdersState();
}

class _PlaceMealMenuOrdersState extends State<PlaceMealMenuOrders>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _scrollController = new ScrollController();
  TextEditingController notes = TextEditingController();
  List<List<MenuCategoryModel>> subCategoryItems = List();
  List<MenuCategoryModel> mainCategoryItems = List();
  List<MenuCategoryModel> tempCategoryItems = List();
  List<FoodItemModel> expansionFoodItems = List();
  List<MenuCategoryModel> categoryItems = List();
  List<List<FoodItemModel>> foodItems = List();
  List<FoodItemModel> itemsFood = List();
  List<MenuModel> menuItems = List();
  List<String> dates = [];
  final _apiCall = Api.instance;
  TabController _pageController;
  MenuOrderModel foodItemOrder;
  bool isLoaded = false;
  int menuId = 0;

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
            .getCategoryFoodItems(
                menuId.toString(), categoryItems[i].id.toString())
            .whenComplete(() => i++));
      }
    }
    if (mounted) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  getDates() {
    dates = [];
    int count = 0;
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
      count++;
    }
  }

  void initState() {
    super.initState();
    isAddressSelected = false;
    concatenatedAddress = '';
    selectedAddressIndex = -1;
    menuId = widget.plan.menuId;
    _pageController = TabController(
        length: int.parse(widget.purchaseDetails.mealPlanDuration),
        vsync: this);
    getDates();
    getData();
  }

  callback(address){
    setState(() {
      concatenatedAddress=address;
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
          title: Text('Place meal orders', style: appBarTextStyle),
        ),
        body: Container(
          child: Column(children: [
            Expanded(
              flex: 4,
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
                          Expanded(
                            flex: 3,
                            child: Text(
                              widget.purchaseDetails.mealPlanName,
                              style: TextStyle(
                                fontFamily: 'RobotoCondensedReg',
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: ClipRect(
                              child: Text(
                                widget.plan.details,
                                style: authInputTextStyle.copyWith(
                                    fontSize: 14, color: Colors.black),
                              ),
                            ),
                          )
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
                          backgroundColor: Colors.white,
                          child: CachedNetworkImage(
                            imageUrl: widget.plan.picture ??
                                "http://via.placeholder.com/350x150",
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
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
                        ),
                      ))
                ],
              ),
            ),
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('${widget.purchaseDetails.kCal} Calorie'),
                    TextButton(
                        onPressed: () {},
                        child: AddressButtonWithModal(
                          callBackFunction: callback,
                          child: Text(
                            'Address',
                            style: TextStyle(
                              color: darkGreen,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )),
                  ],
                )),
            Expanded(
              flex: 1,
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
                  labelStyle:
                      selectedTab.copyWith(color: Colors.black, fontSize: 14),
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
                          Flexible(
                              fit: FlexFit.loose,
                              child: Text('Day ${(index + 1).toString()}')),
                          Flexible(
                              fit: FlexFit.loose, child: Text(dates[index]))
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
            Expanded(
              flex: 9,
              child: isLoaded
                  ? TabBarView(
                      controller: _pageController,
                      children: List.generate(
                          int.parse(widget.purchaseDetails.mealPlanDuration),
                          (index) {
                        return Container(
                          child: menuUi(day: index + 1),
                        );
                      }))
                  : Center(child: CircularProgressIndicator()),
            )
          ]),
        ));
  }

  Widget foodItemCard(FoodItemModel item) {
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
                  Container(
                    height: 15,
                    width: 15,
                    child: Image.asset(
                      item.isVeg ? 'images/veg.png' : 'images/nonVeg.png',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    item.foodName ?? "Food Name",
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
                        imageUrl: item.picture ??
                            "http://via.placeholder.com/350x150",
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
                Positioned(
                  top: 70.0,
                  left: 3.5,
                  child: SizedBox(
                    width: 75,
                    height: 33,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4,
                            color: Colors.black.withOpacity(0.25),
                            spreadRadius: 0,
                            offset: const Offset(0.0, 0.0),
                          )
                        ],
                      ),
                      child: TextButton(
                        onPressed: () async {
                          if (!item.isSelected) {
                            if (isAddressSelected) {
                              foodItemOrder = MenuOrderModel(
                                  foodItemId: item.id,
                                  foodItemCategoryId: item.categoryId,
                                  mealPurchaseId:
                                      int.parse(widget.purchaseDetails.id),
                                  menuItemDate: item.date,
                                  menuItemDay: item.day,
                                  foodItemName: item.foodName,
                                  deliveryAddress: concatenatedAddress,
                                  note:
                                      notes.text.isEmpty ? "null" : notes.text);
                              String body =
                                  convert.jsonEncode(foodItemOrder.toMap());
                              print(body);
                              int result =
                                  await _apiCall.postMenuOrder(foodItemOrder);
                              if (result != null) {
                                item.updateOrderItemId(result);
                                item.change(true);
                                setState(() {});
                              }
                            } else {
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text('Select address first')));
                            }
                          } else {
                            // TODO: delete selected item
                            item.change(false);
                            setState(() {});
                          }
                        },
                        child: Text(item.isSelected ? 'Selected' : 'Select',
                            style: selectedTab.copyWith(
                                color: item.isSelected ? white : defaultGreen,
                                fontSize: 16)),
                        style: TextButton.styleFrom(
                          backgroundColor:
                              item.isSelected ? defaultGreen : white,
                        ),
                      ),
                    ),
                  ),
                )
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
                ? List.generate(itemsFood.length + 1, (index) {
                    if (index == itemsFood.length) {
                      return Column(
                        children: [
                          Divider(),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Text(
                              'Let us know if there is something you’d want us to know about your menu, we’ll pass it on to the chef.',
                              style: authInputTextStyle.copyWith(
                                  fontSize: 20, color: Colors.black),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.all(15),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              height: MediaQuery.of(context).size.height * 0.15,
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
                              child: TextFormField(
                                controller: notes,
                                onChanged: (value) {
                                  notes.text = value;
                                },
                                decoration: authInputFieldDecoration.copyWith(
                                    hintText: 'Enter your note here'),
                              )),
                        ],
                      );
                    }
                    if (itemsFood[index].day == day) {
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
                        children: List.generate(itemsFood.length + 1, (index) {
                          if (index == itemsFood.length) {
                            return Column(
                              children: [
                                Divider(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Text(
                                    'Let us know if there is something you’d want us to know about your menu, we’ll pass it on to the chef.',
                                    style: authInputTextStyle.copyWith(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.all(15),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
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
                                    child: TextFormField(
                                      controller: notes,
                                      onChanged: (value) {
                                        notes.text = value;
                                      },
                                      decoration:
                                          authInputFieldDecoration.copyWith(
                                              hintText: 'Enter your note here'),
                                    )),
                              ],
                            );
                          }
                          if (itemsFood[index].day == day) {
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
