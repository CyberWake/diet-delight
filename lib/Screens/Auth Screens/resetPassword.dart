import 'dart:ui';

import 'package:diet_delight/konstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => new _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController password = TextEditingController();
  TextEditingController confirmPass = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FocusNode pass;
  FocusNode conPass;
  FocusNode submit;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pass = FocusNode();
    conPass = FocusNode();
    submit = FocusNode();
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
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NEW PASSWORD',
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
                                    onChanged: (String pass) {
                                      password.text = pass;
                                    },
                                    onFieldSubmitted: (done) {
                                      password.text = done;
                                      pass.unfocus();
                                      FocusScope.of(context)
                                          .requestFocus(conPass);
                                    },
                                    focusNode: pass,
                                    style: authInputTextStyle,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.emailAddress,
                                    obscureText: true,
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
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CONFIRM NEW PASSWORD',
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
                                    onChanged: (String passCon) {
                                      confirmPass.text = passCon;
                                    },
                                    onFieldSubmitted: (done) {
                                      confirmPass.text = done;
                                      conPass.unfocus();
                                      FocusScope.of(context)
                                          .requestFocus(submit);
                                    },
                                    style: authInputTextStyle,
                                    keyboardType: TextInputType.emailAddress,
                                    obscureText: true,
                                    focusNode: conPass,
                                    textInputAction: TextInputAction.done,
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
                      padding: const EdgeInsets.fromLTRB(30, 50, 30, 0),
                      child: SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          focusNode: submit,
                          onPressed: () {
                            if (password.text.isNotEmpty &&
                                confirmPass.text.isNotEmpty) {
                              if (password.text == confirmPass.text) {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              } else {
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text('Passwords do not match')));
                              }
                            } else {
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content:
                                      Text('Passwords can\'t be left empty')));
                            }
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