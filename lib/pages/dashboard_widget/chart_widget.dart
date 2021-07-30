import 'package:Bit.Me/chart_widget_emptyexample.dart';
import 'package:Bit.Me/controllers/user_controller.dart';
import 'package:Bit.Me/models/settings_model.dart';
import 'package:Bit.Me/tools.dart';
import 'package:Bit.Me/widgets/circular_progress_indicator.dart';
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
  var _multiplierOptions = [1, 4].obs;
  var _multiplier = 1.obs;
  var _multiplierIndex = 0.obs;
  var _multiplierOptionsTitles = ["weekly", "monthly"].obs;
}

class ChartWidget extends StatelessWidget {
  int touchedIndex = -1;
  List<MyChartSectionData> data;
  final _animatedKey = new GlobalKey();
  var userController = Get.find<UserController>();
  var chartController = Get.put(ChartController());

  /*@override
  void initState() {
    _multiplier = _multiplierOptions[0];
    _multiplierIndex = 0;
  }
*/
  @override
  Widget build(BuildContext context) {
    double legendHeight = 42;

    return Obx(() {
      data = userController.pieChartFormattedData.value[userController.baseCoin.value];
      //print("data selected: ${data} / coin: ${userController.baseCoin.value}");
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
                            padding: EdgeInsets.only(top: 32),
                            child: Text(
                              "${returnCurrencyName(userController.baseCoin.value)} Allocation",
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                    icon: Icon(
                                      Icons.chevron_left,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      chartController._multiplierIndex.value -= 1;
                                      if (chartController._multiplierIndex.value < 0) {
                                        chartController._multiplierIndex.value =
                                            chartController._multiplierOptions.length - 1;
                                      }

                                      chartController._multiplier.value =
                                          chartController._multiplierOptions[
                                              chartController._multiplierIndex.value];
                                    }),
                                Text(
                                  chartController._multiplierOptionsTitles[
                                      chartController._multiplierIndex.value],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 20,
                                      color: Colors.black.withOpacity(0.7)),
                                ),
                                IconButton(
                                    icon: Icon(
                                      Icons.chevron_right,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      chartController._multiplierIndex.value += 1;
                                      if (chartController._multiplierIndex.value >
                                          chartController._multiplierOptions.length - 1) {
                                        chartController._multiplierIndex.value = 0;
                                      }

                                      chartController._multiplier.value =
                                          chartController._multiplierOptions[
                                              chartController._multiplierIndex.value];
                                    })
                              ],
                            ),
                          ),
                          Container(
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
                                        "Trading",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'Arial',
                                            fontSize: 24,
                                            color: Colors.black.withOpacity(0.7)),
                                      ),
                                      FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                          "${returnCurrencyCorrectedNumber(userController.baseCoin.value, userController.userTotalExpendingAmount[userController.baseCoin.value] != null ? (userController.userTotalExpendingAmount[userController.baseCoin.value] * chartController._multiplier.value) : 0.0)}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'Arial',
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
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
                                                            '${returnCurrencyCorrectedNumber(data[index].pair.split("/")[1], data[index].amount * chartController._multiplier.value)}',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                      TextSpan(text: ' for '),
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
}
