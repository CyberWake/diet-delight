import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:diet_delight/Models/export_models.dart';
import 'package:diet_delight/Screens/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PlaceMealMenuOrders extends StatefulWidget {
  final List<List<MenuOrderModel>> placedFoodItems;
  final List<DateTime> dates;
  final MealPurchaseModel purchaseDetails;
  final MealModel plan;

  PlaceMealMenuOrders(
      {this.purchaseDetails, this.plan, this.placedFoodItems, this.dates});
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
  List<int> maxBuyCount = List();
  FocusNode note = FocusNode();
  final _apiCall = Api.instance;
  TabController _pageController;
  MenuOrderModel foodItemOrder;
  bool isLoaded = false;
  bool notInProgress = true;
  bool orderPlaced = false;
  double _height = 250;
  int menuId = 0;
  List<int> favPressed = List();
  List<List> favourites = List();
  var maxBuyIndexedList = [];

  getFavourites() async {
    var data = await _apiCall.getFavourites();
    setState(() {
      favourites = data;
      favPressed = favourites[0];
      print('favPressed: $favPressed');
    });
    print('favvvvvvvvvvvvvvv $favourites');
  }

  getData() async {
    DateTime today = DateTime.now();
    today = DateTime.parse(formatDate(today, [yyyy, '-', mm, '-', dd]));
    print(today);
    for (int i = 0; dates == null ? i < 0 : i < dates.length; i++) {
      if (dates[i] == today) {
        _pageController.index = i;
        print(_pageController.index);
        break;
      }
    }
    await getFavourites();

    var resources = await _apiCall.getCalorieDataa(menuId);
    print(resources);
    for (int i = 0; i < resources.length; i++) {
      data.add(resources[i].toString());
    }

    var value = await FlutterSecureStorage().read(key: 'calorie');
    print("Calorie value");
    print(value);
    data.remove(value);
    data.add(value);

    await getMenuCategories(menuId);
  }

  DateTime startDate;
  List<DateTime> breakDates = List();
  List<DateTime> dates = [];

  getDates(success) {
    print("getDatescalled");
    dates = [];
    int count = 0;
    startDate = DateTime.parse(success.startDate);
    DateTime date;
    startDate = DateTime(
        startDate.year, startDate.month, startDate.day, 00, 00, 00, 000);
    List days = success.weekdays;
    if (days.contains('Thu')) {
      days.remove('Thu');
      days.add('Thur');
    }
    for (int i = 0; i < int.parse(success.mealPlanDuration); i++) {
      date = startDate.add(Duration(days: (count)));
      while (!days.contains(formatDate(date, [D])) ||
          ((breakDates != null) ? (breakDates.contains(date)) : false)) {
        count++;
        date = startDate.add(Duration(days: count));
      }
      setState(() {
        dates.insert(i, date);
      });
      print(date);
      count++;
    }
    print("printing dates  $dates");

    DateTime today = DateTime.now();
    today = DateTime.parse(formatDate(today, [yyyy, '-', mm, '-', dd]));
    print(today);
  }

  getMenuCategories(int menuId) async {
    categoryItems = [];
    foodItems = [];
    setState(() {
      isLoaded = false;
    });
    categoryItems = await _apiCall.getMenuCategories(menuId);
    print("printing categoryitemas");
    print(categoryItems);
    for (int i = 0; i < categoryItems.length; i++) {
      categoryItems[i].showNew();
      maxBuyCount.insert(i, 0);
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

    if (categoryItems.length > 0) {
      for (int i = 0; i < categoryItems.length;) {
        foodItems.add(await _apiCall
            .getMenuCategoryFoodItems(
                menuId.toString(), categoryItems[i].id.toString())
            .whenComplete(() => i++));
      }
    }

    for (int i = 0; i < dates.length; i++) {
      var temp = [];
      for (int j = 0; j < mainCategoryItems.length; j++) {
        temp.add(0);
      }
      maxBuyIndexedList.add(temp);
    }

    print("{}{{}{}{{{}}{ $maxBuyIndexedList");

    for (int i = 0; i < foodItems.length; i++) {
      for (int j = 0; j < foodItems[i].length; j++) {
        if (widget.placedFoodItems != null &&
            widget.placedFoodItems.isNotEmpty) {
          for (int k = 0; k < widget.placedFoodItems[i].length; k++) {
            if (foodItems[i][j].id == widget.placedFoodItems[i][k].foodItemId) {
              foodItems[i][j]
                  .updateOrderItemId(widget.placedFoodItems[i][k].id);
              foodItems[i][j].change(true);
            }
          }
        } else {
          break;
        }
      }
    }

    for (int k = 0;
        k < int.parse(widget.purchaseDetails.mealPlanDuration);
        k++) {
      for (int i = 0; i < mainCategoryItems.length; i++) {
        var temp = foodItems[i];
        for (int j = 0; j < temp.length; j++) {
          print(temp[j].foodName);
          print(temp[j].isSelected);
          if (subCategoryItems[i].length == 0 &&
              temp[j].day == k + 1 &&
              temp[j].isSelected == true) {
            print("called1");
            print("$k $i");
            maxBuyIndexedList[k][i]++;
            print(maxBuyIndexedList);
          } else if (temp[j].day == k + 1 && temp[j].isSelected == true) {
            print("called2");
            print("$k $i");
            maxBuyIndexedList[k][i]++;
            print(maxBuyIndexedList);
          }
        }
      }
    }

    print("{}{{}{}{{{}}{ $maxBuyIndexedList");
    print(
        'maxBuyCount: ${maxBuyCount.length}\nfoodItems: ${foodItems.length}\ncategory: ${categoryItems.length}\nmainCategoryItems: ${mainCategoryItems.length}\nsubCategoryItems: ${subCategoryItems.length}');
    if (mounted) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  int pageIndex = 0;

  void initState() {
    super.initState();
    isAddressSelected = true;
    dates = widget.dates;
    getDates(widget.purchaseDetails);
    var line1 = widget.purchaseDetails.shippingAddressLine1;
    var line2 = widget.purchaseDetails.shippingAddressLine2;
    concatenatedAddress = line1 + ',\n' + line2;
    selectedAddressIndex = -1;
    menuId = widget.plan.menuId;
    print(menuId.toString() + "thissss");
    notes.addListener(() {
      if (note.hasFocus) {
        print('height increased');
        setState(() {
          _height = 495;
        });
      } else if (!note.hasFocus) {
        print('height decreased');
        setState(() {
          _height = 250;
        });
      }
    });
    _pageController = TabController(
        length: int.parse(widget.purchaseDetails.mealPlanDuration), vsync: this)
      ..addListener(() {
        setState(() {
          pageIndex = _pageController.index;
        });
      });
    getData();
  }

  List<String> data = [];

  callback(address) {
    setState(() {
      concatenatedAddress = address;
    });
  }

  bool favEnabled = true;
  var intake;

  var postCallMade = false;

  @override
  Widget build(BuildContext context) {
    //getData();
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, orderPlaced);
        return false;
      },
      child: Theme(
        data: Theme.of(context).copyWith(
          accentColor: Color.fromRGBO(144, 144, 144, 1),
        ),
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: white,
            appBar: AppBar(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0))),
              backgroundColor: white,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context, orderPlaced);
                },
                icon: Icon(
                  Icons.keyboard_backspace,
                  size: 30.0,
                  color: defaultGreen,
                ),
              ),
              title: Text('Place meal orders',
                  style: appBarTextStyle.copyWith(color: defaultGreen)),
            ),
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.88,
                child: Column(children: [
                  Expanded(
                    flex: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 7,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 10.0, top: 15, bottom: 0, left: 30),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                      widget.purchaseDetails.mealPlanName,
                                      style: selectedTab.copyWith(
                                          fontSize: 18, color: Colors.black)),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 6.0, right: 10.0),
                                    child: Text(
                                      widget.plan.details,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: 'RobotoCondensedReg',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF77838F)),
                                      maxLines: 6,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),

                                Flexible(
                                  fit: FlexFit.loose,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 6.0, right: 10.0),
                                    child: Text(
                                        widget.purchaseDetails.weekdays
                                                    .contains("Sun") &&
                                                widget.purchaseDetails.weekdays
                                                    .contains("Sat")
                                            ? widget.purchaseDetails
                                                    .mealPlanDuration +
                                                " day meal plan • with weekend"
                                            : widget.purchaseDetails
                                                    .mealPlanDuration +
                                                " day meal plan • without weekend",
                                        style: selectedTab.copyWith(
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                            color: Color(0xFF909090))),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 7.0),
                                    child: DropdownButton<String>(
                                      elevation: 0,
                                      hint: Text(
                                        "Select your calorie intake",
                                        style: descriptionTextStyle.copyWith(
                                            fontSize: 12,
                                            color: Color(0xFF3030303)),
                                      ),
                                      items: data.map((String value) {
                                        return new DropdownMenuItem<String>(
                                          value: value,
                                          child: value != data[data.length - 1]
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(value,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12)),
                                                    Divider(
                                                      color: Color(0xFFDFDFFF)
                                                          .withOpacity(0.5),
                                                    ),
                                                  ],
                                                )
                                              : Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "$value (Recommended)",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFFF79E1B),
                                                          fontSize: 12),
                                                    ),
                                                    Divider(
                                                      color: Color(0xFFDFDFFF)
                                                          .withOpacity(0.5),
                                                    ),
                                                  ],
                                                ),
                                        );
                                      }).toList(),
                                      onChanged: (newVal) async {
                                        intake = newVal;
                                        print(widget.purchaseDetails.id);
                                        await _apiCall.putMealPurchase(
                                            widget.purchaseDetails,
                                            intake.toString());
                                        this.setState(() {});
                                      },
                                      value: intake == null
                                          ? null
                                          : intake.toString(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15.0),
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
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
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
                              ),
                            ))
                      ],
                    ),
                  ),
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
                        labelStyle: selectedTab.copyWith(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                        indicatorColor: defaultGreen,
                        indicatorWeight: 3.0,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelColor: defaultPurple,
                        labelPadding: EdgeInsets.symmetric(horizontal: 10),
                        unselectedLabelStyle: unSelectedTab.copyWith(
                            fontSize: 14,
                            color: Color(0xFF909090).withOpacity(0.5),
                            fontWeight: FontWeight.w600),
                        unselectedLabelColor: Color(0xFF909090),
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
                                    child:
                                        Text('Day ${(index + 1).toString()}')),
                                // Flexible(
                                //     fit: FlexFit.loose,
                                //     child: Text(formatDate(
                                //         widget.dates[index], [dd, '/', mm])))
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
                                int.parse(
                                    widget.purchaseDetails.mealPlanDuration),
                                (index) {
                              return Column(
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: Container(
                                      child: menuUi(day: index + 1),
                                    ),
                                  ),
                                  delataApiCalls.length > 0 ||
                                          addDataApiCalls.length > 0
                                      ? Expanded(
                                          flex: 2,
                                          child: GestureDetector(
                                            onTap: () async {
                                              setState(() {
                                                postCallMade = true;
                                              });
                                              for (int i = 0;
                                                  i < addDataApiCalls.length;
                                                  i++) {
                                                int result = await _apiCall
                                                    .postMenuOrder(
                                                        addDataApiCalls[i]);
                                                if (result != -1) {
                                                  print(maxBuyIndexedList);
                                                  addDataItemForApiCalls[i]
                                                      .updateOrderItemId(
                                                          result);
                                                  setState(() {});
                                                } else {
                                                  addDataItemForApiCalls[i]
                                                      .change(false);
                                                  setState(() {});
                                                  _scaffoldKey.currentState
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              'Something went wrong')));
                                                }
                                              }

                                              for (int i = 0;
                                                  i < delataApiCalls.length;
                                                  i++) {
                                                bool result = await _apiCall
                                                    .deleteMenuOrder(
                                                        delataApiCalls[i]);
                                                if (result) {
                                                  print(maxBuyIndexedList);
                                                  setState(() {});
                                                } else {
                                                  delDataItemForApiCalls[i]
                                                      .change(true);
                                                  setState(() {});
                                                  _scaffoldKey.currentState
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              'Deleting menu order failed')));
                                                }
                                              }
                                              setState(() {
                                                postCallMade = false;
                                              });
                                              addDataApiCalls = [];
                                              addDataItemForApiCalls = [];
                                              delataApiCalls = [];
                                              delDataItemForApiCalls = [];
                                            },
                                            child: Container(
                                              height: 50,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              margin: EdgeInsets.only(top: 20),
                                              color: defaultGreen,
                                              child: Center(
                                                  child: postCallMade
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(6.0),
                                                          child:
                                                              SpinKitChasingDots(
                                                            color: Colors.white,
                                                            size: 25,
                                                          ),
                                                        )
                                                      : Text(
                                                          'DONE',
                                                          style: selectedTab
                                                              .copyWith(
                                                                  color: white),
                                                        )),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              );
                            }))
                        : Center(
                            child: SpinKitDoubleBounce(color: defaultGreen)),
                  )

                ]),
              ),
            )),
      ),
    );
  }

  var addDataApiCalls = [];
  var addDataItemForApiCalls = [];

  var delataApiCalls = [];
  var delDataItemForApiCalls = [];

  Widget foodItemCard(
      {FoodItemModel item, int dateIndex, int maxBuyIndex, int max}) {
    Widget button = GestureDetector(
      onTap: () {
        if (notes.text.isNotEmpty) {
          print('note present');
          setState(() {
            print('note added');
            item.updateNote(notes.text);
          });
        }
        Navigator.pop(context);
      }, //buttonFunction,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0)),
            color: Color(0xFF77838F).withOpacity(0.7),
          ),
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.height * 0.07,
          child: Center(
              child: Text(
            'DONE',
            style:
                selectedTab.copyWith(color: white, fontWeight: FontWeight.w700),
          ))),
    );
    return Container(
      height: 123,
      margin: EdgeInsets.symmetric(horizontal: 12),
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
                    height: 13,
                    width: 13,
                    child: Image.asset(
                      item.isVeg ? 'images/veg.png' : 'images/nonVeg.png',
                      fit: BoxFit.fitHeight,
                      scale: 0.5,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    item.foodName ?? "Food Name",
                    style: appBarTextStyle.copyWith(
                        fontSize: 13, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding: EdgeInsets.only(right: 5),
                            child: IconButton(
                                onPressed: () async {
                                  setState(() {
                                    notes.clear();
                                  });
                                  if (item.noteAdded != null) {
                                    setState(() {
                                      notes.text = item.noteAdded;
                                    });
                                  }
                                  showModalBottomSheet(
                                      context: context,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(50.0),
                                            topRight: Radius.circular(50.0)),
                                      ),
                                      isScrollControlled: true,
                                      builder: (BuildContext context) {
                                        return noteModalSheet(button: button);
                                      });
                                },
                                icon: Icon(
                                  Icons.add_comment_outlined,
                                  size: 15,
                                  color: Color(0xFF77838F),
                                )),
                          ),
                          item.noteAdded != null
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      notes.clear();
                                    });
                                    if (item.noteAdded != null) {
                                      setState(() {
                                        notes.text = item.noteAdded;
                                      });
                                    }
                                    showModalBottomSheet(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(50.0),
                                              topRight: Radius.circular(50.0)),
                                        ),
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (BuildContext context) {
                                          return noteModalSheet(button: button);
                                        });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(right: 10),
                                    child: Text(
                                      'Note to chef added',
                                      style: TextStyle(
                                        color: Color(0xFF77838F),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        padding: EdgeInsets.only(right: 10),
                        child: favPressed.contains(item.id) ||
                                favourites[0].contains(item.id)
                            ? IconButton(
                                onPressed: favEnabled == false
                                    ? null
                                    : () async {
                                        favEnabled = false;
                                        int removeIndex =
                                            favourites[0].indexOf(item.id);
                                        setState(() {
                                          print(favourites[0].indexOf(item.id));
                                          favPressed.remove(item.id);
                                          favourites[0].remove(item.id);
                                          print('favPressed: $favPressed');
                                          print(favourites[0]);
                                          print(item.id);
                                          print(favourites[0].indexOf(item.id));
                                        });
                                        await _apiCall.deleteFavourites(
                                            favourites[1][removeIndex]);
                                        setState(() {
                                          // getFavourites();
                                          print('favPressed: $favPressed');
                                          favEnabled = true;
                                          print('deleted');
                                        });
                                      },
                                icon: Icon(Icons.favorite,
                                    size: 18, color: defaultPurple))
                            : IconButton(
                                onPressed: favEnabled == false ||
                                        favPressed.contains(item.id)
                                    ? null
                                    : () async {
                                        setState(() {
                                          favEnabled = false;
                                          favPressed.add(item.id);
                                        });
                                        int userId = int.parse(Api.userInfo.id);
                                        AddFavouritesModel details =
                                            AddFavouritesModel(
                                          menuItemId: item.id,
                                          userId: userId,
                                        );
                                        await _apiCall.addFavourites(details);
                                        setState(() {
                                          // getFavourites();
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
                  SizedBox(
                    height: 4,
                  ),
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
                      width: 94,
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
                  left: 7,
                  child: SizedBox(
                    width: 80,
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
                          bool isBefore = DateTime.now().isBefore(
                              dates[dateIndex].add(Duration(days: 1)));
                          if (isBefore) {
                            if (notInProgress) {
                              setState(() {
                                notInProgress = false;
                              });
                              if (isAddressSelected) {
                                if (!item.isSelected) {
                                  print("|||");
                                  print(max);
                                  print(maxBuyIndexedList);
                                  print(pageIndex);
                                  print(maxBuyIndex);
                                  print(maxBuyIndexedList[pageIndex]
                                      [maxBuyIndex]);
                                  if (max >
                                      maxBuyIndexedList[pageIndex]
                                          [maxBuyIndex]) {

                                    setState(() {});
                                    foodItemOrder = MenuOrderModel(
                                        foodItemId: item.id,
                                        foodItemCategoryId: item.categoryId,
                                        mealPurchaseId: int.parse(
                                            widget.purchaseDetails.id),
                                        menuItemDate:
                                            dates[dateIndex].toString(),
                                        menuItemDay: item.day,
                                        foodItemName: item.foodName,
                                        deliveryAddress: concatenatedAddress,
                                        note: item.noteAdded != null &&
                                                item.noteAdded.isNotEmpty
                                            ? ""
                                            : item.noteAdded);
                                    if (delDataItemForApiCalls.contains(item)) {
                                      int index =
                                          delDataItemForApiCalls.indexOf(item);
                                      delataApiCalls.removeAt(index);
                                      delDataItemForApiCalls.removeAt(index);
                                    } else {
                                      item.change(true);
                                      orderPlaced = true;
                                      addDataApiCalls.add(foodItemOrder);
                                      addDataItemForApiCalls.add(item);
                                    }
                                    maxBuyIndexedList[pageIndex][maxBuyIndex] =
                                        maxBuyIndexedList[pageIndex]
                                                [maxBuyIndex] +
                                            1;
                                    orderPlaced = true;
                                    print(maxBuyIndexedList);
                                    setState(() {});
                                    // int result = await _apiCall
                                    //     .postMenuOrder(foodItemOrder);
                                    // if (result != -1) {
                                    //
                                    //   orderPlaced = true;
                                    //   print('called');
                                    //   maxBuyIndexedList[pageIndex]
                                    //           [maxBuyIndex] =
                                    //       maxBuyIndexedList[pageIndex]
                                    //               [maxBuyIndex] +
                                    //           1;
                                    //   print(maxBuyIndexedList);
                                    //   item.updateOrderItemId(result);
                                    //   item.change(true);
                                    //   setState(() {});
                                    // } else {
                                    //   item.change(false);
                                    //   setState(() {});
                                    //   _scaffoldKey.currentState.showSnackBar(
                                    //       SnackBar(
                                    //           content: Text(
                                    //               'Something went wrong')));
                                    // }
                                  } else {
                                    print("||||" + concatenatedAddress);
                                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                                        content: Text(
                                            'Max Buy Limit exceeded. Delete one to place one')));
                                  }
                                } else {
                                  item.change(false);
                                  if (addDataItemForApiCalls.contains(item)) {
                                    int index =
                                        addDataItemForApiCalls.indexOf(item);
                                    addDataApiCalls.removeAt(index);
                                    addDataItemForApiCalls.remove(item);
                                  } else {
                                    delataApiCalls
                                        .add(item.orderItemId.toString());
                                    delDataItemForApiCalls.add(item);

                                    print(maxBuyIndexedList);
                                  }
                                  maxBuyIndexedList[pageIndex][maxBuyIndex] -=
                                      1;

                                  setState(() {});
                                  // bool result = await _apiCall.deleteMenuOrder(
                                  //     item.orderItemId.toString());
                                  // if (result) {
                                  //   maxBuyIndexedList[pageIndex][maxBuyIndex] -=
                                  //       1;
                                  //   print(maxBuyIndexedList);
                                  //   item.change(false);
                                  //   setState(() {});
                                  // } else {
                                  //   item.change(true);
                                  //   setState(() {});
                                  //   _scaffoldKey.currentState.showSnackBar(
                                  //       SnackBar(
                                  //           content: Text(
                                  //               'Deleting menu order failed')));
                                  // }
                                }
                                setState(() {
                                  notInProgress = true;
                                });
                              } else {
                                item.change(false);
                                setState(() {});
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text('Select address first')));
                              }
                            }
                          } else {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text('Service already served')));
                            //item.change(false);
                            setState(() {});
                          }

                          print("max buy count " + maxBuyCount.toString());
                        },
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                              item.isSelected
                                  ? 'Selected'.toUpperCase()
                                  : "Select".toUpperCase(),
                              style: selectedTab.copyWith(
                                  color: item.isSelected
                                      ? white
                                      : Color(0xFF079404),
                                  fontSize: 15)),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor:
                              item.isSelected ? Color(0xFF079404) : white,
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

  noteModalSheet({Widget button}) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/bg7.jpg'), fit: BoxFit.cover),
          color: white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(50), topLeft: Radius.circular(50)),
        ),
        child: StatefulBuilder(builder: (context, setState) {
          return Column(
            children: [
              Container(
                  margin: EdgeInsets.all(30),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                    color: Color(0xFF77838F).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: Colors.black.withOpacity(0.25),
                        spreadRadius: 0,
                        offset: const Offset(0.0, 0.0),
                      )
                    ],
                  ),
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(splashColor: Colors.transparent),
                    child: TextFormField(
                      autofocus: true,
                      focusNode: note,
                      controller: notes,
                      textDirection: TextDirection.ltr,
                      decoration: authInputFieldDecoration.copyWith(
                        fillColor: Colors.transparent,
                        filled: true,
                        hintText: 'Enter notes here...',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  )),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  button,
                ],
              )
            ],
          );
        }),
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
              style: selectedTab.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            initiallyExpanded: indexMajor == 0 ? true : false,
            children: subCategoryItems[indexMajor].length == 0
                ? List.generate(itemsFood.length, (index) {
                    if (itemsFood[index].day == day) {

                      return foodItemCard(
                          item: itemsFood[index],
                          dateIndex: day - 1,
                          maxBuyIndex: indexMajor,
                          max: mainCategoryItems[indexMajor].maxBuy);
                    }
                    return Container();
                  })
                : List.generate(subCategoryItems[indexMajor].length,
                    (int indexMinor) {
                    print('indexMinor: $indexMinor indexMajor: $indexMajor');
                    int num;
                    if (indexMajor == 2 && indexMinor == 0) {
                      itemsFood = foodItems[4];
                      //num = 3;
                    } else if (indexMajor == 2 && indexMinor == 1) {
                      itemsFood = foodItems[5];
                      //num = 4;
                    } else if (indexMajor == 4 && indexMinor == 0) {
                      itemsFood = foodItems[7];
                      //num = 5;
                    } else if (indexMajor == 4 && indexMinor == 1) {
                      itemsFood = foodItems[8];
                      //num = 3;
                    }
                    print(num);
                    return ExpansionTile(
                        title: Text(
                          subCategoryItems[indexMajor][indexMinor].name,
                          style: selectedTab.copyWith(fontSize: 20),
                        ),
                        initiallyExpanded: indexMinor == 0 ? true : false,
                        children: List.generate(itemsFood.length, (index) {
                          if (itemsFood[index].day == day) {
                            return foodItemCard(
                                item: itemsFood[index],
                                dateIndex: day - 1,
                                maxBuyIndex: num,
                                max: 0);
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
