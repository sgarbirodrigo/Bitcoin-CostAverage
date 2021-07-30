import 'package:Bit.Me/controllers/user_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';
import '../tools.dart';

enum ScaleLineChart { WEEK1, WEEK2, MONTH1, MONTH6, YEAR1 }

extension ScaleLineExtension on ScaleLineChart {
  int toNumberValue() {
    switch (this) {
      case ScaleLineChart.WEEK1:
        return 7;
      case ScaleLineChart.WEEK2:
        return 14;
      case ScaleLineChart.MONTH1:
        return 30;
      case ScaleLineChart.MONTH6:
        return 180;
      case ScaleLineChart.YEAR1:
        return 365;
      default:
        return 7;
    }
  }

  String toShortNameString() {
    switch (this) {
      case ScaleLineChart.WEEK1:
        return "1W";
      case ScaleLineChart.WEEK2:
        return "2W";
      case ScaleLineChart.MONTH1:
        return "1M";
      case ScaleLineChart.MONTH6:
        return "6M";
      case ScaleLineChart.YEAR1:
        return "1Y";
      default:
        return "1W";
    }
  }

  String toSavingNameString() {
    switch (this) {
      case ScaleLineChart.WEEK1:
        return "WEEK1";
      case ScaleLineChart.WEEK2:
        return "WEEK2";
      case ScaleLineChart.MONTH1:
        return "MONTH1";
      case ScaleLineChart.MONTH6:
        return "MONTH6";
      case ScaleLineChart.YEAR1:
        return "YEAR1";
      default:
        return "WEEK1";
    }
  }
}

class PriceAVGChartLine extends StatelessWidget {
  final String pair;

  var userController = Get.find<UserController>();

  PriceAVGChartLine({this.pair});

  List<FlSpot> fillLineChart(_pairData) {
    List<FlSpot> price_spots = List();

    int spotsMissing =
        userController.scaleLineChart.value.toNumberValue() - _pairData.price_spots.length;

    if (spotsMissing > 0) {
      FlSpot reference = _pairData.price_spots.first;
      Timestamp firstPoint = Timestamp.fromDate(
          DateTime.fromMillisecondsSinceEpoch(reference.x.toInt() * 1000)
              .add(Duration(days: -spotsMissing)));
      price_spots.add(FlSpot(firstPoint.seconds.toDouble(), reference.y));
    }

    price_spots.addAll(_pairData.price_spots);
    return price_spots;
  }

  List<FlSpot> getEmptyPriceSpots() {
    List<FlSpot> price_spots = List();

    price_spots.add(FlSpot(
        Timestamp.fromMillisecondsSinceEpoch(DateTime.now()
                .add(Duration(days: -userController.scaleLineChart.value.toNumberValue()))
                .millisecondsSinceEpoch)
            .seconds
            .toDouble(),
        1.toDouble()));
    price_spots.add(FlSpot(Timestamp.now().seconds.toDouble(), 1.toDouble()));

    return price_spots;
  }

  double getMinDateTimeTimestamp() {
    switch (userController.scaleLineChart.value) {
      case ScaleLineChart.WEEK1:
        return DateTime.now().add(Duration(days: -7)).millisecondsSinceEpoch / 1000;
        break;
      case ScaleLineChart.WEEK2:
        return DateTime.now().add(Duration(days: -14)).millisecondsSinceEpoch / 1000;
        break;
      case ScaleLineChart.MONTH1:
        return DateTime.now().add(Duration(days: -30)).millisecondsSinceEpoch / 1000;
        break;
      case ScaleLineChart.MONTH6:
        return DateTime.now().add(Duration(days: -180)).millisecondsSinceEpoch / 1000;
        break;
      case ScaleLineChart.YEAR1:
        return DateTime.now().add(Duration(days: -365)).millisecondsSinceEpoch / 1000;
        break;
    }
  }

  double getXMin() {
    return Timestamp.fromMillisecondsSinceEpoch(DateTime.now()
            .add(Duration(days: -userController.scaleLineChart.value.toNumberValue()))
            .millisecondsSinceEpoch)
        .seconds
        .toDouble();
  }

  double getXMax() {
    return Timestamp.now().seconds.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      child: Obx(
        () {
          Color color = Colors.deepPurple;
          if (userController.pairData_items.value[pair] == null) {
            color = Colors.grey;
            return Center(
              child: Text(
                "Not enough data to show on the selected period.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            );
          }
          //print("${this.pair.replaceAll("/", "_")} - orders: ${userController.user.orders[this.pair.replaceAll("/", "_")]}");
          if (!userController.user.orders[this.pair.replaceAll("/", "_")].active) {
            color = Colors.grey;
          }
          List<FlSpot> price_spots = List();
          if (DateTime.fromMillisecondsSinceEpoch(userController.pairData_items.value[pair].price_spots.first.x.toInt() * 1000).isAfter(
              DateTime.now()
                  .add(Duration(days: -userController.scaleLineChart.value.toNumberValue())))) {
            price_spots.add(FlSpot(
                DateTime.now()
                        .add(Duration(days: -userController.scaleLineChart.value.toNumberValue()))
                        .millisecondsSinceEpoch /
                    1000,
                userController.pairData_items.value[pair].price_spots.first.y));
          }
          price_spots.addAll(userController.pairData_items.value[pair].price_spots);

          return LineChart(
            LineChartData(
              lineTouchData: LineTouchData(
                enabled: false,
                /*touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return null;
                    }),*/
                //touchCallback: (LineTouchResponse touchResponse) {},
                //handleBuiltInTouches: false,
              ),
              clipData: FlClipData.vertical(),
              gridData: FlGridData(
                show: false,
              ),
              titlesData: FlTitlesData(
                bottomTitles: SideTitles(
                  showTitles: false,
                ),
                leftTitles: SideTitles(
                  showTitles: false,
                  reservedSize: 90,
                  margin: 0,
                  getTitles: (value) {
                    return null;
                  },
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: const Border(
                  bottom: BorderSide(
                    color: Colors.transparent,
                    //width: 1,
                  ),
                  left: BorderSide(
                    color: Colors.transparent,
                  ),
                  right: BorderSide(
                    color: Colors.transparent,
                  ),
                  top: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
              ),
              minX: getXMin(),
              maxX: getXMax(),
              maxY: userController.pairData_items.value[pair] != null
                  ? userController.pairData_items.value[pair].max * 1.01
                  : 2,
              minY: userController.pairData_items.value[pair] != null
                  ? userController.pairData_items.value[pair].min * 0.95
                  : 0,
              lineBarsData: [
                LineChartBarData(
                  spots: userController.pairData_items.value[pair] != null
                      ? price_spots
                      : getEmptyPriceSpots(),
                  isCurved: true,
                  curveSmoothness: 0,
                  colors: [
                    color,
                  ],
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 2,
                          color: color,
                          strokeWidth: 0,
                        );
                      }),
                  belowBarData: BarAreaData(
                    show: true,
                    colors: [
                      color.withOpacity(0.5),
                      color.withOpacity(0.0),
                    ],
                    gradientColorStops: [0.1, 1.0],
                    gradientFrom: const Offset(0, 0),
                    gradientTo: const Offset(0, 1),
                  ),
                ),
                LineChartBarData(
                  spots: userController.pairData_items.value[pair] != null
                      ? userController.pairData_items.value[pair].avg_price_spots
                      : null,
                  isCurved: true,
                  curveSmoothness: 0.2,
                  dashArray: [8, 8],
                  colors: [
                    color,
                  ],
                  barWidth: 2,
                  isStrokeCapRound: false,
                  dotData: FlDotData(
                    show: false,
                  ),
                  belowBarData: BarAreaData(
                      //show: true,
                      ),
                )
              ],
            ),
            swapAnimationCurve: Curves.linear,
            swapAnimationDuration: Duration(milliseconds: 250),
          );
        },
      ),
    );
  }
}
