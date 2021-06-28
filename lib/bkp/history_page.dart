import 'package:Bit.Me/tools.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../charts/line_chart_mean.dart';
import '../charts/line_chart_mean_pair.dart';
import '../list_item/history_list_item.dart';
import '../models/settings_model.dart';
import '../models/user_model.dart';

class HistoryPage extends StatefulWidget {
  Settings settings;
  User user;
  PairData pairData;

  HistoryPage(this.user, this.settings,this.pairData);

  @override
  State<StatefulWidget> createState() {
    return _HistoryPageState();
  }
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {}

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
    TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 14);
    double appreciation =
        (((widget.settings.binanceTicker[widget.pairData.pair.replaceAll("/", "")] *
                        widget.pairData.coinAccumulated) /
                    widget.pairData.totalExpended) -
                1) *
            100;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /*Center(
          child: Container(
            height: 48,
            //color: Colors.red,
            alignment: Alignment.center,
            //width: ,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.user.userData.orders.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  List coins = List();
                  widget.user.userData.orders.forEach((key, value) {
                    coins.add(value.pair);
                  });
                  return GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.settings.updateBasePair(coins[index]);
                        });
                        // widget.settings.base_pair_color = colorsList[0];
                      },
                      child: AnimatedContainer(
                          width: 128,
                          // padding: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            //color: Color(0xffF7F8F9),
                            color: coins[index] == widget.settings.base_pair
                                ? Colors.deepPurple.shade50
                                : Color(0xffF7F8F9),
                            border: coins[index] ==
                                widget.settings.base_pair
                                ? Border(
                                top: BorderSide(
                                    color: Colors.deepPurple, width: 4),
                                right: BorderSide(
                                    color:
                                    Colors.black.withOpacity(0.3),
                                    width: 0.5),
                                left: BorderSide(
                                    color:
                                    Colors.black.withOpacity(0.3),
                                    width: 0.5))
                                : null,
                          ),
                          duration: Duration(milliseconds: 250),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: coins[index] ==
                                        widget.settings.base_pair
                                        ? 4
                                        : 8),
                                child: Text(
                                  "${coins[index]}",
                                  style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 24,
                                      color: Colors.black),
                                ),
                              ),
                              Container(
                                height: 0,
                              ),
                              */ /*Text(
                                    "${widget.user.userTotalExpendingAmount[coins[index]] * _multiplier} ${coins[index]}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                  ),*/ /*
                            ],
                          )));
                }),
          ),
        ),*/
        /*Container(
          padding: EdgeInsets.only(top: 16, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      if (position > 0)
                        position--;
                      else
                        position = widget.user.widget.pairDataItems.length - 1;

                      widget.settings.updateBasePair(widget
                          .user.widget.pairDataItems.values
                          .toList()[position]
                          .pair);
                    });
                  },
                  icon: Icon(Icons.chevron_left)),
              Text(
                "${widget.pairData.pair}",
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.deepPurple,
                    fontFamily: 'Arial Rounded MT Bold'),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    if (position == widget.user.widget.pairDataItems.length - 1)
                      position = 0;
                    else
                      position++;
                    widget.settings.updateBasePair(widget
                        .user.widget.pairDataItems.values
                        .toList()[position]
                        .pair);
                  });
                },
                icon: Icon(Icons.chevron_right),
              )
            ],
          ),
        ),*/
        Text(
          "Accumulated",
          textAlign: TextAlign.center,
        ),
        Text(
          "+ ${doubleToValueString(widget.pairData.coinAccumulated)} ${widget.pairData.pair.split("/")[0]}",
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
                  "${doubleToValueString(widget.pairData.totalExpended)} ${widget.pairData.pair.split("/")[1]}",
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
                  "${doubleToValueString(widget.settings.binanceTicker[widget.pairData.pair.replaceAll("/", "")] * widget.pairData.coinAccumulated)} ${widget.pairData.pair.split("/")[1]}",
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
                "${(appreciation).toStringAsFixed(2)}% (${doubleToValueString((widget.settings.binanceTicker[widget.pairData.pair.replaceAll("/", "")] * widget.pairData.coinAccumulated) - widget.pairData.totalExpended)} ${widget.pairData.pair.split("/")[1]})",
            style: TextStyle(
                color: appreciation < 0 ? Color(0xffA96B6B) : Color(0xff69A67C),
                fontSize: 18,
                fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                  text: " $timespan_name",
                  style: TextStyle(color: Colors.black.withOpacity(0.7))),
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
          child: widget.pairData != null
              ? (widget.pairData.price_spots.length > 0)
                  ? PriceAVGChartLinePair(
                      user: widget.user,
                      settings: widget.settings,pairData:widget.pairData,
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
            child: Container(
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: widget.pairData.historyItems.length,
              itemBuilder: (context, index) {
                return HistoryItemList(
                  historyItem: widget.pairData
                      .historyItems[widget.pairData.historyItems.length - index - 1],
                  userUid: widget.user.firebaseUser.uid,
                );
              }),
        ))
      ],
    );
  }
}
