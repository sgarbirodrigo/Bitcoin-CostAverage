import 'package:Bit.Me/tools.dart';
import 'package:Bit.Me/widgets/dashed_line.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'line_chart_mean.dart';
import '../models/settings_model.dart';
import '../models/user_model.dart';

class PriceAVGChartLinePair extends StatefulWidget {
  UserManager user;
  SettingsApp settings;
  Color color;
  PairData pairData;

  PriceAVGChartLinePair({this.user, this.settings, this.pairData, this.color});

  @override
  State<StatefulWidget> createState() => PriceAVGChartLinePairState();
}

class PriceAVGChartLinePairState extends State<PriceAVGChartLinePair> {
  //bool isShowingMainData;
  double interval; //intervalo de 24 horas
  List<FlSpot> price_spots = List();
  List<FlSpot> avg_price_spots = List();
  double xmin, xmax, ymin, ymax, avgPrice_interval;
  Color _chartLineColor = Colors.deepPurple.withOpacity(1);

  @override
  void initState() {
    super.initState();
  }
  void fillLineChart() {
    if (widget.pairData == null){
      price_spots.clear();
      avg_price_spots.clear();
      int spots_missing = 0;
      switch (widget.settings.scaleLineChart) {
        case ScaleLineChart.WEEK1:
          spots_missing = 7;
          break;
        case ScaleLineChart.WEEK2:
          spots_missing = 14;
          break;
        case ScaleLineChart.MONTH1:
          spots_missing = 30;
          break;
        case ScaleLineChart.MONTH6:
          spots_missing = 180;
          break;
        case ScaleLineChart.YEAR1:
          spots_missing = 365;
          break;
      }
      price_spots.add(FlSpot(
          Timestamp.fromMillisecondsSinceEpoch(DateTime.now()
                  .add(Duration(days: -spots_missing))
                  .millisecondsSinceEpoch)
              .seconds
              .toDouble(),
          1.toDouble()));
      price_spots.add(FlSpot(Timestamp.now().seconds.toDouble(), 1.toDouble()));
      ymax;
      ymin;
      xmin = Timestamp.fromMillisecondsSinceEpoch(DateTime.now()
              .add(Duration(days: -spots_missing))
              .millisecondsSinceEpoch)
          .seconds
          .toDouble();
      xmax = Timestamp.now().seconds.toDouble();
    } else {
      price_spots = widget.pairData.price_spots;
      avg_price_spots = widget.pairData.avg_price_spots;
      avgPrice_interval = widget.pairData.avgPrice;
      xmin = widget.pairData.historyItems.first.timestamp.seconds.toDouble();
      xmax = widget.pairData.historyItems.last.timestamp.seconds.toDouble();
      ymax =  widget.pairData.max!=null ?widget.pairData.max * 1.10:null;
      ymin = widget.pairData.min !=null? widget.pairData.min * 0.95:null;
    }
    interval = (xmax - xmin) / 7;
  }

  @override
  Widget build(BuildContext context) {
    fillLineChart();
    return Column(
      children: [
        Container(
          height: 200,
          padding: EdgeInsets.only(bottom: 8),
          child: LineChart(
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
                      String dateString =
                          DateFormat('MMM d - hh:mm').format(date);
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
                                  '${"Price: "}  ${returnCurrencyCorrectedNumber(widget.pairData.pair.split("/")[1], touchedBarSpots[touchedBarSpots[0].barIndex == 0 ? 0 : 1].y)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ]);

                      LineTooltipItem _avgTooltip = LineTooltipItem(
                        "Average: ${returnCurrencyCorrectedNumber(widget.pairData.pair.split("/")[1], touchedBarSpots[touchedBarSpots[0].barIndex == 0 ? 1 : 0].y)}",
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
              //clipData: FlClipData.vertical(),
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
                    Timestamp timestamp = Timestamp.fromMillisecondsSinceEpoch(
                        (value * 1000).toInt());
                    String xTitle =
                        "${DateFormat('MMM d').format(timestamp.toDate())}";
                    return "";
                  },
                  margin: 0,
                ),
                bottomTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 10,
                  interval: interval == 0 ? 1 : interval,
                  getTextStyles: (value) => const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  margin: 12,
                  getTitles: (value) {
                    if (widget.pairData==null) {
                      return "";
                    }
                    Timestamp timestamp = Timestamp.fromMillisecondsSinceEpoch(
                        (value * 1000).toInt());
                    String xTitle =
                        "${DateFormat('MMM d').format(timestamp.toDate())}";
                    //print("inter: ${interval} - ${60*60*24}");
                    if (interval < 60 * 60 * 24) {
                      xTitle =
                          "${DateFormat('hh:mm\nMMM d').format(timestamp.toDate())}";
                    }

                    if (timestamp.seconds ==
                            widget.pairData.price_spots.first.x ||
                        timestamp.seconds ==
                            widget.pairData.price_spots.last.x) {
                      return "";
                    }
                    return xTitle;
                  },
                ),
                leftTitles: avgPrice_interval!=null && avgPrice_interval!=0 ?SideTitles(
                  interval: avgPrice_interval * 0.03,
                  showTitles: true,
                  reservedSize: 0,
                  getTextStyles: (value) => const TextStyle(
                    color: Color(0xff75729e),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  getTitles: (value) {
                    /*return "${doubleToValueString(value)}";*/
                    return "";
                  },
                  margin: 0,
                  //reservedSize: 84,
                ):null,
              ),
              borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.transparent, width: 1)),
              minX: xmin,
              maxX: xmax,
              maxY: ymax,
              minY: ymin,
              lineBarsData: [
                price_spots!=null?LineChartBarData(
                  spots: price_spots,
                  isCurved: true,
                  curveSmoothness: 0,
                  colors: [
                    widget.color,
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
                          strokeColor: widget.color,
                          //trokeColor: Colors.green
                        );
                      }),
                  belowBarData: BarAreaData(
                    show: true,
                    colors: [
                      widget.color.withOpacity(0.5),
                      widget.color.withOpacity(0.0),
                    ],
                    gradientColorStops: [0.1, 1.0],
                    gradientFrom: const Offset(0, 0),
                    gradientTo: const Offset(0, 1),
                  ),
                  /*gradientTo: Offset(0, 0),
          gradientFrom: Offset(0, 0),*/
                ):null,
                avg_price_spots!=null?LineChartBarData(
                  spots: avg_price_spots,
                  isCurved: true,
                  curveSmoothness: 0.1,
                  dashArray: [8, 8],
                  colors: [
                    widget.color,
                  ],
                  barWidth: 2,
                  isStrokeCapRound: false,
                  dotData: FlDotData(
                    show: false,
                  ),
                  belowBarData: BarAreaData(
                      //show: true,
                      ),
                ):null
              ],
            ),
            swapAnimationCurve: Curves.linear,
            swapAnimationDuration: Duration(milliseconds: 500),
          ),
        ),
        AnimatedContainer(
            height: widget.user.isUpdatingHistory ? 4 : 0,
            duration: Duration(milliseconds: 250),
            child: LinearProgressIndicator()),
      ],
    );
  }
}
