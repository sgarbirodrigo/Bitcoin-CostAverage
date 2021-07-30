import 'package:Bit.Me/controllers/user_controller.dart';
import 'package:Bit.Me/tools.dart';
import 'package:Bit.Me/widgets/dashed_line.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'line_chart_mean.dart';
import '../models/settings_model.dart';
import '../models/user_model.dart';

class PriceAVGChartLinePair extends StatelessWidget {
  //bool isShowingMainData;
  //double interval; //intervalo de 24 horas
  //List<FlSpot> price_spots = List();
  //List<FlSpot> avg_price_spots = List();
  double ymin, ymax;
  Color _chartLineColor = Colors.deepPurple.withOpacity(1);
  var userController = Get.find<UserController>();
  String pair;
  Color color = Colors.white;

  PriceAVGChartLinePair(this.pair);

  double getXMin() {
    return Timestamp.fromMillisecondsSinceEpoch(
            DateTime.now().add(Duration(days: -userController.scaleLineChart.value.toNumberValue())).millisecondsSinceEpoch)
        .seconds
        .toDouble();
  }

  double getXMax() {
    return Timestamp.now().seconds.toDouble();
  }

  double getInterval() {
    return (getXMax() - getXMin()) / 7;
  }

  /*void fillLineChart() {
    */ /* price_spots.add(FlSpot(
        Timestamp.fromMillisecondsSinceEpoch(
                DateTime.now().add(Duration(days: -spots_missing)).millisecondsSinceEpoch)
            .seconds
            .toDouble(),
        1.toDouble()));
    price_spots.add(FlSpot(Timestamp.now().seconds.toDouble(), 1.toDouble()));*/ /*

    */ /*} else {
      price_spots = userController.pairData_items.value[this.pair].price_spots;
      avg_price_spots = userController.pairData_items.value[this.pair].avg_price_spots;
      avgPrice_interval = userController.pairData_items.value[this.pair].avgPrice;
      xmin = userController.pairData_items.value[this.pair].historyItems.first.timestamp.seconds.toDouble();
      xmax = userController.pairData_items.value[this.pair].historyItems.last.timestamp.seconds.toDouble();
      ymax =  userController.pairData_items.value[this.pair].max!=null ?userController.pairData_items.value[this.pair].max * 1.10:null;
      ymin = userController.pairData_items.value[this.pair].min !=null? userController.pairData_items.value[this.pair].min * 0.95:null;
    }*/ /*
    interval = (xmax - xmin) / 7;
  }
*/
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          padding: EdgeInsets.only(bottom: 8),
          child: Obx(() {
            return LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                      fitInsideHorizontally: true,
                      //fitInsideVertically: true,
                      /*showOnTopOfTheChartBoxArea: true,*/
                      //tooltipBgColor: Colors.black45,
                      tooltipBgColor: Color(0xff434343),
                      maxContentWidth: 256,
                      getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                        DateTime date = Timestamp.fromMillisecondsSinceEpoch(
                                touchedBarSpots[0].x.toInt() * 1000)
                            .toDate();
                        String dateString = DateFormat('MMM d - hh:mm').format(date);
                        LineTooltipItem _priceTooltip = LineTooltipItem(
                            "${dateString}\n",
                            TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    '${"Price: "}  ${returnCurrencyCorrectedNumber(userController.pairData_items.value[this.pair].pair.split("/")[1], touchedBarSpots[touchedBarSpots[0].barIndex == 0 ? 0 : 1].y)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ]);

                        LineTooltipItem _avgTooltip = LineTooltipItem(
                          "Average: ${returnCurrencyCorrectedNumber(userController.pairData_items.value[this.pair].pair.split("/")[1], touchedBarSpots[touchedBarSpots[0].barIndex == 0 ? 1 : 0].y)}",
                          TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        );

                        return [_priceTooltip, _avgTooltip];
                      }),
                  touchCallback: (LineTouchResponse touchResponse) {},
                  handleBuiltInTouches: true,
                ),
                gridData: FlGridData(
                  show: false,
                  drawVerticalLine: true,
                  drawHorizontalLine: true,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: _chartLineColor,
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: _chartLineColor,
                      strokeWidth: 4,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  rightTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 0,
                    getTitles: (value) {
                      Timestamp timestamp =
                          Timestamp.fromMillisecondsSinceEpoch((value * 1000).toInt());
                      String xTitle = "${DateFormat('MMM d').format(timestamp.toDate())}";
                      return "";
                    },
                    margin: 0,
                  ),
                  bottomTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 10,
                    interval: getInterval() == 0 ? 1 : getInterval(),
                    getTextStyles: (value) => const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    margin: 12,
                    getTitles: (value) {
                      if (userController.pairData_items.value[this.pair] == null) {
                        return "";
                      }
                      Timestamp timestamp =
                          Timestamp.fromMillisecondsSinceEpoch((value * 1000).toInt());
                      String xTitle = "${DateFormat('MMM d').format(timestamp.toDate())}";
                      //print("inter: ${interval} - ${60*60*24}");
                      if (getInterval() < 60 * 60 * 24) {
                        xTitle = "${DateFormat('hh:mm\nMMM d').format(timestamp.toDate())}";
                      }

                      if (timestamp.seconds ==
                              userController.pairData_items.value[this.pair].price_spots.first.x ||
                          timestamp.seconds ==
                              userController.pairData_items.value[this.pair].price_spots.last.x) {
                        return "";
                      }
                      return xTitle;
                    },
                  ),
                  leftTitles: SideTitles(
                          interval: userController.pairData_items.value[this.pair].avgPrice * 0.05,
                          showTitles: true,
                          reservedSize: 0,
                          getTextStyles: (value) => const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 10,
                          ),
                          getTitles: (value) {
                            //return "${doubleToValueString(value)}";
                            return "";
                          },
                          margin: 0,
                          //reservedSize: 84,
                        ),
                ),
                borderData: FlBorderData(
                    show: true, border: Border.all(color: Colors.transparent, width: 1)),
                minX: getXMin(),
                maxX: getXMax(),
                maxY: ymax,
                minY: ymin,
                lineBarsData: [
                  userController.pairData_items.value[this.pair].price_spots != null
                      ? LineChartBarData(
                          spots: userController.pairData_items.value[this.pair].price_spots,
                          isCurved: true,
                          curveSmoothness: 0,
                          colors: [
                            this.color,
                          ],
                          barWidth: 4,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 4,
                                  color: Colors.deepPurple,
                                  strokeWidth: 2,
                                  strokeColor: this.color,
                                  //trokeColor: Colors.green
                                );
                              }),
                          belowBarData: BarAreaData(
                            show: true,
                            colors: [
                              this.color.withOpacity(0.5),
                              this.color.withOpacity(0.0),
                            ],
                            gradientColorStops: [0.1, 1.0],
                            gradientFrom: const Offset(0, 0),
                            gradientTo: const Offset(0, 1),
                          ),
                          /*gradientTo: Offset(0, 0),
          gradientFrom: Offset(0, 0),*/
                        )
                      : null,
                  userController.pairData_items.value[this.pair].avg_price_spots != null
                      ? LineChartBarData(
                          spots: userController.pairData_items.value[this.pair].avg_price_spots,
                          isCurved: true,
                          curveSmoothness: 0.1,
                          dashArray: [8, 8],
                          colors: [
                            this.color,
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
                      : null
                ],
              ),
              swapAnimationCurve: Curves.linear,
              swapAnimationDuration: Duration(milliseconds: 500),
            );
          }),
        ),
        Obx(() => AnimatedContainer(
            height: userController.isUpdatingHistory.isTrue ? 4 : 0,
            duration: Duration(milliseconds: 250),
            child: LinearProgressIndicator())),
      ],
    );
  }
}
