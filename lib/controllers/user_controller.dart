import 'package:Bit.Me/main_pages/dashboard_widget/chart_widget.dart';
import 'package:Bit.Me/models/binance_balance_model.dart';
import 'package:Bit.Me/models/order_model.dart';
import 'package:Bit.Me/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:get/get.dart';


class UserController extends GetxController {
  Rx<UserData> _userModel = UserData().obs;

  UserData get user => _userModel.value;

  set user(UserData value) => this._userModel.value = value;

  void clear() {
    _userModel.value = UserData();
  }

  Rx<String> baseCoin = "".obs;
  var userTotalBuyingAmount = Map<String, double>().obs;
  var userTotalExpendingAmount = Map<String, double>().obs;
  var balance = Balance().obs;
  var tickerPrices = Map<String, double>().obs;
  var pieChartFormattedData = {}.obs;

  void loadUserData(String userId) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        this._userModel.value = UserData.fromJson(documentSnapshot.data());
        _calculateUserStats();
        loadPrices();
        pieChartFormattedData.value = convertUserData();
      } else {
        this._userModel.value = null;
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

  Future<Balance> loadBalance() async {
    print("load Balance start");
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

  Future<void> loadPrices() async {
    final response = await http.get(Uri.https("api.binance.com", "api/v3/ticker/price"));
    if (response.statusCode == 200) {
      Map<String, double> entry = Map();
      (jsonDecode(response.body) as List<dynamic>).forEach((element) {
        entry[element["symbol"]] = double.parse(element["price"].toString());
      });
      tickerPrices.value = entry;
    } else {
      throw Exception('Failed to load pairs');
    }
  }

  Map<String, List<MyChartSectionData>> convertUserData() {
    try {
      Map<String, List<MyChartSectionData>> chartFullData = Map();
      Map<String, double> total = {};
      this.userTotalBuyingAmount.forEach((pair, amount) {
        double price = tickerPrices["BTC${pair.split("/")[1]}"];
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
        double price = tickerPrices["BTC${pair.split("/")[1]}"];
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
