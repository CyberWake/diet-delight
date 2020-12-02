import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:diet_delight/konstants.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:diet_delight/Authentication/resetPassword.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => new _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
//        appBar: AppBar(
//          backgroundColor: Colors.white,
//          elevation: 0.0,
//          actions: <Widget>[
////            Padding(
////              padding: const EdgeInsets.only(left: 18.0),
////              child: GestureDetector(
////                onTap: () {
////                  Navigator.pop(context);
////                },
////                child: CircleAvatar(
////                  radius: 17,
////                  child: Icon(
////                    Icons.keyboard_backspace,
////                    color: defaultGreen,
////                  ),
////                  backgroundColor: Colors.white,
////                ),
////              ),
////            ),
//            Padding(
//              padding: const EdgeInsets.only(top: 10.0, left: 0.0),
//              child: Align(
//                alignment: Alignment.topLeft,
//                child: SizedBox(
//                  width: 4 * MediaQuery.of(context).size.width / 5,
//                  child: Center(
//                      child: Image.asset(
//                    'images/Group 57.png',
//                    width: 120.0,
//                    height: 50.0,
//                  )),
//                ),
//              ),
//            )
//          ],
//          leading: GestureDetector(
//            onTap: () {
//              Navigator.pop(context);
//            },
//            child: Padding(
//              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0, 0),
//              child: SizedBox(
//                width: 30.0,
//                height: 30.0,
//                child: Icon(
//                  Icons.keyboard_backspace,
//                  size: 30.0,
//                  color: defaultGreen,
//                ),
//              ),
//            ),
//          ),
////          title: Padding(
////            padding: EdgeInsets.fromLTRB(0, 10.0, 0, 0),
////            child: Center(
////                child: Image.asset(
////              'images/Group 57.png',
////              width: 120.0,
////              height: 50.0,
////            )),
////          ),
//        ),
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
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PHONE NUMBER',
                            style: TextStyle(
                              fontFamily: 'RobotoCondensedReg',
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: defaultGreen,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                            child: Material(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                width: 300.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: formLinks,
                                        width: 1.0,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 3, 20, 7),
                                  child: TextFormField(
//                                      onChanged: (String otp1) {
//                                        otp = otp1;
//                                      },
                                    style: TextStyle(
                                      fontFamily: 'RobotoCondensedReg',
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: formFill,
                                    ),
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(3.0),
                                      ),
                                    ),
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
//                            onTextChanged: (String otp1) {
//                              print(otp1);
//                              print(otp);
//
//                              otp = otp1;
//                            },
                                  pinTextStyle: TextStyle(
                                    fontFamily: 'RobotoReg',
                                    color: formFill,
                                  ),
                                  keyboardType: TextInputType.number,
//                                        decoration: InputDecoration(
//                                          fillColor: Colors.white,
//                                          focusedBorder: InputBorder.none,
//                                          enabledBorder: InputBorder.none,
//                                          errorBorder: InputBorder.none,
//                                          disabledBorder: InputBorder.none,
//                                          border: OutlineInputBorder(
//                                            borderRadius:
//                                                BorderRadius.circular(3.0),
//                                          ),
//                                        ),
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
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ResetPassword()));
                          },
                          child: Text(
                            'VERIFY',
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
