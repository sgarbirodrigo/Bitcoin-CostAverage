import 'package:Bit.Me/CreateEditOrder.dart';
import 'package:Bit.Me/models/order_model.dart';
import 'package:Bit.Me/tools.dart';
import 'package:Bit.Me/widgets/circular_progress_indicator.dart';
import 'package:Bit.Me/widgets/weekindicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../main_pages/pairdetail_page.dart';
import '../charts/line_chart_mean.dart';
import '../contants.dart';
import '../models/history_model.dart';
import '../models/settings_model.dart';
import '../models/user_model.dart';

class OrderItemList extends StatefulWidget {
  int index;
  UserManager user;
  SettingsApp settings;

  OrderItemList(this.index, this.user, this.settings);

  @override
  State<StatefulWidget> createState() {
    return _OrderItemListState();
  }
}

class _OrderItemListState extends State<OrderItemList> {
  double appreciation;

  @override
  Widget build(BuildContext context) {
    OrderItem _orderItem =
        widget.user.userData.orders.values.toList()[widget.index];
    PairData _pairData = widget.user.pairDataItems[_orderItem.pair];
    //print("_pairData: ${_pairData}");
    if (_pairData != null &&widget.settings.binanceTicker!=null) {
      appreciation =
          (((widget.settings.binanceTicker[_pairData.pair.replaceAll("/", "")] *
                          _pairData.coinAccumulated) /
                      _pairData.totalExpended) -
                  1) *
              100;
    } else {
      appreciation = 0;
    }
    ORDER_STATUS order_status;
    //bool hasProfit = (_variation ?? 0) > 0;
    if (_orderItem.active) {
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
        _selectedColor = greenAppColor;
        break;
      case ORDER_STATUS.PAUSED:
        _selectedColor = Colors.grey.withOpacity(0.8);
        break;
      case ORDER_STATUS.ERROR:
        _selectedColor = redAppColor;
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
                  _orderItem, widget.user.firebaseUser, widget.settings)));
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
                                '- ${returnCurrencyCorrectedNumber(_orderItem.pair.split("/")[1], _orderItem.amount)} ',
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
                          "Not enough data to show on the selected period.",
                          textAlign: TextAlign.center,
                        ),
                      ),
              ),
              Container(
                width: 130,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Text(
                        getAppreciationConverted(appreciation),
                        /*widget.settings.binanceTicker != null &&
                                _pairData != null
                            ? "${_pairData.percentage_variation.toStringAsFixed(2)} % "
                            : "...",*/
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 20,
                            //fontWeight: FontWeight.w400,
                            color: Colors.deepPurple
                            /*color: hasProfit
                                              ? */ /*greenAppColor*/ /*

                                              : */ /*redAppColor*/),
                      ),
                    ),
                    /*Container(
                                  height: 4,
                                ),*/
                    Padding(
                      padding: EdgeInsets.only(top: 0, bottom: 4),
                      child: Text(
                          _pairData != null
                              ? '+${returnCurrencyCorrectedNumber(_pairData.pair.split("/")[0], _pairData.coinAccumulated)}'
                              : "...",
                          style: TextStyle(
                              color: Colors.deepPurple, fontSize: 14)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [getChangeActive(_pairData, _orderItem)],
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

  bool isActivityChanging = false;

  IconSlideAction getChangeActive(PairData pairData, OrderItem orderItem) {
    bool isActive = orderItem.active;
    return IconSlideAction(
      iconWidget: Container(
        color: isActive ? redAppColor : greenAppColor,
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isActivityChanging
                ? Container(
                    height: 16,
                    width: 16,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 1,
                      ),
                    ),
                  )
                : Icon(
                    isActive ? Icons.pause : Icons.play_arrow_outlined,
                    color: Colors.white,
                  ),
            Container(
              height: 4,
            ),
            Text(
              isActive ? "Pause" : "Activate",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            )
          ],
        ),
      ),
      onTap: () {
        setState(() {
          isActivityChanging = true;
        });
        FirebaseFirestore.instance
            .collection("users")
            .doc(widget.user.firebaseUser.uid)
            .update({
          "orders.${orderItem.pair.replaceAll("/", "_")}.active": !isActive
        }).then((value) {
          isActivityChanging = false;
          widget.user.updateUser();
        });
      },
    );
  }
}
