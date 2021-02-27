import 'package:diet_delight/Models/consultationAppointmentModel.dart';
import 'package:diet_delight/Models/consultationPurchaseModel.dart';
import 'package:diet_delight/Models/consultationModel.dart';
import 'package:diet_delight/konstants.dart';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:diet_delight/Models/registrationModel.dart';
import 'package:diet_delight/Widgets/getAddressModalSheet.dart';
import 'package:diet_delight/landingPage.dart';
import 'package:diet_delight/Screens/Auth Screens/revisedQuestionnaire.dart';
import 'package:date_format/date_format.dart';

class PrePayment extends StatefulWidget {
  final int package;
  final ConsAppointmentModel appointment;
  final ConsPurchaseModel orderDetails;
  final List<ConsultationModel> consultation;
  final String consultationMode;
  PrePayment(
      {this.package,
      this.orderDetails,
      this.appointment,
      this.consultation,
      this.consultationMode});
  @override
  _PrePaymentState createState() => _PrePaymentState();
}

class _PrePaymentState extends State<PrePayment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Api _apiCall = Api.instance;
  ConsAppointmentModel _appointment;
  ConsPurchaseModel order;
  FlutterSecureStorage storage = new FlutterSecureStorage();
  int consultationIndex;
  bool isButtonEnabled = true;
  int paymentMethod = 0;
  List<String> format = [hh, ':', nn, ' ', am, ', ', dd, ' ', 'M', ', ', yyyy];

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
    consultationIndex = widget.package;
    getUserInfo();
    addressPrimaryLine1 == 'null' ? print(addressPrimaryLine1) : print('yes');
    super.initState();
    order = widget.orderDetails;
    _appointment = widget.appointment;
//    DateTime appointmentDateTime =
//        DateTime.parse(widget.appointment.consultationTime);
//    print(appointmentDateTime);
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

  Widget breakDownFields(String disc, String price, bool isGrandTotal) {
    return Row(
      mainAxisAlignment:
          isGrandTotal ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
      children: [
        Padding(
            padding: isGrandTotal
                ? EdgeInsets.only(top: 10.0, right: 10)
                : EdgeInsets.only(top: 10.0),
            child: Text(disc, style: costBreakdownTextStyle)),
        Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(price, style: costBreakdownTextStyle)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var devWidth = MediaQuery.of(context).size.width;
    var devHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/consultation.jpg'),
              fit: BoxFit.fitHeight),
        ),
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
//          shape: RoundedRectangleBorder(
//              borderRadius: BorderRadius.only(
//                  bottomLeft: Radius.circular(20.0),
//                  bottomRight: Radius.circular(20.0))),
            centerTitle: false,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.keyboard_backspace,
                size: 30.0,
                color: questionnaireSelect,
              ),
            ),
            title: Text('Book an Appointment',
                style: appBarTextStyle.copyWith(
                    fontFamily: 'RobotoReg',
                    color: questionnaireSelect,
                    fontWeight: FontWeight.bold)),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.11),
                  child: Text(
                    'Billing Address',
                    style: billingTextStyle,
                  ),
                ),
                Material(
                  borderRadius: BorderRadius.circular(15.0),
                  shadowColor: Color(0x00000000),
                  elevation: 0,
                  color: Colors.transparent,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: MediaQuery.of(context).size.width * 0.11),
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                    decoration: BoxDecoration(
//                    boxShadow: [
//                      BoxShadow(color: Color(0x26000000), blurRadius: 5)
//                    ],
                        borderRadius: BorderRadius.circular(15.0),
                        color: questionnaireDisabled.withOpacity(0.4)),
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
                                          style:
                                              addressChangeTextStyle.copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Not Available',
                                        style: addressChangeTextStyle.copyWith(
                                            fontSize: 14))
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '$name',
                                    style: addressChangeTextStyle.copyWith(
                                        fontSize: 14),
                                  ),
                                  AddressButtonWithModal(
                                    callBackFunction: callback,
                                    child: Text('Change',
                                        style: addressChangeTextStyle.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    (selectedAddressLine1 == '' ||
                                            selectedAddressLine1 == null)
                                        ? Text(
                                            '$addressPrimaryLine1\n$addressPrimaryLine2',
                                            style:
                                                addressChangeTextStyle.copyWith(
                                              fontSize: 14,
                                            ))
                                        : Text(
                                            '$selectedAddressLine1\n$selectedAddressLine2',
                                            style:
                                                addressChangeTextStyle.copyWith(
                                              fontSize: 14,
                                            ))
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.075,
                        0,
                        MediaQuery.of(context).size.width * 0.075,
                        10),
                    child: Container(
                      color: paymentSeparator,
                      height: 1.0,
                    )),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width * 0.11,
                      5,
                      MediaQuery.of(context).size.width * 0.11,
                      10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Payment Method',
                            style: billingTextStyle,
                          ),
                          Spacer(
                            flex: 7,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                right:
                                    MediaQuery.of(context).size.width * 0.075),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NewQuestionnaire()));
                              },
                              child: Text('Change',
                                  style: addressChangeTextStyle.copyWith(
                                      fontSize: 14, color: defaultGreen)),
                            ),
                          ),
                          Spacer(),
                          SizedBox(
                            width: 0,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: devWidth * 0.05),
                            child: Material(
                              borderRadius: BorderRadius.circular(5.0),
                              color: white,
                              elevation: 1,
                              child: ListTile(
                                  dense: true,
                                  onTap: () {
                                    setState(() {
                                      paymentMethod = 0;
                                    });
                                  },
                                  title: Text(
                                    'Pay at Clinic',
                                    style: billingTextStyle.copyWith(
                                        fontSize: 14,
                                        color: paymentMethod == 0
                                            ? defaultGreen
                                            : Colors.black),
                                  ),
                                  trailing: Icon(Icons.check_circle,
                                      color: paymentMethod == 0
                                          ? defaultGreen
                                          : Colors.transparent,
                                      size: 20)),
                            ),
                          ),
                          SizedBox(height: devHeight * 0.015),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: devWidth * 0.05),
                            child: Material(
                              borderRadius: BorderRadius.circular(5.0),
                              color: white,
                              elevation: 1,
                              child: ListTile(
                                  dense: true,
                                  onTap: () {
                                    setState(() {
                                      paymentMethod = 1;
                                    });
                                  },
                                  title: Text(
                                    'Pay Online',
                                    style: billingTextStyle.copyWith(
                                        fontSize: 14,
                                        color: paymentMethod == 1
                                            ? defaultGreen
                                            : Colors.black),
                                  ),
                                  trailing: Icon(Icons.check_circle,
                                      color: paymentMethod == 1
                                          ? defaultGreen
                                          : Colors.transparent,
                                      size: 20)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.075,
                        10,
                        MediaQuery.of(context).size.width * 0.075,
                        10),
                    child: Container(
                      color: paymentSeparator,
                      height: 1.0,
                    )),
                Material(
                  borderRadius: BorderRadius.circular(15.0),
                  elevation: 0,
                  color: Colors.transparent,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.05,
                        0,
                        MediaQuery.of(context).size.width * 0.05,
                        0),
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                    decoration: BoxDecoration(
//                    boxShadow: [
//                      BoxShadow(color: Color(0x26000000), blurRadius: 5)
//                    ],
                        borderRadius: BorderRadius.circular(15.0),
                        color: questionnaireDisabled.withOpacity(0.4)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.0,
                                top: 0.0),
                            child: Text(
                              'Cost Breakdown',
                              style: billingTextStyle,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: Column(
                              children: [
                                breakDownFields(
                                    '${widget.consultation[consultationIndex].name} Consultancy Package',
                                    '${widget.consultation[consultationIndex].price} BHD',
                                    false),
                                widget.consultationMode == "0"
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                            top: 5.0, left: 10.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                              'First Appointment - ' +
                                                  formatDate(
                                                      DateTime.parse(_appointment
                                                          .consultationTime),
                                                      format),
                                              style: costBreakdownTextStyle
                                                  .copyWith(fontSize: 11)),
                                        ))
                                    : SizedBox(),
                                breakDownFields('Extras', '- - BHD', false),
                                breakDownFields('Taxes', '- - BHD', false),
                                breakDownFields(
                                    'Grand Total',
                                    '${int.parse(widget.consultation[consultationIndex].price.substring(0, 2)) + 80} BHD',
                                    true),
                              ],
                            ),
                          ),
                        ]),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 0, 50, 20),
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
                                String id = await _apiCall
                                    .postConsultationPurchase(order);
                              } else if ((selectedAddressLine1 == '' ||
                                      selectedAddressLine1 == null) &&
                                  addressPrimaryLine1 != null) {
                                order.setUserPaymentDetails(
                                    userId: Api.userInfo.id,
                                    paymentId: '11487',
                                    billingAddressLine1: addressPrimaryLine1,
                                    billingAddressLine2: addressPrimaryLine2);
                                String id = await _apiCall
                                    .postConsultationPurchase(order);
                              }
                              String id = await _apiCall
                                  .postConsultationPurchase(order);
                              if (id != null) {
                                _appointment.putDetails(
                                    packagePurchaseId: id,
                                    selectedConsultationMode:
                                        widget.consultationMode);
                                bool success = await _apiCall
                                    .postConsultationAppointment(_appointment);
                                if (success) {
                                  _scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                          content: Text('Appointment Added')));
                                }
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text('Purchase Successful')));
                              } else {
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text('Something went wrong')));
                              }
                              Navigator.pushReplacement(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          HomePage(openPage: 3)));
                            }
                          : () {},
                      child: Text(
                        paymentMethod == 0 ? 'BOOK APPOINTMENT' : 'PAY NOW',
                        style: TextStyle(
                          fontFamily: 'RobotoReg',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
    );
  }
}
