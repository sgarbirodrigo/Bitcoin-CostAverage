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

class HistoryItemListv2 extends StatelessWidget {
  final HistoryItem historyItem;
  final String userUid;
  bool success;

  HistoryItemListv2({Key key, this.historyItem, this.userUid}) {
    success = historyItem.result == TransactinoResult.SUCCESS;
  }

  @override
  Widget build(BuildContext context) {
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
              Container(
                padding: EdgeInsets.only(left: 8),
                child: Column(
                  children: [
                    Text(DateFormat("EEEE").format(historyItem.timestamp.toDate()),
                        style: TextStyle(
                            //color: Colors.black.withOpacity(0.6),
                            fontSize: 14,
                            fontWeight: FontWeight.w400)),
                    Text(DateFormat("MMM d, yyyy").format(historyItem.timestamp.toDate()),
                        style: TextStyle(
                            //color: Colors.black.withOpacity(0.6),
                            fontSize: 14,
                            fontWeight: FontWeight.w400)),
                    Text(DateFormat("h a").format(historyItem.timestamp.toDate()),
                        style: TextStyle(
                            //color: Colors.black.withOpacity(0.6),
                            fontSize: 14,
                            fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                child: Row(
                  children: [
                    Expanded(
                      child: success
                          ? Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text("Bought",
                                          softWrap: true,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black.withOpacity(0.6),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400)),
                                      Text("Price",
                                          softWrap: true,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black.withOpacity(0.6),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400)),
                                      Text("Fee",
                                          softWrap: true,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black.withOpacity(0.6),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                                 Container(padding: EdgeInsets.only(left: 8),child:  Column(
                                   crossAxisAlignment: CrossAxisAlignment.end,
                                   children: [
                                     Text("+${returnCurrencyCorrectedNumber(historyItem.response.symbol.split("/")[0],historyItem.response.filled)}",
                                         softWrap: true,
                                         textAlign: TextAlign.center,
                                         style: TextStyle(
                                             color: Colors.black.withOpacity(1),
                                             fontSize: 14,
                                             fontWeight: FontWeight.w400)),
                                     Text("${returnCurrencyCorrectedNumber(historyItem.response.symbol.split("/")[1], historyItem.response.average)}",
                                         softWrap: true,
                                         textAlign: TextAlign.center,
                                         style: TextStyle(
                                             color: Colors.black.withOpacity(1),
                                             fontSize: 14,
                                             fontWeight: FontWeight.w400)),
                                     Text("${returnCurrencyCorrectedNumber(historyItem.response.fee.currency, historyItem.response.fee.cost)}",
                                         softWrap: true,
                                         textAlign: TextAlign.center,
                                         style: TextStyle(
                                             color: Colors.black.withOpacity(0.6),
                                             fontSize: 14,
                                             fontWeight: FontWeight.w400))
                                   ],
                                 ),)
                                ],
                              ),
                            )
                          : Container(
                              child: Padding(
                                padding: EdgeInsets.only(left: 8, right: 8),
                                child: Text("${historyItem.error}",
                                    softWrap: true,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.6),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ),
                    ),
                    Container(
                      width: 12,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: success ? greenAppColor : redAppColor,
                          borderRadius: BorderRadius.all(Radius.circular(2))),
                      width: 4,
                      height: 48,
                    ),
                    Container(
                      width: 4,
                    )
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
