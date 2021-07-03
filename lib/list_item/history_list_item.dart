import 'dart:convert';
import 'package:Bit.Me/tools.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../contants.dart';
import '../models/history_model.dart';

class HistoryItemList extends StatefulWidget {
  HistoryItemList({Key key, this.historyItem, this.userUid}) : super(key: key);

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
    String date = DateFormat("EEE, MMM d, yyyy h a")
        .format(widget.historyItem.timestamp.toDate());

    return Container(
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(
          color: Colors.black.withOpacity(0.2),
          width: 0.5,
        ),
      )),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: Container(
          padding: EdgeInsets.only(top: 16, bottom: 16, left: 8, right: 8),
          color: Colors.white,
          child: Row(
            children: [
              success
                  ? Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Bought: ${returnCurrencyCorrectedNumber(widget.historyItem.response.symbol.split("/")[0], widget.historyItem.response.filled)}",
                                  style: TextStyle(
                                      //color: Colors.black.withOpacity(0.6),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400)),
                              Text(
                                  "Price: ${returnCurrencyCorrectedNumber(widget.historyItem.response.symbol.split("/")[1], widget.historyItem.response.average)}",
                                  style: TextStyle(
                                      //color: Colors.black.withOpacity(0.6),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400)),
                              Text(
                                  'Fee: ${returnCurrencyCorrectedNumber(widget.historyItem.response.fee.currency, widget.historyItem.response.fee.cost)}',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400)),
                            ],
                          )
                        ],
                      ),
                    )
                  : Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 16,right: 8),
                        child: Text("${widget.historyItem.error}",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontSize: 16,
                                fontWeight: FontWeight.w400)),
                      ),
                    ),
              Visibility(visible: success,child: Expanded(child: Container())),
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: Container(
                  //width: 110,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
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
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                      Container(
                        height: 8,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: success ? greenAppColor : redAppColor,
                            borderRadius: BorderRadius.all(Radius.circular(4))),
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
      ),
    );
  }
}
