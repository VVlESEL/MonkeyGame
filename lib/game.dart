import 'package:flutter/material.dart';
import 'package:monkeygame/banana.dart';
import 'package:monkeygame/monkey.dart';

class Game extends StatefulWidget {
  Game({Key key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  double _screenWidth;
  double _screenHeight;
  MonkeyMovement _moving = MonkeyMovement.WAIT;
  List<Widget> _list = List();

  @override
  void initState() {
    super.initState();

    _list.add(Banana(
      marginLeft: 100.0,
      speed: 5,
      onHitGround: () => print("1 ground"),
      onHitMonkey: () => print("1 monkey"),
    ));
    _list.add(Banana(
      marginLeft: 239.0,
      speed: 3,
    ));
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _moving = details.globalPosition.dx > _screenWidth / 2
              ? MonkeyMovement.RIGHT
              : MonkeyMovement.LEFT;
        });
      },
      onPanEnd: (_) => setState(() => _moving = MonkeyMovement.WAIT),
      child: Scaffold(
        body: Stack(
          children: _list +
              (<Widget>[
                Baseline(
                  baselineType: TextBaseline.alphabetic,
                  baseline: _screenHeight,
                  child: Monkey(
                    movement: _moving,
                    speed: 10,
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}

//banana widget with size, speed,
//add list of bananas to stack, remove on catch or fail