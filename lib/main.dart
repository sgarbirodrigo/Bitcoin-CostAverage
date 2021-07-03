import 'package:Bit.Me/contants.dart';
import 'package:Bit.Me/widgets/circular_progress_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
  ;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print("error initializing firebase first: ${snapshot.error}");
          return CircularProgressIndicatorMy();
        }
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          print("0");
          return MaterialApp(
            title: AppLanguage().appTitle,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.deepPurple,
            ),
            home: StreamBuilder<User>(
              stream: AuthService().authStateChanges(),
              builder: (context, AsyncSnapshot<User> snapshot) {
                if (snapshot.hasData) {
                  return Home(firebaseUser: snapshot.data);
                } else if (snapshot.hasData == false && snapshot.connectionState == ConnectionState.active) {
                  return Authentication();
                } else {
                  return CircularProgressIndicatorMy();
                }
              },
            ),
          );
        }
        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicatorMy();
      },
    );
  }
}
