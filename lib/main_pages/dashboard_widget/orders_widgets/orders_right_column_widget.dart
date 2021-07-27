import 'package:Bit.Me/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../tools.dart';

class OrdersRightColumnWidget extends StatelessWidget {
  var userController = Get.find<UserController>();
  final int index;

  OrdersRightColumnWidget(this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      child: Obx(() {
        if (userController.pairData_items
                .value[userController.user.orders.values.toList()[this.index].pair] !=
            null) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 0),
                child: Text(
                  getAppreciationConverted(userController.pairAppreciation[
                      userController.user.orders.values.toList()[this.index].pair]),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Arial', fontSize: 20, color: Colors.deepPurple),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 0, bottom: 4),
                child: Text(
                  '+${returnCurrencyCorrectedNumber(userController.user.orders.values.toList()[this.index].pair.split("/")[0], userController.pairData_items.value[userController.user.orders.values.toList()[this.index].pair].coinAccumulated)}',
                  style: TextStyle(color: Colors.deepPurple, fontSize: 12),
                ),
              ),
            ],
          );
        } else {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 0),
                child: Text(
                  getAppreciationConverted(0),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Arial', fontSize: 20, color: Colors.grey),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 0, bottom: 4),
                child: Text(
                  '+${returnCurrencyCorrectedNumber(userController.user.orders.values.toList()[this.index].pair.split("/")[0], 0)}',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}
