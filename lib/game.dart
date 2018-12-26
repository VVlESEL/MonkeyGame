import 'package:flutter/material.dart';
import 'package:monkeygame/banana.dart';
import 'package:monkeygame/monkey.dart';

class Game extends StatefulWidget {
  ///height of visible game stack
  static double screenHeight;

  ///width of visible game stack
  static double screenWidth;

  Game({Key key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  MonkeyMovement _moving = MonkeyMovement.WAIT;
  List<Widget> _bananaList = List();
  int _bananaCounter = 0;

  @override
  void initState() {
    super.initState();

    _bananaList.add(Banana(
      key: UniqueKey(),
      marginLeft: 100.0,
      speed: 5,
      onHitGround: (banana) {
        _bananaList.remove(banana);
      },
      onHitMonkey: (banana) {
        setState(() => _bananaCounter++);
        _bananaList.remove(banana);
      },
    ));
    _bananaList.add(Banana(
      key: UniqueKey(),
      marginLeft: 239.0,
      speed: 3,
      onHitGround: (banana) {
        _bananaList.remove(banana);
      },
      onHitMonkey: (banana) {
        setState(() => _bananaCounter++);
        _bananaList.remove(banana);
      },
    ));
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
          title: CircleAvatar(
            child: Text(_bananaCounter.toString()),
          ),
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            Game.screenHeight = constraints.maxHeight;
            Game.screenWidth = constraints.maxWidth;
            return Stack(
              children: _bananaList +
                  (<Widget>[
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Monkey(
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
}