import 'dart:async';
import 'dart:math' as math;
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:monkeygame/monkey.dart';

class Banana extends StatefulWidget {
  ///determines the pixel movement every x millis
  final double speed;

  ///callback after reaching the ground
  final Function onHitGround;

  ///callback after hitting the monkey
  final Function onHitMonkey;

  ///determines where the banana falls
  final double marginLeft;

  final double height;
  final double width;

  Banana({
    @required this.marginLeft,
    this.onHitGround,
    this.onHitMonkey,
    this.speed = 15.0,
    this.height = 50.0,
    this.width = 50.0,
  });

  @override
  _BananaState createState() => _BananaState();
}

class _BananaState extends State<Banana> {
  Timer _timer;
  double _marginTop = 0.0;
  String _animation;

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
    double screenHeight = MediaQuery.of(context).size.height;

    _marginTop += widget.speed;
    _marginTop = math.min(_marginTop, screenHeight - widget.height);

    if (widget.onHitGround != null &&
        _marginTop > screenHeight - Monkey.height - widget.height &&
        widget.marginLeft + widget.width/2 > Monkey.xValue &&
        widget.marginLeft < Monkey.xValue + Monkey.width/2) {

      print(widget.marginLeft.toString() + " " + Monkey.xValue.toString() + " " + Monkey.width.toString());
      widget.onHitMonkey();
    } else if (widget.onHitMonkey != null &&
        _marginTop >= screenHeight - widget.height) {
      widget.onHitGround();
    }

    _animation = "rotate";

    setState(() {});
  }
}
