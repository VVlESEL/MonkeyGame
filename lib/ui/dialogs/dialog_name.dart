import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:monkeygame/utils/auth.dart' as auth;

class ChooseNameDialog extends StatefulWidget {
  @override
  _ChooseNameDialogState createState() => _ChooseNameDialogState();
}

class _ChooseNameDialogState extends State<ChooseNameDialog> {
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _controller = TextEditingController();
  bool _isShowError = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        title: Text(
          "Choose a Beautiful Name",
          style: Theme.of(context).textTheme.headline,
        ),
        content: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView(
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
                  if (text.isEmpty ||
                      text.trim().length < 3 ||
                      text.trim().length > 15)
                    return "Please enter between 3 and 15 letters...";
                },
                controller: _controller,
                style: Theme.of(context).textTheme.display2,
                decoration: InputDecoration(hintText: "Beautiful Name"),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Submit",
              style: Theme.of(context).textTheme.display2,
            ),
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
              await Firestore.instance
                  .collection("leaderboard")
                  .document(auth.currentUser.uid)
                  .updateData({"name": _controller.text});
              Navigator.of(context).pop(true);
            },
          ),
          FlatButton(
            child: Text(
              "Cancel",
              style: Theme.of(context).textTheme.display2,
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      ),
    );
  }
}