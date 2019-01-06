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
      child: AlertDialog(
        title: Text("Choose a Beautiful Name"),
        content: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.9,
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
                  if (text.isEmpty || text.trim().length < 5)
                    return "Please enter min 5 letters...";
                },
                controller: _controller,
                decoration: InputDecoration(hintText: "Beautiful Name"),
              ),
            ],
          ),
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