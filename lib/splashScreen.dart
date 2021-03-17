import 'dart:async';
import 'dart:core';

import 'package:diet_delight/Screens/export.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/Auth Screens/revisedQuestionnaire.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  Timer _timerLink;
  final _apiCall = Api.instance;

  _retrieveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('accessToken')) {
      await Future.delayed(Duration(seconds: 2));
      _apiCall.autoLogin().whenComplete(() {
        print(
            'Api.userInfo.questionnaireStatus: ${Api.userInfo.questionnaireStatus}');
        Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
                builder: (context) => Api.userInfo.questionnaireStatus == 0
                    ? NewQuestionnaire()
                    : HomePage()));
      });
    } else {
      await Future.delayed(Duration(seconds: 2));
      Navigator.of(context).pushReplacement(
          CupertinoPageRoute(builder: (BuildContext context) => AfterSplash()));
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("running did change");
    if (state == AppLifecycleState.resumed) {
      _timerLink = new Timer(const Duration(milliseconds: 850), () {
        _retrieveCredentials();
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_timerLink != null) {
      _timerLink.cancel();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _retrieveCredentials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/bg12.jpg"), fit: BoxFit.cover),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    flex: 3,
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Container(
                          child: Image.asset(
                        'images/Group 66.png',
                        width: 300.0,
                        height: 100.0,
                      )),
                      radius: 100.0,
                    )),
                Spacer(flex: 3),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 24.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          SpinKitChasingDots(
                            color: defaultPurple,
                            size: 36,
                          ),
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
