import 'dart:async';
import 'dart:io';

import 'package:Bit.Me/contants.dart';
import 'package:Bit.Me/controllers/binance_controller.dart';
import 'package:Bit.Me/controllers/connectivityController.dart';
import 'package:Bit.Me/sql_database.dart';
import 'package:Bit.Me/widgets/circular_progress_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info/package_info.dart';
import 'package:purchases_flutter/object_wrappers.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sqflite/sqflite.dart';

import 'auth_pages/authentication.dart';
import 'controllers/auth_controller.dart';
import 'controllers/bindings/auth_binding.dart';
import 'controllers/database_controller.dart';
import 'controllers/purchase_controller.dart';
import 'controllers/user_controller.dart';
import 'external/authService.dart';
import 'home.dart';
import 'pages/authentication/authentication.dart';
import 'pages/authentication/recovery.dart';
import 'pages/authentication/sign_up.dart';

//1222

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Get.put(BinanceController());
  Get.put(PurchaseController());
  Get.put(LocalDatabaseController(onLoad: () {
    Get.put(UserController());
  }));
  Get.put(AuthController());
  Get.put(ConnectivityController());

  final Trace traceInit = FirebasePerformance.instance.newTrace("trace_init_performance");
  await traceInit.start();

  //control device initial settings
  if (Platform.isIOS) {
    await traceInit.putAttribute("platform", "ios");
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.deepPurple, // Color for Android
      statusBarBrightness: Platform.isAndroid
          ? Brightness.light
          : Brightness.dark, // Dark == white status bar -- for IOS.
    ));
  } else {
    await traceInit.putAttribute("platform", "not_ios");
    SystemChrome.setEnabledSystemUIOverlays([]);
  }
  //control app version
  bool appUpdated = true;
  try {
    if (Platform.isAndroid || Platform.isIOS) {
      appUpdated = await checkAppVersion();
    }
  } catch (e) {
    appUpdated = true;
  }
  await traceInit.putAttribute("app_update", appUpdated.toString());

  await traceInit.incrementMetric("local_db_init", 1);
  await traceInit.stop();

  runZonedGuarded(() {
    runApp(MyApp(appUpdated));
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
  var authController = Get.find<AuthController>();
  var purchaseController = Get.find<PurchaseController>();

  MyApp(this.appUpdated) {}

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      locale: Locale("en", "US"),
      title: "Bitcoin-Cost Average",
      //translationsKeys: Messages().keys,
      theme: ThemeData(
        scaffoldBackgroundColor: light,
        textTheme:
            GoogleFonts.mulishTextTheme(Theme.of(context).textTheme).apply(bodyColor: Colors.black),
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        }),
        primarySwatch: Colors.deepPurple,
      ),
      initialBinding: AuthBinding(),
      home: authController.obx(
        (_controller) {
          if (!this.appUpdated) {
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
          if (authController.isUserLogged()) {
            FirebaseCrashlytics.instance.setUserIdentifier(authController.user.uid);
            Get.find<UserController>().loadUserData(authController.user.uid);
            //print("first load user");
            purchaseController.setUser(authController.user.uid);
            return purchaseController.obx(
              (_purchaserController) {
                return Home();
              },
              onLoading: CircularProgressIndicatorMy(
                info: "loading purchase controller",
              ),
              onEmpty: CircularProgressIndicatorMy(
                info: "empty purchase controller",
              ),
              // here also you can set your own error widget, but by
              // default will be an Center(child:Text(error))
              onError: (error) {
                callSnackbar("Oops!", error);
                return Home();
              },
            );
          } else {
            return Authentication();
          }
        },
        // here you can put your custom loading indicator, but
        // by default would be Center(child:CircularProgressIndicator())
        onLoading: CircularProgressIndicatorMy(
          info: "loading auth controller",
        ),
        onEmpty: CircularProgressIndicatorMy(
          info: "empty auth controller",
        ),
        // here also you can set your own error widget, but by
        // default will be an Center(child:Text(error))
        onError: (error) => Authentication(),
      ),
    );
  }
}
