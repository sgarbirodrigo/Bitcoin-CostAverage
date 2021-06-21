import 'dart:collection';
import 'dart:convert';

import 'package:Bit.Me/binanceOrderMaker.dart';
import 'package:Bit.Me/models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactinoResult { SUCCESS, FAILURE }

class HistoryItem {
  OrderItem order;
  BinanceResponseMakeOrder response;
  TransactinoResult result;
  Timestamp timestamp;
  String error;

  HistoryItem(
      {this.order, this.response, this.result, this.timestamp, this.error});

  HistoryItem.fromJson(Map<String, dynamic> data) {
    this.error = data["error"];
    this.timestamp = data["timestamp"];
    this.result = data["result"] == "success"
        ? TransactinoResult.SUCCESS
        : TransactinoResult.FAILURE;

    if(this.result == TransactinoResult.SUCCESS) {
      this.response =
          BinanceResponseMakeOrder.fromJson(json.decode(data["response"]));
    }
    //print("order: ${data["order"]}");
    OrderItem orderItem = OrderItem(
        active: data["order"]["active"],
        amount: double.parse(data["order"]["amount"].toString()),
        createdTimestamp: data["order"]["createdTimestamp"],
        exchange: data["order"]["exchange"],
        pair: data["order"]["pair"]);
    this.order = orderItem;
  }
}
