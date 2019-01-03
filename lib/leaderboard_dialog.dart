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
    if(!isLoggedIn) {
      setState(() {
        _content = Row(
          children: <Widget>[
            FlatButton(
              onPressed: () {
                auth.facebookLogin();
              },
              child: Text("FB"),
            ),FlatButton(
              onPressed: () {
                auth.googleLogin();
              },
              child: Text("Google"),
            ),
          ],
        );
      });
    }
    Firestore.instance
        .collection("leaderboard")
        .document(auth.currentUser.uid)
        .setData({
          "name": auth.currentUser.displayName,
          "score": widget.score
        });
  }
}