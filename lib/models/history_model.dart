import 'dart:collection';
import 'dart:convert';

import 'package:bitcoin_cost_average/external/binanceOrderMaker.dart';
import 'package:bitcoin_cost_average/models/order_model.dart';
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
    this.timestamp = data["timestamp"] is int
        ? Timestamp.fromMillisecondsSinceEpoch(data["timestamp"])
        : data["timestamp"];
    this.result = data["result"] == "success"
        ? TransactinoResult.SUCCESS
        : TransactinoResult.FAILURE;

    if (this.result == TransactinoResult.SUCCESS) {
      //print("0- resp: ${data["response"]}");
      Map<String, dynamic> response = data["response"] is String
          ? json.decode(data["response"])
          : data["response"];
      //print("1- resp: ${response}");
      this.response = BinanceResponseMakeOrder.fromJson(response);
    }
    //print("data $data");
    //print("order: ${data["order"]}");
    OrderItem orderItem = OrderItem(
        active: data["order"]["active"],
        amount: double.parse(data["order"]["amount"].toString()),
        createdTimestamp: data["order"]["createdTimestamp"] is int
            ? Timestamp.fromMillisecondsSinceEpoch(
                data["order"]["createdTimestamp"])
            : data["order"]["createdTimestamp"],
        exchange: data["order"]["exchange"],
        pair: data["order"]["pair"]);
    this.order = orderItem;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["error"] = this.error;
    data["timestamp"] = this.timestamp.millisecondsSinceEpoch;
    data["result"] =
        this.result == TransactinoResult.SUCCESS ? "success" : "failure";
    data["response"] = this.response != null ? this.response.toJson() : null;
    data["order"] = this.order.toJson();
    return data;
  }
}
