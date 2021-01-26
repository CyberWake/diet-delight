import 'dart:async';
import 'dart:core';

import 'package:diet_delight/Models/loginModel.dart';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'file:///C:/Users/VK/Desktop/ritik/diet-delight-mobile/lib/Screens/landingPage.dart';

class SplashScreen extends StatefulWidget {
  final dynamic navigateAfterSeconds;
  SplashScreen({
    this.navigateAfterSeconds,
  });

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  Timer _timerLink;

  _retrieveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool credEmailFound = prefs.containsKey('email');
    bool credMobileFound = prefs.containsKey('mobile');
    if (!credEmailFound && !credMobileFound) {
      Timer(Duration(seconds: 2), () {
        Navigator.of(context).pushReplacement(CupertinoPageRoute(
            builder: (BuildContext context) => widget.navigateAfterSeconds));
      });
    } else {
      bool result;
      final _apiCall = Api.instance;
      if (credEmailFound) {
        result = await _apiCall.login(LogModel(
            email: prefs.getString('email'),
            password: prefs.getString('password')));
      } else {
        result = await _apiCall.login(LogModel(
            mobile: prefs.getString('mobile'),
            password: prefs.getString('password')));
      }
      if (result) {
        Navigator.of(context).pushReplacement(
            CupertinoPageRoute(builder: (BuildContext context) => HomePage()));
      } else {
        Navigator.of(context).pushReplacement(CupertinoPageRoute(
            builder: (BuildContext context) => widget.navigateAfterSeconds));
      }
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
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Container(
                          child: Image.asset(
                        'images/Group 66.png',
                        width: 300.0,
                        height: 100.0,
                      )),
                      radius: 100.0,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                    ),
                  ],
                )),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SpinKitFadingCircle(
                      itemBuilder: (BuildContext context, int index) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: index.isEven ? Colors.red : Colors.green,
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
