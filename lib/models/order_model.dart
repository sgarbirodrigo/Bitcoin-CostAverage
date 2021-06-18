import 'package:bitbybit/models/schedule_model.dart';
import 'package:bitbybit/widgets/weekindicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  bool active;
  double amount;
  Timestamp createdTimestamp;
  Timestamp updatedTimestamp;
  String exchange;
  String pair;
  String documentId;
  Schedule schedule;

  OrderItem(
      {this.active,
      this.amount,
      this.createdTimestamp,
      this.updatedTimestamp,
      this.exchange,
      this.pair,
      this.schedule});

  OrderItem.fromJson(Map<String, dynamic> json) {
    active = json['active'];
    amount = json['amount'];
    createdTimestamp = json['createdTimestamp'];
    updatedTimestamp = json['updatedTimestamp'];
    exchange = json['exchange'];
    pair = json['pair'];
    if(json["schedule"]!=null) {
      schedule = Schedule(
          monday: json['schedule']['monday'] ?? false,
          tuesday: json['schedule']['tuesday'] ?? false,
          wednesday: json['schedule']['wednesday'] ?? false,
          thursday: json['schedule']['thursday'] ?? false,
          friday: json['schedule']['friday'] ?? false,
          saturday: json['schedule']['saturday'] ?? false,
          sunday: json['schedule']['sunday'] ?? false);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['active'] = this.active;
    data['amount'] = this.amount;
    data['createdTimestamp'] = this.createdTimestamp;
    data['updatedTimestamp'] = this.updatedTimestamp;
    data['exchange'] = this.exchange;
    data['pair'] = this.pair;
    data['schedule'] = this.schedule.toJson();
    return data;
  }
}
