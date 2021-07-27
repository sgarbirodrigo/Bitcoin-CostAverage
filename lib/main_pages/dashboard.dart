import 'package:Bit.Me/main_pages/dashboard_widget/orders_widget.dart';
import 'package:Bit.Me/models/settings_model.dart';
import 'package:Bit.Me/models/user_model.dart';
import 'package:Bit.Me/sql_database.dart';
import 'package:Bit.Me/widgets/circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'dashboard_widget/chart_widget.dart';


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
