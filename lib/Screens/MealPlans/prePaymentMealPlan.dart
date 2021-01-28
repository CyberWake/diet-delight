import 'package:diet_delight/Models/mealModel.dart';
import 'package:diet_delight/Models/mealPurchaseModel.dart';
import 'package:diet_delight/Models/menuCategoryModel.dart';
import 'package:diet_delight/konstants.dart';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:intl/intl.dart';

class PrePaymentMealPlan extends StatefulWidget {
  final MealModel mealPlan;
  final DateTime selectedDate;
  final List<String> selectedDays;
  PrePaymentMealPlan({this.selectedDate, this.selectedDays, this.mealPlan});
  @override
  _PrePaymentMealPlanState createState() => _PrePaymentMealPlanState();
}

class _PrePaymentMealPlanState extends State<PrePaymentMealPlan> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController addressPrimary = TextEditingController();
  TextEditingController addressSecondary = TextEditingController();
  FocusNode addressFocus = FocusNode();
  bool isLoaded = false;
  List<MenuCategoryModel> categoryItems = List();
  List<MenuCategoryModel> tempItems = List();
  final _apiCall = Api.instance;
  String addressArea = 'Bahrain';
  String localAddress = '';
  double _height = 350;
  int items = 4;
  int selectedAddress = -1;
  List<String> types = ['Home', 'Work'];
  List<String> areas1 = ['Bahrain', 'India'];
  List<String> areas2 = ['Bahrain', 'India'];
  String addressType = 'Home';

  Widget breakDownFields(String disc, String price, bool isGrandTotal) {
    return Row(
      mainAxisAlignment:
          isGrandTotal ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
      children: [
        Padding(
            padding: isGrandTotal
                ? EdgeInsets.only(top: 5.0, right: 10)
                : EdgeInsets.only(top: 5.0),
            child: Text(
              disc,
              style: selectedTab.copyWith(fontSize: 14),
            )),
        Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              price,
              style: TextStyle(
                fontFamily: 'RobotoCondensedReg',
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            )),
      ],
    );
  }

  void initState() {
    super.initState();
    getData();
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

  void getBottomSheet() {
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

  getCategories() {
    String displayCategories = '';
    categoryItems.forEach((element) {
      displayCategories += element.name + ', ';
    });
    return displayCategories;
  }

  getData() async {
    await getMenuCategories(widget.mealPlan.menuId);
  }

  getMenuCategories(int menuId) async {
    categoryItems = [];
    setState(() {
      isLoaded = false;
    });
    categoryItems = await _apiCall.getCategories(menuId);
    categoryItems.forEach((element) {
      if (element.parent == 0) {
        tempItems.add(element);
      }
    });
    categoryItems = [];
    categoryItems = tempItems;
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
        title: Text('Payment', style: appBarTextStyle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'Billing Address',
                  style: selectedTab,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(width: 1, color: Colors.grey),
                    color: white),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Jane Doe',
                          style: selectedTab,
                        ),
                        GestureDetector(
                          onTap: () {
                            getBottomSheet();
                            print('pressed');
                          },
                          child: Text('Change',
                              style:
                                  unSelectedTab.copyWith(color: defaultGreen)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            '3 NewBridge Court\nChino Hills, CA 91709, United States',
                            style: unSelectedTab)
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 30, 0),
                child: Text(
                  'Your Plan',
                  style: selectedTab,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(width: 1, color: Colors.grey),
                    color: white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Menu Package',
                          style: selectedTab,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(widget.mealPlan.name,
                              style: selectedTab.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.normal)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(widget.mealPlan.details,
                              style: selectedTab.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.normal)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(getCategories(),
                              style: selectedTab.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.normal)),
                        ),
                      ],
                    ),
                    Divider(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Starting Date',
                          style: selectedTab,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                              DateFormat.E().format(widget.selectedDate) +
                                  ', ' +
                                  DateFormat.MMM()
                                      .add_d()
                                      .format(widget.selectedDate) +
                                  ', ' +
                                  widget.selectedDate.year.toString(),
                              style: selectedTab.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.normal)),
                        ),
                      ],
                    ),
                    Divider(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Subscription Days', style: selectedTab),
                        Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Row(
                              children: List.generate(
                                  widget.selectedDays.length, (index) {
                                return Text(
                                  widget.selectedDays[index] + ', ',
                                  style: selectedTab.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                );
                              }),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Payment',
                          style: selectedTab,
                        ),
                        Text('Change',
                            style: unSelectedTab.copyWith(color: defaultGreen)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 55,
                          width: 75,
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: Image.asset(
                            'images/card.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        Text('**** **** **** 3947', style: unSelectedTab),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 30, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Cost Breakdown',
                      style: selectedTab,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      breakDownFields(widget.mealPlan.name,
                          widget.mealPlan.price + ' USD', false),
                      breakDownFields('Extras', '- - USD', false),
                      breakDownFields('Taxes', '- - USD', false),
                      breakDownFields(
                          'Grand Total', widget.mealPlan.price + ' USD', true),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 50, 30, 30),
                child: SizedBox(
                  width: double.infinity,
                  height: 50.0,
                  child: TextButton(
                    onPressed: () async {
                      print('pressed');
                      MealPurchaseModel orderDetails = MealPurchaseModel(
                        userId: Api.userInfo.id,
                        mealPlanId: widget.mealPlan.id.toString(),
                        paymentId: '1234123',
                        status: '1',
                        mealPlanName: widget.mealPlan.name,
                        mealPlanDuration: widget.mealPlan.duration.toString(),
                        amountPaid: widget.mealPlan.price,
                        startDate: widget.selectedDate.toString(),
                        endDate: widget.selectedDate
                            .add(Duration(days: widget.mealPlan.duration))
                            .toString(),
                        weekdays: widget.selectedDays,
                      );
                      bool success =
                          await _apiCall.postMealPurchase(orderDetails);
                      if (success) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text('Meal Plan Purchased Successfully')));
                      } else {
                        _scaffoldKey.currentState.showSnackBar(
                            SnackBar(content: Text('Something went wrong')));
                      }
                    },
                    child: Text(
                      'Pay Now',
                      style: TextStyle(
                        fontFamily: 'RobotoCondensedReg',
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                    style: TextButton.styleFrom(
                        backgroundColor: defaultGreen,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
