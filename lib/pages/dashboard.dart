import 'package:Bit.Me/pages/dashboard_widget/orders_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../pages/dashboard_widget/chart_widget.dart';

class DashboardBitMe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ChartWidget(),
            OrdersWidget(),
          ],
        ),
      ),
    );
  }
}
