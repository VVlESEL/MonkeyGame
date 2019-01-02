import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class GameAppBar extends StatelessWidget with PreferredSizeWidget {
  final int bananaCounter;
  final int secondsLeft;

  GameAppBar({@required this.bananaCounter, @required this.secondsLeft});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                height: 40.0,
                width: 40.0,
                child: FlareActor("assets/banana.flr"),
              ),
              Text(
                bananaCounter.toString(),
                maxLines: 1,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                height: 40.0,
                width: 40.0,
                child: Icon(Icons.access_time),
              ),
              Text(
                secondsLeft.toString(),
                maxLines: 1,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(30.0);
}