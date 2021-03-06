import 'package:bitcoin_cost_average/controllers/user_controller.dart';
import 'package:bitcoin_cost_average/pages/dashboard_widget/orders_widgets/header_orders_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../list_item/order_item_list.dart';import 'package:bitcoin_cost_average/controllers/history_controller.dart';

class OrdersWidget extends StatelessWidget {
  var userController = Get.find<UserController>();
  var historyController = Get.find<HistoryController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        OrdersHeaderWidget(),
        /*Obx(() => AnimatedContainer(
            height: historyController.isUpdatingHistory.isTrue ? 4 : 0,
            duration: Duration(milliseconds: 250),
            child: LinearProgressIndicator())),*/
        Obx(() => Container(
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
              child: userController.user.orders != null && userController.user.orders.length > 0
                  ? ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: userController.user.orders.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        if (userController.user.orders.values.toList()[index].active) {
                          return OrderItemList(index);
                          //return Container();
                        } else {
                          return Container();
                        }
                      })
                  : Container(
                      height: 200,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Center(
                        child: Text("order_widget_empty".tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18)),
                      ),
                    ),
            )),
      ],
    );
  }
}
