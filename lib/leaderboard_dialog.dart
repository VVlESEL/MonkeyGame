import 'package:flutter/material.dart';
import 'package:monkeygame/leaderboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:monkeygame/auth.dart' as auth;

class LeaderboardDialog extends StatefulWidget {
  final int score;

  LeaderboardDialog({@required this.score});

  @override
  _LeaderboardDialogState createState() => _LeaderboardDialogState();
}

class _LeaderboardDialogState extends State<LeaderboardDialog> {
  Widget _content = Leaderboard();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Leaderboard"),
      content: _content,
      actions: <Widget>[
        FlatButton(
          child: Text("Submit"),
          onPressed: () {
            _updateScore();
          },
        ),
        FlatButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Future<void> _updateScore() async {
    bool isLoggedIn = await auth.checkLogin();
    if (isLoggedIn) {
      _sendScore();
    } else {
      setState(() {
        _content = Row(
          children: <Widget>[
            FlatButton(
              onPressed: () async {
                bool isLogin = await auth.facebookLogin();
                if (isLogin) {
                  if (await _chooseNameOrContinue()) {
                    _sendScore();
                    setState(() => _content = Leaderboard());
                  }
                }
              },
              child: Image.asset(
                "assets/ic_facebook.png",
                width: 30.0,
                height: 30.0,
              ),
            ),
            FlatButton(
              onPressed: () async {
                bool isLogin = await auth.googleLogin();
                if (isLogin) {
                  if (await _chooseNameOrContinue()) {
                    _sendScore();
                    setState(() => _content = Leaderboard());
                  }
                }
              },
              child: Image.asset(
                "assets/ic_google.png",
                width: 30.0,
                height: 30.0,
              ),
            ),
          ],
        );
      });
    }
  }

  Future<void> _sendScore() async {
    return Firestore.instance
        .collection("leaderboard")
        .document(auth.currentUser.uid)
        .setData({"name": auth.currentUser.displayName, "score": widget.score});
  }

  Future<bool> _chooseNameOrContinue() async {
    if (auth.currentUser.metadata.creationTimestamp !=
        auth.currentUser.metadata.lastSignInTimestamp) return true;

    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return LoginDialog();
      },
    );
  }
}

class LoginDialog extends StatefulWidget {
  @override
  _LoginDialogState createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _controller = TextEditingController();
  bool _isShowError = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        title: Text("Choose a Beautiful Name"),
        content: ListView(
          shrinkWrap: true,
          children: <Widget>[
            _isShowError
                ? Text(
              "Name is beautiful but already taken. Please choose another name.",
              style: TextStyle(color: Colors.red),
            )
                : Container(),
            TextFormField(
              validator: (text) {
                if (text.isEmpty || text.trim().length < 5)
                  return "Please enter min 5 letters...";
              },
              controller: _controller,
              decoration: InputDecoration(hintText: "Beautiful Name"),
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("Submit"),
            onPressed: () async {
              if (!_formKey.currentState.validate()) return;

              QuerySnapshot snapshot = await Firestore.instance
                  .collection("user")
                  .where("name", isEqualTo: _controller.text)
                  .limit(1)
                  .getDocuments();

              if (snapshot.documents.length > 0) {
                setState(() => _isShowError = true);
                return;
              }

              await auth.updateUser(_controller.text);
              await Firestore.instance
                  .collection("user")
                  .document(auth.currentUser.uid)
                  .setData({
                "name": _controller.text,
                "email": auth.currentUser.email
              });
              Navigator.of(context).pop(true);
            },
          ),
          FlatButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      ),
    );
  }
}
