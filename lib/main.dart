import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/services.dart';
import 'package:monkeygame/monkey.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Set landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _screenWidth;
  double _screenHeight;
  MonkeyMovement _moving = MonkeyMovement.WAIT;

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _moving = details.globalPosition.dx > _screenWidth / 2
              ? MonkeyMovement.RIGHT
              : MonkeyMovement.LEFT;
        });
      },
      onPanEnd: (_) => setState(() {
            _moving = MonkeyMovement.WAIT;
          }),
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 100.0, top: 100.0),
              height: 50.0,
              width: 50.0,
              child: FlareActor(
                "assets/banana.flr",
                alignment: Alignment.center,
                animation: "rotate",
                fit: BoxFit.contain,
              ),
            ),
            Baseline(
                baselineType: TextBaseline.alphabetic,
                baseline: _screenHeight,
                child: Monkey(
                  movement: _moving,
                  speed: 15,
                )),
          ],
        ),
      ),
    );
  }
}

//banana widget with size, speed,
//add list of bananas to stack, remove on catch or fail
