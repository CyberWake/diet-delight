import 'package:diet_delight/konstants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrePaymentMealPlan extends StatefulWidget {
  final DateTime selectedDate;
  final List<String> selectedDays;
  PrePaymentMealPlan({this.selectedDate, this.selectedDays});
  @override
  _PrePaymentMealPlanState createState() => _PrePaymentMealPlanState();
}

class _PrePaymentMealPlanState extends State<PrePaymentMealPlan> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Jane Doe',
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
                          child: Text('Menu Package Name',
                              style: selectedTab.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.normal)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text('Menu Package Description',
                              style: selectedTab.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.normal)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text('Menu Package Categories',
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
                      breakDownFields('Meal Plan Name', '- - USD', false),
                      breakDownFields('Extras', '- - USD', false),
                      breakDownFields('Taxes', '- - USD', false),
                      breakDownFields('Grand Total', '- - USD', true),
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
                    onPressed: () {
                      print('pressed');
                      _scaffoldKey.currentState.showSnackBar(
                          SnackBar(content: Text('To be implemented')));
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
