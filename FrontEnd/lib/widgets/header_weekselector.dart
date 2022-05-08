import 'package:bitcoin_cost_average/charts/line_chart_mean_small.dart';
import 'package:bitcoin_cost_average/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WeekHeaderSelector extends StatelessWidget {
  var userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
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
              child: Text("1W".tr),
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
              child: Text("2W".tr),
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
              child: Text("1M".tr),
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
              child: Text("6M".tr),
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
                child: Text("1Y".tr))
          ],
        ),
      ),
    );
  }
}
