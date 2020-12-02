import 'package:diet_delight/main.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:diet_delight/konstants.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => new _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
              padding: const EdgeInsets.fromLTRB(0, 30.0, 0, 0),
              child: Container(
                color: formBackground,
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'RESET PASSWORD',
                        style: TextStyle(
                          fontFamily: 'RobotoCondensedReg',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: defaultGreen,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NEW PASSWORD',
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
                                    keyboardType: TextInputType.emailAddress,
                                    obscureText: true,
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
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CONFIRM NEW PASSWORD',
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
                                    keyboardType: TextInputType.emailAddress,
                                    obscureText: true,
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
                      padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                      child: SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AfterSplash()));
                          },
                          child: Text(
                            'CONFIRM',
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
