import 'package:diet_delight/Models/consultationAppointmentModel.dart';
import 'package:diet_delight/Models/consultationPurchaseModel.dart';
import 'package:diet_delight/konstants.dart';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:diet_delight/Models/registrationModel.dart';
import 'package:diet_delight/Widgets/getAddressModalSheet.dart';
import 'package:diet_delight/landingPage.dart';

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
  FlutterSecureStorage storage = new FlutterSecureStorage();

  bool isButtonEnabled = true;

  RegModel info;
  String name;
  String mobileNo;
  String email;
  String addressPrimaryLine1;
  String addressPrimaryLine2;
  String addressSecondaryLine1;
  String addressSecondaryLine2;

  getUserInfo() async {
    info = Api.userInfo;
    name = info.firstName + ' ' + info.lastName;
    mobileNo = info.mobile;
    email = info.email;
    addressPrimaryLine1 = info.addressLine1;
    addressSecondaryLine1 = info.addressSecondary1;
    addressPrimaryLine2 = info.addressLine2;
    addressSecondaryLine2 = info.addressSecondary2;
  }

  @override
  void initState() {
    getUserInfo();
    addressPrimaryLine1 == 'null' ? print(addressPrimaryLine1) : print('yes');
    super.initState();
    order = widget.orderDetails;
    _appointment = widget.appointment;
    concatenatedAddress = '';
    selectedAddressLine1 = '';
    selectedAddressLine2 = '';
//    print('selectedIndex : ' +
//        storage.read(key: 'selectedAddressIndex').toString());
//    if (storage.read(key: 'selectedAddressIndex') != null) {
//      isAddressSelected = true;
//      selectedAddressIndex =
//          int.parse(storage.read(key: 'selectedAddressIndex').toString());
//    } else {
    isAddressSelected = false;
    selectedAddressIndex = 0;
//    }
  }

  callback(address) {
    setState(() {
      concatenatedAddress = address;
    });
  }

  @override
  Widget build(BuildContext context) {
    var devWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: white,
        centerTitle: false,
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
        title: Text('Book an Appointment', style: appBarTextStyle),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.075),
              child: Text(
                'Billing Address',
                style: billingTextStyle,
              ),
            ),
            Material(
              borderRadius: BorderRadius.circular(5.0),
              shadowColor: Color(0x26000000),
              elevation: 2,
              color: Colors.white,
              child: Container(
                margin: EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: MediaQuery.of(context).size.width * 0.075),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: Color(0x26000000), blurRadius: 5)
                    ],
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white),
                child: addressPrimaryLine1 == null
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                AddressButtonWithModal(
                                  addNewAddressOnly: true,
                                  callBackFunction: callback,
                                  child: Text('ADD',
                                      style: billingTextStyle.copyWith(
                                          fontSize: 14, color: defaultGreen)),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Not Available',
                                    style: billingTextStyle.copyWith(
                                        fontSize: 14,
                                        fontStyle: FontStyle.normal,
                                        color: Color(0xFF4E4848)))
                              ],
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${name}',
                                style: billingTextStyle.copyWith(fontSize: 14),
                              ),
                              AddressButtonWithModal(
                                callBackFunction: callback,
                                child: Text('Change',
                                    style: billingTextStyle.copyWith(
                                        fontSize: 14, color: defaultGreen)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              (selectedAddressLine1 == '' ||
                                      selectedAddressLine1 == null)
                                  ? Text(
                                      '$addressPrimaryLine1\n$addressPrimaryLine2',
                                      style: billingTextStyle.copyWith(
                                        fontSize: 14,
                                        fontStyle: FontStyle.normal,
                                        color: Color(0xFF222222),
                                      ))
                                  : Text(
                                      '$selectedAddressLine1\n$selectedAddressLine2',
                                      style: billingTextStyle.copyWith(
                                        fontSize: 14,
                                        fontStyle: FontStyle.normal,
                                        color: Color(0xFF222222),
                                      ))
                            ],
                          ),
                        ],
                      ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.075, 20, 0, 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Payment',
                        style: billingTextStyle,
                      ),
                      Spacer(
                        flex: 7,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.075),
                        child: Text('Change',
                            style: billingTextStyle.copyWith(
                                fontSize: 14, color: defaultGreen)),
                      ),
                      Spacer(),
                      SizedBox(
                        width: 0,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Material(
                        borderRadius: BorderRadius.circular(5.0),
                        shadowColor: Color(0x26000000),
                        elevation: 2,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.height * 0.1,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0x26000000), blurRadius: 5)
                              ],
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.white),
                          child: Center(
                            child: Image.asset(
                              'images/card.png',
                              width: MediaQuery.of(context).size.width * 0.15,
                              height:
                                  MediaQuery.of(context).size.height * 0.075,
                            ),
                          ),
                        ),
                      ),
//                      Material(
//                          elevation: 2.0,
//                          borderRadius: BorderRadius.circular(2.0),
//                          color: Colors.white,
//                          child: Padding(
//                              padding: EdgeInsets.symmetric(
//                                  vertical: 15, horizontal: 30),
//                              child: Container(
//                                height: 55,
//                                width: 75,
//                                child: Image.asset(
//                                  'images/card.png',
//                                  fit: BoxFit.fill,
//                                ),
//                              ))),
                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.05),
                        child: Text('**** **** **** 3947',
                            style: billingTextStyle.copyWith(
                                fontStyle: FontStyle.normal)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 50, 50, 30),
              child: SizedBox(
                width: double.infinity,
                height: 40.0,
                child: TextButton(
                  onPressed: isButtonEnabled
                      ? () async {
                          setState(() {
                            isButtonEnabled = false;
                          });
                          print('pressed');
                          if ((selectedAddressLine1 == '' ||
                                  selectedAddressLine1 == null) &&
                              addressPrimaryLine1 == null) {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text(
                                    'Please Add and select an address before proceeding')));
                          } else if (selectedAddressLine1 != null &&
                              selectedAddressLine1 != '') {
                            order.setUserPaymentDetails(
                                userId: Api.userInfo.id,
                                paymentId: '11487',
                                billingAddressLine1: selectedAddressLine1,
                                billingAddressLine2: selectedAddressLine2);
                            String id =
                                await _apiCall.postConsultationPurchase(order);
                          } else if ((selectedAddressLine1 == '' ||
                                  selectedAddressLine1 == null) &&
                              addressPrimaryLine1 != null) {
                            order.setUserPaymentDetails(
                                userId: Api.userInfo.id,
                                paymentId: '11487',
                                billingAddressLine1: addressPrimaryLine1,
                                billingAddressLine2: addressPrimaryLine2);
                            String id =
                                await _apiCall.postConsultationPurchase(order);
                          }
                          String id =
                              await _apiCall.postConsultationPurchase(order);
                          if (id != null) {
                            _appointment.putId(packagePurchaseId: id);
                            bool success = await _apiCall
                                .postConsultationAppointment(_appointment);
                            if (success) {
                              _scaffoldKey.currentState.showSnackBar(
                                  SnackBar(content: Text('Appointment Added')));
                            }
                            _scaffoldKey.currentState.showSnackBar(
                                SnackBar(content: Text('Purchase Successful')));
                          } else {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text('Something went wrong')));
                          }
                          Navigator.pushReplacement(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      HomePage(drawerPage: 3)));
                        }
                      : () {},
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
