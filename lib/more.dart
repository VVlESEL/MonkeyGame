import 'package:flutter/material.dart';
import 'package:monkeygame/auth.dart' as auth;
import 'package:monkeygame/background.dart';
import 'package:monkeygame/choose_name_dialog.dart';
import 'package:monkeygame/credits_dialog.dart';
import 'package:monkeygame/style.dart';

class More extends StatefulWidget {
  @override
  _MoreState createState() => _MoreState();
}

class _MoreState extends State<More> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Background(imgResource: "assets/img_leafs.png"),
        Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(backgroundColor: Colors.transparent),
            body: ListView(
              shrinkWrap: true,
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    showDialog<bool>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                              dialogBackgroundColor: baseColor),
                          child: CreditsDialog(),
                        );
                      },
                    );
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.photo_camera,
                      color: baseColor,
                    ),
                    title: Text("Credits", style: _textStyle()),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    showDialog<bool>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                              dialogBackgroundColor: baseColor),
                          child: ChooseNameDialog(),
                        );
                      },
                    );
                  },
                  child: Text("Change Name", style: _textStyle()),
                ),
                Builder(
                  builder: (BuildContext context) => FlatButton(
                        onPressed: () => auth.logout().then((b) {
                              if (b) {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  backgroundColor: Colors.transparent,
                                  content: Text("Logged out...",
                                      style: _textStyle()),
                                  duration: Duration(seconds: 2),
                                ));
                              }
                            }),
                        child: Text("Logout", style: _textStyle()),
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  TextStyle _textStyle() {
    return TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 26.0,
    );
  }
}
