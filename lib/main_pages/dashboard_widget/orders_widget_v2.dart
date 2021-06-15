import 'package:bitbybit/line_chart_mean.dart';
import 'package:bitbybit/models/settings_model.dart';
import 'package:bitbybit/models/user_model.dart';
import 'package:bitbybit/tools.dart';
import 'package:bitbybit/weekindicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class OrdersWidgetv2 extends StatefulWidget {
  User user;
  Settings settings;

  OrdersWidgetv2(this.user, this.settings);

  @override
  State<StatefulWidget> createState() {
    return _OrdersWidgetv2State();
  }
}

class _OrdersWidgetv2State extends State<OrdersWidgetv2> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16, right: 0, top: 20, bottom: 4),
                child: Text(
                  "Orders",
                  style: TextStyle(
                    fontFamily: 'Arial Rounded MT Bold',
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(0.5, 0.5),
                        blurRadius: 4,
                        color: Color.fromARGB(4, 0, 0, 0),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(child: Container()),
              Padding(
                padding: EdgeInsets.only(top: 16, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        style: ButtonStyle(
                          backgroundColor: widget.settings.scaleLineChart ==
                                  ScaleLineChart.WEEK1
                              ? MaterialStateProperty.all<Color>(
                                  Colors.deepPurple.withOpacity(0.2))
                              : null,
                        ),
                        onPressed: () {
                          setState(() {
                            widget.settings
                                .updateScaleLineChart(ScaleLineChart.WEEK1);
                          });
                        },
                        child: Text("1W")),
                    TextButton(
                        style: ButtonStyle(
                          backgroundColor: widget.settings.scaleLineChart ==
                                  ScaleLineChart.WEEK2
                              ? MaterialStateProperty.all<Color>(
                                  Colors.deepPurple.withOpacity(0.2))
                              : null,
                        ),
                        onPressed: () {
                          setState(() {
                            widget.settings
                                .updateScaleLineChart(ScaleLineChart.WEEK2);
                          });
                        },
                        child: Text("2W")),
                    TextButton(
                        style: ButtonStyle(
                          backgroundColor: widget.settings.scaleLineChart ==
                                  ScaleLineChart.MONTH1
                              ? MaterialStateProperty.all<Color>(
                                  Colors.deepPurple.withOpacity(0.2))
                              : null,
                        ),
                        onPressed: () {
                          setState(() {
                            widget.settings
                                .updateScaleLineChart(ScaleLineChart.MONTH1);
                          });
                        },
                        child: Text("1M")),
                    /*TextButton(
                        onPressed: () {
                          setState(() {});
                        },
                        child: Text("6M")),*/
                    TextButton(
                        style: ButtonStyle(
                          backgroundColor: widget.settings.scaleLineChart ==
                                  ScaleLineChart.YEAR1
                              ? MaterialStateProperty.all<Color>(
                                  Colors.deepPurple.withOpacity(0.2))
                              : null,
                        ),
                        onPressed: () {
                          setState(() {
                            widget.settings
                                .updateScaleLineChart(ScaleLineChart.YEAR1);
                          });
                        },
                        child: Text("1Y"))
                  ],
                ),
              ),
              Container(
                width: 4,
              )
            ],
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10.0,
                    offset: Offset(0.0, 0.5))
              ],
              color: Colors.white,
            ),
            //height: 300,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.user.orderItems.length,
                //shrinkWrap: true,
                itemBuilder: (context, index) {
                  PairData _pairData = widget
                      .user.pairDataItems[widget.user.orderItems[index].pair];
                  double _variation = getValueVariation(
                      widget.settings
                          .binanceTicker[_pairData.pair.replaceAll("/", "")],
                      _pairData.avgPrice);
                  bool hasProfit = _variation > 0;
                  return Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.2,
                    child: Container(
                      //height: 64,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 0.5,
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ),
                      ),
                      padding: EdgeInsets.only(
                          top: 4, bottom: 4, left: 16, right: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 120,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 0),
                                  child: Text(
                                    _pairData.pair,
                                    style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 20,
                                        //fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 0, bottom: 0),
                                  child: Text(
                                      '+${doubleToValueString(_pairData.coinAccumulated)} ${_pairData.pair.split("/")[0]}',
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.4),
                                          fontSize: 16)),
                                ),
                                Container(height: 4,),
                                WeekIndicator(widget.user.orderItems[index].schedule)
                              ],
                            ),
                          ),
                          Container(
                            width: 16,
                          ),
                          Expanded(
                            child: _pairData.price_spots.length > 0
                                ? PriceAVGChartLine(
                                    widget.user,
                                    widget.settings,
                                    widget.user.orderItems[index].pair,
                                    hasProfit ? Colors.green : Colors.red)
                                : Container(),
                          ),
                          Container(
                            width: 128,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 0),
                                  child: Text(
                                    widget.settings.binanceTicker != null
                                        ? "${_variation.toStringAsFixed(2)} % "
                                        : "...",
                                    style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 20,
                                        //fontWeight: FontWeight.w400,
                                        color: hasProfit
                                            ? Colors.green
                                            : Colors.red),
                                  ),
                                ),
                                Container(
                                  height: 4,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: hasProfit
                                          ? Color(0xff69A67C)
                                          : Color(0xffA96B6B),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16))),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 4),
                                  child: Text(
                                    '+${doubleToValueString(_pairData.avgPrice)} ${_pairData.pair.split("/")[1]}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        )
      ],
    );
  }
}
