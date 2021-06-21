import 'package:Bit.Me/charts/line_chart_mean.dart';
import 'package:Bit.Me/models/history_model.dart';
import 'package:Bit.Me/models/settings_model.dart';
import 'package:Bit.Me/models/user_model.dart';
import 'package:Bit.Me/page/pairdetail_page.dart';
import 'package:Bit.Me/tools.dart';
import 'package:Bit.Me/widgets/weekindicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../CreateOrderDialog.dart';
import '../../EditOrderDialog.dart';

class OrdersWidget extends StatefulWidget {
  User user;
  Settings settings;

  OrdersWidget({this.user, this.settings});

  @override
  State<StatefulWidget> createState() {
    return _OrdersWidgetState();
  }
}

class _OrdersWidgetState extends State<OrdersWidget> {
  List<String> scaleNames = ["1W", "2W", "1M", "6M", "1Y"];
  String btnText = "1W";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
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
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.deepPurple.withOpacity(0.2)),
                    ),
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
        AnimatedContainer(
            height: widget.user.isUpdatingHistory ? 4 : 0,
            duration: Duration(milliseconds: 250),
            child: LinearProgressIndicator()),
        Container(
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
          child: widget.user.pairDataItems.isNotEmpty
              ? ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: widget.user.orderItems.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    //print("pair: ${widget.user.orderItems[index].pair}");
                    PairData _pairData = widget
                        .user.pairDataItems[widget.user.orderItems[index].pair];
                    //print("_pairData: ${_pairData}");
                    ORDER_STATUS order_status;
                    //bool hasProfit = (_variation ?? 0) > 0;
                    if (widget.user.orderItems[index].active) {
                      order_status = ORDER_STATUS.RUNNING;
                    } else {
                      order_status = ORDER_STATUS.PAUSED;
                    }
                    if (_pairData != null) {
                      if (_pairData.historyItems.last.result ==
                          TransactinoResult.FAILURE) {
                        order_status = ORDER_STATUS.ERROR;
                      }
                    }
                    Color _selectedColor;
                    switch (order_status) {
                      case ORDER_STATUS.RUNNING:
                        _selectedColor = Color(0xff69A67C);
                        break;
                      case ORDER_STATUS.PAUSED:
                        _selectedColor = Colors.grey.withOpacity(0.8);
                        break;
                      case ORDER_STATUS.ERROR:
                        _selectedColor = Color(0xffA96B6B);
                        break;
                      default:
                        _selectedColor = Colors.grey.withOpacity(0.8);
                    }

                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.3,
                      child: Container(
                        height: 72,
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
                                      widget.user.orderItems[index].pair,
                                      style: TextStyle(
                                          fontFamily: 'Arial',
                                          fontSize: 20,
                                          //fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 0, bottom: 4),
                                    /*Text(
                                      ,
                                      style: TextStyle(
                                          color: _selectedColor,
                                          fontSize: 14))*/
                                    child: RichText(
                                      text: TextSpan(
                                          text:
                                              '- ${doubleToValueString(widget.user.orderItems[index].amount)} ${widget.user.orderItems[index].pair.split("/")[1]}',
                                          style: TextStyle(color: _selectedColor, fontSize: 14),
                                          children: [
                                            TextSpan(
                                                text: "/day",
                                                style: TextStyle(
                                                    color: _selectedColor,
                                                    fontSize: 10))
                                          ]),
                                    ),
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
                              child: _pairData != null
                                  ? (_pairData.price_spots.length > 0)
                                      ? PriceAVGChartLine(
                                          // key:_chartKey,
                                          user: widget.user,
                                          settings: widget.settings,
                                          pair: widget
                                              .user.orderItems[index].pair,
                                          color: Colors.deepPurple
                                          /*hasProfit ? Colors.green : Colors.red*/)
                                      : Container(
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
                              width: 128,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 0),
                                    child: Text(
                                      widget.settings.binanceTicker != null &&
                                              _pairData != null
                                          ? "${_pairData.percentage_variation.toStringAsFixed(2)} % "
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
                                  /*Container(
                                  height: 4,
                                ),*/
                                  Padding(
                                    padding: EdgeInsets.only(top: 0, bottom: 4),
                                    child: Text(
                                        _pairData != null
                                            ? '+${doubleToValueString(_pairData.coinAccumulated)} ${_pairData.pair.split("/")[0]}'
                                            : "...",
                                        style: TextStyle(
                                            color: Colors.deepPurple,
                                            fontSize: 16)),
                                  ),
                                  /*Container(
                                  decoration: BoxDecoration(
                                      color: Colors.deepPurple.withOpacity(0.7),
                                      */ /*color: hasProfit
                                            ? Color(0xff69A67C)
                                            : Color(0xffA96B6B),*/ /*
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4))),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  child: Text(
                                    'AVG: ${doubleToValueString(_pairData.avgPrice)} ${_pairData.pair.split("/")[1]}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ),*/
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: ORDER_STATUS.ERROR == order_status
                          ? [
                              IconSlideAction(
                                iconWidget: Container(
                                  color: _selectedColor,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _pairData.historyItems.last.error,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
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
                              )
                            ]
                          : [],
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
                                  size: 24,
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
                        IconSlideAction(
                          iconWidget: Container(
                            color: Colors.deepPurple.shade300,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.history,
                                  size: 24,
                                  color: Colors.white,
                                ),
                                Text(
                                  "History",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => PairDetailPage(widget.user.orderItems[index],widget.user.firebasUser,widget.settings)));
                          },
                        ),
                      ],
                    );
                  })
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ],
    );
  }
}
