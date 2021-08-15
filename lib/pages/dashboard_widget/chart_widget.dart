import 'package:bitcoin_cost_average/chart_widget_emptyexample.dart';
import 'package:bitcoin_cost_average/controllers/user_controller.dart';
import 'package:bitcoin_cost_average/models/settings_model.dart';
import 'package:bitcoin_cost_average/tools.dart';
import 'package:bitcoin_cost_average/widgets/circular_progress_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../../contants.dart';
import '../../models/user_model.dart';
import 'chart_widgets/tab_widget.dart';

class MyChartSectionData {
  String _pair;
  double _percentage;
  double _amount;

  String get pair => _pair;

  set pair(String value) {
    _pair = value;
  }

  MyChartSectionData(this._pair, this._percentage, this._amount);

  double get percentage => _percentage;

  set percentage(double value) {
    _percentage = value;
  }

  double get amount => _amount;

  set amount(double value) {
    _amount = value;
  }
}

class ChartController extends GetxController {
  var multiplier = Multiplier.WEEKLY.obs;

  _getActualMultiplierPosition() {
    for (int index = 0; index < Multiplier.values.length; index++) {
      if (Multiplier.values[index] == multiplier.value) {
        return index;
      }
    }
  }

  nextMultiplier() {
    int position = _getActualMultiplierPosition();
    position++;
    if (position > Multiplier.values.length - 1) {
      position = 0;
    }
    multiplier.value = Multiplier.values[position];
  }

  previousMultiplier() {
    int position = _getActualMultiplierPosition();
    position--;
    if (position < 0) {
      position = Multiplier.values.length - 1;
    }
    multiplier.value = Multiplier.values[position];
  }
}

enum Multiplier { DAILY, WEEKLY, MONTHLY }

extension MultiplierExtension on Multiplier {
  toSmallString() {
    switch (this) {
      case Multiplier.DAILY:
        return "daily".tr;
      case Multiplier.WEEKLY:
        return "weekly".tr;
      case Multiplier.MONTHLY:
        return "monthly".tr;
    }
  }

  toNumberMultiplier() {
    switch (this) {
      case Multiplier.DAILY:
        return 1 / 7;
      case Multiplier.WEEKLY:
        return 1;
      case Multiplier.MONTHLY:
        return 4;
    }
  }
}

class ChartWidget extends StatelessWidget {
  int touchedIndex = -1;
  List<MyChartSectionData> data;
  final _animatedKey = new GlobalKey();
  var userController = Get.find<UserController>();
  var chartController = Get.put(ChartController());

  @override
  Widget build(BuildContext context) {
    double legendHeight = 42;

    return Obx(() {
      data = userController.pieChartFormattedData.value[userController.baseCoin.value];
      // print("data selected: ${} / coin: ${userController.baseCoin.value}");
      bool isDataChartLoaded = true;
      if (data == null) {
        isDataChartLoaded = false;
      } else {
        if (!(data.length > 0)) isDataChartLoaded = false;
      }
      if (!(userController.userTotalBuyingAmount.length > 0)) isDataChartLoaded = false;

      return AnimatedContainer(
          key: _animatedKey,
          duration: Duration(seconds: 2),
          //height: 600,
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15.0,
                offset: Offset(0.0, 0.75),
              )
            ],
            color: Colors.white,
          ),
          child: AnimatedSwitcher(
            duration: Duration(seconds: 1),
            child: isDataChartLoaded
                ? Column(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text(
                              "chart_title_allocation".trParams({
                                'coin': returnCurrencyName(userController.baseCoin.value),
                              }),
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              headerPrices(
                                  "daily_average_expense".tr,
                                  "~${returnCurrencyCorrectedNumber(userController.baseCoin.value, userController.userTotalExpendingAmount[userController.baseCoin.value] != null ? (userController.userTotalExpendingAmount[userController.baseCoin.value] / 7) : 0.0)}",
                                  "daily_average_expense_tip"
                                      .trParams({'coin': userController.baseCoin.value})),
                              headerPrices(
                                  "weekly_expense".tr,
                                  returnCurrencyCorrectedNumber(
                                      userController.baseCoin.value,
                                      userController.userTotalExpendingAmount[
                                                  userController.baseCoin.value] !=
                                              null
                                          ? (userController.userTotalExpendingAmount[
                                              userController.baseCoin.value])
                                          : 0.0),
                                  "weekly_expense_tip"
                                      .trParams({'coin': userController.baseCoin.value})),
                              headerPrices(
                                  "monthly_expense".tr,
                                  returnCurrencyCorrectedNumber(
                                      userController.baseCoin.value,
                                      userController.userTotalExpendingAmount[
                                                  userController.baseCoin.value] !=
                                              null
                                          ? (userController.userTotalExpendingAmount[
                                                  userController.baseCoin.value] *
                                              4)
                                          : 0.0),
                                  "monthly_expense_tip"
                                      .trParams({'coin': userController.baseCoin.value})
                                  )
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 16),
                            height: MediaQuery.of(context).size.width * 0.7,
                            child: Stack(children: [
                              Center(
                                child: PieChart(
                                  PieChartData(
                                      pieTouchData: PieTouchData(
                                        touchCallback: (pieTouchResponse) {
                                          final desiredTouch =
                                              pieTouchResponse.touchInput is! PointerExitEvent &&
                                                  pieTouchResponse.touchInput is! PointerUpEvent;
                                          if (desiredTouch &&
                                              pieTouchResponse.touchedSection != null) {
                                            touchedIndex =
                                                pieTouchResponse.touchedSection.touchedSectionIndex;
                                          } else {
                                            touchedIndex = -1;
                                          }
                                        },
                                      ),
                                      borderData: FlBorderData(
                                        show: false,
                                      ),
                                      sectionsSpace: 1,
                                      centerSpaceRadius: 84,
                                      sections: List.generate(data.length, (i) {
                                        final isTouched = i == touchedIndex;
                                        //final fontSize = isTouched ? 20.0 : 16.0;
                                        // final radius = isTouched ? 62.0 : 48.0;
                                        final radius = 48.0;
                                        final fontSize = 16.0;
                                        final Color sectionColor = colorsList[i];
                                        return PieChartSectionData(
                                          badgePositionPercentageOffset: isTouched ? -1.5 : 2.8,
                                          color: sectionColor,
                                          value: data[i].percentage,
                                          title:
                                              "${(data[i].percentage * 100).toStringAsFixed(0)}%",
                                          radius: radius,
                                          //showTitle: false,
                                          titleStyle: TextStyle(
                                              fontSize: fontSize,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xffffffff)),
                                        );
                                      })),

                                  swapAnimationDuration: Duration(milliseconds: 250), // Optional
                                  swapAnimationCurve: Curves.linear, // Optional
                                ),
                              ),
                              Center(
                                child: Container(
                                  width: 169,
                                  height: 169,
                                  decoration: BoxDecoration(
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color: Colors.black.withOpacity(0.6),
                                            blurRadius: 16.0,
                                            offset: Offset(0.0, 0.0))
                                      ],
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(128))),
                                  child: Center(
                                      child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    //mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "trading".tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            //fontFamily: 'Arial',
                                            fontSize: 22,
                                            color: Colors.black.withOpacity(0.7)),
                                      ),
                                      FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                          "${returnCurrencyCorrectedNumber(userController.baseCoin.value, userController.userTotalExpendingAmount[userController.baseCoin.value] != null ? (userController.userTotalExpendingAmount[userController.baseCoin.value] * chartController.multiplier.value.toNumberMultiplier()) : 0.0)}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              //fontFamily: 'Arial',
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                      FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Container(
                                          //color: Colors.red,
                                          height: 28,
                                          //fit: BoxFit.fitWidth,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                  icon: Icon(
                                                    Icons.chevron_left,
                                                    size: 18,
                                                  ),
                                                  onPressed: () {
                                                    chartController.previousMultiplier();
                                                  }),
                                              Text(
                                                chartController.multiplier.value.toSmallString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black.withOpacity(0.7)),
                                              ),
                                              IconButton(
                                                  icon: Icon(
                                                    Icons.chevron_right,
                                                    size: 18,
                                                  ),
                                                  onPressed: () {
                                                    chartController.nextMultiplier();
                                                  })
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                                ),
                              ),
                            ]),
                          ),
                          AnimatedContainer(
                            height: data != null
                                ? ((data.length / 2).ceil().toDouble() * legendHeight) + 16
                                : 0,
                            duration: Duration(milliseconds: 250),
                            child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 0,
                                  mainAxisSpacing: 0,
                                  childAspectRatio: ((MediaQuery.of(context).size.width - 32) / 2) /
                                      legendHeight),
                              // padding: EdgeInsets.all(8),
                              //shrinkWrap: true,
                              itemCount: data != null ? data.length : 0,
                              itemBuilder: (context, index) {
                                //widget.settings.updateBasePair(data[index].pair);
                                return GestureDetector(
                                  onTap: () {
                                    //userController.baseCoin.value = (data[index].pair.split("/")[1]);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: 4, right: 4),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(4),
                                            color: colorsList[index],
                                          ),
                                          margin: EdgeInsets.symmetric(horizontal: 16),
                                          height: 12,
                                          width: 12,
                                        ),
                                        //Container(width: ,),
                                        Expanded(
                                          child: Container(
                                            //color: Colors.red,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  data[index].pair,
                                                  style: TextStyle(
                                                      fontFamily: 'Arial',
                                                      fontSize: 24,
                                                      //fontWeight: FontWeight.w400,
                                                      color: Colors.black),
                                                ),
                                                RichText(
                                                  textAlign: TextAlign.left,
                                                  softWrap: true,
                                                  text: TextSpan(
                                                    text: '',
                                                    style: TextStyle(
                                                        color: Colors.black.withOpacity(0.4),
                                                        fontSize: 11),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text:
                                                            '${returnCurrencyCorrectedNumber(data[index].pair.split("/")[1], data[index].amount * chartController.multiplier.value.toNumberMultiplier())}',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                      TextSpan(text: ' ${'for'.tr} '),
                                                      TextSpan(
                                                        text:
                                                            '${data[index].pair.toString().split("/")[0]}',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                      TextSpan(text: ''),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      ChartTabWidget()
                    ],
                  )
                : ExampleChartPie(),
          ));
    });
  }

  Widget headerPrices(String title, String value, String message) {
    return Container(
      margin: EdgeInsets.only(left: 8, right: 8),
      child: Column(
        children: [
          Row(
            children: [
              Text(title,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.6),
                      fontSize: 14,
                      fontWeight: FontWeight.w400)),
              Container(
                width: 4,
              ),
              MyTooltip(
                  message: message,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black.withOpacity(0.4)),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Center(
                      child: Text(
                        "!",
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.4)),
                      ),
                    ),
                  )),
            ],
          ),
          Text(value,
              softWrap: true,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black.withOpacity(1), fontSize: 14, fontWeight: FontWeight.w400))
        ],
      ),
    );
  }
}

class MyTooltip extends StatelessWidget {
  final Widget child;
  final String message;

  MyTooltip({@required this.message, @required this.child});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<State<Tooltip>>();
    return Tooltip(
      key: key,
      message: message,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(20),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onTap(key),
        child: child,
      ),
    );
  }

  void _onTap(GlobalKey key) {
    final dynamic tooltip = key.currentState;
    tooltip?.ensureTooltipVisible();
  }
}
