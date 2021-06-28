
import 'package:Bit.Me/contants.dart';
import 'package:Bit.Me/widgets/circular_progress_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'auth_pages/authentication.dart';
import 'external/authService.dart';
import 'home.dart';
void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.deepPurple, // Color for Android
      statusBarBrightness: Brightness.dark, // Dark == white status bar -- for IOS.
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppLanguage().appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: StreamBuilder<FirebaseUser>(
        stream: AuthService().authStateChanges(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Home(firebaseUser: snapshot.data);
          } else if (snapshot.hasData == false &&
              snapshot.connectionState == ConnectionState.active) {
            return Authentication();
          } else {
            return CircularProgressIndicatorMy();
          }
        },
      ),
    );
  }
}
