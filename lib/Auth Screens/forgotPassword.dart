import 'dart:ui';

import 'package:diet_delight/konstants.dart';
import 'package:diet_delight/services/otp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

import 'file:///C:/Users/VK/Desktop/ritik/diet-delight-mobile/lib/Auth%20Screens/resetPassword.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => new _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  int count = 0;
  String enteredOtp;
  TextEditingController mobileNo = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FlutterOtp otp = FlutterOtp();

  sendOtp() {
    List<String> number = mobileNo.text.split(' ');
    print(number.first);
    print(number.last);
    print('running');
    otp.sendOtp(number.last, "<#> Verification code for diet delight is: ",
        100000, 999999, number.first);
    otp.getOtp();
    print('done');
  }

  @override
  Widget build(BuildContext context) {
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
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PHONE NUMBER',
                            style: authLabelTextStyle,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                            child: Material(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                width: double.infinity,
                                height: 40.0,
                                decoration: authFieldDecoration,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 3, 20, 7),
                                  child: TextFormField(
                                    onChanged: (String number) {
                                      mobileNo.text = number;
                                    },
                                    onFieldSubmitted: (done) {
                                      mobileNo.text = done;
                                    },
                                    style: authInputTextStyle,
                                    keyboardType: TextInputType.phone,
                                    decoration: authInputFieldDecoration,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ENTER OTP',
                            style: TextStyle(
                              fontFamily: 'RobotoCondensedReg',
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: defaultGreen,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 11, vertical: 4),
                                child: PinCodeTextField(
                                  maxLength: 6,
                                  hasUnderline: false,
                                  pinBoxWidth: 30,
                                  pinBoxHeight: 40,
                                  hasTextBorderColor: Color(0xff909090),
                                  pinBoxColor: Colors.transparent,
                                  pinBoxDecoration: ProvidedPinBoxDecoration
                                      .underlinedPinBoxDecoration,
                                  defaultBorderColor: Color(0xff909090),
                                  onTextChanged: (String otp) {
                                    print(otp);
                                    enteredOtp = otp;
                                  },
                                  pinTextStyle: TextStyle(
                                    fontFamily: 'RobotoReg',
                                    color: formFill,
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 30, 0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: sendOtp,
                          child: Text(
                            'Resend OTP',
                            style: TextStyle(
                              fontFamily: 'RobotoCondensedReg',
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: formFill,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                      child: SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            if (count > 0 && mobileNo.text.isNotEmpty) {
                              if (enteredOtp.isNotEmpty && otp.resultChecker(int.parse(enteredOtp))) {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => ResetPassword()));
                              }else {
                                if(enteredOtp.isEmpty){
                                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                                      content:
                                      Text('OTP not entered')));
                                }else if(!otp.resultChecker(int.parse(enteredOtp))){
                                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                                      content:
                                      Text('Enter a valid OTP')));
                                }
                              }
                            }
                            if (mobileNo.text.isNotEmpty && count == 0) {
                              sendOtp();
                              setState(() {
                                count++;
                              });
                            } else {
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content:
                                      Text('Enter phone number to get OTP')));
                            }
                          },
                          child: Text(
                            count == 0 ? 'SEND OTP' : 'VERIFY',
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
