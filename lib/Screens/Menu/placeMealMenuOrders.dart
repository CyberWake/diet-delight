import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:diet_delight/Models/export_models.dart';
import 'package:diet_delight/Screens/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_panel/flutter_search_panel.dart';
import 'package:flutter_search_panel/search_item.dart';
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

  getData() async {
    DateTime today = DateTime.now();
    today = DateTime.parse(formatDate(today, [yyyy, '-', mm, '-', dd]));
    print(today);
    for (int i = 0; dates == null ?i < 0 : i < dates.length; i++) {
      if (dates[i] == today) {
        _pageController.index = i;
        print(_pageController.index);
        break;
      }
    }


    var resources = await _apiCall.getCalorieDataa(menuId);
    print(resources);
    for(int i =0;i<resources.length;i++){
      data.add(resources[i].toString());
    }
    intake = resources[0].toString();
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
    List days =success.weekdays;
    if (days.contains('Thu')) {
      days.remove('Thu');
      days.add('Thur');
    }
    for (int i = 0;
    i < int.parse(success.mealPlanDuration);
    i++) {
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
    if (categoryItems.length>0) {
      for (int i = 0; i < categoryItems.length;) {
        foodItems.add(await _apiCall
            .getMenuCategoryFoodItems(
                menuId.toString(), categoryItems[i].id.toString())
            .whenComplete(() => i++));
      }
    }
    for (int i = 0; i < foodItems.length; i++) {
      for (int j = 0; j < foodItems[i].length; j++) {
        if (widget.placedFoodItems != null  && widget.placedFoodItems.isNotEmpty) {
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
    print(
        'maxBuyCount: ${maxBuyCount.length}\nfoodItems: ${foodItems.length}\ncategory: ${categoryItems.length}\nmainCategoryItems: ${mainCategoryItems.length}\nsubCategoryItems: ${subCategoryItems.length}');
    if (mounted) {
      setState(() {
        isLoaded = true;
      });
    }
  }


  void initState() {
    super.initState();
    isAddressSelected = true;
    dates = widget.dates;
    getDates(widget.purchaseDetails);
    var line1 = widget.purchaseDetails.shippingAddressLine1;
    var line2 = widget.purchaseDetails.shippingAddressLine1;
    concatenatedAddress = line1 +
        ',\n' +
        line1;
    selectedAddressIndex = -1;
    menuId = widget.plan.menuId;
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
        length: int.parse(widget.purchaseDetails.mealPlanDuration),
        vsync: this);
    getData();
  }

  List<String> data = [
  ];


  callback(address) {
    setState(() {
      concatenatedAddress = address;
    });
  }

  var intake = "1000 Calorie";
  @override
  Widget build(BuildContext context) {
    //getData();
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, orderPlaced);
        return false;
      },
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: white,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: white,
            centerTitle: true,
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
            title: Text('Place meal orders', style: appBarTextStyle),
          ),
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.88,
              child: Column(children: [
                Expanded(
                  flex: 4,
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
                                child: Text(  widget.purchaseDetails.mealPlanName,
                                    style: selectedTab.copyWith(fontSize: 18,color: Colors.black)),
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
                          child: Padding(
                            padding: const EdgeInsets.only(top : 15.0),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                        //    child: Text('${widget.purchaseDetails.kCal} Calorie')
                          child:  DropdownButton<String>(
                            items: data.map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value,style: TextStyle(
                                  color: Colors.black
                                ),),
                              );
                            }).toList(),
                onChanged: (newVal) {
                  intake = newVal;
                  this.setState(() {});
                },
                            value: intake.toString(),
                          ),
                          ),
                        // TextButton(
                        //     onPressed: () {},
                        //     child: AddressButtonWithModal(
                        //       callBackFunction: callback,
                        //       child: Text(
                        //         'Address',
                        //         style: TextStyle(
                        //           color: darkGreen,
                        //           decoration: TextDecoration.underline,
                        //         ),
                        //       ),
                        //     )),
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
                      labelStyle: selectedTab.copyWith(
                          color: Colors.black, fontSize: 14,fontWeight: FontWeight.w500),
                      indicatorColor: Colors.transparent,
                      indicatorWeight: 3.0,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelColor: Colors.black,
                      labelPadding: EdgeInsets.symmetric(horizontal: 10),
                      unselectedLabelStyle:
                          unSelectedTab.copyWith(color: Color(0xFF909090).withOpacity(0.5),fontWeight: FontWeight.w400),
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
                                  child: Text('Day ${(index + 1).toString()}')),
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
                            return Container(
                              child: menuUi(day: index + 1),
                            );
                          }))
                      : Center(child: SpinKitDoubleBounce(color: defaultGreen)),
                )
              ]),
            ),
          )),
    );
  }

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
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.07,
          color: defaultGreen,
          child: Center(
              child: Text(
            'DONE',
            style: selectedTab.copyWith(color: white),
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
                                icon: Icon(Icons.add_comment_outlined,    size: 15,
                                  color: Color(0xFF77838F),)),
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
                              child: Text('Note to chef added',style: TextStyle(
                                color: Color(0xFF77838F),
                                fontSize: 11,
                              ),),
                            ),
                          )
                              : Container(),
                        ],
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        padding: EdgeInsets.only(right: 10),
                        child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.favorite_border,
                              size: 15,
                              color: Color(0xFF77838F),
                            )),
                      ),
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
                          bool isBefore = DateTime.now().isBefore(
                              dates[dateIndex].add(Duration(days: 1)));
                          if (isBefore) {
                            if (notInProgress) {
                              setState(() {
                                notInProgress = false;
                              });
                              if (max > maxBuyCount[maxBuyIndex]) {
                                if (!item.isSelected) {
                                  if (isAddressSelected) {
                                    item.change(true);
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
                                        note: item.noteAdded != null && item.noteAdded.isNotEmpty
                                            ? ""
                                            : item.noteAdded);
                                    int result = await _apiCall
                                        .postMenuOrder(foodItemOrder);
                                    if (result != -1) {
                                      orderPlaced = true;
                                      maxBuyCount[maxBuyIndex] += 1;
                                      item.updateOrderItemId(result);
                                      item.change(true);
                                      setState(() {});
                                    } else {
                                      item.change(false);
                                      setState(() {});
                                      _scaffoldKey.currentState.showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Something went wrong')));
                                    }
                                  } else {
                                    item.change(false);
                                    setState(() {});
                                    _scaffoldKey.currentState.showSnackBar(
                                        SnackBar(
                                            content:
                                                Text('Select address first')));
                                  }
                                } else {
                                  item.change(false);
                                  setState(() {});
                                  bool result = await _apiCall.deleteMenuOrder(
                                      item.orderItemId.toString());
                                  if (result) {
                                    item.change(false);
                                    setState(() {});
                                  } else {
                                    item.change(true);
                                    setState(() {});
                                    _scaffoldKey.currentState.showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Deleting menu order failed')));
                                  }
                                }
                                setState(() {
                                  notInProgress = true;
                                });
                              } else {
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text(
                                        'Max Buy Limit exceeded. Delete one to place one')));
                              }
                            }
                          } else {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text('Service already served')));
                            //item.change(false);
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

  noteModalSheet({Widget button}) {
    return Container(
      height: _height,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(50), topLeft: Radius.circular(50)),
      ),
      child: Column(
        mainAxisAlignment:
            _height == 250 ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.all(30),
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                color: white,
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
              child: TextFormField(
                autofocus: true,
                focusNode: note,
                controller: notes,
                textDirection: TextDirection.ltr,
                decoration: authInputFieldDecoration.copyWith(
                    hintText: 'Enter your note here'),
              )),
          button
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
              style: selectedTab.copyWith(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.black),
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
