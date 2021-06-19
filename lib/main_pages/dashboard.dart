import 'package:bitbybit/main_pages/dashboard_widget/orders_widget.dart';
import 'package:bitbybit/models/settings_model.dart';
import 'package:bitbybit/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dashboard_widget/chart_widget.dart';

class DashboardBitMe extends StatefulWidget {
  final User user;
  final Settings settings;

  const DashboardBitMe({this.user, this.settings});

  @override
  State<StatefulWidget> createState() {
    return _DashboardBitMeState();
  }
}

class _DashboardBitMeState extends State<DashboardBitMe> {
  @override
  Widget build(BuildContext context) {
    if (widget.user != null && widget.user.orderItems!=null) {
      return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Container(child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ChartWidget(widget.user, widget.settings),
            OrdersWidget(user: widget.user, settings: widget.settings),
            /*OrdersWidget(user: widget.user, settings: widget.settings)*/
          ],
        ),),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
