import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:monkeygame/utils/auth.dart' as auth;

class CreditsDialog extends StatefulWidget {
  @override
  _CreditsDialogState createState() => _CreditsDialogState();
}

class _CreditsDialogState extends State<CreditsDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: AlertDialog(
        title: Text(
          "Credits",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26.0),
        ),
        content: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text("Jungle Photo by Marianne Long on Unsplash",
                  style: _textStyle()),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text("Leafs Photo by Yoal Desurmont on Unsplash",
                  style: _textStyle()),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text("Music: https://www.bensound.com", style: _textStyle()),
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Got It",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      ),
    );
  }

  TextStyle _textStyle() {
    return TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 16.0,
    );
  }
}
