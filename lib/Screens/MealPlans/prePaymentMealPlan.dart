import 'package:date_format/date_format.dart';
import 'package:diet_delight/Models/couponModel.dart';
import 'package:diet_delight/Models/export_models.dart';
import 'package:diet_delight/Screens/export.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrePaymentMealPlan extends StatefulWidget {
  final MealModel mealPlan;
  final DateTime selectedDate;
  final List<String> selectedDays;
  final String categories;
  final String shippingAddressLine1;
  final String shippingAddressLine2;
  final int addressIndex;
  final int afterNoonPrice;
  PrePaymentMealPlan(
      {this.categories,
      this.afterNoonPrice,
      this.addressIndex,
      this.selectedDate,
      this.selectedDays,
      this.mealPlan,
      this.shippingAddressLine1,
      this.shippingAddressLine2});
  @override
  _PrePaymentMealPlanState createState() => _PrePaymentMealPlanState();
}

class _PrePaymentMealPlanState extends State<PrePaymentMealPlan> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoaded = false;
  List<MenuCategoryModel> categoryItems = List();
  List<MenuCategoryModel> tempItems = List();
  final _apiCall = Api.instance;
  bool progress = false;
  DateTime startDate;
  List<DateTime> breakDates = List();
  List<DateTime> planSelectedOffDays = List();
  List<List<MenuOrderModel>> foodItems = List();
  List<DateTime> dates = [];
  List<List<MenuOrderModel>> foodItems1 = List();
  double discount = 0.0;
  getDates(success) {
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
        if (!days.contains(formatDate(date, [D]))) {
          planSelectedOffDays.add(date);
        }
        count++;
        date = startDate.add(Duration(days: count));
      }
      dates.insert(i, date);
      print(date);
      count++;
    }
    DateTime today = DateTime.now();
    today = DateTime.parse(formatDate(today, [yyyy, '-', mm, '-', dd]));
    print(today);
  }

  getData(success) async {
    categoryItems = [];
    foodItems1 = [];
    setState(() {
      isLoaded = false;
    });
    categoryItems = await _apiCall.getMenuCategories(widget.mealPlan.menuId);

    if (categoryItems.isNotEmpty) {
      for (int i = 0; i < categoryItems.length;) {
        foodItems.add(await _apiCall
            .getCurrentMealCategoryOrdersFoodItems(
                categoryItems[i].id.toString(), success.id)
            .whenComplete(() => i++));
      }
    }
    if (mounted) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  double getDiscount(CouponModel item) {
    double total = (double.parse(widget.mealPlan.price) +
            double.parse(widget.afterNoonPrice.toString())) +
        80;
    item.addUsed();
    if (item.flatDiscount != null) {
      return double.parse(item.flatDiscount);
    } else {
      return total * double.parse(item.percentageDiscount) / 100;
    }
  }

  @override
  void initState() {
    super.initState();
    concatenatedAddress =
        widget.shippingAddressLine1 + ',\n' + widget.shippingAddressLine2;
    isAddressSelected = true;
    selectedAddressIndex = widget.addressIndex;
  }

  callback(address) {
    setState(() {
      concatenatedAddress = address;
    });
  }

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
              style: selectedTab.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            )),
        Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              price,
              style: TextStyle(
                fontFamily: 'RobotoCondensedReg',
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            )),
      ],
    );
  }

  var hasCoupon = false;
  String couponCode;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: defaultGreen,
      ),
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/bg2.jpg'), fit: BoxFit.fitHeight)),
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 5.0,
            backgroundColor: white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0))),
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
            title: Text('Purchase Meal Plan',
                style: appBarTextStyle.copyWith(color: defaultGreen)),
          ),
          body: Container(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, bottom: 5),
                      child: Text(
                        'Billing Address',
                        style: selectedTab.copyWith(
                            color: questionnaireSelect,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      decoration: BoxDecoration(
                        color: questionnaireDisabled.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: isAddressSelected
                          ? Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${Api.userInfo.firstName ?? ''} ${Api.userInfo.lastName ?? ''}",
                                      style: selectedTab.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    AddressButtonWithModal(
                                      callBackFunction: callback,
                                      child: Text('Change',
                                          style: unSelectedTab.copyWith(
                                            color: Colors.white,
                                          )),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      concatenatedAddress,
                                      style: unSelectedTab.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    AddressButtonWithModal(
                                      callBackFunction: callback,
                                      child: Text('Select',
                                          style: unSelectedTab.copyWith(
                                              color: defaultGreen)),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text('Select An Address',
                                        style: unSelectedTab)
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 30, 0),
                      child: Text(
                        'Your Plan',
                        style: selectedTab.copyWith(
                            color: questionnaireSelect,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                                style: selectedTab.copyWith(
                                    color: questionnaireSelect,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10.0, top: 4),
                                child: Text(widget.mealPlan.name,
                                    style: selectedTab.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Color(0xFF909090))),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10.0, top: 2),
                                child: Text(
                                    widget.selectedDays.contains("Sun") &&
                                            widget.selectedDays.contains("Sat")
                                        ? widget.mealPlan.duration.toString() +
                                            " day meal plan with weekend"
                                        : widget.mealPlan.duration.toString() +
                                            " day meal plan without weekend",
                                    style: selectedTab.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Color(0xFF909090))),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10.0, top: 2),
                                child: Text(widget.categories,
                                    style: selectedTab.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Color(0xFF909090))),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Starting Date',
                                style: selectedTab.copyWith(
                                    color: questionnaireSelect,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10.0, top: 4),
                                child: Text(
                                    DateFormat.E().format(widget.selectedDate) +
                                        ', ' +
                                        DateFormat.MMM()
                                            .add_d()
                                            .format(widget.selectedDate) +
                                        ', ' +
                                        widget.selectedDate.year.toString(),
                                    style: selectedTab.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Color(0xFF909090))),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Subscription Days',
                                  style: selectedTab.copyWith(
                                      color: questionnaireSelect,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15)),
                              Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10.0, top: 4),
                                  child: Row(
                                    children: List.generate(
                                        widget.selectedDays.length, (index) {
                                      return Text(
                                        widget.selectedDays[index] + ', ',
                                        style: selectedTab.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                            color: Color(0xFF909090)),
                                      );
                                    }),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: questionnaireDisabled.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      /*   decoration: BoxDecoration(
                          color: Color(0xFFC4C4C4).withOpacity(0.6),
                          borderRadius: BorderRadius.circular(10)), */
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            ImageIcon(AssetImage('images/discount.png'),
                                color: white, size: 28),
                            SizedBox(
                              width: 20,
                            ),
                            hasCoupon
                                ? Expanded(
                                    child: TextFormField(
                                      onChanged: (value) {
                                        setState(() {
                                          couponCode = value;
                                        });
                                      },
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          hintStyle: appBarTextStyle.copyWith(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600),
                                          hintText: "Enter coupon code here"),
                                    ),
                                  )
                                : Expanded(
                                    child: Container(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            hasCoupon = true;
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            "APPLY COUPON",
                                            style: appBarTextStyle.copyWith(
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            Padding(
                              padding: const EdgeInsets.only(left: 18.0),
                              child: !hasCoupon
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          hasCoupon = true;
                                        });
                                      },
                                      child: Icon(
                                        Icons.navigate_next,
                                        color: Colors.white,
                                        size: 30,
                                      ))
                                  : GestureDetector(
                                      onTap: () async {
                                        var data = await _apiCall.getCoupons();
                                        int couponIndex;
                                        if (data is List<List<dynamic>> &&
                                            data != null &&
                                            data.length >= 2) {
                                          couponIndex = data[0].indexOf(
                                              couponCode.toUpperCase());

                                          CouponModel item =
                                              data[1][couponIndex];
                                          if (item.timesUsable >
                                              item.timesUsed) {
                                            setState(() {
                                              discount = getDiscount(item);
                                            });

                                            _scaffoldKey.currentState
                                                .showSnackBar(SnackBar(
                                              content:
                                                  Text('Coupon Code applied'),
                                            ));
                                          }
                                        } else
                                          _scaffoldKey.currentState
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Some error occured')));

                                        print("apply");
                                      },
                                      child: Text(
                                        "APPLY",
                                        style: appBarTextStyle.copyWith(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Divider(),
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
                                style: selectedTab.copyWith(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              Text('Change',
                                  style: unSelectedTab.copyWith(
                                      color: defaultGreen)),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 55,
                                  width: 75,
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 0.5,
                                          color: Colors.grey.withOpacity(0.5))),
                                  child: Image.asset(
                                    'images/card.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                SizedBox(
                                  width: 75,
                                ),
                                Text('**** **** **** 3947',
                                    style: unSelectedTab),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      /*  decoration: 
                      BoxDecoration(
                          color: Color.fromRGBO(196, 196, 196, 0.5),
                          borderRadius: BorderRadius.circular(20)), */
                      decoration: BoxDecoration(
                        color: questionnaireDisabled.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Cost Breakdown',
                                style: selectedTab.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Column(
                                children: [
                                  breakDownFields(widget.mealPlan.name,
                                      widget.mealPlan.price + ' USD', false),
                                  widget.afterNoonPrice > 0
                                      ? breakDownFields('Delivery Cost',
                                          '${widget.afterNoonPrice} USD', false)
                                      : Container(),
                                  breakDownFields('Extras', '- - USD', false),
                                  breakDownFields('Taxes', '- - USD', false),
                                  breakDownFields(
                                      'Grand Total',
                                      ((double.parse(widget.mealPlan.price) +
                                                      double.parse(widget
                                                          .afterNoonPrice
                                                          .toString())) -
                                                  discount)
                                              .toString() +
                                          ' USD',
                                      true),
                                ],
                              ),
                            ),
                          ),
                        ],
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
                            if (isAddressSelected && !progress) {
                              setState(() {
                                progress = true;
                              });
                              MealPurchaseModel orderDetails =
                                  MealPurchaseModel(
                                userId: Api.userInfo.id,
                                mealPlanId: widget.mealPlan.id.toString(),
                                paymentId: '1234123',
                                status: '1',
                                mealPlanName: widget.mealPlan.name,
                                mealPlanDuration:
                                    widget.mealPlan.duration.toString(),
                                amountPaid:
                                    ((double.parse(widget.mealPlan.price) +
                                                double.parse(widget
                                                    .afterNoonPrice
                                                    .toString())) -
                                            discount)
                                        .toString(),
                                startDate: widget.selectedDate.toString(),
                                endDate: widget.selectedDate
                                    .add(Duration(
                                        days: widget.mealPlan.duration))
                                    .toString(),
                                weekdays: widget.selectedDays,
                                billingAddressLine1: selectedAddressLine1,
                                billingAddressLine2: selectedAddressLine2,
                                shippingAddressLine1:
                                    widget.shippingAddressLine1,
                                shippingAddressLine2:
                                    widget.shippingAddressLine2,
                              );
                              MealPurchaseModel success =
                                  await _apiCall.postMealPurchase(orderDetails);
                              if (success != null) {
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text(
                                        'Meal Plan Purchased Successfully')));
                                Future.delayed(Duration(seconds: 1))
                                    .whenComplete(() {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  getDates(success);
                                  getData(success);

                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (BuildContext context) =>
                                              PlaceMealMenuOrders(
                                                dates: dates,
                                                placedFoodItems: foodItems,
                                                plan: widget.mealPlan,
                                                purchaseDetails: success,
                                              )));

                                  // Navigator.push(
                                  //     context,
                                  //     CupertinoPageRoute(
                                  //         builder: (context) => PlacedMealMenuOrders(
                                  //               plan: widget.mealPlan,
                                  //               purchaseDetails: success,
                                  //             )));
                                });
                              } else {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  setState(() {
                                    progress = false;
                                  });

                                  _scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Something went wrong')));
                                });
                              }
                              if (success != null) {
                                setState(() {
                                  progress = false;
                                });
                              }
                            } else if (!isAddressSelected) {
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content:
                                      Text('Select a billing address first')));
                            } else if (progress) {
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(
                                      'Please wait purchase in progress')));
                            }
                          },
                          child: Text(
                            'PAY NOW',
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
          ),
        ),
      ),
    );
  }
}
