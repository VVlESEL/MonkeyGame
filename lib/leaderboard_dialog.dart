import 'package:flutter/material.dart';
import 'package:monkeygame/leaderboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:monkeygame/auth.dart' as auth;
import 'package:monkeygame/choose_name_dialog.dart';

class LeaderboardDialog extends StatefulWidget {
  final int score;

  LeaderboardDialog({this.score = 0});

  @override
  _LeaderboardDialogState createState() => _LeaderboardDialogState();
}

class _LeaderboardDialogState extends State<LeaderboardDialog> {
  Widget _content = Leaderboard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: AlertDialog(
        title: Text(
          "Ranking",
          style: Theme.of(context).textTheme.headline,
        ),
        content: _content,
        actions: <Widget>[
          widget.score == 0
              ? FlatButton(
                  child: Text(
                    "Cancel",
                    style: Theme.of(context).textTheme.display2,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FutureBuilder(
                      initialData: false,
                      future: auth.checkLogin(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data) {
                            _sendScore();
                            return Text(
                              "Score Updated...",
                              style: Theme.of(context).textTheme.display2,
                            );
                          } else {
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Submit:   ",
                                    style: Theme.of(context).textTheme.display2,
                                  ),
                                  FlatButton(
                                    onPressed: () async {
                                      bool isLogin = await auth.facebookLogin();
                                      if (isLogin) {
                                        if (await _chooseNameOrContinue()) {
                                          _sendScore();
                                          setState(
                                              () => _content = Leaderboard());
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
                                          setState(
                                              () => _content = Leaderboard());
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
                              ),
                            );
                          }
                        }
                      },
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Play Again:",
                            style: Theme.of(context).textTheme.display2,
                          ),
                          FlatButton(
                            child: Icon(
                              Icons.repeat,
                              color: Colors.white,
                              size: 34.0,
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/game', ModalRoute.withName('/'));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Future<void> _sendScore() async {
    DocumentReference ref = Firestore.instance
        .collection("leaderboard")
        .document(auth.currentUser.uid);

    DocumentSnapshot doc = await ref.get();
    if (!doc.exists) {
      ref.setData(
          {"name": auth.currentUser.displayName, "score": widget.score});
    } else {
      int oldScore = doc.data["score"];
      if (widget.score >= oldScore) {
        ref.updateData(
            {"name": auth.currentUser.displayName, "score": widget.score});
      }
    }
  }

  Future<bool> _chooseNameOrContinue() async {
    if (auth.currentUser.metadata.creationTimestamp !=
        auth.currentUser.metadata.lastSignInTimestamp) return true;

    return await showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return ChooseNameDialog();
      },
    );
  }
}
