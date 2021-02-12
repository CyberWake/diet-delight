import 'package:diet_delight/Models/consultationAppointmentModel.dart';
import 'package:diet_delight/Models/consultationPurchaseModel.dart';
import 'package:diet_delight/konstants.dart';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:diet_delight/Models/registrationModel.dart';

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

  TextEditingController addressPrimary1 = TextEditingController();
  TextEditingController addressPrimary2 = TextEditingController();
  TextEditingController addressSecondary1 = TextEditingController();
  TextEditingController addressSecondary2 = TextEditingController();
  FocusNode addressFocus1 = FocusNode();
  FocusNode addressFocus2 = FocusNode();
  String addressArea = 'Bahrain';
  String localAddress = '';
  double _height = 350;
  int items = 4;
  int selectedAddress = -1;
  List<String> types = ['Primary', 'Secondary'];
  List<String> areas = ['Bahrain', 'India'];
  List<String> areas2 = ['Bahrain', 'India'];
  String addressType = 'Primary';

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
  }

  void addAddress({int address}) {
    if (address == 0 && addressPrimary1.text.isNotEmpty) {
      var separatedAddress = addressPrimary1.text.split(',');
      addressArea = separatedAddress[separatedAddress.length - 1];
      localAddress = separatedAddress[0];
    } else if (address == 1 && addressSecondary1.text.isNotEmpty) {
      var separatedAddress = addressSecondary1.text.split(',');
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
                    if (index < 1) {
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(50, 10, 50, 10),
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.0),
                            border: Border.all(width: 0.5, color: formLinks),
                            color: white,
                          ),
                          child: DropDown<String>(
                            showUnderline: false,
                            initialValue: types[index],
                            items: index == 0 ? types : areas,
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
                    } else if (index == 1 || index == 2) {
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(50, 10, 50, 10),
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.0),
                            border: Border.all(width: 0.5, color: formLinks),
                            color: white,
                          ),
                          child: TextFormField(
                              controller: address == 0
                                  ? (index == 1
                                      ? addressPrimary1
                                      : addressPrimary2)
                                  : (index == 1
                                      ? addressSecondary1
                                      : addressSecondary2),
                              focusNode:
                                  index == 1 ? addressFocus1 : addressFocus2,
                              onFieldSubmitted: (done) {
                                localAddress = done;
                              },
                              style: authInputTextStyle,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              decoration: authInputFieldDecoration.copyWith(
                                  hintText: 'Address Line ${index}')),
                        ),
                      );
                    } else if (index == 3) {
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            print(addressArea);
                            if (address == 0) {
                              addressPrimary1.text += ', ' + addressArea;
                              print(addressPrimary1.text);
                            } else if (address == 1) {
                              addressSecondary1.text += ', ' + addressArea;
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
                                      ? 'UPDATE'
                                      : 'ADD',
                                  style: TextStyle(
                                      fontFamily: 'RobotoReg',
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                        ),
                      );
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
                              'DONE',
                              style: TextStyle(
                                  fontFamily: 'RobotoReg',
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                      );
                    }
                    if (index == 0 && addressPrimary1.text.isNotEmpty) {
                      var separatedAddress = addressPrimary1.text.split(',');
                      addressArea =
                          separatedAddress[separatedAddress.length - 1];
                      localAddress = separatedAddress[0];
                    } else if (index == 1 &&
                        addressSecondary1.text.isNotEmpty) {
                      var separatedAddress = addressSecondary1.text.split(',');
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
                                const EdgeInsets.only(left: 0.0, bottom: 10),
                            child: Text(
                              index == 0
                                  ? 'Primary Address'
                                  : 'Secondary Address',
                              style: billingTextStyle.copyWith(
                                  color:
                                      index == 0 ? defaultGreen : Colors.black),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (index == 0) {
                                if (addressPrimary1.text.isNotEmpty) {
                                  modalStateUpdate(() {
                                    selectedAddress = index;
                                  });
                                }
                              } else if (index == 1) {
                                if (addressSecondary1.text.isNotEmpty) {
                                  modalStateUpdate(() {
                                    selectedAddress = index;
                                  });
                                }
                              }
                            },
                            child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.0),
                                  border:
                                      Border.all(width: 0.5, color: formLinks),
                                  color: selectedAddress == index
                                      ? defaultGreen
                                      : white,
                                ),
                                child: localAddress.length > 0
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${name}',
                                                style: billingTextStyle
                                                    .copyWith(fontSize: 14),
                                              ),
                                              Text('Select',
                                                  style:
                                                      billingTextStyle.copyWith(
                                                          fontSize: 14,
                                                          color: defaultGreen)),
                                            ],
                                          ),
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
                                                    style: billingTextStyle
                                                        .copyWith(
                                                      fontSize: 14,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      color: selectedAddress ==
                                                              index
                                                          ? white
                                                          : defaultGreen,
                                                    )),
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
                                                    style: billingTextStyle
                                                        .copyWith(
                                                            fontSize: 14,
                                                            color:
                                                                defaultGreen)),
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
                                            children: [
                                              Text('Not Available',
                                                  style:
                                                      billingTextStyle.copyWith(
                                                          fontSize: 14,
                                                          fontStyle:
                                                              FontStyle.normal))
                                            ],
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
      backgroundColor: Colors.white,
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
        title: Text('Book an Appointment', style: appBarTextStyle),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Text(
                'Billing Address',
                style: billingTextStyle,
              ),
            ),
            GestureDetector(
              onTap: getBottomSheet,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    border: Border.all(width: 0.5, color: formLinks),
                    color: white),
                child: addressPrimaryLine1 == null
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('Add',
                                    style: billingTextStyle.copyWith(
                                        fontSize: 14, color: defaultGreen)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Not Available',
                                    style: billingTextStyle.copyWith(
                                        fontSize: 14,
                                        fontStyle: FontStyle.normal))
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
                              Text('Change',
                                  style: billingTextStyle.copyWith(
                                      fontSize: 14, color: defaultGreen)),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('$addressPrimaryLine1\n$addressPrimaryLine2',
                                  style: billingTextStyle.copyWith(
                                      fontSize: 14,
                                      fontStyle: FontStyle.normal))
                            ],
                          ),
                        ],
                      ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
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
                      Text('Change',
                          style: billingTextStyle.copyWith(
                              fontSize: 14, color: defaultGreen)),
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
                          elevation: 2.0,
                          borderRadius: BorderRadius.circular(2.0),
                          color: Colors.white,
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 30),
                              child: Container(
                                height: 55,
                                width: 75,
                                child: Image.asset(
                                  'images/card.png',
                                  fit: BoxFit.fill,
                                ),
                              ))),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
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
                          await _apiCall.postConsultationAppointment(_appointment);
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
