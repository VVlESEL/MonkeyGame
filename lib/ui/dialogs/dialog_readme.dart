import 'package:flutter/material.dart';

class ReadMeDialog extends StatefulWidget {
  @override
  _ReadMeDialogState createState() => _ReadMeDialogState();
}

class _ReadMeDialogState extends State<ReadMeDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Read Me",
        style: Theme.of(context).textTheme.headline,
      ),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Text(
              "How To Play?",
              style: Theme.of(context).textTheme.display2,
            ),
            Padding(padding: const EdgeInsets.symmetric(vertical: 4.0)),
            Text(
              "Control the monkey by tapping (and holding) on the left or "
                  "right side of the screen. You can also hold down your "
                  "finger and move over the screen. If your finger is on the "
                  "left side the monkey will move left and if it is on the "
                  "right side it will move to the right. Try to collect as "
                  "many bananas as possible but avoid the coconuts - they hurt!",
              style: Theme.of(context).textTheme.display3,
            ),
            Padding(padding: const EdgeInsets.symmetric(vertical: 8.0)),
            Text(
              "Why The advertisement?",
              style: Theme.of(context).textTheme.display2,
            ),
            Padding(padding: const EdgeInsets.symmetric(vertical: 4.0)),
            Text(
              "I tried to place the advertisement where it does not disturb. "
                  "There is still quite a lot - I know. This is my charity "
                  "project and all the money google pays for the ads (if any) "
                  "will be spend to help animals in need. So you don't have "
                  "to feel bad if you click on it. Have fun :)",
              style: Theme.of(context).textTheme.display3,
            ),
          ],
        ),
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
    );
  }
}
