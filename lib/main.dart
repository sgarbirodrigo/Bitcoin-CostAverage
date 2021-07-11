import 'dart:async';
import 'dart:io';

import 'package:Bit.Me/contants.dart';
import 'package:Bit.Me/sql_database.dart';
import 'package:Bit.Me/widgets/circular_progress_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:purchases_flutter/object_wrappers.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sqflite/sqflite.dart';

import 'auth_pages/authentication.dart';
import 'external/authService.dart';
import 'home.dart';

//1222
void main() async {

  if (Platform.isIOS) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.deepPurple, // Color for Android
      statusBarBrightness: Platform.isAndroid
          ? Brightness.light
          : Brightness.dark, // Dark == white status bar -- for IOS.
    ));
  }else{
    SystemChrome.setEnabledSystemUIOverlays([]);
  }
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  bool app_updated = true;
  try {
    if (Platform.isAndroid || Platform.isIOS) {
      app_updated = true;
    }
  } catch (e) {
    app_updated = true;
  }
  await Purchases.setup(apiKey, observerMode: false);
  SqlDatabase sql_database = SqlDatabase();
  await sql_database.initDB();
  FirebaseAuth.instance.authStateChanges().listen((firebaseUser) async {
    if (firebaseUser == null) {
      await sql_database.deleteDB();
      await Purchases.reset();
    }
  });
  runZonedGuarded(() {
    runApp(MyApp(app_updated, sql_database));
  }, FirebaseCrashlytics.instance.recordError);
}

Future<bool> checkAppVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String appName = packageInfo.appName;
  String packageName = packageInfo.packageName;
  String version = packageInfo.version;
  String buildNumber = packageInfo.buildNumber;

  DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
      await FirebaseFirestore.instance.collection("appConfig").doc("standard").get();
  var data = documentSnapshot.data();
  bool result = int.parse(buildNumber) >= int.parse(data["min_version_build"].toString());
  return result;
}

class MyApp extends StatelessWidget {
  bool appUpdated;
  SqlDatabase sql_database;

  MyApp(this.appUpdated, this.sql_database);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppLanguage().appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: StreamBuilder<User>(
        stream: AuthService().authStateChanges(),
        builder: (context, AsyncSnapshot<User> snapshot) {
          if (this.appUpdated) {
            if (snapshot.hasData) {
              FirebaseCrashlytics.instance.setUserIdentifier(snapshot.data.uid);
              return FutureBuilder<PurchaserInfo>(
                  future: Purchases.identify(snapshot.data.uid),
                  builder: (context, purchaserInfoSnapshot) {
                    if (purchaserInfoSnapshot.hasData) {
                      print("Purchaser Info: ${purchaserInfoSnapshot.data.activeSubscriptions}");
                      return Home(
                          firebaseUser: snapshot.data,
                          purchaserInfo: purchaserInfoSnapshot.data,
                          sql_database: sql_database);
                    } else {
                      return CircularProgressIndicatorMy();
                    }
                  });
            } else if (snapshot.hasData == false &&
                snapshot.connectionState == ConnectionState.active) {
              return Authentication();
            } else {
              return CircularProgressIndicatorMy();
            }
          } else {
            return Scaffold(
              body: Container(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Center(
                    child: Text(
                      "Sorry for the inconvenient but you must update your app to keep using the app.\n:\'(",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24),
                    ),
                  )),
            );
          }
        },
      ),
    );
  }
}
