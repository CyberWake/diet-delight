import 'dart:ui';

import 'package:diet_delight/Models/registrationModel.dart';
import 'package:diet_delight/Screens/Auth%20Screens/resetPassword.dart';
import 'package:diet_delight/konstants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => new _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int count = 0;
  String _verificationId;
  bool result = false;
  bool initialised = false;
  TextEditingController mobileNo = TextEditingController();
  TextEditingController enteredOtp = TextEditingController();
  TextEditingController countryCode = TextEditingController();
  FocusNode country = FocusNode();
  FocusNode mobile = FocusNode();
  RegModel userData;

  verifyPhoneNo() async {
    userData = RegModel(mobile: countryCode.text + mobileNo.text);
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      final User user =
          (await _auth.signInWithCredential(phoneAuthCredential)).user;
      if (user != null) {
        userData.setUid(user.uid);
        Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
                builder: (context) => ResetPassword(
                      userInfo: userData,
                    )));
        showSnackBar("Phone number automatically verified");
      }
    };
    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      setState(() {
        initialised = false;
      });
      showSnackBar(
          'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
    };
    PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      setState(() {
        count++;
      });
      showSnackBar('Please check your phone for the verification code.');
      _verificationId = verificationId;
    };
    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      print('time out');
      _verificationId = verificationId;
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: countryCode.text + mobileNo.text,
          timeout: Duration(seconds: 120),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      print('error');
      setState(() {
        initialised = false;
      });
      showSnackBar("Failed to Verify Phone Number: ${e.toString()}");
    }
  }

  Future<void> signInWithPhoneNumber() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: enteredOtp.text,
      );

      final User user = (await _auth.signInWithCredential(credential)).user;
      if (user != null) {
        userData.setUid(user.uid);
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => ResetPassword(userInfo: userData)));
      }
    } catch (e) {
      setState(() {
        initialised = false;
      });
      showSnackBar('Verification OTP entered is invalid');
    }
  }

  void showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    // TODO: implement initState
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
                                              verifyPhoneNo();
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
                                  controller: enteredOtp,
                                  onDone: (String userOtp) {
                                    signInWithPhoneNumber();
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
                          onTap: () {
                            if (!initialised) {
                              if (countryCode.text.isNotEmpty &&
                                  mobileNo.text.isNotEmpty) {
                                verifyPhoneNo();
                              } else {
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text(
                                        'Enter both fields to receive an OTP.')));
                              }
                            }
                          },
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
                            if (!initialised) {
                              if (count == 0) {
                                verifyPhoneNo();
                              } else {
                                signInWithPhoneNumber();
                              }
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
