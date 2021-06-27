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
        //widget.settings.updateBasePair(user.userData.orders.values.toList()[0].pair.toString());
        pairData = this.user.pairDataItems[widget.orderItem.pair];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String timespan_name = "";
    switch (widget.settings.scaleLineChart) {
      case ScaleLineChart.WEEK1:
        timespan_name = "last week";
        break;
      case ScaleLineChart.WEEK2:
        timespan_name = "last two week";
        break;
      case ScaleLineChart.MONTH1:
        timespan_name = "last month";
        break;
      case ScaleLineChart.MONTH6:
        timespan_name = "last six months";
        break;
      case ScaleLineChart.YEAR1:
        timespan_name = "last year";
        break;
    }
    double appreciation =
        (((widget.settings.binanceTicker[pairData.pair.replaceAll("/", "")] *
            pairData.coinAccumulated) /
            pairData.totalExpended) -
            1) *
            100;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBarBitMe(
        returnIcon: true,
        title:"Purchase History",
      ),
      body: pairData != null
          ? pairData.isLoaded
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 16,
                    ),
                    Text(
                      "${pairData.pair}",
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.deepPurple,
                          fontFamily: 'Arial Rounded MT Bold'),
                    ),
                    Container(
                      height: 8,
                    ),
                    Text(
                      "Accumulated",
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "+ ${doubleToValueString(pairData.coinAccumulated)} ${pairData.pair.split("/")[0]}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Column(
                          children: [
                            Text(
                              "Invested",
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "${doubleToValueString(pairData.totalExpended)} ${pairData.pair.split("/")[1]}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                        Container(
                          width: 8,
                        ),
                        Expanded(
                            child: Column(
                          children: [
                            Text(
                              "Market Value",
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "${doubleToValueString(widget.settings.binanceTicker[pairData.pair.replaceAll("/", "")] * pairData.coinAccumulated)} ${pairData.pair.split("/")[1]}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ))
                      ],
                    ),
                    Container(
                      height: 8,
                    ),
                    RichText(
                      text: TextSpan(
                        text:
                        "${(appreciation).toStringAsFixed(2)}% (${doubleToValueString((widget.settings.binanceTicker[pairData.pair.replaceAll("/", "")] * pairData.coinAccumulated) - pairData.totalExpended)} ${pairData.pair.split("/")[1]})",
                        style: TextStyle(
                            color: appreciation < 0 ? Color(0xffA96B6B) : Color(0xff69A67C),
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        children: [
                          TextSpan(
                              text: " $timespan_name",
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.7))),
                        ],
                      ),
                    ),
                    Container(
                      //clipBehavior: Clip.antiAlias,
                      padding: EdgeInsets.only(/*bottom: 8,*/ top: 16),
                      /*margin: EdgeInsets.only(
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
                      ),*/
                      // height: 30,
                      child: pairData != null
                          ? (pairData.price_spots.length > 0)
                              ? PriceAVGChartLinePair(
                                  user: this.user,
                                  settings: widget.settings,
                                  pairData: pairData,
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
