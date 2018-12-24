import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

enum MonkeyMovement { LEFT, RIGHT, WAIT }

class Monkey extends StatefulWidget {
  static double xValue;
  static double height;
  static double width;
  ///pass and update state of MonkeyMovement variable to control the monkey
  final MonkeyMovement movement;
  ///determines the pixel movement every x millis
  final double speed;

  Monkey(
      {@required this.movement,
        height = 80.0,
        width = 80.0,
        this.speed = 15.0}) {

    Monkey.height = height;
    Monkey.width = width;
    Monkey.xValue = 100.0;
  }

  @override
  _MonkeyState createState() => _MonkeyState();
}

class _MonkeyState extends State<Monkey> {
  Timer _timer;
  double _margin = 100.0;

  @override
  void initState() {
    _timer = Timer.periodic(Duration(milliseconds: 40), (timer) {
      setState(() {
        if (widget.movement == MonkeyMovement.LEFT) {
          _margin -= widget.speed;
        } else if (widget.movement == MonkeyMovement.RIGHT) {
          _margin += widget.speed;
        }
        Monkey.xValue = _margin;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Monkey.height,
      width: Monkey.width,
      margin: EdgeInsets.only(
        left: getMargin(context),
      ),
      child: FlareActor(
        "assets/monkey.flr",
        alignment: Alignment.center,
        animation: getAnimation(),
        fit: BoxFit.contain,
      ),
    );
  }

  String getAnimation() {
    return widget.movement == MonkeyMovement.WAIT ? "wait" : "walk";
  }

  double getMargin(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    _margin = _margin > 0 ? math.min(_margin, screenWidth - Monkey.width) : 0.0;
    return _margin;
  }
}