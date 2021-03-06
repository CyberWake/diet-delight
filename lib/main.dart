import 'package:diet_delight/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:diet_delight/konstants.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );
  await Firebase.initializeApp();
  return runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage('images/user_dashboard_bg.jpg'), context);
    precacheImage(AssetImage('images/order_history.jpg'), context);
    precacheImage(AssetImage('images/popup_background.jpg'), context);
    precacheImage(AssetImage("images/Group 7.png"), context);
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => SafeArea(child: SplashScreen()),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
