import 'package:Bit.Me/CreateEditOrder.dart';
import 'package:Bit.Me/tools.dart';
import 'package:Bit.Me/widgets/weekindicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../bkp/EditOrderDialog.dart';
import '../bkp/pairdetail_page.dart';
import '../charts/line_chart_mean.dart';
import '../models/history_model.dart';
import '../models/settings_model.dart';
import '../models/user_model.dart';

class OrderItemList extends StatefulWidget {
  int index;
  User user;
  Settings settings;

  OrderItemList(this.index, this.user, this.settings);

  @override
  State<StatefulWidget> createState() {
    return _OrderItemListState();
  }
}

class _OrderItemListState extends State<OrderItemList> {
  @override
  Widget build(BuildContext context) {
    //print("pair: ${widget.user.userData.orders.values.toList()[index].pair}");
    /*print(
                          "test${widget.user.userData.orders.values.toList()[index]}");*/
    PairData _pairData = widget.user.pairDataItems[
        widget.user.userData.orders.values.toList()[widget.index].pair];
    //print("_pairData: ${_pairData}");
    ORDER_STATUS order_status;
    //bool hasProfit = (_variation ?? 0) > 0;
    if (widget.user.userData.orders.values.toList()[widget.index].active) {
      order_status = ORDER_STATUS.RUNNING;
    } else {
      order_status = ORDER_STATUS.PAUSED;
    }
    if (_pairData != null) {
      if (_pairData.historyItems.last.result == TransactinoResult.FAILURE) {
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
      actionExtentRatio: 0.2,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PairDetailPage(
                  widget.user.userData.orders.values.toList()[widget.index],
                  widget.user.firebaseUser,
                  widget.settings)));
        },
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
          padding: EdgeInsets.only(top: 4, bottom: 4, left: 16, right: 8),
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
                        widget.user.userData.orders.values
                            .toList()[widget.index]
                            .pair,
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
                                '- ${doubleToValueString(widget.user.userData.orders.values.toList()[widget.index].amount)} ${widget.user.userData.orders.values.toList()[widget.index].pair.split("/")[1]}',
                            style: TextStyle(color: _selectedColor, fontSize: 14),
                            children: [
                              TextSpan(
                                  text: "/day",
                                  style: TextStyle(
                                      color: _selectedColor, fontSize: 10))
                            ]),
                      ),
                    ),
                    WeekIndicator(
                        widget.user.userData.orders.values
                            .toList()[widget.index]
                            .schedule,
                        order_status)
                  ],
                ),
              ),
              Container(
                width: 16,
              ),
              Expanded(
                child: _pairData != null
                    ? PriceAVGChartLine(
                        user: widget.user,
                        settings: widget.settings,
                        pair: _pairData.pair,
                        color: Colors.deepPurple,
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
                              color: Colors.deepPurple, fontSize: 16)),
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
      ),
      actions: ORDER_STATUS.ERROR == order_status
          ? [
              IconSlideAction(
                iconWidget: Container(
                  color: _selectedColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _pairData.historyItems.last.error ?? "",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  /*showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return EditOrderDialog(
                                        widget.user.userData.orders.values.toList()[widget.index],
                                        widget.user.firebasUser.uid);
                                  },
                                );*/
                },
              )
            ]
          : [],
      secondaryActions: _pairData != null && _pairData.historyItems.length > 0
          ? [
              MyIconActionEdit(widget.index),
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
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PairDetailPage(
                          widget.user.userData.orders.values
                              .toList()[widget.index],
                          widget.user.firebaseUser,
                          widget.settings)));
                },
              ),
            ]
          : [
              MyIconActionEdit(widget.index),
            ],
    );
  }

  IconSlideAction MyIconActionEdit(int index) {
    return IconSlideAction(
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
              style: TextStyle(color: Colors.white, fontSize: 16),
            )
          ],
        ),
      ),
      onTap: () async {
        await showModalBottomSheet(
          context: context,
          useRootNavigator: true,
          isScrollControlled: true,
          builder: (context) => Container(
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: CreateEditOrder(
                widget.user,
                orderItem: widget.user.userData.orders.values.toList()[index],
              ),
            ),
          ),
        );
        widget.user.updateUser();
      },
    );
  }
}
