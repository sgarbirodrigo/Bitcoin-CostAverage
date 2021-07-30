import 'package:Bit.Me/controllers/user_controller.dart';
import 'package:Bit.Me/models/history_model.dart';
import 'package:Bit.Me/widgets/weekindicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Bit.Me/controllers/history_controller.dart';
import '../../../contants.dart';
import '../../../tools.dart';

class OrdersLeftColumnWidget extends StatelessWidget{
  var userController = Get.find<UserController>();
  var historyController = Get.find<HistoryController>();
  final int index;
  OrdersLeftColumnWidget(this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      child: Obx(() {
        ORDER_STATUS orderStatus;
        if (userController.user.orders.values.toList()[this.index].active) {
          orderStatus = ORDER_STATUS.RUNNING;
        } else {
          orderStatus = ORDER_STATUS.PAUSED;
        }
        if (historyController.pairData_items.value[
        userController.user.orders.values.toList()[this.index].pair] !=
            null) {
          if (historyController
              .pairData_items
              .value[
          userController.user.orders.values.toList()[this.index].pair]
              .historyItems
              .last
              .result ==
              TransactinoResult.FAILURE) {
            orderStatus = ORDER_STATUS.ERROR;
          }
        }
        Color _selectedColor;
        switch (orderStatus) {
          case ORDER_STATUS.RUNNING:
            _selectedColor = greenAppColor;
            break;
          case ORDER_STATUS.PAUSED:
            _selectedColor = Colors.grey.withOpacity(0.8);
            break;
          case ORDER_STATUS.ERROR:
            _selectedColor = redAppColor;
            break;
          default:
            _selectedColor = Colors.grey.withOpacity(0.8);
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 0),
              child: Text(
                userController.user.orders.values.toList()[this.index].pair,
                style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 20,
                    //fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 0, bottom: 4),
              child: RichText(
                text: TextSpan(
                    text:
                    '- ${returnCurrencyCorrectedNumber(userController.user.orders.values.toList()[this.index].pair.split("/")[1], userController.user.orders.values.toList()[this.index].amount)} ',
                    style: TextStyle(color: _selectedColor, fontSize: 14),
                    children: [
                      TextSpan(
                          text: "/day",
                          style: TextStyle(color: _selectedColor, fontSize: 10))
                    ]),
              ),
            ),
            Obx(() {
              return WeekIndicator(
                  userController.user.orders.values.toList()[this.index].schedule,
                  orderStatus);
            })
          ],
        );
      }),
    );
  }

}