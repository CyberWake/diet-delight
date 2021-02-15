import 'dart:ui';

import 'package:diet_delight/Models/registrationModel.dart';
import 'package:diet_delight/Screens/Auth%20Screens/newUserQuestionnaire.dart';
import 'package:diet_delight/Screens/Auth%20Screens/resetPassword.dart';
import 'package:diet_delight/konstants.dart';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class VerifyPhoneNumber extends StatefulWidget {
  final RegModel regDetails;
  final FromPage from;
  VerifyPhoneNumber({this.regDetails, this.from});
  @override
  _VerifyPhoneNumberState createState() => new _VerifyPhoneNumberState();
}

class _VerifyPhoneNumberState extends State<VerifyPhoneNumber> {
  final _apiCall = Api.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String enteredOtp;
  int count = 0;
  bool initiated = false;
  String _verificationId;
  bool result = false;

  void showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  registerUser() async {
    result = false;
    result = await _apiCall.register(widget.regDetails);
    print(result);
    if (result) {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => Questionnaire(
                  username: widget.regDetails.firstName +
                      " " +
                      widget.regDetails.lastName)));
    } else {
      showSnackBar('Something went wrong');
    }
  }

  @override
  void initState() {
    super.initState();
    verifyPhoneNo();
  }

  verifyPhoneNo() async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      final User user =
          (await _auth.signInWithCredential(phoneAuthCredential)).user;
      if (user != null) {
        widget.regDetails.setUid(user.uid);
        if (widget.from == FromPage.signUp) {
          showSnackBar("Phone number automatically verified");
          registerUser();
        } else {
          showSnackBar("Phone number automatically verified");
          Future.delayed(Duration(seconds: 1)).then((value) {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => ResetPassword(
                          userInfo: widget.regDetails,
                        )));
          });
        }
      }
    };
    print('ver complete check');
    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      showSnackBar(
          'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
    };
    print('ver fail check');
    PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      showSnackBar('Please check your phone for the verification code.');
      _verificationId = verificationId;
    };
    print('ver codesent check');
    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      print('time out');
      _verificationId = verificationId;
    };
    print('ver timeout check');
    try {
      print(widget.regDetails.mobile);
      await _auth.verifyPhoneNumber(
          phoneNumber: widget.regDetails.mobile,
          timeout: Duration(seconds: 120),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
      print('ver done check');
    } catch (e) {
      print('error');
      showSnackBar("Failed to Verify Phone Number: ${e.toString()}");
    }
  }

  Future<void> signInWithPhoneNumber() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: enteredOtp,
      );

      final User user = (await _auth.signInWithCredential(credential)).user;
      if (user != null) {
        widget.regDetails.setUid(user.uid);
        if (widget.from == FromPage.signUp) {
          registerUser();
        } else {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => ResetPassword(
                        userInfo: widget.regDetails,
                      )));
        }
      }
    } catch (e) {
      showSnackBar('Verification OTP entered is invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'VERIFY YOUR PHONE NUMBER',
                          style: TextStyle(
                            fontFamily: 'RobotoCondensedReg',
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: defaultGreen,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                          child: Text(
                            'You would have received an otp on your phone...',
                            style: TextStyle(
                              fontFamily: 'RobotoCondensedReg',
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                              color: defaultGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
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
                                  wrapAlignment: WrapAlignment.spaceBetween,
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
                          onTap: () {
                            verifyPhoneNo();
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
                      padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: TextButton(
                          onPressed: () async {
                            if (enteredOtp.isNotEmpty && !initiated) {
                              setState(() {
                                initiated = true;
                              });
                              await signInWithPhoneNumber();
                            } else {
                              if (enteredOtp.isNotEmpty) {
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content:
                                        Text('Enter the OTP to continue')));
                              }
                            }
                          },
                          child: initiated
                              ? CircularProgressIndicator()
                              : Text(
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
