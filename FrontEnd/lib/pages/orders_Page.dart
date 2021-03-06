import 'package:bitcoin_cost_average/charts/line_chart_mean_small.dart';
import 'package:bitcoin_cost_average/controllers/database_controller.dart';
import 'package:bitcoin_cost_average/controllers/user_controller.dart';
import 'package:bitcoin_cost_average/models/history_model.dart';
import 'package:bitcoin_cost_average/models/settings_model.dart';
import 'package:bitcoin_cost_average/models/user_model.dart';
import 'package:bitcoin_cost_average/pages/pairdetail_page.dart';
import 'package:bitcoin_cost_average/external/sql_database.dart';
import 'package:bitcoin_cost_average/tools.dart';
import 'package:bitcoin_cost_average/widgets/header_weekselector.dart';
import 'package:bitcoin_cost_average/widgets/weekindicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../contants.dart';
import '../list_item/order_item_list.dart';
import 'package:bitcoin_cost_average/controllers/history_controller.dart';

class OrdersPageController extends GetxController {}

class OrdersPage extends StatelessWidget {
  var userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        WeekHeaderSelector(),
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
            child: userController.user.orders.length > 0
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: userController.user.orders.length,
                    //physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return OrderItemList(index);
                    })
                : Container(
                    height: 200,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Center(
                      child: Text(
                          "order_widget_empty".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18)),
                    ),
                  ),
          ),
        )
      ],
    );
  }
}
