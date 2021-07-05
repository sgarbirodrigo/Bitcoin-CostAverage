import 'package:Bit.Me/main_pages/dashboard_widget/orders_widget.dart';
import 'package:Bit.Me/models/settings_model.dart';
import 'package:Bit.Me/models/user_model.dart';
import 'package:Bit.Me/sql_database.dart';
import 'package:Bit.Me/widgets/circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dashboard_widget/chart_widget.dart';

class DashboardBitMe extends StatefulWidget {
  final UserManager user;
  final SettingsApp settings;
  SqlDatabase sqlDatabase;

  DashboardBitMe({this.user, this.settings,this.sqlDatabase});

  @override
  State<StatefulWidget> createState() {
    return _DashboardBitMeState();
  }
}

class _DashboardBitMeState extends State<DashboardBitMe> {
  @override
  Widget build(BuildContext context) {
    if (widget.user != null && widget.user.userData != null) {
      return SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ChartWidget(widget.user, widget.settings),
              OrdersWidget(user: widget.user, settings: widget.settings,sqlDatabase: widget.sqlDatabase,),
            ],
          ),
        ),
      );
    } else {
      return Center(
        child: CircularProgressIndicatorMy(),
      );
    }
  }
}
