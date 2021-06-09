import 'package:bitbybit/external/binance_api.dart';
import 'package:bitbybit/models/binance_balance_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'order_model.dart';

class HistoryItem {}

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
      querySnapshot.documents.forEach((DocumentSnapshot orderDocumentSnapshot) {
        OrderItem orderItem = OrderItem.fromJson(orderDocumentSnapshot.data);
        orderItem.documentId = orderDocumentSnapshot.documentID;
        orderItems.add(orderItem);
      });
      _calculateUserStats();
      this.onUserDataUpdate(this);
    });
    print("-01");
    getBinanceBalance(this).then((Balance balance) {
      this.balance = balance;
      print("bal: ${balance}");
      this.onUserDataUpdate(this);
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
