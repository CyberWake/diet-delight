import 'dart:ui';

import 'package:diet_delight/Screens/Auth%20Screens/login_signup_form.dart';
import 'package:diet_delight/konstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SplashScreen(
        seconds: 3,
        navigateAfterSeconds: AfterSplash(), //AfterSplash(),
        image: Image.asset(
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
