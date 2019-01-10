import 'package:flutter/material.dart';

class CreditsDialog extends StatefulWidget {
  @override
  _CreditsDialogState createState() => _CreditsDialogState();
}

class _CreditsDialogState extends State<CreditsDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Credits",
        style: Theme.of(context).textTheme.headline,
      ),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Jungle Photo by Marianne Long on Unsplash",
                style: Theme.of(context).textTheme.display3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Leafs Photo by Yoal Desurmont on Unsplash",
                style: Theme.of(context).textTheme.display3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Music: https://www.bensound.com",
                style: Theme.of(context).textTheme.display3,
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            "Got It",
            style: Theme.of(context).textTheme.display2,
          ),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ],
    );
  }
}
