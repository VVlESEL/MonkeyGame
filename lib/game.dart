import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:monkeygame/banana.dart';
import 'package:monkeygame/monkey.dart';

class Game extends StatefulWidget {
  ///lifecycle state of the app
  static AppLifecycleState lifecycleState;

  ///height of visible game stack
  static double screenHeight;

  ///width of visible game stack
  static double screenWidth;

  ///current x value of the monkey
  static double monkeyX = 100.0;

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
  int _bananaCounter = 0;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();

    if (_timer == null) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (Game.lifecycleState != AppLifecycleState.paused &&
            Game.lifecycleState != AppLifecycleState.inactive) {
          _seconds++;
          addBanana();
          setState(() {});
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
      child: Scaffold(
        appBar: AppBar(
          leading: CircleAvatar(
            child: Text(_bananaCounter.toString()),
          ),
          actions: <Widget>[
            CircleAvatar(
              child: Text(_seconds.toString()),
            )
          ],
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            Game.screenHeight = constraints.maxHeight;
            Game.screenWidth = constraints.maxWidth;
            return Stack(
              children: _bananaList +
                  (<Widget>[
                    Image.asset(
                      "img_jungle.png",
                      fit: BoxFit.fill,
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Monkey(
                        height: Game.monkeyHeight,
                        width: Game.monkeyWidth,
                        movement: _moving,
                        speed: 10,
                      ),
                    ),
                  ]),
            );
          },
        ),
      ),
    );
  }

  void addBanana() {
    math.Random random = math.Random();
    double size = 30.0 + random.nextInt(20);
    double margin =
        random.nextInt((Game.screenWidth - size).toInt()).toDouble();
    double speed = 5.0 + random.nextInt(15);

    Banana banana = Banana(
      key: UniqueKey(),
      height: size,
      width: size,
      marginLeft: margin,
      speed: speed,
      onHitGround: (banana) {
        _bananaList.remove(banana);
      },
      onHitMonkey: (banana) {
        setState(() => _bananaCounter++);
        _bananaList.remove(banana);
      },
    );
    _bananaList.add(banana);
  }
}
