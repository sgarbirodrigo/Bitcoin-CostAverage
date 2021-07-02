import 'package:Bit.Me/charts/line_chart_mean.dart';
import 'package:Bit.Me/models/history_model.dart';
import 'package:Bit.Me/models/settings_model.dart';
import 'package:Bit.Me/models/user_model.dart';
import 'package:Bit.Me/main_pages/pairdetail_page.dart';
import 'package:Bit.Me/tools.dart';
import 'package:Bit.Me/widgets/weekindicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../bkp/CreateOrderDialog.dart';
import '../../bkp/EditOrderDialog.dart';
import '../../list_item/order_item_list.dart';

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
  String btnText;

  @override
  void initState() {
    super.initState();
    switch (widget.settings.scaleLineChart) {
      case ScaleLineChart.WEEK1:
        btnText = scaleNames[0];
        break;
      case ScaleLineChart.WEEK2:
        btnText = scaleNames[1];
        break;
      case ScaleLineChart.MONTH1:
        btnText = scaleNames[2];
        break;
      case ScaleLineChart.MONTH6:
        btnText = scaleNames[3];
        break;
      case ScaleLineChart.YEAR1:
        btnText = scaleNames[4];
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          padding: EdgeInsets.only(top: 16, bottom: 8),
          child: Row(
            children: [
              /*IconButton(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CreateOrderDialog(widget.user);
                      },
                    );
                    widget.user.updateUser();
                  },
                  icon: Icon(Icons.add_circle)),*/
              Padding(
                padding: EdgeInsets.only(left: 16, right: 0, top: 0, bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Active Orders",
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
                    Text(
                      "Executed on the selected days at 11 PM.",
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 12,
                        fontWeight: FontWeight.w100,
                        color: Colors.black.withOpacity(0.7),
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(0.5, 0.5),
                            blurRadius: 4,
                            color: Color.fromARGB(4, 0, 0, 0),
                          )
                        ],
                      ),
                    )
                  ],
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
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    if (widget.user.userData.orders.values
                        .toList()[index]
                        .active) {
                      return OrderItemList(index, widget.user, widget.settings);
                    } else {
                      return Container();
                    }
                  })
              : Container(height: 200,padding: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                  child: Center(
                    child: Text(
                        "Here you will be able to view all the orders that are being executed daily.",textAlign: TextAlign.center,style: TextStyle(fontSize: 18)),
                  ),
                ),
        ),
      ],
    );
  }
}
