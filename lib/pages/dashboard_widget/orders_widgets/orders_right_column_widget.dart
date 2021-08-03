import 'package:bitcoin_cost_average/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bitcoin_cost_average/controllers/history_controller.dart';
import '../../../tools.dart';

class OrdersRightColumnWidget extends StatelessWidget {
  var historyController = Get.find<HistoryController>();
  final int index;
  final String pair;

  OrdersRightColumnWidget(this.index, this.pair);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(() => Padding(
                padding: EdgeInsets.only(top: 0),
                child: Text(
                  historyController.pairAppreciationString != null
                      ? historyController.pairAppreciationString[this.pair] != null
                          ? historyController.pairAppreciationString[this.pair]
                          : "..."
                      : "",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Arial', fontSize: 20, color: Colors.deepPurple),
                ),
              )),
          Obx(() => Padding(
                padding: EdgeInsets.only(top: 0, bottom: 4),
                child: Text(
                  '${historyController.pairData_items.value[this.pair] != null ? "+${historyController.pairData_items.value[this.pair].coinAccumulatedString}" : "..."}',
                  style: TextStyle(color: Colors.deepPurple, fontSize: 12),
                ),
              )),
        ],
      ),
    );
  }
}
