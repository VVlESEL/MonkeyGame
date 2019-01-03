import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

///Is equal to FirebaseAuth.instance.currentUser() or null. You have
///to call checkLogin, facebookLogin or googleLogin first.
FirebaseUser currentUser;

/*
UserUpdateInfo info = UserUpdateInfo();
info.displayName = "Peter";
user.updateProfile(info);
*/
/*
print("creation "+user.metadata.creationTimestamp.toString());
print("last "+user.metadata.lastSignInTimestamp.toString());
*/

///Asynchronously checks if the user is currently logged in.
Future<bool> checkLogin() async {
  await FirebaseAuth.instance.currentUser().then((user){
    if (user != null){
      print("checkLogin: User is logged in");
      currentUser = user;
    }
    else print("checkLogin: User is NOT logged in");
  }).catchError((error) {
    print("checkLogin: Something went wrong! ${error.toString()}");
    throw error;
  });
  return currentUser != null;
}

Future<bool> logout() async {
  await FirebaseAuth.instance.signOut().then((_) {
    print("logout: User logged out");
    currentUser = null;
  }).catchError((error) {
    print("logout: Something went wrong! ${error.toString()}");
    throw error;
  });

  return currentUser == null;
}

Future<bool> facebookLogin() async {
  final facebookLogin = FacebookLogin();

  await facebookLogin.logInWithReadPermissions(['email']).then((result) {
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        FirebaseAuth.instance
            .signInWithFacebook(accessToken: result.accessToken.token)
            .then((user) {

          currentUser = user;
          print("facebookLogin: ${user.displayName} (${user.uid}) signed in");
        });
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("canceled");
        break;
      case FacebookLoginStatus.error:
        print(result.errorMessage);
        break;
    }
  });

  return currentUser != null;
}

Future<bool> googleLogin() async {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  await googleSignIn.signIn().then((googleUser) async {
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await FirebaseAuth.instance.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    currentUser = user;
    print("googleLogin: ${user.displayName} (${user.uid}) signed in");
  }).catchError((e) => print(e));

  return currentUser != null;
}
