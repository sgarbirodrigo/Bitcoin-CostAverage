import 'dart:convert';
import 'package:Bit.Me/binanceOrderMaker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import 'models/history_model.dart';

class HistoryItemList extends StatefulWidget {
  HistoryItemList({Key key, this.historyItem, this.userUid})
      : super(key: key);

  final HistoryItem historyItem;
  final String userUid;

  @override
  _HistoryItemListState createState() => _HistoryItemListState();
}

class _HistoryItemListState extends State<HistoryItemList> {
  @override
  Widget build(BuildContext context) {
    //bool active = widget.querySnapshotData.data["active"];
    bool success = widget.historyItem.result == TransactinoResult.SUCCESS;
    String date = DateFormat("EEE, MMM d, yyyy h a").format(widget.historyItem.timestamp.toDate());

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
                      widget.historyItem.order.pair,
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
                                  "Price: ${double.parse(widget.historyItem.response.price.toStringAsFixed(8))} ${widget.historyItem.response.symbol.split("/")[1]}",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400)),
                              Text(
                                  "Bought ${widget.historyItem.response.filled} ${widget.historyItem.response.symbol.split("/")[0]}",
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
                            color: success ? Color(0xff69A67C) : Color(0xffA96B6B),
                            borderRadius:
                                BorderRadius.all(Radius.circular(4))),
                        padding: EdgeInsets.only(
                            left: 8, right: 8, top: 2, bottom: 2),
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
                          Text('${widget.historyItem.response}'),
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
