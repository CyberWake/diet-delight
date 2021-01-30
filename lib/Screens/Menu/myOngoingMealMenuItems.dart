import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:diet_delight/Models/foodItemModel.dart';
import 'package:diet_delight/Models/mealModel.dart';
import 'package:diet_delight/Models/mealPurchaseModel.dart';
import 'package:diet_delight/Screens/Menu/editMyMealPlanMenuItems.dart';
import 'package:diet_delight/konstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';

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
  TabController _pageController;
  TextEditingController addressPrimary = TextEditingController();
  TextEditingController addressSecondary = TextEditingController();
  FocusNode addressFocus = FocusNode();
  List<String> dates = [];
  String addressArea = 'Bahrain';
  String localAddress = '';
  double _height = 350;
  int items = 4;
  int selectedAddress = -1;
  List<String> format = [dd, ' ', 'M', ', ', yyyy];
  List<String> types = ['Home', 'Work'];
  List<String> areas1 = ['Bahrain', 'India'];
  List<String> areas2 = ['Bahrain', 'India'];
  String addressType = 'Home';
  List<String> time = ['Breakfast', 'Lunch', 'Dinner'];
  List<String> calorie = [
    'Calorie1',
    'Calorie2',
    'Calorie3',
  ];
  List<List<FoodItemModel>> category = [
    [
      FoodItemModel(
          isVeg: true, foodName: 'Crunchy Chickpea Salad', isSelected: false),
      FoodItemModel(
          isVeg: true, foodName: 'Crunchy Chickpea Salad', isSelected: false),
      FoodItemModel(
          isVeg: true, foodName: 'Crunchy Chickpea Salad', isSelected: false),
    ],
    [
      FoodItemModel(
          isVeg: true, foodName: 'Crunchy Chickpea Salad', isSelected: false),
      FoodItemModel(
          isVeg: true, foodName: 'Crunchy Chickpea Salad', isSelected: false),
      FoodItemModel(
          isVeg: true, foodName: 'Crunchy Chickpea Salad', isSelected: false),
    ],
    [
      FoodItemModel(
          isVeg: true, foodName: 'Crunchy Chickpea Salad', isSelected: false),
      FoodItemModel(
          isVeg: true, foodName: 'Crunchy Chickpea Salad', isSelected: false),
      FoodItemModel(
          isVeg: true, foodName: 'Crunchy Chickpea Salad', isSelected: false),
    ]
  ];

  @override
  void initState() {
    super.initState();
    getDates();
    _pageController = TabController(
        length: int.parse(widget.purchaseDetails.mealPlanDuration),
        vsync: this);
    addressFocus.addListener(() {
      if (addressFocus.hasFocus) {
        setState(() {
          items = 5;
          _height = 600;
        });
      } else if (!addressFocus.hasFocus) {
        setState(() {
          items = 4;
          _height = 350;
        });
      }
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

  void addAddress({int address}) {
    if (address == 0 && addressPrimary.text.isNotEmpty) {
      var separatedAddress = addressPrimary.text.split(',');
      addressArea = separatedAddress[separatedAddress.length - 1];
      localAddress = separatedAddress[0];
    } else if (address == 1 && addressSecondary.text.isNotEmpty) {
      var separatedAddress = addressSecondary.text.split(',');
      addressArea = separatedAddress[separatedAddress.length - 1];
      localAddress = separatedAddress[0];
    } else {
      localAddress = '';
    }
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        builder: (builder) {
          return StatefulBuilder(builder:
              (BuildContext context, StateSetter addressModalStateUpdate) {
            return Container(
              height: _height,
              color:
                  Colors.transparent, //could change this to Color(0xFF737373),
              //so you don't have to change MaterialApp canvasColor
              child: Container(
                  padding: EdgeInsets.only(top: 30),
                  child: Column(
                      children: List.generate(items, (index) {
                    if (index < 2) {
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
                            items: index == 0
                                ? types
                                : address == 0
                                    ? areas1
                                    : areas2,
                            onChanged: (String choice) {
                              if (index == 0) {
                                addressType = choice;
                              } else if (index == 1) {
                                addressArea = choice;
                              }
                              print(choice);
                              addressModalStateUpdate(() {});
                            },
                            isExpanded: true,
                          ),
                        ),
                      );
                    } else if (index == 2) {
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
                              controller: address == 0
                                  ? addressPrimary
                                  : addressSecondary,
                              focusNode: addressFocus,
                              onFieldSubmitted: (done) {
                                localAddress = done;
                              },
                              style: authInputTextStyle,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              decoration: authInputFieldDecoration.copyWith(
                                  hintText:
                                      'House #, House name, Street name')),
                        ),
                      );
                    } else if (index == 3) {
                      return Expanded(
                          child: GestureDetector(
                        onTap: () {
                          print(addressArea);
                          if (address == 0) {
                            addressPrimary.text += ', ' + addressArea;
                            print(addressPrimary.text);
                          } else if (address == 1) {
                            addressSecondary.text += ', ' + addressArea;
                          }
                          setState(() {});
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 20),
                          color: defaultGreen,
                          child: Center(
                              child: Text(
                            localAddress.length > 0 || addressArea != null
                                ? 'Update'
                                : 'ADD',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          )),
                        ),
                      ));
                    } else {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                      );
                    }
                  }))),
            );
          });
        });
  }

  void getBottomSheet({int address}) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
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
                            Navigator.pop(context);
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
                    if (index == 0 && addressPrimary.text.isNotEmpty) {
                      var separatedAddress = addressPrimary.text.split(',');
                      addressArea =
                          separatedAddress[separatedAddress.length - 1];
                      localAddress = separatedAddress[0];
                    } else if (index == 1 && addressSecondary.text.isNotEmpty) {
                      var separatedAddress = addressSecondary.text.split(',');
                      addressArea =
                          separatedAddress[separatedAddress.length - 1];
                      localAddress = separatedAddress[0];
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
                                if (addressPrimary.text.isNotEmpty) {
                                  modalStateUpdate(() {
                                    selectedAddress = index;
                                  });
                                }
                              } else if (index == 1) {
                                if (addressSecondary.text.isNotEmpty) {
                                  modalStateUpdate(() {
                                    selectedAddress = index;
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
                                                  Navigator.pop(context);
                                                  addAddress(address: index);
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
                                        imageUrl: widget.plan.picture,
                                        imageBuilder:
                                            (context, imageProvider) =>
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
                      TextButton(
                          onPressed: () {
                            getBottomSheet();
                          },
                          child: Text(
                            'Address',
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
                      labelStyle: selectedTab.copyWith(color: Colors.black,fontSize: 14),
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
                  child: TabBarView(
                      controller: _pageController,
                      children: List.generate(
                          int.parse(widget.purchaseDetails.mealPlanDuration),
                          (index) {
                        return Column(
                          children: [
                            Expanded(child: menuUi()),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (BuildContext context) =>
                                            EditMealMenu(
                                                plan: widget.plan,
                                                purchaseDetails:
                                                    widget.purchaseDetails)));
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
                      })),
                )
              ]),
        ));
  }

  Widget menuUi() {
    return ListView.separated(
      controller: _scrollController,
      shrinkWrap: true,
      itemCount: category.length,
      itemBuilder: (BuildContext context, int indexMajor) {
        List<FoodItemModel> items = category[indexMajor];
        return ExpansionTile(
          title: Text(
            time[indexMajor],
            style: selectedTab.copyWith(fontSize: 28),
          ),
          children: List.generate(items.length + 1, (index) {
            if (index == 3) {
              return Column(
                children: [
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
                        decoration: authInputFieldDecoration.copyWith(
                            hintText: 'Enter your note here'),
                      )),
                ],
              );
            }
            return Container(
              height: 110,
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
                              items[index].isVeg
                                  ? 'images/veg.png'
                                  : 'images/nonVeg.png',
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            items[index].foodName,
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
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0.0,
                          left: 0.0,
                          child: Container(
                              margin: EdgeInsets.only(right: 20),
                              decoration: authFieldDecoration,
                              child: FlutterLogo(
                                size: 80,
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
        );
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
