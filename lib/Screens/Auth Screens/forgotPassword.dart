import 'dart:ui';

import 'package:diet_delight/Models/export_models.dart';
import 'package:diet_delight/Screens/export.dart';
import 'package:diet_delight/konstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => new _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool result = false;
  bool initialised = false;
  TextEditingController mobileNo = TextEditingController();
  TextEditingController enteredOtp = TextEditingController();
  TextEditingController countryCode = TextEditingController();
  FocusNode country = FocusNode();
  FocusNode mobile = FocusNode();
  RegModel userData;

  @override
  void initState() {
    super.initState();
    countryCode.text = '+973';
  }

  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0, 0),
                    child: SizedBox(
                      width: 30.0,
                      height: 30.0,
                      child: Icon(
                        Icons.keyboard_backspace,
                        size: 30.0,
                        color: defaultGreen,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 4 * MediaQuery.of(context).size.width / 5,
                      child: Image.asset(
                        'images/Group 57.png',
                        width: 120.0,
                        height: 50.0,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 30.0, 0, 20.0),
              child: Container(
                color: formBackground,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        'FORGOT PASSWORD',
                        style: TextStyle(
                          fontFamily: 'RobotoCondensedReg',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: defaultGreen,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 15, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('PHONE NUMBER', style: authLabelTextStyle),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8.0, 20, 0),
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Container(
                                      width: devWidth / 5,
                                      height: 40.0,
                                      decoration: authFieldDecoration,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 3, 15, 7),
                                        child: TextFormField(
                                          focusNode: country,
                                          controller: countryCode,
                                          onFieldSubmitted: (done) {
                                            country.unfocus();
                                            FocusScope.of(context)
                                                .requestFocus(mobile);
                                          },
                                          style: TextStyle(
                                            fontFamily: 'RobotoCondensedReg',
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                            color: formFill,
                                          ),
                                          textAlign: TextAlign.center,
                                          textInputAction: TextInputAction.next,
                                          keyboardType: TextInputType.phone,
                                          decoration: authInputFieldDecoration,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Container(
                                      width: 3 * devWidth / 5,
                                      height: 40.0,
                                      decoration: authFieldDecoration,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 3, 20, 7),
                                        child: TextFormField(
                                            controller: mobileNo,
                                            onFieldSubmitted: (done) {
                                              mobile.unfocus();
                                            },
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.phone,
                                            focusNode: mobile,
                                            textInputAction:
                                                TextInputAction.done,
                                            style: authInputTextStyle,
                                            decoration:
                                                authInputFieldDecoration),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
            padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                      child: SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => VerifyPhoneNumber(
                                      regDetails: RegModel(mobile: countryCode.text+mobileNo.text),
                                      from: FromPage.forgetPass,
                                    )));
                          },
                          child: Text(
                            'SEND OTP',
                            style: TextStyle(
                              fontFamily: 'RobotoCondensedReg',
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                          style: TextButton.styleFrom(
                              backgroundColor: defaultGreen,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)))),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
