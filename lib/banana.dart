import 'dart:async';
import 'dart:math' as math;
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:monkeygame/game.dart';
import 'package:monkeygame/monkey.dart';

typedef void BananaCallback(Banana banana);
class Banana extends StatefulWidget {
  ///determines the pixel movement every x millis
  final double speed;

  ///callback after reaching the ground, remove view here
  final BananaCallback onHitGround;

  ///callback after hitting the monkey, remove view here
  final BananaCallback onHitMonkey;

  ///determines where the banana falls
  final double marginLeft;

  final double height;
  final double width;

  Banana({
    Key key,
    @required this.marginLeft,
    this.onHitGround,
    this.onHitMonkey,
    this.speed = 15.0,
    this.height = 50.0,
    this.width = 50.0,
  }) : super(key: key);

  @override
  _BananaState createState() => _BananaState();
}

class _BananaState extends State<Banana> {
  Timer _timer;
  double _marginTop = 0.0;
  String _animation = "rotate";

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_timer == null)
      _timer = Timer.periodic(Duration(milliseconds: 40), (timer) {
        update(context);
      });

    return Container(
      height: widget.height,
      width: widget.width,
      margin: EdgeInsets.only(
        left: widget.marginLeft,
        top: _marginTop,
      ),
      child: FlareActor(
        "assets/banana.flr",
        alignment: Alignment.center,
        animation: _animation,
        fit: BoxFit.contain,
      ),
    );
  }

  void update(BuildContext context) {
    _marginTop += widget.speed;
    _marginTop = math.min(_marginTop, Game.screenHeight - widget.height);

    if (_animation == "rotate") {
      if (widget.onHitGround != null &&
          _marginTop > Game.screenHeight - Monkey.height - widget.height &&
          widget.marginLeft + widget.width / 2 > Monkey.xValue &&
          widget.marginLeft < Monkey.xValue + Monkey.width / 2) {
        _animation = "success";
        Timer(Duration(seconds: 1), () => widget.onHitMonkey(widget));
      } else if (widget.onHitMonkey != null &&
          _marginTop >= Game.screenHeight - widget.height) {
        _animation = "failure";
        Timer(Duration(seconds: 1), () => widget.onHitGround(widget));
      }
    }

    setState(() {});
  }
}
