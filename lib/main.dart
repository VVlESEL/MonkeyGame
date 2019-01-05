import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monkeygame/game.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:monkeygame/auth.dart' as auth;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Set orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: Start(),
    );
  }
}

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            height: 100.0,
            width: 100.0,
            child: FlareActor(
              "assets/monkey.flr",
              animation: "wave",
            ),
          ),
          Center(
            child: FlatButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((BuildContext context) => Game()))),
              child: Text("Start Game"),
            ),
          ),
          Builder(
            builder: (BuildContext context) => FlatButton(
                  onPressed: () => auth.logout().then((b) {
                        if (b) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("Logged out..."),
                            duration: Duration(seconds: 2),
                          ));
                        }
                      }),
                  child: Text("Logout"),
                ),
          )
        ],
      ),
    );
  }
}
