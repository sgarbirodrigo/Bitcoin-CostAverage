import 'package:Bit.Me/charts/line_chart_mean.dart';
import 'package:Bit.Me/models/history_model.dart';
import 'package:Bit.Me/models/settings_model.dart';
import 'package:Bit.Me/models/user_model.dart';
import 'package:Bit.Me/bkp/pairdetail_page.dart';
import 'package:Bit.Me/tools.dart';
import 'package:Bit.Me/widgets/weekindicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../CreateOrderDialog.dart';
import '../../EditOrderDialog.dart';
import 'order_item_list.dart';

class OrdersPage extends StatefulWidget {
  User user;
  Settings settings;

  OrdersPage({this.user, this.settings});

  @override
  State<StatefulWidget> createState() {
    return _OrdersPageState();
  }
}

class _OrdersPageState extends State<OrdersPage> {
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
          //color: Colors.grey.shade200,
          margin: EdgeInsets.only(top: 8, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        ScaleLineChart.WEEK1 == widget.settings.scaleLineChart
                            ? MaterialStateProperty.all<Color>(
                                Colors.deepPurple.withOpacity(0.2))
                            : null,
                  ),
                  onPressed: () {
                    this.setState(() {
                      widget.settings
                          .updateScaleLineChart(ScaleLineChart.WEEK1);
                      widget.user.forceUpdateHistoryData(7);
                    });
                  },
                  child: Text("1W")),
              TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      ScaleLineChart.WEEK2 == widget.settings.scaleLineChart
                          ? MaterialStateProperty.all<Color>(
                              Colors.deepPurple.withOpacity(0.2))
                          : null,
                ),
                onPressed: () {
                  this.setState(() {
                    widget.settings.updateScaleLineChart(ScaleLineChart.WEEK2);
                    widget.user.forceUpdateHistoryData(14);
                  });
                },
                child: Text("2W"),
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      ScaleLineChart.MONTH1 == widget.settings.scaleLineChart
                          ? MaterialStateProperty.all<Color>(
                              Colors.deepPurple.withOpacity(0.2))
                          : null,
                ),
                onPressed: () {
                  this.setState(() {
                    widget.settings.updateScaleLineChart(ScaleLineChart.MONTH1);
                    widget.user.forceUpdateHistoryData(30);
                  });
                },
                child: Text("1M"),
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      ScaleLineChart.MONTH6 == widget.settings.scaleLineChart
                          ? MaterialStateProperty.all<Color>(
                              Colors.deepPurple.withOpacity(0.2))
                          : null,
                ),
                onPressed: () {
                  this.setState(() {
                    widget.settings.updateScaleLineChart(ScaleLineChart.MONTH6);
                    widget.user.forceUpdateHistoryData(180);
                  });
                },
                child: Text("6M"),
              ),
              TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        ScaleLineChart.YEAR1 == widget.settings.scaleLineChart
                            ? MaterialStateProperty.all<Color>(
                                Colors.deepPurple.withOpacity(0.2))
                            : null,
                  ),
                  onPressed: () {
                    this.setState(() {
                      widget.settings
                          .updateScaleLineChart(ScaleLineChart.YEAR1);
                      widget.user.forceUpdateHistoryData(365);
                    });
                  },
                  child: Text("1Y"))
            ],
          ),
        ),
        AnimatedContainer(
            height: widget.user.isUpdatingHistory ? 4 : 0,
            duration: Duration(milliseconds: 250),
            child: LinearProgressIndicator()),
        Expanded(
            child: Container(
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10.0,
                      offset: Offset(0.0, 0.0),
                    )
                  ],
                  color: Colors.white,
                ),
                //height: 300,
                child: widget.user.userData.orders.length > 0
                    ? ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: widget.user.userData.orders.length,
                        //physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          //print("pair: ${widget.user.userData.orders.values.toList()[index].pair}");
                          /*print(
                          "test${widget.user.userData.orders.values.toList()[index]}");*/
                          PairData _pairData = widget.user.pairDataItems[widget
                              .user.userData.orders.values
                              .toList()[index]
                              .pair];
                          //print("_pairData: ${_pairData}");
                          ORDER_STATUS order_status;
                          //bool hasProfit = (_variation ?? 0) > 0;
                          if (widget.user.userData.orders.values
                              .toList()[index]
                              .active) {
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

                          return OrderItemList(
                              index, widget.user, widget.settings);
                          ;
                        })
                    : Container(
                        child: Center(
                          child: Text(
                              "Here you will be able to view all the orders that are being executed daily."),
                        ),
                      ))),
      ],
    );
  }
}
