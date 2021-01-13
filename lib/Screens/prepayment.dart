import 'package:diet_delight/konstants.dart';
import 'package:flutter/material.dart';

class PrePayment extends StatefulWidget {
  @override
  _PrePaymentState createState() => _PrePaymentState();
}

class _PrePaymentState extends State<PrePayment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                'Billing Address',
                style: selectedTab,
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.grey[500],
                      spreadRadius: 1,
                    )
                  ],
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
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.grey[500],
                      spreadRadius: 1,
                    )
                  ],
                  border: Border.all(width: 1, color: Colors.grey),
                  color: white),
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
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey)),
                        child: FlutterLogo(
                          size: 60,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 30.0, bottom: 20),
                        child:
                            Text('**** **** **** 3947', style: unSelectedTab),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
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
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
