import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:diet_delight/Models/mealModel.dart';
import 'package:diet_delight/Models/mealPurchaseModel.dart';
import 'package:diet_delight/Models/menuCategoryModel.dart';
import 'package:diet_delight/Models/menuModel.dart';
import 'package:diet_delight/Models/menuOrdersModel.dart';
import 'package:diet_delight/Screens/Menu/placeMealMenuOrders.dart';
import 'package:diet_delight/konstants.dart';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class PlacedMealMenuOrders extends StatefulWidget {
  final MealPurchaseModel purchaseDetails;
  final MealModel plan;
  PlacedMealMenuOrders({this.purchaseDetails, this.plan});
  @override
  _PlacedMealMenuOrdersState createState() => _PlacedMealMenuOrdersState();
}

class _PlacedMealMenuOrdersState extends State<PlacedMealMenuOrders>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _scrollController = new ScrollController();
  TextEditingController addressPrimaryLine1 = TextEditingController();
  TextEditingController addressSecondaryLine1 = TextEditingController();
  TextEditingController addressPrimaryLine2 = TextEditingController();
  TextEditingController addressSecondaryLine2 = TextEditingController();
  FocusNode addressLine1 = FocusNode();
  FocusNode addressLine2 = FocusNode();
  final _apiCall = Api.instance;
  TabController _pageController;
  FocusNode addressFocus = FocusNode();
  List<String> dates = [];
  List<String> format = [dd, ' ', 'M', ', ', yyyy];
  bool isLoaded = false;
  bool addressSelected = false;
  String addressType = 'Home';
  List<String> types = ['Home', 'Work'];
  String addressArea = '';
  String deliveryAddress;
  String localAddress = '';
  double _height = 300;
  DateTime startDate;
  int items = 4;
  int menuId = 0;
  int selectedAddress;
  List<DateTime> breakDates = List();
  List<DateTime> planSelectedOffDays = List();
  List<DateTime> deliverPrimary = List();
  List<DateTime> deliverSecondary = List();
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
    addressPrimaryLine1.text = Api.userInfo.addressLine1;
    addressPrimaryLine2.text = Api.userInfo.addressLine2;
    addressSecondaryLine1.text = Api.userInfo.addressSecondary1;
    addressSecondaryLine2.text = Api.userInfo.addressSecondary2;
  }

  getMenuCategories(int menuId) async {
    categoryItems = [];
    foodItems = [];
    setState(() {
      isLoaded = false;
    });
    categoryItems = await _apiCall.getCategories(menuId);
    for (int i = 0; i < categoryItems.length; i++) {
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
    if (mounted) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  getDates() {
    dates = [];
    int count = 0;
    startDate = DateTime.parse(widget.purchaseDetails.startDate);
    DateTime date;
    startDate = DateTime(
        startDate.year, startDate.month, startDate.day, 00, 00, 00, 000);
    List days = widget.purchaseDetails.weekdays;
    if (days.contains('Thu')) {
      days.remove('Thu');
      days.add('Thur');
    }
    for (int i = 0;
        i < int.parse(widget.purchaseDetails.mealPlanDuration);
        i++) {
      date = startDate.add(Duration(days: (count)));
      while (!days.contains(formatDate(date, [D])) ||
          ((breakDates != null) ? (breakDates.contains(date)) : false)) {
        if (!days.contains(formatDate(date, [D]))) {
          planSelectedOffDays.add(date);
        }
        count++;
        date = startDate.add(Duration(days: count));
      }
      dates.insert(i, formatDate(date, [dd, '/', mm]));
      print(date);
      count++;
    }
    widget.purchaseDetails.setEndDate(date.toString());
    print('end Date: ${widget.purchaseDetails.endDate}');
  }

  void _onSelectionChanged(
      DateRangePickerSelectionChangedArgs args, bool address) {
    if (!address) {
      print(args.value);
      breakDates = [];
      breakDates = args.value;
    } else {
      if (selectedAddress == 0) {
        deliverPrimary = args.value;
        if (args.value != null) {
          deliverPrimary = [];
        }
      } else if (selectedAddress == 1) {
        deliverSecondary = args.value;
        if (args.value != null) {
          deliverSecondary = [];
        }
      }
    }
  }

  showCalendar({bool addressCalendar}) async {
    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Center(
              child: Material(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.65,
              width: MediaQuery.of(context).size.width * 0.85,
              child: SfDateRangePicker(
                showNavigationArrow: true,
                todayHighlightColor: defaultGreen,
                toggleDaySelection: true,
                headerHeight: 60,
                initialSelectedDates: addressCalendar
                    ? selectedAddress == 0
                        ? deliverPrimary
                        : deliverSecondary
                    : breakDates,
                selectionColor: defaultGreen,
                monthCellStyle: DateRangePickerMonthCellStyle(
                    todayCellDecoration: BoxDecoration(
                        border: Border.all(color: defaultGreen),
                        shape: BoxShape.circle),
                    todayTextStyle: TextStyle(
                      color: defaultGreen,
                    ),
                    specialDatesDecoration: BoxDecoration(
                        color: Colors.deepPurple,
                        border: Border.all(color: defaultGreen),
                        shape: BoxShape.circle),
                    blackoutDateTextStyle: const TextStyle(
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough)),
                monthViewSettings: DateRangePickerMonthViewSettings(
                    numberOfWeeksInView:
                        ((DateTime.parse(widget.purchaseDetails.endDate))
                                        .difference(startDate)
                                        .inDays /
                                    7)
                                .round() +
                            1,
                    specialDates: addressCalendar
                        ? selectedAddress == 0
                            ? deliverPrimary
                            : deliverSecondary
                        : breakDates,
                    blackoutDates: planSelectedOffDays),
                enablePastDates: false,
                minDate: DateTime.parse(widget.purchaseDetails.startDate),
                maxDate: DateTime.parse(widget.purchaseDetails.endDate),
                view: DateRangePickerView.month,
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  if (args.value != null) {
                    _onSelectionChanged(args, addressCalendar);
                  } else {
                    setState(() {
                      breakDates = [];
                    });
                  }
                },
                selectionMode: DateRangePickerSelectionMode.multiple,
              ),
            ),
          ));
        }).then((value) {
      getDates();
      setState(() {
        print(breakDates);
      });
    });
  }

  void addAddressBottomSheet({int address}) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        builder: (builder) {
          return Container(
            height: _height,
            color: Colors.transparent,
            child: Container(
                padding: EdgeInsets.only(top: 30),
                child: Column(
                    children: List.generate(items, (index) {
                  if (index == 0) {
                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(50, 10, 50, 10),
                        padding: EdgeInsets.symmetric(horizontal: 20),
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
                        child: DropDown<String>(
                          showUnderline: false,
                          items: types,
                          onChanged: (String choice) {
                            addressType = choice;
                          },
                          initialValue: addressType,
                          isExpanded: true,
                        ),
                      ),
                    );
                  } else if (index < 3) {
                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(50, 10, 50, 10),
                        padding: EdgeInsets.symmetric(horizontal: 20),
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
                            focusNode: index == 1 ? addressLine1 : addressLine2,
                            onChanged: (value) {
                              if (index == 1) {
                                if (address == 0) {
                                  addressPrimaryLine1.text = value;
                                } else {
                                  addressSecondaryLine1.text = value;
                                }
                              } else {
                                if (address == 0) {
                                  addressPrimaryLine2.text = value;
                                } else {
                                  addressSecondaryLine2.text = value;
                                }
                              }
                            },
                            onFieldSubmitted: (done) {
                              if (index == 1) {
                                Focus.of(context).requestFocus(addressLine2);
                              }
                            },
                            style: authInputTextStyle,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            decoration: authInputFieldDecoration.copyWith(
                                hintText: index == 1
                                    ? 'House No, Street Name'
                                    : 'City')),
                      ),
                    );
                  } else if (index == 3) {
                    return Expanded(
                        child: GestureDetector(
                      onTap: () {
                        if (address == 0) {
                          print(addressPrimaryLine1.text +
                              ' ' +
                              addressPrimaryLine2.text);
                        } else if (address == 1) {
                          print(addressSecondaryLine1.text +
                              ' ' +
                              addressSecondaryLine2.text);
                        }
                        setState(() {});
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 20),
                        color: defaultGreen,
                        child: Center(
                            child: Text(
                          'Update',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        )),
                      ),
                    ));
                  } else {
                    return SizedBox(
                      height: 250,
                    );
                  }
                }))),
          );
        });
  }

  getBottomSheet() async {
    showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        builder: (builder) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter modalStateUpdate) {
            return Container(
              height: 380,
              color: Colors.transparent,
              child: Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Column(
                      children: List.generate(3, (index) {
                    if (index == 2) {
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (addressSelected) {
                              if (selectedAddress == 0) {
                                deliveryAddress = addressPrimaryLine1.text +
                                    ' ' +
                                    addressPrimaryLine2.text;
                              } else if (selectedAddress == 1) {
                                deliveryAddress = addressSecondaryLine1.text +
                                    ' ' +
                                    addressSecondaryLine2.text;
                              }
                              Navigator.pop(context);
                              showCalendar(addressCalendar: true);
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 20),
                            color: defaultGreen,
                            child: Center(
                                child: Text(
                              'Done',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            )),
                          ),
                        ),
                      );
                    }
                    if (index == 0 &&
                        addressPrimaryLine1.text.isNotEmpty &&
                        addressPrimaryLine2.text.isNotEmpty) {
                      localAddress = addressPrimaryLine1.text;
                      addressArea = addressPrimaryLine2.text;
                    } else if (index == 1 &&
                        addressSecondaryLine1.text.isNotEmpty &&
                        addressSecondaryLine2.text.isNotEmpty) {
                      addressArea = addressSecondaryLine2.text;
                      localAddress = addressSecondaryLine1.text;
                    } else {
                      localAddress = '';
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, bottom: 10),
                            child: Text(
                              index == 0
                                  ? 'Primary Address'
                                  : 'Secondary Address',
                              style: selectedTab.copyWith(
                                  color:
                                      index == 0 ? defaultGreen : Colors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (index == 0) {
                                if (addressPrimaryLine1.text.isNotEmpty &&
                                    addressPrimaryLine2.text.isNotEmpty) {
                                  modalStateUpdate(() {
                                    selectedAddress = index;
                                    addressSelected = true;
                                  });
                                }
                              } else if (index == 1) {
                                if (addressSecondaryLine1.text.isNotEmpty &&
                                    addressSecondaryLine2.text.isNotEmpty) {
                                  modalStateUpdate(() {
                                    selectedAddress = index;
                                    addressSelected = true;
                                  });
                                }
                              }
                            },
                            child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                    color: selectedAddress == index
                                        ? defaultGreen
                                        : white,
                                    border: Border.all(color: defaultGreen),
                                    borderRadius: BorderRadius.circular(15)),
                                child: localAddress.length > 0
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: Text(
                                                  localAddress +
                                                      ',\n' +
                                                      addressArea,
                                                  style: selectedTab.copyWith(
                                                      color: selectedAddress ==
                                                              index
                                                          ? white
                                                          : defaultGreen,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              TextButton(
                                                child: Text('Add',
                                                    style: TextStyle(
                                                      color: darkGreen,
                                                    )),
                                                onPressed: () {
                                                  Navigator.pop(context, false);
                                                  addAddressBottomSheet(
                                                      address: index);
                                                },
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [Text('Not Available')],
                                          )
                                        ],
                                      )),
                          )
                        ],
                      ),
                    );
                  }))),
            );
          });
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
          title: Text('Placed Meal Orders', style: appBarTextStyle),
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
                          onPressed: () async {
                            getBottomSheet();
                          },
                          child: Text(
                            'Address',
                            style: TextStyle(
                              color: darkGreen,
                              decoration: TextDecoration.underline,
                            ),
                          )),
                      Text('${widget.purchaseDetails.kCal} Calorie'),
                      TextButton(
                          onPressed: () async {
                            await showCalendar(addressCalendar: false);
                          },
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
                                                PlaceMealMenuOrders(
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

class CustomWeekdayLabelsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text("M", textAlign: TextAlign.center)),
        Expanded(child: Text("T", textAlign: TextAlign.center)),
        Expanded(child: Text("W", textAlign: TextAlign.center)),
        Expanded(child: Text("T", textAlign: TextAlign.center)),
        Expanded(child: Text("F", textAlign: TextAlign.center)),
        Expanded(child: Text("S", textAlign: TextAlign.center)),
        Expanded(child: Text("S", textAlign: TextAlign.center)),
      ],
    );
  }
}
