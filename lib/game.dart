import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:monkeygame/falling_object.dart';
import 'package:monkeygame/game_appbar.dart';
import 'package:monkeygame/game_scaffold.dart';
import 'package:monkeygame/monkey.dart';
import 'package:monkeygame/leaderboard.dart';
import 'package:monkeygame/auth.dart' as auth;
import 'package:monkeygame/leaderboard_dialog.dart';

class Game extends StatefulWidget {
  ///lifecycle state of the app
  static AppLifecycleState lifecycleState;

  ///height of visible game stack
  static double screenHeight;

  ///width of visible game stack
  static double screenWidth;

  ///current x value of the monkey
  static double monkeyX = 100.0;

  ///state of the monkey
  static bool monkeyIsDizzy = false;

  ///height of the monkey
  static final double monkeyHeight = 80.0;

  ///width of the monkey
  static final double monkeyWidth = 80.0;

  Game({Key key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> with WidgetsBindingObserver {
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

  @override
  void initState() {
    super.initState();

    if (_timer == null) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (mounted &&
            Game.lifecycleState != AppLifecycleState.paused &&
            Game.lifecycleState != AppLifecycleState.inactive) {
          if (!_isGameOver && _secondsLeft > 0) {
            _secondsLeft--;
            _secondsPassed++;
            if (_secondsPassed % 10 == 0) {
              _baseSpeed++;
              _newInfo("Banana Speed Increased!");
            }
            if(_secondsPassed % 5 == 0)_addCoconut();
            _addBanana();
            setState(() {});
          } else if (!_isGameOver) {
            setState(() {
              _isGameOver = true;
              _bananaList.clear();
              _coconutList.clear();
              _showLeaderboard();
            });
          }
        }
      });
    }
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Game.lifecycleState = state;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _moving = details.globalPosition.dx > Game.screenWidth / 2
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
            Game.screenHeight = constraints.maxHeight;
            Game.screenWidth = constraints.maxWidth;
            return Stack(
              children: _bananaList +
                  _coconutList +
                  (<Widget>[
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Monkey(
                        height: Game.monkeyHeight,
                        width: Game.monkeyWidth,
                        movement: _moving,
                        speed: 10,
                      ),
                    ),
                    Center(
                      child: Text(
                        _info,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
    random.nextInt((Game.screenWidth - size).toInt()).toDouble();
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
    random.nextInt((Game.screenWidth - size).toInt()).toDouble();
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
        Game.monkeyIsDizzy = false;
      },
      onHitMonkey: (coconut) {
        Game.monkeyIsDizzy = true;
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

  Future<void> _showLeaderboard() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return LeaderboardDialog(
          score: _bananaCounter,
        );
      },
    );
  }
}
