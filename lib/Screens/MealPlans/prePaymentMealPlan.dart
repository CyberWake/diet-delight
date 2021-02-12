import 'package:diet_delight/Models/mealModel.dart';
import 'package:diet_delight/Models/mealPurchaseModel.dart';
import 'package:diet_delight/Models/menuCategoryModel.dart';
import 'package:diet_delight/Screens/Menu/placedMealMenuOrders.dart';
import 'package:diet_delight/Widgets/getAddressModalSheet.dart';
import 'package:diet_delight/konstants.dart';
import 'package:diet_delight/services/apiCalls.dart';
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
  PrePaymentMealPlan(
      {this.categories,
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

  @override
  void initState() {
    super.initState();
    concatenatedAddress = '';
    isAddressSelected = false;
    selectedAddressIndex = -1;
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
                child: isAddressSelected
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Api.userInfo.firstName +
                                    ' ' +
                                    Api.userInfo.lastName,
                                style: selectedTab,
                              ),
                              AddressButtonWithModal(
                                callBackFunction: callback,
                                child: Text('Change',
                                    style: unSelectedTab.copyWith(
                                        color: defaultGreen)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(concatenatedAddress, style: unSelectedTab)
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Select An Address', style: unSelectedTab)
                            ],
                          ),
                          SizedBox(
                            height: 20,
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
                          child: Text(widget.categories,
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
                      if (isAddressSelected && !progress) {
                        setState(() {
                          progress = true;
                        });
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
                          billingAddressLine1: selectedAddressLine1,
                          billingAddressLine2: selectedAddressLine2,
                          shippingAddressLine1: widget.shippingAddressLine1,
                          shippingAddressLine2: widget.shippingAddressLine2,
                        );
                        MealPurchaseModel success =
                            await _apiCall.postMealPurchase(orderDetails);
                        if (success != null) {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content:
                                  Text('Meal Plan Purchased Successfully')));
                          Future.delayed(Duration(seconds: 1)).whenComplete(() {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => PlacedMealMenuOrders(
                                          plan: widget.mealPlan,
                                          purchaseDetails: success,
                                        )));
                          });
                        } else {
                          setState(() {
                            progress = false;
                          });
                          _scaffoldKey.currentState.showSnackBar(
                              SnackBar(content: Text('Something went wrong')));
                        }
                        if (success != null) {
                          setState(() {
                            progress = false;
                          });
                        }
                      } else if (!isAddressSelected) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text('Select a billing address first')));
                      } else if (progress) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text('Please wait purchase in progress')));
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
