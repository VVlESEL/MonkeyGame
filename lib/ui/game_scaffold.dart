import 'package:flutter/material.dart';
import 'package:monkeygame/ui/game_appbar.dart';
import 'package:monkeygame/ui/background.dart';

class GameScaffold extends StatelessWidget {
  final GameAppBar appBar;
  final Widget body;

  GameScaffold({@required this.appBar, @required this.body});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Background(imgResource: "assets/img_jungle.png"),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: appBar,
          body: body,
        ),
      ],
    );
  }
}