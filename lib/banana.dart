import 'dart:async';
import 'dart:math' as math;
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class Banana extends StatefulWidget {
  ///determines the pixel movement every x millis
  final double speed;

  ///callback after reaching the ground
  final Function onHitGround;

  ///determines where the banana falls
  final double marginLeft;

  final double height;
  final double width;

  Banana({
    @required this.marginLeft,
    this.onHitGround,
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

  @override
  void initState() {
    _timer = Timer.periodic(Duration(milliseconds: 40), (timer) {
      setState(() {
        _marginTop += widget.speed;
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
        left: widget.marginLeft,
        top: getMargin(context),
      ),
      child: FlareActor(
        "assets/banana.flr",
        alignment: Alignment.center,
        animation: "rotate",
        fit: BoxFit.contain,
      ),
    );
  }

  double getMargin(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    _marginTop = math.min(_marginTop, screenHeight - widget.height);
    return _marginTop;
  }
}
