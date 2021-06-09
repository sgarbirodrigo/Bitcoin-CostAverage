
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  bool active;
  double amount;
  Timestamp createdTimestamp;
  Timestamp updatedTimestamp;
  String exchange;
  String pair;
  String documentId;

  OrderItem(
      {this.active,
        this.amount,
        this.createdTimestamp,
        this.updatedTimestamp,
        this.exchange,
        this.pair});

  OrderItem.fromJson(Map<String, dynamic> json) {
    active = json['active'];
    amount = json['amount'];
    createdTimestamp = json['createdTimestamp'];
    updatedTimestamp = json['updatedTimestamp'];
    exchange = json['exchange'];
    pair = json['pair'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['active'] = this.active;
    data['amount'] = this.amount;
    data['createdTimestamp'] = this.createdTimestamp;
    data['updatedTimestamp'] = this.updatedTimestamp;
    data['exchange'] = this.exchange;
    data['pair'] = this.pair;
    return data;
  }
}