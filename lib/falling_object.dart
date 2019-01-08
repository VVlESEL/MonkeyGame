import 'dart:async';
import 'dart:math' as math;
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:monkeygame/game.dart';

typedef void MyCallback(FallingObject banana);
class FallingObject extends StatefulWidget {
  ///determines the pixel movement every x millis
  final double speed;

  ///callback after hitting the monkey, remove view here
  final MyCallback onHitMonkey;

  ///callback after reaching opacity of 0
  final MyCallback onFaded;

  ///determines where the banana falls
  final double marginLeft;

  final double height;
  final double width;

  final String actorAsset;
  final String idleAnimation;
  final String hitMonkeyAnimation;
  final String hitGroundAnimation;

  FallingObject({
    Key key,
    @required this.marginLeft,
    @required this.onHitMonkey,
    @required this.onFaded,
    @required this.actorAsset,
    @required this.idleAnimation,
    @required this.hitMonkeyAnimation,
    @required this.hitGroundAnimation,
    this.speed = 15.0,
    this.height = 50.0,
    this.width = 50.0,
  }) : super(key: key);

  @override
  _FallingObjectState createState() => _FallingObjectState();
}

class _FallingObjectState extends State<FallingObject> {
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
    if (_animation == null) _animation = widget.idleAnimation;
    if (_timer == null)
      _timer = Timer.periodic(Duration(milliseconds: 40), (timer) {
        if (Game.lifecycleState != AppLifecycleState.paused &&
            Game.lifecycleState != AppLifecycleState.inactive) {
          update(context);
        }
      });

    return Container(
      height: widget.height,
      width: widget.width,
      margin: EdgeInsets.only(
        left: widget.marginLeft,
        top: _marginTop,
      ),
      child: FlareActor(
        widget.actorAsset,
        alignment: Alignment.center,
        animation: _animation,
        fit: BoxFit.contain,
      ),
    );
  }

  void update(BuildContext context) {
    if (_animation == widget.idleAnimation) {
      _marginTop += widget.speed;
      _marginTop = math.min(_marginTop, Game.screenHeight - widget.height);

      if (_marginTop > Game.screenHeight - Game.monkeyHeight - widget.height &&
          widget.marginLeft + widget.width > Game.monkeyX &&
          widget.marginLeft < Game.monkeyX + Game.monkeyWidth) {
        _animation = widget.hitMonkeyAnimation;
        widget.onHitMonkey(widget);
        Timer(Duration(seconds: 1), () => widget.onFaded(widget));
      } else if (_marginTop >= Game.screenHeight - widget.height) {
        _animation = widget.hitGroundAnimation;
        Timer(Duration(seconds: 1), () => widget.onFaded(widget));
      }
    }

    setState(() {});
  }
}
