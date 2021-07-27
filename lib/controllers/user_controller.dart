import 'package:Bit.Me/charts/line_chart_mean.dart';
import 'package:Bit.Me/controllers/auth_controller.dart';
import 'package:Bit.Me/controllers/binance_controller.dart';
import 'package:Bit.Me/main_pages/dashboard_widget/chart_widget.dart';
import 'package:Bit.Me/models/binance_balance_model.dart';
import 'package:Bit.Me/models/history_model.dart';
import 'package:Bit.Me/models/order_model.dart';
import 'package:Bit.Me/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../contants.dart';
import 'database_controller.dart';

class UserController extends GetxController with StateMixin {
  SharedPreferences preferences;

  var localdatabaseController = Get.find<LocalDatabaseController>();
  var authController = Get.find<AuthController>();
  var binanceController = Get.find<BinanceController>();

  var scaleLineChart = Rx<ScaleLineChart>(ScaleLineChart.WEEK1);
  var selectedScaleText = "1W".obs;

  Rx<UserData> _userModel = UserData().obs;
  var pairData_items = Rx<Map<String, PairData>>({});
  var pairAppreciation = {}.obs;

  var isUpdatingHistory = false.obs;
  Rx<String> baseCoin = "".obs;
  var userTotalBuyingAmount = Map<String, double>().obs;
  var userTotalExpendingAmount = Map<String, double>().obs;
  var balance = Balance().obs;
  var pieChartFormattedData = {}.obs;

  UserData get user => _userModel.value;

  set user(UserData value) => this._userModel.value = value;

  @override
  void onInit() {
    super.onInit();
    SharedPreferences.getInstance().then((value) {
      this.preferences = value;

      //handling baseCoin preference
      this.baseCoin.value = preferences.getString(base_coin_preference);
      this.baseCoin.listen((String newCoin) {
        this.preferences.setString(base_coin_preference, newCoin);
      });

      //handling scale preference
      this.scaleLineChart.listen((ScaleLineChart scaleLineChart) {
        switch (scaleLineChart) {
          case ScaleLineChart.WEEK1:
            print("1w");
            this.preferences.setString(scale_line_preference, "WEEK1");
            this.forceUpdateHistoryData(7);
            this.selectedScaleText.value = "1W";
            break;
          case ScaleLineChart.WEEK2:
            print("2w");
            this.preferences.setString(scale_line_preference, "WEEK2");
            this.forceUpdateHistoryData(14);
            this.selectedScaleText.value = "2W";
            break;
          case ScaleLineChart.MONTH1:
            print("1M");
            this.preferences.setString(scale_line_preference, "MONTH1");
            this.forceUpdateHistoryData(30);
            this.selectedScaleText.value = "1M";
            break;
          case ScaleLineChart.MONTH6:
            print("6M");
            this.preferences.setString(scale_line_preference, "MONTH6");
            this.forceUpdateHistoryData(180);
            this.selectedScaleText.value = "6M";
            break;
          case ScaleLineChart.YEAR1:
            print("1Y");
            this.preferences.setString(scale_line_preference, "YEAR1");
            this.forceUpdateHistoryData(365);
            this.selectedScaleText.value = "1Y";
            break;
        }
      });
      this.scaleLineChart.value = _getScale();
    });

    binanceController.tickerPrices.listen((tickerPrices) {
      if (tickerPrices.length > 0) {
        calculateAppreciation();
      }
    });
  }

  void calculateAppreciation() {
    pairData_items.value.forEach((pair, pairData) {
      print("pair: ${pairData.pair} - accumulated: ${pairData.coinAccumulated}");
      this.pairAppreciation[pair] =
          (((binanceController.tickerPrices[pair.replaceAll("/", "")] * pairData.coinAccumulated) /
                      pairData.totalExpended) -
                  1) *
              100;
    });
  }

  ScaleLineChart _getScale() {
    ScaleLineChart scale = ScaleLineChart.WEEK1;
    switch (this.preferences.getString(scale_line_preference)) {
      case "WEEK1":
        scale = ScaleLineChart.WEEK1;
        break;
      case "WEEK2":
        scale = ScaleLineChart.WEEK2;
        break;
      case "MONTH1":
        scale = ScaleLineChart.MONTH1;
        break;
      case "MONTH6":
        scale = ScaleLineChart.MONTH6;
        break;
      case "YEAR1":
        scale = ScaleLineChart.YEAR1;
        break;
    }
    return scale;
  }


  void loadUserData(String userId) async {
    change(null, status: RxStatus.loading());
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        this._userModel.value = UserData.fromJson(documentSnapshot.data());
        _calculateUserStats();
        loadBalance();
        pieChartFormattedData.value = convertUserData();
        change(null, status: RxStatus.success());
      } else {
        this._userModel.value = null;
        change(this, status: RxStatus.error("User don\'t exist"));
      }
    });
  }

  void _calculateUserStats() {
    //reset all data before reload
    Map<String, double> temporaryBuying = Map();
    Map<String, double> temporaryExpending = Map();
    temporaryBuying.keys.forEach((key) {
      temporaryBuying[key] = 0;
      temporaryExpending[key.split("/")[1]] = 0;
    });
    if (this._userModel.value != null) {
      this._userModel.value.orders.forEach((String pair, OrderItem element) {
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
          if (temporaryBuying[element.pair] != null) {
            temporaryBuying[element.pair] += amount * multiplier;
          } else {
            temporaryBuying[element.pair] = amount * multiplier;
          }
          if (temporaryExpending[element.pair.split("/")[1]] != null) {
            temporaryExpending[element.pair.split("/")[1]] +=
                double.parse((amount * multiplier).toStringAsFixed(6));
          } else {
            temporaryExpending[element.pair.split("/")[1]] =
                double.parse((amount * multiplier).toStringAsFixed(6));
          }
        }
      });
    }

    temporaryBuying = _deleteEmptyMapItemList(temporaryBuying);
    temporaryExpending = _deleteEmptyMapItemList(temporaryExpending);
    //{XRP/BTC: 0.00030000000000000003, UNI/BTC: 0.0004, BTC/BRL: 490, IOTA/BTC: 0.00030000000000000003, ADA/BRL: 40, BNB/BRL: 30, NANO/BTC: 0.0004}
    userTotalBuyingAmount.value = temporaryBuying;
    //{BTC: 0.0014, BRL: 560}
    userTotalExpendingAmount.value = temporaryExpending;
    baseCoin.value = userTotalExpendingAmount.keys.first;
  }

  Map<String, double> _deleteEmptyMapItemList(Map<String, double> list) {
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

  void forceUpdateHistoryData(int daysToConsider) async {
    this.isUpdatingHistory.value = true;
    /*try {*/
      String userUid = authController.user.uid;
      List<Map<String, dynamic>> dbQuery = await localdatabaseController.sql_database.database
          .rawQuery('SELECT * FROM History ORDER BY timestamp DESC');

      //print("load history for: ${userUid}");

      Query firestoreHistoryQuery = FirebaseFirestore.instance
          .collection("users")
          .doc(userUid)
          .collection("history")
          .orderBy("timestamp", descending: false);

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
        if (lastLoadedTimestamp.toDate().isBefore(DateTime.now().add(Duration(hours: -24)))) {
          addSnapshotToSQLDB(await firestoreHistoryQuery
              .where('timestamp', isGreaterThan: lastLoadedTimestamp)
              .get());
        }
      } else {
        addSnapshotToSQLDB(await firestoreHistoryQuery.get());
      }

      List<
          Map<String,
              dynamic>> rawQuery = await localdatabaseController.sql_database.database.rawQuery(
          'SELECT * FROM History WHERE timestamp>= ${DateTime.now().add(Duration(days: -daysToConsider)).millisecondsSinceEpoch}');

      //historyItems.clear();
      pairData_items.value.clear();
      rawQuery.forEach((element) {
        HistoryItem historyItem = HistoryItem.fromJson(json.decode(element['rawFirestore']));
        //historyItems.add(historyItem);
        if (pairData_items.value[historyItem.order.pair] == null) {
          pairData_items.value[historyItem.order.pair] = PairData().addHistoryItem(historyItem);
        } else {
          pairData_items.value[historyItem.order.pair] =
              pairData_items.value[historyItem.order.pair].addHistoryItem(historyItem);
        }
      });
      if (binanceController.tickerPrices.length > 0) {
        calculateAppreciation();
      }
    /*} catch (e) {
      print("error on load history: ${e.toString()}");
    }*/
    this.isUpdatingHistory.value = false;
  }

  Future<Balance> loadBalance() async {
    if (this.user.private_key != null && this.user.public_key != null) {
      int timeStamp = DateTime.now().millisecondsSinceEpoch;
      Map<String, dynamic> parameters = Map();
      parameters["recvWindow"] = "5000";
      parameters["timestamp"] = timeStamp.toString();
      String queryParams = 'recvWindow=5000&timestamp=' + timeStamp.toString();
      List<int> messageBytes = utf8.encode(queryParams);
      List<int> key = utf8.encode(this.user.private_key);
      Hmac hmac = new Hmac(sha256, key);
      Digest digest = hmac.convert(messageBytes);
      String signature = digest.toString();
      parameters["signature"] = signature;
      Uri url = Uri.https("api.binance.com", "api/v3/account", parameters);
      http.Response response = await http.get(url, headers: {"X-MBX-APIKEY": this.user.public_key});
      if (response.statusCode >= 200 && response.statusCode < 300) {
        this.balance.value = Balance.fromJson(jsonDecode(response.body));
      } else {
        this.balance.value = null;
      }
    } else {
      this.balance.value = null;
    }
  }

/*
  Future<void> loadPrices() async {
    final response = await http.get(Uri.https("api.binance.com", "api/v3/ticker/price"));
    if (response.statusCode == 200) {
      Map<String, double> entry = Map();
      (jsonDecode(response.body) as List<dynamic>).forEach((element) {
        entry[element["symbol"]] = double.parse(element["price"].toString());
      });
      tickerPrices.value = entry;

    } else {
      tickerPrices.value = null;
      print("response binance: ${response.body}");
    }
  }*/

  void refreshUserData() {
    loadUserData(this.user.uid);
  }

  Map<String, List<MyChartSectionData>> convertUserData() {
    try {
      Map<String, List<MyChartSectionData>> chartFullData = Map();
      Map<String, double> total = {};
      this.userTotalBuyingAmount.forEach((pair, amount) {
        double price = binanceController.tickerPrices["BTC${pair.split("/")[1]}"];
        double percentage;
        if (price == null) {
          percentage = amount;
        } else {
          percentage = amount / price;
        }
        if (total[pair.split("/")[1]] == null) {
          total[pair.split("/")[1]] = 0;
        } else {
          total[pair.split("/")[1]] += percentage;
        }
      });
      //print("total ${total}");
      this.userTotalBuyingAmount.forEach((pair, amount) {
        double price = binanceController.tickerPrices["BTC${pair.split("/")[1]}"];
        double percentage = 1;
        if (price == null) {
          percentage = amount;
        } else {
          percentage = amount / price;
        }
        if (amount >= 0) {
          /*print(
              "pair: $pair - percentage: ${percentage / total[pair.split("/")[1]]} - amount: ${amount}");*/
          if (chartFullData[pair.split("/")[1]] == null) {
            chartFullData[pair.split("/")[1]] = List<MyChartSectionData>();
          }
          chartFullData[pair.split("/")[1]]
              .add(MyChartSectionData(pair, percentage / total[pair.split("/")[1]], amount));
        }
      });
      return chartFullData;
    } catch (e) {
      print("converting error: $e");
      return Map<String, List<MyChartSectionData>>();
    }
  }
}
