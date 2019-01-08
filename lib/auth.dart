import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

///Is equal to FirebaseAuth.instance.currentUser() or null. You have
///to call checkLogin, facebookLogin or googleLogin first.
FirebaseUser currentUser;

///Asynchronously checks if the user is currently logged in.
Future<bool> checkLogin() async {
  await FirebaseAuth.instance.currentUser().then((user) {
    if (user != null) {
      print("checkLogin: User ${user.displayName} is logged in");
      currentUser = user;
    } else
      print("checkLogin: User is NOT logged in");
  }).catchError((error) {
    print("checkLogin: Something went wrong! ${error.toString()}");
  });
  return currentUser != null;
}

Future<bool> logout() async {
  await FirebaseAuth.instance.signOut().then((_) {
    print("logout: User logged out");
    currentUser = null;
  }).catchError((error) {
    print("logout: Something went wrong! ${error.toString()}");
  });
  return currentUser == null;
}

Future<void> updateUser(String name) async {
  UserUpdateInfo info = UserUpdateInfo();
  info.displayName = name;
  await currentUser.updateProfile(info).then((_) {
    print("updateUser: User displayName is $name");
  }).catchError((error) {
    print("updateUser: Something went wrong! ${error.toString()}");
  });
  return await checkLogin();
}

Future<bool> facebookLogin() async {
  final facebookLogin = FacebookLogin();

  await facebookLogin.logInWithReadPermissions(['email']).then((result) async {
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        await FirebaseAuth.instance
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
  }).catchError((error) {
    print("facebookLogin: Something went wrong! ${error.toString()}");
  });

  return currentUser != null;
}

Future<bool> googleLogin() async {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  await googleSignIn.signIn().then((googleUser) async {
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await FirebaseAuth.instance
        .signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    )
        .catchError((error) {
      print("signInWithGoogle: Somthing went wrong! ${error.toString()}");
    });

    currentUser = user;
    print("googleLogin: ${user.displayName} (${user.uid}) signed in");
  }).catchError((error) {
    print("googleLogin: Somthing went wrong! ${error.toString()}");
  });

  return currentUser != null;
}
