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

    GlobalKey<FormState> formKey = GlobalKey();
    TextEditingController controller = TextEditingController();

    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Form(
          key: formKey,
          child: AlertDialog(
            title: Text("Choose a Beautiful Name"),
            content: TextFormField(
              validator: (text) {
                if (text.isEmpty || text.trim().length < 5)
                  return "Please enter min 5 letters...";
              },
              controller: controller,
              decoration: InputDecoration(hintText: "Beautiful Name"),
            ),
            actions: <Widget>[
              Builder(
                builder: (BuildContext context) => FlatButton(
                      child: Text("Submit"),
                      onPressed: () async {
                        if (!formKey.currentState.validate()) return;

                        QuerySnapshot snapshot = await Firestore.instance
                            .collection("user")
                            .where("name", isEqualTo: controller.text)
                            .limit(1)
                            .getDocuments();

                        if (snapshot.documents.length > 0) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Name is beautiful but already exists. Please choose another name."),
                            duration: Duration(seconds: 3),
                          ));
                          return;
                        }

                        await auth.updateUser(controller.text);
                        await Firestore.instance
                            .collection("user")
                            .document(auth.currentUser.uid)
                            .setData({"name": controller.text});
                        Navigator.of(context).pop(true);
                      },
                    ),
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
      },
    );
  }
}
