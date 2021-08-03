import 'package:bitcoin_cost_average/charts/line_chart_mean_small.dart';
import 'package:bitcoin_cost_average/controllers/user_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersHeaderWidget extends StatelessWidget {
  var userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16, right: 0, top: 0, bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Active Orders",
                  style: TextStyle(
                    //fontFamily: 'Arial Rounded MT Bold',
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(0.5, 0.5),
                        blurRadius: 4,
                        color: Color.fromARGB(4, 0, 0, 0),
                      )
                    ],
                  ),
                ),
                Text(
                  "Executed on the selected days",
                  style: TextStyle(
                    //fontFamily: 'Arial',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withOpacity(0.9),
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(0.5, 0.5),
                        blurRadius: 4,
                        color: Color.fromARGB(4, 0, 0, 0),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(child: Container()),
          Padding(
            padding: EdgeInsets.only(top: 0, bottom: 0, right: 8),
            child: TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.deepPurple.withOpacity(0.2)),
                ),
                onPressed: () {
                  switch (userController.scaleLineChart.value) {
                    case ScaleLineChart.WEEK1:
                      userController.scaleLineChart.value = (ScaleLineChart.WEEK2);
                      break;
                    case ScaleLineChart.WEEK2:
                      userController.scaleLineChart.value = (ScaleLineChart.MONTH1);
                      break;
                    case ScaleLineChart.MONTH1:
                      userController.scaleLineChart.value = (ScaleLineChart.MONTH6);
                      break;
                    case ScaleLineChart.MONTH6:
                      userController.scaleLineChart.value = (ScaleLineChart.YEAR1);
                      break;
                    case ScaleLineChart.YEAR1:
                      userController.scaleLineChart.value = (ScaleLineChart.WEEK1);
                      break;
                  }
                },
                child: Container(
                  child: Obx(() => Text(userController.scaleLineChart.value.toShortNameString())),
                )),
          ),
          Container(
            width: 4,
          )
        ],
      ),
    );
  }
}
