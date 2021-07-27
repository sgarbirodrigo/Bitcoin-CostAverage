import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../sql_database.dart';

class LocalDatabaseController extends GetxController with StateMixin {
  final SqlDatabase sql_database = SqlDatabase();

  final Function onLoad;
  LocalDatabaseController({this.onLoad});

  @override
  void onInit() {
    super.onInit();
    load();
  }

  void load() async {
    change(this, status: RxStatus.loading());
    try {
      await sql_database.initDB();
      this.onLoad();
      //change(this, status: RxStatus.loading());
    } catch (e) {
      change(this, status: RxStatus.error(e.toString()));
    }
    change(this, status: RxStatus.success());
  }

  @override
  void onReady() {}

  @override
  void onClose() {}

 Future<void> deleteDB() async {
    change(this, status: RxStatus.loading());
    try {
      await sql_database.deleteDB();
      change(this, status: RxStatus.loading());
    } catch (e) {
      change(this, status: RxStatus.error(e.toString()));
    }
    change(this, status: RxStatus.success());
  }
}
