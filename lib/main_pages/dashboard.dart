import 'package:bitbybit/main_pages/dashboard_widget/orders_widget_v2.dart';
import 'package:bitbybit/models/settings_model.dart';
import 'package:bitbybit/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../line_chart_mean.dart';
import 'dashboard_widget/chart_widget.dart';
import 'dashboard_widget/balance_widget.dart';
import 'dashboard_widget/orders_widget.dart';

class DashboardBitMe extends StatefulWidget {
  final User user;
  final Settings settings;

  const DashboardBitMe({Key key, this.user, this.settings}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DashboardBitMeState();
  }
}

class _DashboardBitMeState extends State<DashboardBitMe> {
  @override
  Widget build(BuildContext context) {
    if (widget.user != null) {
      return Column(
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        //mainAxisAlignment: MainAxisAlignment.start,
        //mainAxisSize: MainAxisSize.min,
        children: [
          /* Container(
              padding:
              EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              color: Colors.red,
              child: Text(
                "You are not connected with Binance.\nInsert your API Keys.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),*/

          ChartWidget(widget.user, widget.settings),
          Expanded(
            child: OrdersWidgetv2(widget.user, widget.settings),
          ),
          //PriceAVGChartLine(widget.user,widget.settings),

          //BalanceWidget(widget.user, widget.settings),
          //OrdersWidget(widget.user, widget.settings),
          //Expanded(child: Container())
          // HistoryWidget(querySnapshot.data, widget.user.uid)
        ],
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
