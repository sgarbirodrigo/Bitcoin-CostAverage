import 'package:bitbybit/authService.dart';
import 'package:bitbybit/authentication.dart';
import 'package:bitbybit/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Initializer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: AuthService().authStateChanges(),
      builder: (context, AsyncSnapshot snapshot) {
        // if the stream has data, the user is logged in
        if (snapshot.hasData) {
          // isLoggedIn
          FirebaseUser user = snapshot.data;
          return Home(userUid: user.uid);
        } else if (snapshot.hasData == false &&
            snapshot.connectionState == ConnectionState.active) {
          // isLoggedOut
          return Authentication();
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
