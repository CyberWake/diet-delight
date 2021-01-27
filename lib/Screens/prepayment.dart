import 'package:diet_delight/Models/consultationAppointmentModel.dart';
import 'package:diet_delight/Models/consultationPurchaseModel.dart';
import 'package:diet_delight/konstants.dart';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:flutter/material.dart';

class PrePayment extends StatefulWidget {
  final ConsAppointmentModel appointment;
  final ConsPurchaseModel orderDetails;
  PrePayment({this.orderDetails, this.appointment});
  @override
  _PrePaymentState createState() => _PrePaymentState();
}

class _PrePaymentState extends State<PrePayment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Api _apiCall = Api.instance;
  ConsAppointmentModel _appointment;
  ConsPurchaseModel order;
  @override
  void initState() {
    super.initState();
    order = widget.orderDetails;
    _appointment = widget.appointment;
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
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.25),
                      spreadRadius: 0,
                      offset: const Offset(0.0, 0.0),
                    )
                  ],
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
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.25),
                      spreadRadius: 0,
                      offset: const Offset(0.0, 0.0),
                    )
                  ],
                  borderRadius: BorderRadius.circular(8.0),
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
            Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 50, 30, 30),
              child: SizedBox(
                width: double.infinity,
                height: 50.0,
                child: TextButton(
                  onPressed: () async {
                    print('pressed');
                    order.setUserPaymentDetails(
                        userId: Api.userInfo.id, paymentId: '11487');
                    String id = await _apiCall.postConsultationPurchase(order);
                    if (id != null) {
                      _appointment.putId(packagePurchaseId: id);
                      bool success =
                          await _apiCall.postAppointment(_appointment);
                      if (success) {
                        _scaffoldKey.currentState.showSnackBar(
                            SnackBar(content: Text('Appointment Added')));
                      }
                      _scaffoldKey.currentState.showSnackBar(
                          SnackBar(content: Text('Purchase Successful')));
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
