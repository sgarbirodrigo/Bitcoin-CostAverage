import 'dart:io';

import 'package:Bit.Me/controllers/database_controller.dart';
import 'package:Bit.Me/controllers/purchase_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../contants.dart';

class AuthController extends GetxController with StateMixin {
  var purchaseController = Get.find<PurchaseController>();
  var databaseController = Get.find<LocalDatabaseController>();

  final Trace _traceAuthChange =
      FirebasePerformance.instance.newTrace("trace_authChange_performance");
  FirebaseAuth _auth;
  var _user = Rx<User>(null);
  RxBool rememberMe = false.obs;

  User get user => _user.value;

  @override
  int get hashCode {}

  @override
  void dispose() {
    super.dispose();
    _traceAuthChange.stop();
  }

  @override
  void onInit() {
    super.onInit();
    change(this, status: RxStatus.loading());
    _traceAuthChange.start();
    _auth = FirebaseAuth.instance;
    _auth.authStateChanges().listen((User user) {
      _traceAuthChange.incrementMetric("stateChange_counter", 1);
      _user.value = user;
    });
    change(this, status: RxStatus.success());
  }

  bool isUserLogged() {
    if (this.user != null && !this.user.isBlank && !this.user.isAnonymous) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> signUp(String user, String password) async {
    change(this, status: RxStatus.loading());
    String error;

    if (user.isNotEmpty && password.isNotEmpty) {
      try {
        _user.value = (await FirebaseAuth.instance
                .createUserWithEmailAndPassword(email: user, password: password))
            .user;
        print("pre-user signed: ${_user.value}");
        //update();
        //print("pro-user signed: ${_user.value}");
        //Get.toNamed(rootRoute);
      } on FirebaseException catch (e) {
        print("Auth error: $e");
        error = e.message;
      }
    } else {
      if (user.isEmpty) {
        error = "Email cannot be empty.";
      }
      if (user.isEmpty) {
        error = "Password cannot be empty.";
      }
    }
    if (error != null) {
      change(this, status: RxStatus.error(error));
      print("error signup: $error");
      callSnackbar("Oops!", error);
      update();
    } else {
      print("success ");

      //wait to close only when firebase functions finish creation of user directory
      FirebaseFirestore.instance
          .collection("users")
          .doc(_user.value.uid)
          .snapshots()
          .listen((event) {
        if (event.exists) {
          change(this, status: RxStatus.success());
          update();
        }
      });
    }
  }

  Future<void> recover(String email) async {
    change(this, status: RxStatus.loading());
    String error;

    if (email.isNotEmpty) {
      if (GetUtils.isEmail(email)) {
        try {
          await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
          //update();
        } on FirebaseAuthException catch (e) {
          print("Auth error: $e");
          error = e.message;
        }
      } else {
        error = "Invalid email.";
      }
    } else {
      error = "Email cannot be empty.";
    }
    if (error != null) {
      change(this, status: RxStatus.error(error));
      callSnackbar("Oops!", error);
    } else {
      callSnackbar("Check your email!", "We\'ve sent your instructions.");
      change(this, status: RxStatus.success());
    }
    update();
  }

  Future<void> signIn(String user, String password) async {
    change(this, status: RxStatus.loading());
    String error;
    /*Get.dialog(
        Center(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        barrierDismissible: false);*/
    if (user.isNotEmpty && password.isNotEmpty) {
      try {
        if (!(Platform.isIOS || Platform.isAndroid)) {
          if (rememberMe.value) {
            FirebaseAuth.instance.setPersistence(Persistence.SESSION);
          } else {
            FirebaseAuth.instance.setPersistence(Persistence.NONE);
          }
        }
        _user.value = (await FirebaseAuth.instance
                .signInWithEmailAndPassword(email: user, password: password))
            .user;

        //update();
        //Get.toNamed(rootRoute);
      } on FirebaseAuthException catch (e) {
        print("Auth error: $e");
        if (e.code == 'user-not-found') {
          error = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          error = 'Wrong password provided for that user.';
        } else {
          error = e.message;
        }
      }
    } else {
      if (user.isEmpty) {
        error = "Email cannot be empty.";
      }
      if (user.isEmpty) {
        error = "Password cannot be empty.";
      }
    }
    //Get.back();
    if (error != null) {
      change(this, status: RxStatus.error(error));
      callSnackbar("Oops!", error);
    } else {
      change(this, status: RxStatus.success());
    }
    update();
  }

  Future<void> signOut() async {
    // Show loading widget till we sign out
    /*Get.dialog(
        Center(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        barrierDismissible: false);*/
    change(this, status: RxStatus.loading());
    await _auth.signOut();
    await databaseController.deleteDB();
    await purchaseController.reset();
    //Get.back();
    // Navigate to Login again
    //Get.offAllNamed(authenticationPageRoute);
    change(this, status: RxStatus.success());
    refresh();
  }
}
