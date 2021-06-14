import 'dart:convert';

import 'package:bitbybit/CreateOrderDialog.dart';
import 'package:bitbybit/binanceOrderMaker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HistoryItemList extends StatefulWidget {
  HistoryItemList({Key key, this.querySnapshotData, this.userUid})
      : super(key: key);

  final DocumentSnapshot querySnapshotData;
  final String userUid;

  @override
  _HistoryItemListState createState() => _HistoryItemListState();
}

class _HistoryItemListState extends State<HistoryItemList> {
  @override
  Widget build(BuildContext context) {
    //bool active = widget.querySnapshotData.data["active"];
    bool success = widget.querySnapshotData.data["result"] == "success";
    BinanceResponseMakeOrder binanceResponse;
    if(success) {
      binanceResponse =
      BinanceResponseMakeOrder.fromJson(
          json.decode(widget.querySnapshotData.data["response"]));
    }
    String date;
    if(widget.querySnapshotData.data["timestamp"]  !=null){
      date = DateTime.fromMillisecondsSinceEpoch((widget.querySnapshotData.data["timestamp"] as Timestamp).millisecondsSinceEpoch).toLocal().toString().substring(0,16).replaceAll("-", "/");
    }else{
      date = Timestamp.now().toDate().toLocal().toString().substring(0,16).replaceAll("-", "/");
    }

    return Container(
      decoration: BoxDecoration(
          border: Border(
            top: BorderSide( //                    <--- top side
              color: Colors.black.withOpacity(0.2),
              width: 0.5,
            ),
          )
      ),
      height: 96,
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: Container(
          color: Colors.white,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.querySnapshotData.data["order"]["pair"],
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                    ),
                    success
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Price: ${double.parse(binanceResponse.price.toStringAsFixed(8))} ${binanceResponse.symbol.split("/")[1]}",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400)),
                              Text(
                                  "Bought ${binanceResponse.filled} ${binanceResponse.symbol.split("/")[0]}",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400))
                            ],
                          )
                        : Text("Swipe left for more details",
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontSize: 16,
                                fontWeight: FontWeight.w400))
                  ],
                ),
              ),
              Expanded(child: Container()),
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: Container(
                  //width: 110,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /*Text(
                        "${success ? "+" : ""}${binanceResponse.filled} ${binanceResponse.symbol.split("/")[0]}",
                        style: TextStyle(
                            fontSize: 14,
                            color: success ? Colors.green : Colors.black),
                      ),*/
                      /*Container(
                        height: 4,
                      ),*/
                      Text(
                        "${date}",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black),
                      ),
                      Container(
                        height: 8,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: success ? Colors.green : Colors.red,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        padding: EdgeInsets.only(
                            left: 8, right: 8, top: 4, bottom: 4),
                        child: Text(
                          success ? "Success" : "Failure",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),



                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        secondaryActions: [
          IconSlideAction(
            caption: 'Details',
            color: Colors.blue,
            icon: Icons.details_sharp,
            onTap: () {
              showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Binance Response:'),
                    content: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Text('${widget.querySnapshotData.data["response"]}'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Close'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
