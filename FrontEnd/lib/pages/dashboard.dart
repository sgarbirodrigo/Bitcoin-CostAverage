import 'package:bitcoin_cost_average/contants.dart';
import 'package:bitcoin_cost_average/controllers/user_controller.dart';
import 'package:bitcoin_cost_average/pages/dashboard_widget/orders_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../pages/dashboard_widget/chart_widget.dart';

class DashboardBitMe extends StatelessWidget {
  var userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            !userController.user.hasConnected
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    color: redAppColor,
                    child: Text(
                        "Go to settings and connect to your exchange, otherwise we cannot execute your orders.",textAlign: TextAlign.center,style: TextStyle(color: Colors.white),))
                : Container(),
            ChartWidget(),
            OrdersWidget(),
          ],
        ),
      ),
    );
  }
}
