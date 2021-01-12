import 'dart:ui';

import 'package:diet_delight/Models/registrationModel.dart';
import 'package:diet_delight/Screens/Auth%20Screens/userMoto.dart';
import 'package:diet_delight/konstants.dart';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:diet_delight/services/otp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class VerifyPhoneNumber extends StatefulWidget {
  final RegModel regDetails;
  VerifyPhoneNumber({this.regDetails});
  @override
  _VerifyPhoneNumberState createState() => new _VerifyPhoneNumberState();
}

class _VerifyPhoneNumberState extends State<VerifyPhoneNumber> {
  final _apiCall = Api.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String enteredOtp;
  bool initiated = false;
  FlutterOtp otp = FlutterOtp();

  sendOtp() {
    List<String> number = widget.regDetails.mobile.split(' ');
    print(number.first);
    print(number.last);
    print('running');
    otp.sendOtp(number.last, "<#> Verification code for diet delight is: ",
        100000, 999999, number.first);
    otp.getOtp();
    print('done');
  }

  @override
  void initState() {
    sendOtp();
    super.initState();
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
                      padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: TextButton(
                          onPressed: () async {
                            if (enteredOtp.isNotEmpty && !initiated) {
                              if (otp.resultChecker(int.parse(enteredOtp))) {
                                setState(() {
                                  initiated = true;
                                });
                                bool result =
                                    await _apiCall.register(widget.regDetails);
                                print(result);
                                if (result) {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => Questionnaire(
                                              username: widget
                                                      .regDetails.firstName +
                                                  " " +
                                                  widget.regDetails.lastName)));
                                } else {
                                  _scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Something went wrong')));
                                }
                              } else {
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text('Entered an invalid OTP')));
                              }
                            } else {
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text('Enter the OTP to continue')));
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
