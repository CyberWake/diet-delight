import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:diet_delight/konstants.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:diet_delight/Authentication/forgotPassword.dart';
import 'package:diet_delight/Authentication/resetPassword.dart';
import 'package:diet_delight/Authentication/verifyPhoneNumber.dart';

void main() {
  runApp(new MaterialApp(
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: new SplashScreen(
        seconds: 3,
        navigateAfterSeconds: new AfterSplash(),
        image: new Image.asset(
          'images/Group 66.png',
          width: 300.0,
          height: 100.0,
        ),
        backgroundColor: Colors.white,
        photoSize: 100.0,
        useLoader: true,
        loaderColor: defaultGreen,
      ),
    );
  }
}

class AfterSplash extends StatefulWidget {
  @override
  _AfterSplashState createState() => new _AfterSplashState();
}

class _AfterSplashState extends State<AfterSplash>
    with SingleTickerProviderStateMixin {
  TabController _tabcontroller;
  double conHeight = 300.0;

  @override
  void initState() {
    _tabcontroller = new TabController(length: 2, vsync: this);
    _tabcontroller.addListener(() {
      if (_tabcontroller.index == 0) {
        setState(() {
          conHeight = 300.0;
          print(conHeight);
        });
      } else if (_tabcontroller.index == 1) {
        setState(() {
          conHeight = 600.0;
          print(conHeight);
        });
      } else {
        setState(() {
          conHeight = 300.0;
          print(conHeight);
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.of(context).size.width;
    double devHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: new Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 10.0,
            ),
            Center(
                child: Image.asset(
              'images/Group 57.png',
              width: 120.0,
              height: 50.0,
            )),
            SizedBox(
              height: 20.0,
            ),
            Container(
              width: 240,
              child: TabBar(
                labelStyle: TextStyle(
                  fontFamily: 'RobotoCondensedReg',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                indicatorColor: defaultGreen,
                indicatorWeight: 4.0,
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: defaultGreen,
                labelPadding: EdgeInsets.symmetric(horizontal: 13),
                unselectedLabelStyle: TextStyle(
                  fontFamily: 'RobotoCondensedReg',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelColor: inactiveGreen,
                controller: _tabcontroller,
                tabs: <Widget>[
                  Tab(
                    icon: Align(
                      alignment: Alignment.centerRight,
                      child: Text('SIGN IN'),
                    ),
                  ),
                  Tab(
                    icon: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('SIGN UP'),
                    ),
                  ),
                ],
              ),
            ),
            ListView(shrinkWrap: true, children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: double.infinity,
                  height: 3 * devHeight / 4,
                  decoration: BoxDecoration(
                    color: formBackground,
                  ),
                  child: TabBarView(
                    controller: _tabcontroller,
                    children: <Widget>[
                      Container(
                        height: 300.0,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 0),
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 15, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'PHONE NUMBER / EMAIL ADDRESS',
                                      style: TextStyle(
                                        fontFamily: 'RobotoCondensedReg',
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        color: defaultGreen,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 8.0, 0, 0),
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
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                20, 3, 20, 7),
                                            child: TextFormField(
//                                      onChanged: (String otp1) {
//                                        otp = otp1;
//                                      },
                                              style: TextStyle(
                                                fontFamily:
                                                    'RobotoCondensedReg',
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                                color: formFill,
                                              ),
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                focusedBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                disabledBorder:
                                                    InputBorder.none,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          3.0),
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
                                padding:
                                    const EdgeInsets.fromLTRB(20, 15, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ENTER PASSWORD',
                                      style: TextStyle(
                                        fontFamily: 'RobotoCondensedReg',
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        color: defaultGreen,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 8.0, 0, 0),
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
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                20, 3, 20, 7),
                                            child: TextFormField(
//                                      onChanged: (String otp1) {
//                                        otp = otp1;
//                                      },
                                              style: TextStyle(
                                                fontFamily:
                                                    'RobotoCondensedReg',
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                                color: formFill,
                                              ),
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              obscureText: true,
                                              decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                focusedBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                disabledBorder:
                                                    InputBorder.none,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          3.0),
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
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 20, 0),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ForgotPassword()));
                                    },
                                    child: Text(
                                      'Forgot Password?',
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
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: TextButton(
                                    child: Text(
                                      'SIGN IN',
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
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)))),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      color: defaultGreen,
                                      height: 1,
                                      width: 130,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                                      child: Text(
                                        'OR',
                                        style: TextStyle(
                                          fontFamily: 'RobotoCondensedReg',
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          color: defaultGreen,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: defaultGreen,
                                      height: 1,
                                      width: 130,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: 100.0,
                                      child: TextButton(
                                        child: Image.asset(
                                            'images/Group 59.png',
                                            width: 11),
                                        style: TextButton.styleFrom(
                                            backgroundColor: fColor,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)))),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 100.0,
                                      child: TextButton(
                                        child: Image.asset(
                                            'images/Group 58.png',
                                            width: 18),
                                        style: TextButton.styleFrom(
                                            backgroundColor: gColor,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)))),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 600.0,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
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
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 8.0, 0, 0),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 10, 0),
                                            child: Material(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: Container(
                                                width: 80.0,
                                                height: 40.0,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: formLinks,
                                                        width: 1.0,
                                                        style:
                                                            BorderStyle.solid),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          20, 3, 20, 7),
                                                  child: TextFormField(
//                                      onChanged: (String otp1) {
//                                        otp = otp1;
//                                      },
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'RobotoCondensedReg',
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: formFill,
                                                    ),
                                                    initialValue: '+91',
                                                    readOnly: true,
                                                    textAlign: TextAlign.center,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration: InputDecoration(
                                                      fillColor: Colors.white,
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      errorBorder:
                                                          InputBorder.none,
                                                      disabledBorder:
                                                          InputBorder.none,
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(3.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Material(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Container(
                                              width: 210.0,
                                              height: 40.0,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: formLinks,
                                                      width: 1.0,
                                                      style: BorderStyle.solid),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20, 3, 20, 7),
                                                child: TextFormField(
//                                      onChanged: (String otp1) {
//                                        otp = otp1;
//                                      },
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'RobotoCondensedReg',
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: formFill,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                    fillColor: Colors.white,
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    errorBorder:
                                                        InputBorder.none,
                                                    disabledBorder:
                                                        InputBorder.none,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3.0),
                                                    ),
                                                  ),
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
                                padding:
                                    const EdgeInsets.fromLTRB(20, 15, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'EMAIL ADDRESS',
                                      style: TextStyle(
                                        fontFamily: 'RobotoCondensedReg',
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        color: defaultGreen,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 8.0, 0, 0),
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
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                20, 3, 20, 7),
                                            child: TextFormField(
//                                      onChanged: (String otp1) {
//                                        otp = otp1;
//                                      },
                                              style: TextStyle(
                                                fontFamily:
                                                    'RobotoCondensedReg',
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                                color: formFill,
                                              ),
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                focusedBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                disabledBorder:
                                                    InputBorder.none,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          3.0),
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
                                padding:
                                    const EdgeInsets.fromLTRB(20, 15, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ENTER PASSWORD',
                                      style: TextStyle(
                                        fontFamily: 'RobotoCondensedReg',
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        color: defaultGreen,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 8.0, 0, 0),
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
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                20, 3, 20, 7),
                                            child: TextFormField(
//                                      onChanged: (String otp1) {
//                                        otp = otp1;
//                                      },
                                              style: TextStyle(
                                                fontFamily:
                                                    'RobotoCondensedReg',
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                                color: formFill,
                                              ),
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              obscureText: true,
                                              decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                focusedBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                disabledBorder:
                                                    InputBorder.none,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          3.0),
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
                                padding:
                                    const EdgeInsets.fromLTRB(20, 15, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'CONFIRM PASSWORD',
                                      style: TextStyle(
                                        fontFamily: 'RobotoCondensedReg',
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        color: defaultGreen,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 8.0, 0, 0),
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
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                20, 3, 20, 7),
                                            child: TextFormField(
//                                      onChanged: (String otp1) {
//                                        otp = otp1;
//                                      },
                                              style: TextStyle(
                                                fontFamily:
                                                    'RobotoCondensedReg',
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                                color: formFill,
                                              ),
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              obscureText: true,
                                              decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                focusedBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                disabledBorder:
                                                    InputBorder.none,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          3.0),
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
                                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      color: defaultGreen,
                                      height: 1,
                                      width: 130,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                                      child: Text(
                                        'OR',
                                        style: TextStyle(
                                          fontFamily: 'RobotoCondensedReg',
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          color: defaultGreen,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: defaultGreen,
                                      height: 1,
                                      width: 130,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: 100.0,
                                      child: TextButton(
                                        child: Image.asset(
                                            'images/Group 59.png',
                                            width: 11),
                                        style: TextButton.styleFrom(
                                            backgroundColor: fColor,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)))),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 100.0,
                                      child: TextButton(
                                        child: Image.asset(
                                            'images/Group 58.png',
                                            width: 18),
                                        style: TextButton.styleFrom(
                                            backgroundColor: gColor,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)))),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 50),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  VerifyPhoneNumber()));
                                    },
                                    child: Text(
                                      'SIGN UP',
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
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)))),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
//                      SizedBox(
//                        height: 300.0,
//                      ),
//                      SizedBox(
//                        height: 600.0,
//                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
