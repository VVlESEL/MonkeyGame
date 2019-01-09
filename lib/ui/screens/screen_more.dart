import 'package:flutter/material.dart';
import 'package:monkeygame/utils/auth.dart' as auth;
import 'package:monkeygame/ui/background.dart';
import 'package:monkeygame/ui/dialogs/dialog_name.dart';
import 'package:monkeygame/ui/dialogs/dialog_credits.dart';
import 'package:monkeygame/utils/globals.dart';
import 'package:monkeygame/ui/dialogs/dialog_readme.dart';

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
                      builder: (BuildContext context) {
                        return Theme(
                          data: Theme.of(context)
                              .copyWith(dialogBackgroundColor: baseColor),
                          child: CreditsDialog(),
                        );
                      },
                    );
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.photo_camera,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    title: Text(
                      "Credits",
                      style: Theme.of(context).textTheme.display1,
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return Theme(
                          data: Theme.of(context)
                              .copyWith(dialogBackgroundColor: baseColor),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 50.0),
                            child: ReadMeDialog(),
                          ),
                        );
                      },
                    );
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.help_outline,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    title: Text(
                      "Read Me",
                      style: Theme.of(context).textTheme.display1,
                    ),
                  ),
                ),
                FutureBuilder(
                  future: auth.checkLogin(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData || !snapshot.data) return Container();
                    return FlatButton(
                      onPressed: () {
                        showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return Theme(
                              data: Theme.of(context)
                                  .copyWith(dialogBackgroundColor: baseColor),
                              child: ChooseNameDialog(),
                            );
                          },
                        );
                      },
                      child: ListTile(
                        leading: Icon(
                          Icons.person,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        title: Text(
                          "Change Name",
                          style: Theme.of(context).textTheme.display1,
                        ),
                      ),
                    );
                  },
                ),
                FutureBuilder(
                    future: auth.checkLogin(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData || !snapshot.data) return Container();
                      return FlatButton(
                        onPressed: () => auth.logout().then((b) {
                              if (b) {
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.transparent,
                                    content: Text(
                                      "Logged out...",
                                      style:
                                          Theme.of(context).textTheme.display1,
                                    ),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                                setState(() {});
                              }
                            }),
                        child: ListTile(
                          leading: Icon(
                            Icons.exit_to_app,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          title: Text(
                            "Logout",
                            style: Theme.of(context).textTheme.display1,
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
