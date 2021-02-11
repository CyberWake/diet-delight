import 'package:diet_delight/Models/registrationModel.dart';
import 'package:diet_delight/konstants.dart';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressButtonWithModal extends StatefulWidget {
  final bool addNewAddressOnly;
  final Widget child;
  final Function(String) callBackFunction;
  AddressButtonWithModal(
      {this.child, this.callBackFunction, this.addNewAddressOnly = false});
  @override
  _AddressButtonWithModalState createState() => _AddressButtonWithModalState();
}

class _AddressButtonWithModalState extends State<AddressButtonWithModal> {
  TextEditingController addressPrimaryLine1 = TextEditingController();
  TextEditingController addressSecondaryLine1 = TextEditingController();
  TextEditingController addressPrimaryLine2 = TextEditingController();
  TextEditingController addressSecondaryLine2 = TextEditingController();
  FocusNode addressLine1 = FocusNode();
  FocusNode addressLine2 = FocusNode();
  final _apiCall = Api.instance;
  List<String> types = ['Primary', 'Secondary'];
  String addressType = 'Primary';
  double _height = 300;
  int whichAddress;
  int items = 4;
  RegModel info;
  String name;

  getUserInfo() async {
//    info = Api.userInfo;
//    name = info.firstName + ' ' + info.lastName;
    name = Api.userInfo.name;
    addressPrimaryLine1.text = Api.userInfo.addressLine1;
    addressSecondaryLine1.text = Api.userInfo.addressSecondary1;
    addressPrimaryLine2.text = Api.userInfo.addressLine2;
    addressSecondaryLine2.text = Api.userInfo.addressSecondary2;
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
    addressLine1.addListener(() {
      if (addressLine1.hasFocus) {
        print('height increased');
        setState(() {
          items = 5;
          _height = 550;
        });
      } else if (!addressLine1.hasFocus) {
        print('height decreased');
        setState(() {
          items = 4;
          _height = 300;
        });
      }
    });
    addressLine2.addListener(() {
      if (addressLine2.hasFocus) {
        print('height increased');
        setState(() {
          items = 5;
          _height = 550;
        });
      } else if (!addressLine2.hasFocus) {
        print('height decreased');
        setState(() {
          items = 4;
          _height = 300;
        });
      }
    });
  }

  void addAddressBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        builder: (builder) {
          return Container(
            height: _height,
            color: Colors.transparent,
            child: Container(
                padding: EdgeInsets.only(top: 30),
                child: Column(
                    children: List.generate(items, (index) {
                  if (index == 0) {
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
                          items: types,
                          onChanged: (String choice) {
                            addressType = choice;
                            whichAddress = types.indexOf(choice);
                          },
                          initialValue: addressType,
                          isExpanded: true,
                        ),
                      ),
                    );
                  } else if (index < 3) {
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
                            focusNode: index == 1 ? addressLine1 : addressLine2,
                            onChanged: (value) {
                              if (index == 1) {
                                if (whichAddress == 0) {
                                  addressPrimaryLine1.text = value;
                                } else {
                                  addressSecondaryLine1.text = value;
                                }
                              } else {
                                if (whichAddress == 0) {
                                  addressPrimaryLine2.text = value;
                                } else {
                                  addressSecondaryLine2.text = value;
                                }
                              }
                            },
                            onFieldSubmitted: (done) {
                              if (index == 1) {
                                Focus.of(context).requestFocus(addressLine2);
                              }
                            },
                            style: authInputTextStyle,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            decoration: authInputFieldDecoration.copyWith(
                                hintText: index == 1
                                    ? 'House No, Street Name'
                                    : 'City')),
                      ),
                    );
                  } else if (index == 3) {
                    return Expanded(
                        child: GestureDetector(
                      onTap: () async {
                        if (whichAddress == 0) {
                          primaryAddressLine1 = addressPrimaryLine1.text;
                          primaryAddressLine2 = addressPrimaryLine2.text;
                          concatenatedAddress = addressPrimaryLine1.text +
                              ',\n' +
                              addressPrimaryLine2.text;
                        } else if (whichAddress == 1) {
                          secondaryAddressLine1 = addressSecondaryLine1.text;
                          secondaryAddressLine2 = addressSecondaryLine2.text;
                          concatenatedAddress = addressSecondaryLine1.text +
                              ',\n' +
                              addressSecondaryLine2.text;
                        }
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        String password = prefs.getString('password');
                        RegModel updateUserData = RegModel(
                          name: Api.userInfo.firstName +
                              ' ' +
                              Api.userInfo.lastName,
                          firstName: Api.userInfo.firstName,
                          lastName: Api.userInfo.lastName,
                          email: Api.userInfo.email,
                          mobile: Api.userInfo.mobile,
                          password: password,
                          addressLine1: primaryAddressLine1,
                          addressSecondary1: secondaryAddressLine1,
                          addressLine2: primaryAddressLine2,
                          addressSecondary2: secondaryAddressLine2,
                        );
                        updateUserData.show();
                        Navigator.pop(context);
                        bool result = false;
                        if (!widget.addNewAddressOnly) {
                          result = await _apiCall.putUserInfo(updateUserData);
                        }
                        setState(() {});
                        widget.callBackFunction(concatenatedAddress);
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 20),
                        color: defaultGreen,
                        child: Center(
                            child: Text(
                          'UPDATE',
                          style: TextStyle(
                              fontFamily: 'RobotoReg',
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    ));
                  } else {
                    return SizedBox(
                      height: 250,
                    );
                  }
                }))),
          );
        });
  }

  getBottomSheet() async {
    await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
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
                            if (isAddressSelected) {
                              if (selectedAddressIndex == 0) {
                                concatenatedAddress = addressPrimaryLine1.text +
                                    ',\n' +
                                    addressPrimaryLine2.text;
                                selectedAddressLine1 = addressPrimaryLine1.text;
                                selectedAddressLine2 = addressPrimaryLine2.text;

                                widget.callBackFunction(concatenatedAddress);
                              } else if (selectedAddressIndex == 1) {
                                concatenatedAddress =
                                    addressSecondaryLine1.text +
                                        ',\n' +
                                        addressSecondaryLine2.text;
                                selectedAddressLine1 =
                                    addressSecondaryLine1.text;
                                selectedAddressLine2 =
                                    addressSecondaryLine2.text;
                                widget.callBackFunction(concatenatedAddress);
                              }
                            }
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
                              style: billingTextStyle.copyWith(
                                  color: index == 0
                                      ? defaultGreen
                                      : Color(0xFF222222)),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (index == 0) {
                                if (addressPrimaryLine1.text.isNotEmpty &&
                                    addressPrimaryLine2.text.isNotEmpty) {
                                  modalStateUpdate(() {
                                    selectedAddressIndex = index;
                                    isAddressSelected = true;
                                  });
                                }
                              } else if (index == 1) {
                                if (addressSecondaryLine1.text.isNotEmpty &&
                                    addressSecondaryLine2.text.isNotEmpty) {
                                  modalStateUpdate(() {
                                    selectedAddressIndex = index;
                                    isAddressSelected = true;
                                  });
                                }
                              }
                            },
                            child: Material(
                                borderRadius: BorderRadius.circular(5.0),
                                shadowColor: Color(0x26000000),
                                elevation: 2,
                                color: Colors.white,
                                child: Container(
                                    height: 100.0,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 25),
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color: Color(0x26000000),
                                              blurRadius: 5)
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: selectedAddressIndex == index
                                            ? defaultGreen
                                            : Colors.white),
                                    child: (addressPrimaryLine1
                                                    .text.isNotEmpty ||
                                                addressSecondaryLine1
                                                    .text.isNotEmpty) &&
                                            (addressPrimaryLine2
                                                    .text.isNotEmpty ||
                                                addressSecondaryLine2
                                                    .text.isNotEmpty)
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    '${name}',
                                                    style: billingTextStyle
                                                        .copyWith(
                                                      fontSize: 14,
                                                      color:
                                                          selectedAddressIndex ==
                                                                  index
                                                              ? white
                                                              : Color(
                                                                  0xFF222222),
                                                    ),
                                                  ),
                                                  Text('Select',
                                                      style: billingTextStyle
                                                          .copyWith(
                                                              fontSize: 14,
                                                              color:
                                                                  defaultGreen)),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    index == 0
                                                        ? addressPrimaryLine1
                                                                .text +
                                                            ',\n' +
                                                            addressPrimaryLine2
                                                                .text
                                                        : addressSecondaryLine1
                                                                .text +
                                                            ',\n' +
                                                            addressSecondaryLine2
                                                                .text,
                                                    style: billingTextStyle
                                                        .copyWith(
                                                      fontSize: 14,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      color:
                                                          selectedAddressIndex ==
                                                                  index
                                                              ? white
                                                              : Color(
                                                                  0xFF222222),
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
                                                    child: Text('ADD',
                                                        style: billingTextStyle
                                                            .copyWith(
                                                                fontSize: 14,
                                                                color:
                                                                    defaultGreen)),
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, false);
                                                      addAddressBottomSheet();
                                                    },
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text('Not Available',
                                                      style: billingTextStyle
                                                          .copyWith(
                                                              fontSize: 14,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              color: Color(
                                                                  0xFF4E4848)))
                                                ],
                                              )
                                            ],
                                          ))),
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
    return GestureDetector(
      onTap: () {
        if (widget.addNewAddressOnly) {
          addAddressBottomSheet();
        } else {
          getBottomSheet();
        }
      },
      child: widget.child,
    );
  }
}
