import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:monkeygame/ui/screens/screen_game.dart';
import 'package:monkeygame/ui/screens/screen_more.dart';
import 'package:monkeygame/utils/admob.dart';
import 'package:monkeygame/ui/screens/screen_start.dart';
import 'package:monkeygame/utils/globals.dart' as globals;

void main() {
  FirebaseAdMob.instance.initialize(appId: getAdMobAppId());

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: Start(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => Start(),
        '/game': (BuildContext context) => Game(),
        '/more': (BuildContext context) => More(),
      },
      theme: ThemeData(
        primaryColor: globals.baseColor,
        cursorColor: Colors.white,
        primaryIconTheme: IconThemeData(color: globals.baseColor),
        iconTheme: IconThemeData(color: globals.baseColor),
        accentIconTheme: IconThemeData(color: Colors.white),
        textTheme: TextTheme(
          headline: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 26.0,
          ),
          display1: TextStyle(
            color: globals.baseColor,
            fontWeight: FontWeight.bold,
            fontSize: 26.0,
          ),
          display2: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
          display3: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
