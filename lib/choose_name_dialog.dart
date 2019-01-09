import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:monkeygame/auth.dart' as auth;

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
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: AlertDialog(
          title: Text(
            "Choose a Beautiful Name",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 26.0),
          ),
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
                  if (text.isEmpty ||
                      text.trim().length < 3 ||
                      text.trim().length > 15)
                    return "Please enter between 3 and 15 letters...";
                },
                controller: _controller,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
                decoration: InputDecoration(hintText: "Beautiful Name"),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Submit",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
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
                Navigator.of(context).pop(true);
              },
            ),
            FlatButton(
              child: Text(
                "Cancel",
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
      ),
    );
  }
}
