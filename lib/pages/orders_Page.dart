import 'package:bitcoin_cost_average/charts/line_chart_mean_small.dart';
import 'package:bitcoin_cost_average/controllers/database_controller.dart';
import 'package:bitcoin_cost_average/controllers/user_controller.dart';
import 'package:bitcoin_cost_average/models/history_model.dart';
import 'package:bitcoin_cost_average/models/settings_model.dart';
import 'package:bitcoin_cost_average/models/user_model.dart';
import 'package:bitcoin_cost_average/pages/pairdetail_page.dart';
import 'package:bitcoin_cost_average/external/sql_database.dart';
import 'package:bitcoin_cost_average/tools.dart';
import 'package:bitcoin_cost_average/widgets/weekindicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../contants.dart';
import '../list_item/order_item_list.dart';
import 'package:bitcoin_cost_average/controllers/history_controller.dart';

class OrdersPageController extends GetxController{

}

class OrdersPage extends StatelessWidget {
  var userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Obx(
          () => Container(
            //color: Colors.grey.shade200,
            margin: EdgeInsets.only(top: 8, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: ScaleLineChart.WEEK1 == userController.scaleLineChart.value
                        ? MaterialStateProperty.all<Color>(Colors.deepPurple.withOpacity(0.2))
                        : null,
                  ),
                  onPressed: () {
                    userController.scaleLineChart.value = (ScaleLineChart.WEEK1);
                  },
                  child: Text("1W"),
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: ScaleLineChart.WEEK2 == userController.scaleLineChart.value
                        ? MaterialStateProperty.all<Color>(Colors.deepPurple.withOpacity(0.2))
                        : null,
                  ),
                  onPressed: () {
                    userController.scaleLineChart.value = (ScaleLineChart.WEEK2);
                  },
                  child: Text("2W"),
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: ScaleLineChart.MONTH1 == userController.scaleLineChart.value
                        ? MaterialStateProperty.all<Color>(Colors.deepPurple.withOpacity(0.2))
                        : null,
                  ),
                  onPressed: () {
                    userController.scaleLineChart.value = (ScaleLineChart.MONTH1);
                  },
                  child: Text("1M"),
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: ScaleLineChart.MONTH6 == userController.scaleLineChart.value
                        ? MaterialStateProperty.all<Color>(Colors.deepPurple.withOpacity(0.2))
                        : null,
                  ),
                  onPressed: () {
                    userController.scaleLineChart.value = (ScaleLineChart.MONTH6);
                  },
                  child: Text("6M"),
                ),
                TextButton(
                    style: ButtonStyle(
                      backgroundColor: ScaleLineChart.YEAR1 == userController.scaleLineChart.value
                          ? MaterialStateProperty.all<Color>(Colors.deepPurple.withOpacity(0.2))
                          : null,
                    ),
                    onPressed: () {
                      userController.scaleLineChart.value = (ScaleLineChart.YEAR1);
                    },
                    child: Text("1Y"))
              ],
            ),
          ),
        ),
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
          child: userController.user.orders.length > 0
              ? ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: userController.user.orders.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return OrderItemList(index);
              })
              : Container(
            height: 200,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Center(
              child: Text(
                  "Here you will be able to view all the orders that are being executed daily.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18)),
            ),
          ),
        )
      ],
    );
  }
}
