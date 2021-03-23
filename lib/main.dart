import 'package:diet_delight/Screens/Auth%20Screens/revisedQuestionnaire.dart';
import 'package:diet_delight/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

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
    precacheImage(AssetImage('images/bg1.jpg'), context);
    precacheImage(AssetImage('images/bg13.jpg'), context);
    precacheImage(AssetImage('images/bg7.jpg'), context);
    precacheImage(AssetImage("images/Group 7.png"), context);
    precacheImage(AssetImage("images/Group 57.png"), context);
    // precacheImage(bmiBackground.image, context);
    // precacheImage(question1Background.image, context);
    // precacheImage(question2Background1.image, context);
    // precacheImage(question2Background2.image, context);
    // precacheImage(consultationBackground.image, context);
    // precacheImage(selectConsultationBackgroundImage.image, context);
    // precacheImage(consultationHomePageBackground.image, context);
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => SafeArea(child: SplashScreen()),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
