import 'dart:async';
import 'dart:io';

import 'package:bitcoin_cost_average/contants.dart';
import 'package:bitcoin_cost_average/controllers/binance_controller.dart';
import 'package:bitcoin_cost_average/controllers/connectivityController.dart';
import 'package:bitcoin_cost_average/controllers/deviceController.dart';
import 'package:bitcoin_cost_average/controllers/remoteConfigController.dart';
import 'package:bitcoin_cost_average/external/sql_database.dart';
import 'package:bitcoin_cost_average/tools.dart';
import 'package:bitcoin_cost_average/translation.dart';
import 'package:bitcoin_cost_average/widgets/circular_progress_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
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
import 'package:intl/date_symbol_data_local.dart';
import 'package:package_info/package_info.dart';

import 'CustomKeyboard.dart';
import 'auth_pages/authentication.dart';
import 'controllers/auth_controller.dart';
import 'controllers/bindings/auth_binding.dart';
import 'controllers/database_controller.dart';
import 'controllers/purchase_controller.dart';
import 'controllers/user_controller.dart';
import 'home.dart';

//The !sequence! matters
initControllers() {
  Get.put(DeviceController());
  Get.put(BinanceController());
  Get.put(PurchaseController());
  Get.put(LocalDatabaseController(onLoad: () {
    Get.put(UserController());
  }));
  Get.put(AuthController());
  Get.put(ConnectivityController());
  Get.put(RemoteConfigController());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initControllers();

  final Trace traceInit = FirebasePerformance.instance.newTrace("trace_init_performance");
  await traceInit.start();

  //control device initial settings
  if (Platform.isIOS) {
    await traceInit.putAttribute("platform", "ios");
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.deepPurple, // Color for Android
      statusBarBrightness: Brightness.dark, // Dark == white status bar -- for IOS.
    ));
  } else {
    await traceInit.putAttribute("platform", "not_ios");
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Color(0xff553277),
    ));
  }

  //control app version
  bool appUpdated = await runAppVersionCheck();
  await traceInit.putAttribute("app_update", appUpdated.toString());

  await traceInit.incrementMetric("local_db_init", 1);
  await traceInit.stop();

  CustomNumberKeyboard.register();
  runZonedGuarded(() {
    runApp(MyApp(appUpdated));
  }, FirebaseCrashlytics.instance.recordError);
}

class MyApp extends StatelessWidget {
  bool appUpdated;
  var authController = Get.find<AuthController>();
  var purchaseController = Get.find<PurchaseController>();

  MyApp(this.appUpdated);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      locale: Get.deviceLocale,
      fallbackLocale: Locale('en', 'US'),
      title: "title".tr,
      translationsKeys: Messages().keys,
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
                      "Sorry for the inconvenient but you must update your app.\n:\'(",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24),
                    ),
                  )),
            );
          }
          if (authController.isUserLogged()) {
            FirebaseCrashlytics.instance.setUserIdentifier(authController.user.uid);
            Get.find<UserController>().loadUserData(authController.user.uid);
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
        onError: (error) {
          print("main userController error $error");
          return Authentication();
        },
      ),
    );
  }
}
