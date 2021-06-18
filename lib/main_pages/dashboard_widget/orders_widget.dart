import 'package:bitbybit/line_chart_mean.dart';
import 'package:bitbybit/models/history_model.dart';
import 'package:bitbybit/models/settings_model.dart';
import 'package:bitbybit/models/user_model.dart';
import 'package:bitbybit/tools.dart';
import 'package:bitbybit/widgets/weekindicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../CreateOrderDialog.dart';
import '../../EditOrderDialog.dart';

class OrdersWidgetv2 extends StatefulWidget {
  User user;
  Settings settings;

  OrdersWidgetv2({this.user, this.settings});

  @override
  State<StatefulWidget> createState() {
    return _OrdersWidgetv2State();
  }
}

class _OrdersWidgetv2State extends State<OrdersWidgetv2> {
  List<String> scaleNames = ["1W", "2W", "1M", "6M", "1Y"];
  String btnText = "1W";

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.only(top: 16),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CreateOrderDialog(widget.user.firebasUser.uid);
                      },
                    );
                  },
                  icon: Icon(Icons.add_circle)),
              Padding(
                padding: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
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
                padding: EdgeInsets.only(top: 0, bottom: 0),
                child: TextButton(
                    /*style: ButtonStyle(
                          backgroundColor: widget.settings.scaleLineChart ==
                                  ScaleLineChart.WEEK1
                              ? MaterialStateProperty.all<Color>(
                                  Colors.deepPurple.withOpacity(0.2))
                              : null,
                        ),*/
                    onPressed: () {
                      switch (widget.settings.scaleLineChart) {
                        case ScaleLineChart.WEEK1:
                          widget.settings
                              .updateScaleLineChart(ScaleLineChart.WEEK2);
                          btnText = scaleNames[1];
                          widget.user.forceUpdateHistoryData(14);
                          break;
                        case ScaleLineChart.WEEK2:
                          widget.settings
                              .updateScaleLineChart(ScaleLineChart.MONTH1);
                          btnText = scaleNames[2];
                          widget.user.forceUpdateHistoryData(30);
                          break;
                        case ScaleLineChart.MONTH1:
                          widget.settings
                              .updateScaleLineChart(ScaleLineChart.MONTH6);
                          btnText = scaleNames[3];
                          widget.user.forceUpdateHistoryData(180);
                          break;
                        case ScaleLineChart.MONTH6:
                          widget.settings
                              .updateScaleLineChart(ScaleLineChart.YEAR1);
                          btnText = scaleNames[4];
                          widget.user.forceUpdateHistoryData(365);
                          break;
                        case ScaleLineChart.YEAR1:
                          widget.settings
                              .updateScaleLineChart(ScaleLineChart.WEEK1);
                          btnText = scaleNames[0];
                          widget.user.forceUpdateHistoryData(7);
                          break;
                      }
                      setState(() {});
                    },
                    child: Text(btnText)),
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
                  offset: Offset(0.0, 0.5),
                )
              ],
              color: Colors.white,
            ),
            //height: 300,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.user.orderItems.length,
                //shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (widget.user.pairDataItems.isNotEmpty) {
                    PairData _pairData = widget
                        .user.pairDataItems[widget.user.orderItems[index].pair];
                    double _variation;
                    if (widget.settings.binanceTicker != null) {
                      _variation = getValueVariation(
                          widget.settings.binanceTicker[
                              _pairData.pair.replaceAll("/", "")],
                          _pairData.avgPrice);
                    }
                    ORDER_STATUS order_status;
                    bool hasProfit = (_variation ?? 0) > 0;
                    if (_pairData.historyItems.last.result ==
                        TransactinoResult.FAILURE) {
                      order_status = ORDER_STATUS.ERROR;
                    }else{
                      if(widget.user.orderItems[index].active){
                        order_status = ORDER_STATUS.RUNNING;
                      }else{
                        order_status = ORDER_STATUS.PAUSED;
                      }
                    }

                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
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
                                            color:
                                                Colors.black.withOpacity(0.4),
                                            fontSize: 16)),
                                  ),
                                  Container(
                                    height: 4,
                                  ),
                                  WeekIndicator(
                                      widget.user.orderItems[index].schedule,
                                      order_status)
                                ],
                              ),
                            ),
                            Container(
                              width: 16,
                            ),
                            Expanded(
                              child: _pairData.price_spots.length > 0
                                  ? PriceAVGChartLine(
                                      // key:_chartKey,
                                      user: widget.user,
                                      settings: widget.settings,
                                      pair: widget.user.orderItems[index].pair,
                                      color: Colors.deepPurple
                                      /*hasProfit ? Colors.green : Colors.red*/)
                                  : Container(
                                      child: Text(
                                        "Not enough data to show.",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
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
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'Arial',
                                          fontSize: 20,
                                          //fontWeight: FontWeight.w400,
                                          color: Colors.deepPurple
                                          /*color: hasProfit
                                              ? */ /*Color(0xff69A67C)*/ /*

                                              : */ /*Color(0xffA96B6B)*/),
                                    ),
                                  ),
                                  Container(
                                    height: 4,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.deepPurple.withOpacity(0.7),
                                        /*color: hasProfit
                                            ? Color(0xff69A67C)
                                            : Color(0xffA96B6B),*/
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4))),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    child: Text(
                                      'Price Average:\n${doubleToValueString(_pairData.avgPrice)} ${_pairData.pair.split("/")[1]}',
                                      textAlign: TextAlign.center,
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
                      secondaryActions: [
                        IconSlideAction(
                          iconWidget: Container(
                            color: Colors.deepPurple,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.edit,
                                  size: 36,
                                  color: Colors.white,
                                ),
                                Text(
                                  "Edit",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return EditOrderDialog(
                                    widget.user.orderItems[index],
                                    widget.user.firebasUser.uid);
                              },
                            );
                          },
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ),
        )
      ],
    );
  }
}
