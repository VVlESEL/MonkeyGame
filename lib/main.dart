import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monkeygame/game.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  ///has to be relmoved blablabla
  ///
  /// ///
  /// /// ///
  @override
  void initState() {
    var facebookLogin = new FacebookLogin();
    facebookLogin.logInWithReadPermissions(['email']).then((result) {
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          FirebaseAuth.instance
              .signInWithFacebook(accessToken: result.accessToken.token)
              .then((user) {
            print(user.uid);
          });
          break;
        case FacebookLoginStatus.cancelledByUser:
          print("canceled");
          break;
        case FacebookLoginStatus.error:
          print(result.errorMessage);
          break;
      }
    });

    super.initState();
  }

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
        ],
      ),
    );
  }
}
