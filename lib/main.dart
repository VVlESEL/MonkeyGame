import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monkeygame/game.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:monkeygame/admob.dart';
import 'dart:async';
import 'package:monkeygame/background.dart';
import 'package:monkeygame/leaderboard_dialog.dart';
import 'package:monkeygame/more.dart';
import 'package:monkeygame/globals.dart' as globals;

void main() {
  FirebaseAdMob.instance.initialize(appId: getAdMobAppId());
  globals.playMusic("song_ukulele.mp3");

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
            )),
      ),
    );
  }
}

/**
 *
 *
 *
 * TO DO : Sound
 *
 *
 */

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  bool _isCurrentRoute = true;
  bool _isBannerAdShown = false;
  BannerAd _bannerAd;

  @override
  void initState() {
    _bannerAd = createBannerAd()
      ..load().then((loaded) {
        if (loaded && _isCurrentRoute) {
          _bannerAd?.show(anchorType: AnchorType.bottom)?.then((shown) {
            _isBannerAdShown = shown;
            if (shown && !_isCurrentRoute) {
              Timer(const Duration(milliseconds: 500), () {
                _bannerAd?.dispose();
              });
            }
          });
        }
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Background(imgResource: "assets/img_leafs.png"),
        Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 100.0,
                    width: 100.0,
                    child: FlareActor(
                      "assets/monkey.flr",
                      animation: "wave",
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      _isCurrentRoute = false;
                      if (_isBannerAdShown) {
                        Timer(const Duration(milliseconds: 250), () {
                          _bannerAd?.dispose();
                        });
                      }

                      Navigator.of(context).pushNamed('/game');
                    },
                    child: Text(
                      "Start Game",
                      style: Theme.of(context).textTheme.display1,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return Theme(
                            data: Theme.of(context)
                                .copyWith(dialogBackgroundColor: globals.baseColor),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 50.0),
                              child: LeaderboardDialog(),
                            ),
                          );
                        },
                      );
                    },
                    child: Text(
                      "Ranking",
                      style: Theme.of(context).textTheme.display1,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/more');
                    },
                    child: Text(
                      "More",
                      style: Theme.of(context).textTheme.display1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
