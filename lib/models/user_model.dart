import 'dart:convert';

import 'package:bitbybit/external/binance_api.dart';
import 'package:bitbybit/models/binance_balance_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'history_model.dart';
import 'order_model.dart';

class UserData {
  String email;
  Timestamp lastUpdateTime;
  String public_key;
  String private_key;
  String uid;

  UserData.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    lastUpdateTime = json['lastUpdateTime'];
    public_key = json['public_key'];
    private_key = json['private_key'];
    uid = json['uid'];
  }
}

class User {
  final FirebaseUser firebasUser;
  List<OrderItem> orderItems = List();
  List<HistoryItem> historyItems = List();
  Map<String, double> userTotalBuyingAmount = Map();
  Map<String, double> userTotalExpendingAmount = Map();
  Function(User user) onUserDataUpdate;
  Balance balance;

  User(this.firebasUser, this.onUserDataUpdate) {
    Firestore.instance
        .collection("users")
        .document(firebasUser.uid)
        .collection("orders")
        .orderBy("active", descending: true)
        .snapshots()
        .listen((QuerySnapshot querySnapshot) {
      orderItems.clear();
      querySnapshot.documents.forEach((DocumentSnapshot orderDocumentSnapshot) {
        OrderItem orderItem = OrderItem.fromJson(orderDocumentSnapshot.data);
        orderItem.documentId = orderDocumentSnapshot.documentID;
        orderItems.add(orderItem);
      });
      _calculateUserStats();
      this.onUserDataUpdate(this);
    });
    getBinanceBalance(this).then((Balance balance) {
      this.balance = balance;
      this.onUserDataUpdate(this);
    });
    Firestore.instance
        .collection("users")
        .document(firebasUser.uid)
        .collection("history")
        .orderBy("timestamp", descending: false)
        //.startAt([Timestamp.fromDate(DateTime.now().add(Duration(days: -30)))])
        .getDocuments()
        .then((QuerySnapshot value) {
      if (value.documents.length > 0) {
        value.documents.forEach((DocumentSnapshot element) {
          if (element.data["result"] == "success") {
            /*BinanceResponseMakeOrder binanceResponse =
            BinanceResponseMakeOrder.fromJson(
                json.decode(element.data["response"]));
            */
            historyItems.add(HistoryItem.fromJson(element.data));
            //rint("HIstory: ${historyItem}");
            /*data.add(FlSpot(binanceResponse.timestamp.toDouble(),
                double.parse(binanceResponse.info.price)));*/
          }
        });
        print(
            "loaded:${value.documents.length} / saved:${historyItems.length}");
        this.onUserDataUpdate(this);
      }
    });
    }

  Future<UserData> getDocumentData() async {
    DocumentSnapshot documentSnapshot = await Firestore.instance
        .collection("users")
        .document(this.firebasUser.uid)
        .get();

    if (documentSnapshot.exists) {
      return UserData.fromJson(documentSnapshot.data);
    } else {
      return null;
    }
  }

  void _calculateUserStats() {
    orderItems.forEach((OrderItem element) {
      double amount = double.parse(element.amount.toString());
      if (element.active) {
        if (userTotalBuyingAmount[element.pair] != null) {
          userTotalBuyingAmount[element.pair] += amount;
        } else {
          userTotalBuyingAmount[element.pair] = amount;
        }
        if (userTotalExpendingAmount[element.pair.split("/")[1]] != null) {
          userTotalExpendingAmount[element.pair.split("/")[1]] +=
              double.parse(amount.toStringAsFixed(6));
        } else {
          userTotalExpendingAmount[element.pair.split("/")[1]] =
              double.parse(amount.toStringAsFixed(6));
        }
      }
    });
  }
}
