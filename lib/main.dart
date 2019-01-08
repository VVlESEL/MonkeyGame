import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monkeygame/game.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:monkeygame/auth.dart' as auth;
import 'package:firebase_admob/firebase_admob.dart';
import 'package:monkeygame/admob.dart';
import 'dart:async';
import 'package:monkeygame/background.dart';

void main() {
  FirebaseAdMob.instance.initialize(appId: getAdMobAppId());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Set orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: Start(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => Start(),
        '/game': (BuildContext context) => Game(),
      },
    );
  }
}

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
            body: Column(
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
                Center(
                  child: FlatButton(
                    onPressed: () {
                      _isCurrentRoute = false;
                      if (_isBannerAdShown) {
                        Timer(const Duration(milliseconds: 250), () {
                          _bannerAd?.dispose();
                        });
                      }

                      Navigator.of(context).pushNamed('/game');
                    },
                    child: Text("Start Game", style: _textStyle()),
                  ),
                ),
                Builder(
                  builder: (BuildContext context) => FlatButton(
                        onPressed: () => auth.logout().then((b) {
                              if (b) {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  backgroundColor: Colors.transparent,
                                  content: Text("Logged out...",
                                      style: _textStyle()),
                                  duration: Duration(seconds: 2),
                                ));
                              }
                            }),
                        child: Text("Logout", style: _textStyle()),
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  TextStyle _textStyle() {
    return TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 26.0,
    );
  }
}
