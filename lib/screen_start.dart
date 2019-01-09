import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:monkeygame/admob.dart';
import 'dart:async';
import 'package:monkeygame/globals.dart' as globals;
import 'package:flare_flutter/flare_actor.dart';
import 'package:monkeygame/background.dart';
import 'package:monkeygame/leaderboard_dialog.dart';

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> with WidgetsBindingObserver {
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

    globals.playMusic("song_ukulele.mp3");

    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    globals.lifecycleState = state;
    if(state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      globals.audioPlayer.pause();
    }else if(state == AppLifecycleState.resumed) {
      globals.audioPlayer.resume();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
                            data: Theme.of(context).copyWith(
                                dialogBackgroundColor: globals.baseColor),
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