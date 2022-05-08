import 'dart:convert';

import 'package:bitcoin_cost_average/controllers/auth_controller.dart';
import 'package:bitcoin_cost_average/controllers/binance_controller.dart';
import 'package:bitcoin_cost_average/controllers/connectivityController.dart';
import 'package:bitcoin_cost_average/controllers/database_controller.dart';
import 'package:bitcoin_cost_average/models/history_model.dart';
import 'package:bitcoin_cost_average/models/user_model.dart';
import 'package:bitcoin_cost_average/tools.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import '../contants.dart';

class HistoryController extends GetxController with StateMixin {
  var localdatabaseController = Get.find<LocalDatabaseController>();
  var authController = Get.find<AuthController>();
  var connectivityController = Get.find<ConnectivityController>();
  var binanceController = Get.find<BinanceController>();

  var pairData_items = Rx<Map<String, PairData>>({});
  var history_items = [].obs;
  var pairAppreciation = {}.obs;
  var pairAppreciationString = {}.obs;

  Query getHistoryQuery(String userUid) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userUid)
        .collection("history")
        .orderBy("timestamp", descending: false);
  }

  void forceUpdateHistoryData(int daysToConsider) async {
    change(null, status: RxStatus.loading());

    List<Map<String, dynamic>> dbQuery = await localdatabaseController.sql_database.database
        .rawQuery('SELECT * FROM History ORDER BY timestamp DESC');

    void addSnapshotToSQLDB(QuerySnapshot historySnapshots) async {
      historySnapshots.docs.forEach(
        (element) async {
          HistoryItem historyItem = HistoryItem.fromJson(element.data());
          await localdatabaseController.sql_database.database.insert(
              'history',
              {
                'id': element.id,
                'timestamp': historyItem.timestamp.millisecondsSinceEpoch,
                'amount': historyItem.order.amount,
                'pair': historyItem.order.pair,
                'result': historyItem.result.index,
                'rawFirestore': json.encode(historyItem.toJson()),
              },
              conflictAlgorithm: ConflictAlgorithm.replace);
        },
      );
    }

    if (dbQuery.length > 0) {
      Timestamp lastLoadedTimestamp =
          Timestamp.fromMillisecondsSinceEpoch(dbQuery.first['timestamp']);

      //print("lastLoadedTimestamp: ${lastLoadedTimestamp.toDate()}");

      if (lastLoadedTimestamp.toDate().isBefore(DateTime.now().add(Duration(hours: -24)))) {
        if (!connectivityController.isOffline()) {
          if (authController.isUserLogged())
            addSnapshotToSQLDB(await getHistoryQuery(authController.user.uid)
                .where('timestamp', isGreaterThan: lastLoadedTimestamp)
                .get());
        } else {
          callErrorSnackbar("Sorry :\'(", "No internet connection.");
        }
      }
    } else {
      if (!connectivityController.isOffline()) {
        if (authController.isUserLogged())
          addSnapshotToSQLDB(await getHistoryQuery(authController.user.uid).get());
      } else {
        callErrorSnackbar("sorry".tr,"no_connection".tr);
      }
    }

    List<
        Map<String,
            dynamic>> rawQuery = await localdatabaseController.sql_database.database.rawQuery(
        'SELECT * FROM History WHERE timestamp>= ${DateTime.now().add(Duration(days: -daysToConsider)).millisecondsSinceEpoch} ORDER BY timestamp ASC');

    pairData_items.value.clear();
    history_items.clear();
    List temporaryHistory = [];
    Map<String, PairData> temporaryPairData = {};

    rawQuery.forEach((element) {
      HistoryItem historyItem = HistoryItem.fromJson(json.decode(element['rawFirestore']));
      temporaryHistory.add(historyItem);
      if (temporaryPairData[historyItem.order.pair] == null) {
        temporaryPairData[historyItem.order.pair] = PairData().addHistoryItem(historyItem);
      } else {
        temporaryPairData[historyItem.order.pair] =
            temporaryPairData[historyItem.order.pair].addHistoryItem(historyItem);
      }
    });

    pairData_items.value.addAll(temporaryPairData);
    history_items.addAll(temporaryHistory.reversed);

    if (binanceController.tickerPrices.length > 0) {
      calculateAppreciation();
    }

    change(null, status: RxStatus.success());

    pairData_items.update((val) {});
  }

  @override
  void onInit() {
    super.onInit();
    binanceController.tickerPrices.listen((tickerPrices) {
      if (tickerPrices.length > 0) {
        calculateAppreciation();
      }
    });
  }

  void calculateAppreciation() {
    //todo save last updated price and load everytime from local
    this.pairAppreciationString.clear();
    pairData_items.value.forEach((pair, pairData) {
      //print("pair: ${pairData.pair} - accumulated: ${pairData.coinAccumulated}");
      this.pairAppreciation[pair] =
          (((binanceController.tickerPrices[pair.replaceAll("/", "")] * pairData.coinAccumulated) /
                      pairData.totalExpended) -
                  1) *
              100;

      this.pairAppreciationString[pair] = getAppreciationConverted(this.pairAppreciation[pair]);
    });
  }
}
