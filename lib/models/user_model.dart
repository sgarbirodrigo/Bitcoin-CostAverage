import 'dart:collection';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:Bit.Me/sql_database.dart';
import 'package:path/path.dart';
import 'package:Bit.Me/external/binance_api.dart';
import 'package:Bit.Me/external/firestoreService.dart';
import 'package:Bit.Me/models/binance_balance_model.dart';
import 'package:Bit.Me/models/settings_model.dart';
import 'package:Bit.Me/tools.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sqflite/sqflite.dart';
import '../charts/line_chart_mean.dart';
import 'history_model.dart';
import 'order_model.dart';

class UserData {
  String email;
  Timestamp lastUpdateTimestamp;
  String public_key;
  String private_key;
  bool active;
  String uid;
  bool hasIntroduced;
  bool hasConnected;
  bool hasRunFirstWizzardOrder;
  Map<String, OrderItem> orders;

  UserData();

  UserData.fromJson(Map<String, dynamic> jsonx) {
    email = jsonx['email'];
    hasIntroduced = jsonx['hasIntroduced'] ?? false;
    hasConnected = jsonx['hasConnected'] ?? false;

    hasRunFirstWizzardOrder = jsonx['hasRunFirstWizzardOrder'] ?? false;
    lastUpdateTimestamp = jsonx['lastUpdateTimestamp'];
    active = jsonx['active'];
    public_key = jsonx['public_key'];
    private_key = jsonx['private_key'];
    if (public_key != null && private_key != null) {
      if (public_key.isNotEmpty && private_key.isNotEmpty) {
        hasConnected = true;
      }
    }
    uid = jsonx['uid'];
    orders = new Map();
    if (jsonx['orders'] != null) {
      (jsonx['orders'] as Map).forEach((key, value) {
        orders[key] = OrderItem.fromJson(Map<String, dynamic>.from(value));
      });
    }
  }
}

class PairData {
  String pair;
  double max;
  double min;
  List<HistoryItem> historyItems = List();
  double percentage_variation = 0;
  double coinAccumulated = 0;
  double avgPrice = 0;
  Timestamp firstTimestamp;
  Timestamp lastTimestamp;
  double totalExpended = 0;
  List<FlSpot> price_spots = List();
  List<FlSpot> avg_price_spots = List();
  bool isLoaded = false;

  PairData addHistoryItem(HistoryItem historyItem) {
    this.historyItems.add(historyItem);
    if (this.pair == null) {
      this.pair = historyItem.order.pair;
    }
    if (historyItem.result == TransactinoResult.SUCCESS) {
      if (this.max != null) {
        if (this.max < historyItem.response.price) {
          this.max = historyItem.response.price;
        }
      } else {
        this.max = historyItem.response.price;
      }
      if (this.min != null) {
        if (this.min > historyItem.response.price) {
          this.min = historyItem.response.price;
        }
      } else {
        this.min = historyItem.response.price;
      }

      coinAccumulated += historyItem.response.filled;
      totalExpended += historyItem.response.filled * historyItem.response.price;
      avgPrice = totalExpended / coinAccumulated;
      //avgPrice =null;
      price_spots
          .add(FlSpot((historyItem.timestamp.seconds).toDouble(), historyItem.response.price));
      avg_price_spots.add(FlSpot((historyItem.timestamp.seconds).toDouble(), avgPrice));
      percentage_variation = getValueVariation(historyItem.response.price, avgPrice);
      isLoaded = true;
    } else {
      isLoaded = false;
    }
    return this;
  }
}

class UserManager {
  final User firebaseUser;
  UserData userData;

  /*List<OrderItem> orderItems = List();*/
  List<HistoryItem> historyItems = List();
  Map<String, double> userTotalBuyingAmount = Map();
  Map<String, double> userTotalExpendingAmount = Map();
  Function(UserManager user) onUserDataUpdate;
  Balance balance;
  Map<String, PairData> pairDataItems = Map();
  SettingsApp settings;
  bool isUpdatingHistory = false;
  SqlDatabase sqlDatabase;

  UserManager(this.sqlDatabase, this.firebaseUser, this.settings, this.onUserDataUpdate) {
    updateUser();
    switch (this.settings.scaleLineChart) {
      case ScaleLineChart.WEEK1:
        forceUpdateHistoryData(7);
        break;
      case ScaleLineChart.WEEK2:
        forceUpdateHistoryData(14);
        break;
      case ScaleLineChart.MONTH1:
        forceUpdateHistoryData(30);
        break;
      case ScaleLineChart.MONTH6:
        forceUpdateHistoryData(180);
        break;
      case ScaleLineChart.YEAR1:
        forceUpdateHistoryData(365);
        break;
    }
  }

  void updateUser() {
    FirestoreDB.getUserData(this.firebaseUser.uid).then((UserData userdata) {
      this.userData = userdata;
      _calculateUserStats();
      this.onUserDataUpdate(this);
      getBinanceBalance(this).then((Balance balance) {
        this.balance = balance;
        this.onUserDataUpdate(this);
      });
    });
  }

  void forceUpdateHistoryData(int daysToConsider) async {
    List<Map<String, dynamic>> db_query =
        await this.sqlDatabase.database.rawQuery('SELECT * FROM History ORDER BY timestamp DESC');

    Query firestoreHistoryQuery = FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser.uid)
        .collection("history")
        .orderBy("timestamp", descending: false);

    void addSnapshotToSQLDB(QuerySnapshot historySnapshots) async {
      historySnapshots.docs.forEach((element) async {
        HistoryItem historyItem = HistoryItem.fromJson(element.data());
        await this.sqlDatabase.database.insert('history', {
          'id': element.id,
          'timestamp': historyItem.timestamp.millisecondsSinceEpoch,
          'amount': historyItem.order.amount,
          'pair': historyItem.order.pair,
          'result': historyItem.result.index,
          'rawFirestore': json.encode(historyItem.toJson()),
        },conflictAlgorithm: ConflictAlgorithm.replace);
      });
    }

    if (db_query.length > 0) {
      Timestamp last_loaded_timestamp =
          Timestamp.fromMillisecondsSinceEpoch(db_query.first['timestamp']);
      if (last_loaded_timestamp.toDate().isBefore(DateTime.now().add(Duration(hours: -24)))) {
        addSnapshotToSQLDB(await firestoreHistoryQuery
            .where('timestamp', isGreaterThan: last_loaded_timestamp)
            .get());
      }
    } else {
      addSnapshotToSQLDB(await firestoreHistoryQuery.get());
    }

    List<Map<String, dynamic>> rawQuery = await this.sqlDatabase.database.rawQuery(
        'SELECT * FROM History WHERE timestamp>= ${DateTime.now().add(Duration(days: -daysToConsider)).millisecondsSinceEpoch}');
    historyItems.clear();
    pairDataItems.clear();
    rawQuery.forEach((element) {
      HistoryItem historyItem = HistoryItem.fromJson(json.decode(element['rawFirestore']));
      historyItems.add(historyItem);
      if (pairDataItems[historyItem.order.pair] == null) {
        pairDataItems[historyItem.order.pair] = PairData().addHistoryItem(historyItem);
      } else {
        pairDataItems[historyItem.order.pair] =
            pairDataItems[historyItem.order.pair].addHistoryItem(historyItem);
      }
    });

    this.isUpdatingHistory = false;
    this.onUserDataUpdate(this);
  }

/*

  void forceUpdateHistoryData2(int daysToConsider) {
    this.isUpdatingHistory = true;
    this.onUserDataUpdate(this);
    Firestore.instance
        .collection("users")
        .doc(firebaseUser.uid)
        .collection("history")
        .orderBy("timestamp", descending: false)
        .where(
          'timestamp',
          isGreaterThan: Timestamp.fromDate(
            DateTime.now().add(
              Duration(days: -daysToConsider),
            ),
          ),
        )
        .getDocuments()
        .then((QuerySnapshot value) {
      historyItems.clear();
      pairDataItems.clear();
      if (value.documents.length > 0) {
        value.documents.forEach((DocumentSnapshot element) {
          HistoryItem historyItem = HistoryItem.fromJson(element.data);
          historyItems.add(historyItem);

          if (pairDataItems[historyItem.order.pair] == null) {
            pairDataItems[historyItem.order.pair] =
                PairData().addHistoryItem(historyItem);
          } else {
            pairDataItems[historyItem.order.pair] =
                pairDataItems[historyItem.order.pair]
                    .addHistoryItem(historyItem);
          }
        });
      }
      this.isUpdatingHistory = false;
      this.onUserDataUpdate(this);
    });
  }
*/

  void _calculateUserStats() {
    //reset all data before reload
    userTotalBuyingAmount.keys.forEach((key) {
      userTotalBuyingAmount[key] = 0;
      userTotalExpendingAmount[key.split("/")[1]] = 0;
    });

    if (this.userData != null) {
      this.userData.orders.forEach((String pair, OrderItem element) {
        double amount = double.parse(element.amount.toString());
        if (element.active) {
          int multiplier = 0;
          if (element.schedule != null) {
            if (element.schedule.monday) {
              multiplier++;
            }
            if (element.schedule.tuesday) {
              multiplier++;
            }
            if (element.schedule.wednesday) {
              multiplier++;
            }
            if (element.schedule.thursday) {
              multiplier++;
            }
            if (element.schedule.friday) {
              multiplier++;
            }
            if (element.schedule.saturday) {
              multiplier++;
            }
            if (element.schedule.sunday) {
              multiplier++;
            }
          } else {
            multiplier = 0;
          }
          if (userTotalBuyingAmount[element.pair] != null) {
            userTotalBuyingAmount[element.pair] += amount * multiplier;
          } else {
            userTotalBuyingAmount[element.pair] = amount * multiplier;
          }
          if (userTotalExpendingAmount[element.pair.split("/")[1]] != null) {
            userTotalExpendingAmount[element.pair.split("/")[1]] +=
                double.parse((amount * multiplier).toStringAsFixed(6));
          } else {
            userTotalExpendingAmount[element.pair.split("/")[1]] =
                double.parse((amount * multiplier).toStringAsFixed(6));
          }
          //print("totalbuying: ${userTotalBuyingAmount}");
        }
      });
    }

    userTotalBuyingAmount = deleteEmptyMapItemList(userTotalBuyingAmount);
    userTotalExpendingAmount = deleteEmptyMapItemList(userTotalExpendingAmount);
  }

  Map<String, double> deleteEmptyMapItemList(Map<String, double> list) {
    List<String> deleteKeyList = List();
    list.forEach((key, value) {
      if (value == 0) {
        deleteKeyList.add(key);
      }
    });
    deleteKeyList.forEach((key) {
      list.remove(key);
    });
    return list;
  }
}
