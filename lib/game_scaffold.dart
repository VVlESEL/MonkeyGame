import 'package:flutter/material.dart';
import 'package:monkeygame/game_appbar.dart';

class GameScaffold extends StatelessWidget {
  final GameAppBar appBar;
  final Widget body;

  GameScaffold({@required this.appBar, @required this.body});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/img_jungle.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Container(
            color: Colors.black.withOpacity(0.30),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: appBar,
          body: body,
        ),
      ],
    );
  }
}