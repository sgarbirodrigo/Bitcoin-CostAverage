import 'package:Bit.Me/charts/line_chart_mean.dart';
import 'package:Bit.Me/controllers/auth_controller.dart';
import 'package:Bit.Me/controllers/binance_controller.dart';
import 'package:Bit.Me/controllers/connectivityController.dart';
import 'package:Bit.Me/main_pages/dashboard_widget/chart_widget.dart';
import 'package:Bit.Me/models/history_model.dart';
import 'package:Bit.Me/models/order_model.dart';
import 'package:Bit.Me/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../contants.dart';
import 'database_controller.dart';

class HistoryController extends GetxController with StateMixin{

}

class UserController extends GetxController with StateMixin {
  SharedPreferences preferences;

  var localdatabaseController = Get.find<LocalDatabaseController>();
  var authController = Get.find<AuthController>();
  var binanceController = Get.find<BinanceController>();
  var connectivityController = Get.find<ConnectivityController>();

  var scaleLineChart = Rx<ScaleLineChart>(ScaleLineChart.WEEK1);

  Rx<UserData> _userModel = UserData().obs;

  var pairData_items = Rx<Map<String, PairData>>({});
  var pairAppreciation = {}.obs;

  var isUpdatingHistory = false.obs;
  Rx<String> baseCoin = "".obs;
  var userTotalBuyingAmount = Map<String, double>().obs;
  var userTotalExpendingAmount = Map<String, double>().obs;

  //var balance = Balance().obs;
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
        this.preferences.setString(scale_line_preference, scaleLineChart.toSavingNameString());
        this.forceUpdateHistoryData(scaleLineChart.toNumberValue());
      });
      this.scaleLineChart.value = _loadScale();
    });

    binanceController.tickerPrices.listen((tickerPrices) {
      if (tickerPrices.length > 0) {
        calculateAppreciation();
      }
    });
  }

  /*List<FlSpot> fillPriceSpots() {
    List<FlSpot> price_spots = List();
    int spotsMissing = 0;
    switch (this.scaleLineChart.value) {
      case ScaleLineChart.WEEK1:
        spotsMissing = 7 - _pairData.price_spots.length;
        break;
      case ScaleLineChart.WEEK2:
        spotsMissing = 14 - _pairData.price_spots.length;
        break;
      case ScaleLineChart.MONTH1:
        spotsMissing = 30 - _pairData.price_spots.length;
        break;
      case ScaleLineChart.MONTH6:
        spotsMissing = 180 - _pairData.price_spots.length;
        break;
      case ScaleLineChart.YEAR1:
        spotsMissing = 365 - _pairData.price_spots.length;
        break;
    }

    if (spotsMissing > 0) {
      FlSpot reference = _pairData.price_spots.first;
      Timestamp firstPoint = Timestamp.fromDate(
          DateTime.fromMillisecondsSinceEpoch(reference.x.toInt() * 1000)
              .add(Duration(days: -spotsMissing)));
      price_spots.add(FlSpot(firstPoint.seconds.toDouble(), reference.y));
    }

    price_spots.addAll(_pairData.price_spots);
    return price_spots;
  }*/

  void calculateAppreciation() {
    //todo save last updated price and load everytime from local
    pairData_items.value.forEach((pair, pairData) {
      print("pair: ${pairData.pair} - accumulated: ${pairData.coinAccumulated}");
      this.pairAppreciation[pair] =
          (((binanceController.tickerPrices[pair.replaceAll("/", "")] * pairData.coinAccumulated) /
                      pairData.totalExpended) -
                  1) *
              100;
    });
  }

  ScaleLineChart _loadScale() {
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

        if (documentSnapshot.metadata.isFromCache) {
          callErrorSnackbar("Sorry :\'(", "No internet connection.");
        } else {
          binanceController.loadBalance(this.user.public_key, this.user.private_key);
        }
        pieChartFormattedData.value = convertUserData();
        change(null, status: RxStatus.success());
      } else {
        this._userModel.value = null;
        change(this, status: RxStatus.error("User don\'t exist"));
      }
    });
  }

  void _calculateUserStats() {
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

    String userUid = authController.user.uid;
    List<Map<String, dynamic>> dbQuery = await localdatabaseController.sql_database.database
        .rawQuery('SELECT * FROM History ORDER BY timestamp DESC');

    //print("days: -${daysToConsider} / load history local: ${dbQuery.length}");

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

      //print("lastLoadedTimestamp: ${lastLoadedTimestamp.toDate()}");

      if (lastLoadedTimestamp.toDate().isBefore(DateTime.now().add(Duration(hours: -24)))) {
        if (!connectivityController.isOffline()) {
          await addSnapshotToSQLDB(await firestoreHistoryQuery
              .where('timestamp', isGreaterThan: lastLoadedTimestamp)
              .get());
        } else {
          callErrorSnackbar("Sorry :\'(", "No internet connection.");
        }
      }
    } else {
      if (!connectivityController.isOffline()) {
        await addSnapshotToSQLDB(await firestoreHistoryQuery.get());
      } else {
        callErrorSnackbar("Sorry :\'(", "No internet connection.");
      }
    }

    List<
        Map<String,
            dynamic>> rawQuery = await localdatabaseController.sql_database.database.rawQuery(
        'SELECT * FROM History WHERE timestamp>= ${DateTime.now().add(Duration(days: -daysToConsider)).millisecondsSinceEpoch} ORDER BY timestamp ASC');

    pairData_items.value.clear();

    rawQuery.forEach((element) {
      HistoryItem historyItem = HistoryItem.fromJson(json.decode(element['rawFirestore']));

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

    pairData_items.update((val) {});
  }

/*
  Future<void> loadBalance() async {
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
  }*/

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
