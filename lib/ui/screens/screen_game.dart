import 'dart:async';
import 'dart:math' as math;

import 'package:firebase_admob/firebase_admob.dart';
import 'package:monkeygame/utils/admob.dart';
import 'package:flutter/material.dart';
import 'package:monkeygame/ui/falling_object.dart';
import 'package:monkeygame/ui/game_appbar.dart';
import 'package:monkeygame/ui/game_scaffold.dart';
import 'package:monkeygame/ui/monkey.dart';
import 'package:monkeygame/ui/dialogs/dialog_leaderboard.dart';
import 'package:monkeygame/utils/globals.dart' as globals;

class Game extends StatefulWidget {
  Game({Key key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  Timer _timer;
  MonkeyMovement _moving = MonkeyMovement.WAIT;
  List<Widget> _bananaList = List();
  List<Widget> _coconutList = List();
  double _baseSpeed = 5.0;
  int _bananaCounter = 0;
  int _secondsLeft = 30;
  int _secondsPassed = 0;
  String _info = "";
  bool _isGameOver = false;
  bool _isAdOption = true;

  @override
  void initState() {
    super.initState();

    if (_timer == null) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
        if (mounted &&
            globals.lifecycleState != AppLifecycleState.paused &&
            globals.lifecycleState != AppLifecycleState.inactive) {
          if (!_isGameOver) {
            _secondsLeft--;
            _secondsPassed++;
            if (_secondsLeft > 0) {
              if ((_secondsPassed <= 40 && _secondsPassed % 10 == 0) ||
                  (_secondsPassed <= 130 && _secondsPassed % 20 == 0) ||
                  (_secondsPassed >= 130 && _secondsPassed % 30 == 0)) {
                _baseSpeed++;
                _newInfo("Banana Speed Increased!");
              }
              if (_secondsPassed % 5 == 0) _addCoconut();
              _addBanana();
              setState(() {});
            } else {
              setState(() {
                _isGameOver = true;
                _bananaList.clear();
                _coconutList.clear();
              });
              if (await _showLeaderboard()) {
                _newInfo("Loading ad...");
                await RewardedVideoAd.instance.load(
                  adUnitId: getAdMobRewardAdUnitId(),
                  targetingInfo: targetingInfo,
                );
                RewardedVideoAd.instance.listener = (RewardedVideoAdEvent event,
                    {String rewardType, int rewardAmount}) {
                  if (event == RewardedVideoAdEvent.loaded) {
                    RewardedVideoAd.instance.show();
                    setState(() => _info = "");
                  }
                  else if (event == RewardedVideoAdEvent.rewarded) {
                    setState(() {
                      _isAdOption = false;
                      _isGameOver = false;
                      _secondsLeft += 5;
                    });
                  } else if (event == RewardedVideoAdEvent.failedToLoad){
                    _newInfo("Unable To Load Ad...");
                  } else if (event == RewardedVideoAdEvent.closed) {
                    if(_isGameOver) _newInfo("No Cheating!");
                  }
                };
              }
            }
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _moving = details.globalPosition.dx > globals.screenWidth / 2
              ? MonkeyMovement.RIGHT
              : MonkeyMovement.LEFT;
        });
      },
      onPanEnd: (_) => setState(() => _moving = MonkeyMovement.WAIT),
      child: GameScaffold(
        appBar: GameAppBar(
          bananaCounter: _bananaCounter,
          secondsLeft: _secondsLeft,
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            globals.screenHeight = constraints.maxHeight;
            globals.screenWidth = constraints.maxWidth;
            return Stack(
              children: _bananaList +
                  _coconutList +
                  (<Widget>[
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Monkey(
                        height: globals.monkeyHeight,
                        width: globals.monkeyWidth,
                        movement: _moving,
                        speed: 10,
                      ),
                    ),
                    Center(
                      child: Text(_info,
                          style: Theme.of(context).textTheme.display2),
                    ),
                  ]),
            );
          },
        ),
      ),
    );
  }

  void _addBanana() {
    math.Random random = math.Random();
    double size = 30.0 + random.nextInt(20);
    double margin =
        random.nextInt((globals.screenWidth - size).toInt()).toDouble();
    double speed = _baseSpeed + random.nextInt(15);

    FallingObject banana = FallingObject(
      key: UniqueKey(),
      actorAsset: "assets/banana.flr",
      idleAnimation: "rotate",
      hitMonkeyAnimation: "success",
      hitGroundAnimation: "failure",
      height: size,
      width: size,
      marginLeft: margin,
      speed: speed,
      onFaded: (banana) {
        _bananaList.remove(banana);
      },
      onHitMonkey: (banana) {
        if (mounted) {
          setState(() {
            _bananaCounter++;
            _secondsLeft++;
          });
        }
      },
    );
    _bananaList.add(banana);
  }

  void _addCoconut() {
    math.Random random = math.Random();
    double size = 30.0;
    double margin =
        random.nextInt((globals.screenWidth - size).toInt()).toDouble();
    double speed = _baseSpeed + random.nextInt(15);

    FallingObject coconut = FallingObject(
      key: UniqueKey(),
      actorAsset: "assets/coconut.flr",
      idleAnimation: "rotate",
      hitMonkeyAnimation: "hit",
      hitGroundAnimation: "hit",
      height: size,
      width: size,
      marginLeft: margin,
      speed: speed,
      onFaded: (coconut) {
        _coconutList.remove(coconut);
        globals.monkeyIsDizzy = false;
      },
      onHitMonkey: (coconut) {
        globals.monkeyIsDizzy = true;
      },
    );
    _coconutList.add(coconut);
  }

  void _newInfo(String info) {
    if (mounted) {
      setState(() {
        _info = info;
      });
      Timer(Duration(seconds: 3), () => _info = "");
    }
  }

  Future<bool> _showLeaderboard() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context)
              .copyWith(dialogBackgroundColor: globals.baseColor),
          child: LeaderboardDialog(
            score: _bananaCounter,
            adOption: _isAdOption,
          ),
        );
      },
    );
  }
}
