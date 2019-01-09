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
      iconTheme: Theme.of(context).accentIconTheme,
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
                style: Theme.of(context).textTheme.display2,
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                height: 40.0,
                width: 40.0,
                child: Icon(Icons.access_time, color: Theme.of(context).accentIconTheme.color,),
              ),
              Text(
                secondsLeft.toString(),
                maxLines: 1,
                style: Theme.of(context).textTheme.display2,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(30.0);
}
