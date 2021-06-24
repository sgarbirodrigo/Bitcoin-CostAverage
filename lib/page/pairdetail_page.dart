import 'package:Bit.Me/external/binance_api.dart';
import 'package:Bit.Me/charts/line_chart_mean.dart';
import 'package:Bit.Me/models/order_model.dart';
import 'package:Bit.Me/models/settings_model.dart';
import 'package:Bit.Me/models/user_model.dart';
import 'package:Bit.Me/tools.dart';
import 'package:Bit.Me/widgets/appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../history_list_item.dart';
import '../charts/line_chart_mean_pair.dart';

class PairDetailPage extends StatefulWidget {
  OrderItem orderItem;
  FirebaseUser firebaseUser;
  Settings settings;

  PairDetailPage(this.orderItem, this.firebaseUser, this.settings);

  @override
  State<StatefulWidget> createState() {
    return _PairDetailPageState();
  }
}

class _PairDetailPageState extends State<PairDetailPage> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  PairData pairData;
  User user;

  @override
  void initState() {
    user = User(widget.firebaseUser, widget.settings, (user) async {
      setState(() {
        this.user = user;
        widget.settings.updateBasePair(user.userData.orders.values.toList()[0].pair.toString());
        pairData = this.user.pairDataItems[widget.orderItem.pair];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _valueStyle = TextStyle(color: Colors.deepPurple, fontSize: 16);
    TextStyle _headerStyle =
        TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 14);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBarBitMe(
        returnIcon: true,
        title: widget.orderItem.pair,
      ),
      body: pairData != null
          ? pairData.isLoaded
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      padding: EdgeInsets.only(/*bottom: 8,*/ top: 16),
                      margin: EdgeInsets.only(
                          left: 8, right: 8, bottom: 16, top: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 15.0,
                            offset: Offset(0.0, 0.75),
                          )
                        ],
                        color: Colors.grey.shade50,
                      ),
                      // height: 30,
                      child: pairData != null
                          ? (pairData.price_spots.length > 0)
                              ? PriceAVGChartLinePair(
                                  user: this.user,
                                  settings: widget.settings,
                                  pair: widget.orderItem.pair,
                                  avgPrice: pairData.avgPrice,
                                  color: Colors.deepPurple)
                              : Container(
                                  height: 200,
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "Not enough data to show.",
                                    textAlign: TextAlign.center,
                                  ),
                                )
                          : Container(
                              child: Text(
                                "Not enough data to show.",
                                textAlign: TextAlign.center,
                              ),
                            ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 8, right: 8, bottom: 16, top: 16),
                      //padding:EdgeInsets.only(left: 8,right: 8,bottom: 16,top: 16),
                      decoration: BoxDecoration(
                        /* borderRadius: BorderRadius.all(Radius.circular(8)),*/
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 15.0,
                            offset: Offset(0.0, 0.75),
                          )
                        ],
                        color: Colors.grey.shade50,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  "Average Buy Price",
                                  style: _headerStyle,
                                ),
                                Text(
                                  "${doubleToValueString(pairData.avgPrice)} ${pairData.pair.split("/")[1]}",
                                  style: _valueStyle,
                                ),
                                Container(height: 8,),
                                Text(
                                  "Invested Amount",
                                  style: _headerStyle,
                                ),
                                Text(
                                    "${doubleToValueString(pairData.totalExpended)} ${pairData.pair.split("/")[1]}",
                                    style: _valueStyle)
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Column(
                                children: [
                                  Text(
                                    "Growth",
                                    style: _headerStyle,
                                  ),
                                  Text(
                                      "${pairData.percentage_variation.toStringAsFixed(2)}%",
                                      style: _valueStyle),
                                  Container(height: 8,),
                                  Text(
                                    "Accumulated",
                                    style: _headerStyle,
                                  ),
                                  Text(
                                      "+${doubleToValueString(pairData.coinAccumulated)} ${pairData.pair.split("/")[0]}",
                                      style: _valueStyle)
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                              child: Column(
                            children: [
                              Text(
                                "Actual Price",
                                style: _headerStyle,
                              ),
                              Text(
                                  "${doubleToValueString(widget.settings.binanceTicker[pairData.pair.replaceAll("/", "")])} ${pairData.pair.split("/")[1]}",
                                  style: _valueStyle),
                              Container(height: 8,),
                              Text(
                                "Actual Worth",
                                style: _headerStyle,
                              ),
                              Text(
                                  "${doubleToValueString(widget.settings.binanceTicker[pairData.pair.replaceAll("/", "")] * pairData.coinAccumulated)} ${pairData.pair.split("/")[1]}",
                                  style: _valueStyle)
                            ],
                          ))
                        ],
                      ),
                    ),
                    Container(height: 16,),
                    Expanded(
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: pairData.historyItems.length,
                            itemBuilder: (context, index) {
                              return HistoryItemList(
                                historyItem: pairData.historyItems[
                                    pairData.historyItems.length - index - 1],
                                userUid: widget.firebaseUser.uid,
                              );
                            }))
                  ],
                )
              : Center(child: Text("No order has been executed yet."))
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
