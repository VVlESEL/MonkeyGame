import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

enum MonkeyMovement { LEFT, RIGHT, WAIT }
class Monkey extends StatefulWidget {
  final MonkeyMovement movement;
  final double height;
  final double width;

  Monkey({@required this.movement, this.height = 80.0, this.width = 80.0});

  @override
  _MonkeyState createState() => _MonkeyState();
}

class _MonkeyState extends State<Monkey> {
  Timer _timer;
  double _margin = 100.0;

  @override
  void initState() {
    _timer = Timer.periodic(Duration(milliseconds: 5), (timer) {
      setState(() {
        if (widget.movement == MonkeyMovement.LEFT) {
          _margin -= 2;
        } else if (widget.movement == MonkeyMovement.RIGHT) {
          _margin += 2;
        }
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
      height: widget.height,
      width: widget.width,
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
    _margin = _margin > 0 ? math.min(_margin, screenWidth - widget.width) : 0.0;
    return _margin;
  }
}